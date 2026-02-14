import 'package:logger/logger.dart';
import '../../domain/entities/builder_form.dart';
import '../../domain/entities/form_version_history.dart';
import '../../domain/repositories/form_builder_repository.dart';
import '../../../../core/exceptions/app_exception.dart';
import '../../../../core/network/api_client_wrapper.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../domain/entities/form_section.dart';

/// Implementation of [FormBuilderRepository] for managing form CRUD operations.
///
/// Handles form retrieval, saving, publishing, and version history through
/// the API client with proper error handling and data transformation.
class FormBuilderRepositoryImpl implements FormBuilderRepository {
  final ApiClient _apiClient;
  final Logger _logger = Logger();

  FormBuilderRepositoryImpl(this._apiClient);

  @override
  Future<BuilderForm> getForm(String id) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.getForm(id));
      final data = response.data as Map<String, dynamic>;

      // Backend returns form with versions array
      // We need to extract the active/latest version's sections
      List<dynamic> versions = data['versions'] ?? [];
      String activeVersion = data['active_version'] ?? '1.0';

      // Find the active version or use the last one
      Map<String, dynamic>? versionData;
      if (versions.isNotEmpty) {
        versionData = versions.firstWhere(
          (v) => v['version'] == activeVersion,
          orElse: () => versions.last,
        );
      }

      // Extract sections from the version
      List<dynamic> sections = versionData?['sections'] ?? [];

      // Transform to frontend format
      final transformedData = {
        'id': data['id'] ?? data['_id'],
        'title': data['title'] ?? 'Untitled Form',
        'status': data['status'] ?? 'draft',
        'isPublished': data['status'] == 'published',
        'version': activeVersion,
        'isLatest': true,
        'sections': sections,
        'updatedAt': data['updated_at'],
        'workflows': data['workflows'] ?? {},
        'versionHistory': versions
            .map(
              (v) => {
                'version': v['version'],
                'createdAt': v['created_at'],
                'changeLog': 'Version ${v['version']}',
              },
            )
            .toList(),
      };

      return BuilderForm.fromJson(transformedData);
    } catch (e, s) {
      _logger.e('Failed to load form', error: e, stackTrace: s);
      throw FormLoadException(id, originalError: e);
    }
  }

  @override
  Future<void> saveForm(BuilderForm form) async {
    try {
      // Transform frontend format to backend format
      final backendData = {
        'title': form.title,
        'status': form.status,
        'slug': form.id, // Use ID as slug for now
        'versions': [
          {
            'version': form.version,
            'sections': form.sections.map((s) => s.toJson()).toList(),
            'created_at': DateTime.now().toIso8601String(),
          },
        ],
        'active_version': form.version,
        'workflows': form.workflows,
      };

      // If form exists update, otherwise create
      if (form.id.isEmpty || form.id == 'new' || form.updatedAt == null) {
        await _apiClient.post(ApiEndpoints.createForm, data: backendData);
      } else {
        await _apiClient.put(
          ApiEndpoints.updateForm(form.id),
          data: backendData,
        );
      }
    } catch (e, s) {
      _logger.e('Failed to save form', error: e, stackTrace: s);
      throw FormSaveException(form.id, originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> publishForm(String formId) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.publishForm(formId),
        data: {},
      );
      return response.data;
    } catch (e, s) {
      _logger.e('Failed to publish form', error: e, stackTrace: s);
      throw FormLoadException(formId, originalError: e);
    }
  }

  @override
  Future<List<FormVersionHistory>> getVersionHistory(String formId) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.getFormVersions(formId),
      );
      return (response.data as List)
          .map((e) => FormVersionHistory.fromJson(e))
          .toList();
    } catch (e, s) {
      _logger.w(
        'Failed to get version history for form $formId',
        error: e,
        stackTrace: s,
      );
      return [];
    }
  }

  @override
  Future<BuilderForm> getFormVersion(String formId, String version) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.getFormVersion(formId, version),
      );
      return BuilderForm.fromJson(response.data);
    } catch (e, s) {
      _logger.e('Failed to load form version', error: e, stackTrace: s);
      throw FormVersionException(formId, version, originalError: e);
    }
  }

  @override
  Future<List<FormSection>> generateFieldsWithAI(
    String prompt, {
    BuilderForm? currentForm,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.generateFormAI,
        data: {
          'prompt': prompt,
          if (currentForm != null) 'current_form': currentForm.toJson(),
        },
      );

      final data = response.data as Map<String, dynamic>;
      final suggestion = data['suggestion'] as Map<String, dynamic>;
      final sectionsJson = suggestion['sections'] as List<dynamic>;

      final transformedSections = sectionsJson.map((s) {
        final section = Map<String, dynamic>.from(s);
        final questions = (section['questions'] as List<dynamic>).map((q) {
          final question = Map<String, dynamic>.from(q);

          // Map backend to frontend fields
          if (question.containsKey('question_text')) {
            question['label'] = question['question_text'];
          }
          if (question.containsKey('field_type')) {
            // Normalize field types
            String type = question['field_type'];
            if (type == 'long_text') type = 'paragraph';
            if (type == 'radio' || type == 'boolean') type = 'multiple_choice';
            if (type == 'checkbox') type = 'checkboxes';
            question['type'] = type;
          }

          // Map options from List<Map> to List<String>
          if (question.containsKey('options') && question['options'] is List) {
            question['options'] = (question['options'] as List).map((o) {
              if (o is Map) return o['option_label'] ?? o['label'] ?? '';
              return o.toString();
            }).toList();
          }

          return question;
        }).toList();

        section['questions'] = questions;
        return FormSection.fromJson(section);
      }).toList();

      return transformedSections;
    } catch (e, s) {
      _logger.e('Failed to generate fields with AI', error: e, stackTrace: s);
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAISuggestions(BuilderForm form) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.getFieldSuggestions,
        data: {'current_form': form.toJson()},
      );

      final data = response.data as Map<String, dynamic>;
      final suggestions = data['suggestions'] as List<dynamic>;

      return suggestions.cast<Map<String, dynamic>>();
    } catch (e, s) {
      _logger.e('Failed to get AI suggestions', error: e, stackTrace: s);
      return [];
    }
  }

  @override
  Future<Map<String, dynamic>> validateFormWithAI(BuilderForm form) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.validateFormDesign(form.id),
        data: {'form': form.toJson()},
      );

      return response.data as Map<String, dynamic>;
    } catch (e, s) {
      _logger.e('Failed to validate form with AI', error: e, stackTrace: s);
      return {
        'score': 0,
        'issues': [
          {'type': 'error', 'message': 'AI validation failed: $e'},
        ],
        'suggestions': [],
      };
    }
  }
}
