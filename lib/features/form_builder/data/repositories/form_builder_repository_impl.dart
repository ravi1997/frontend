import 'package:logger/logger.dart';
import '../../domain/entities/builder_form.dart';
import '../../domain/entities/form_version_history.dart';
import '../../domain/repositories/form_builder_repository.dart';
import '../../../../core/exceptions/app_exception.dart';
import '../../../../core/network/api_client_wrapper.dart';

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
      final response = await _apiClient.get('/forms/$id');
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
    } catch (e) {
      _logger.e('Failed to load form: $e');
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
      if (form.id.isEmpty || form.id == 'new') {
        await _apiClient.post('/forms', data: backendData);
      } else {
        await _apiClient.put('/forms/${form.id}', data: backendData);
      }
    } catch (e) {
      _logger.e('Failed to save form: $e');
      throw FormSaveException(form.id, originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> publishForm(String formId) async {
    try {
      final response = await _apiClient.post(
        '/forms/$formId/publish',
        data: {},
      );
      return response.data;
    } catch (e) {
      _logger.e('Failed to publish form: $e');
      throw FormLoadException(formId, originalError: e);
    }
  }

  @override
  Future<List<FormVersionHistory>> getVersionHistory(String formId) async {
    try {
      final response = await _apiClient.get('/forms/$formId/versions');
      return (response.data as List)
          .map((e) => FormVersionHistory.fromJson(e))
          .toList();
    } catch (e) {
      _logger.w('Failed to get version history for form $formId: $e');
      return [];
    }
  }

  @override
  Future<BuilderForm> getFormVersion(String formId, String version) async {
    try {
      final response = await _apiClient.get('/forms/$formId/versions/$version');
      return BuilderForm.fromJson(response.data);
    } catch (e) {
      _logger.e('Failed to load form version: $e');
      throw FormVersionException(formId, version, originalError: e);
    }
  }
}
