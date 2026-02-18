import 'package:logger/logger.dart';
import '../../domain/entities/builder_form.dart';
import '../../domain/entities/form_version_history.dart';
import '../../domain/repositories/form_builder_repository.dart';
import '../../../../core/exceptions/app_exception.dart';
import '../../../../core/network/api_client_wrapper.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../domain/entities/form_section.dart';
import '../dto/form_dto.dart';
import '../mappers/form_mapper.dart';

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
      final dto = FormDto.fromJson(response.data as Map<String, dynamic>);

      return FormMapper.fromDto(dto);
    } catch (e, s) {
      _logger.e('Failed to load form', error: e, stackTrace: s);
      throw FormLoadException(id, originalError: e);
    }
  }

  @override
  Future<BuilderForm> saveForm(BuilderForm form) async {
    try {
      // Transform frontend format to backend format
      final backendData = FormMapper.toBackendJson(form);

      dynamic responseData;
      // If form exists update, otherwise create
      if (form.id.isEmpty || form.id == 'new' || form.updatedAt == null) {
        final response = await _apiClient.post(
          ApiEndpoints.createForm,
          data: backendData,
        );
        responseData = response.data['form'];
      } else {
        final response = await _apiClient.put(
          ApiEndpoints.updateForm(form.id),
          data: backendData,
        );
        responseData = response.data['form'];
      }
      // Ideally backend returns consistent structure.
      final dto = FormDto.fromJson(responseData as Map<String, dynamic>);
      return FormMapper.fromDto(dto);
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

      final dto = FormDto.fromJson(response.data as Map<String, dynamic>);
      return FormMapper.fromDto(dto);
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

      return FormMapper.mapAISectionsToFrontend(sectionsJson);
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
