import 'package:logger/logger.dart';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import 'package:frontend/models/form_models.dart';
import '../../domain/entities/form_version_history.dart';
import '../../domain/repositories/form_builder_repository.dart';
import '../../domain/entities/custom_field_template.dart';
import '../../../../core/exceptions/app_exception.dart';
import '../../../../core/network/api_client_wrapper.dart';
import '../../../../core/network/api_endpoints.dart';
import '../dto/form_dto.dart';
import '../mappers/form_mapper.dart';

/// Implementation of [FormBuilderRepository] for managing form CRUD operations.
///
/// Handles form retrieval, saving, publishing, and version history through
/// the API client with proper error handling and data transformation.
///
/// EnvelopeInterceptor in the Dio pipeline already unwraps
/// { "success": true, "data": ... } responses, so response.data is the unwrapped data.
class FormBuilderRepositoryImpl implements FormBuilderRepository {
  final ApiClient _apiClient;
  final Logger _logger = Logger();
  static const _uuid = Uuid();

  FormBuilderRepositoryImpl(this._apiClient);

  @override
  Future<BuilderForm> getForm(String projectId, String id) async {
    try {
      final endpoint = ApiEndpoints.getProjectForm(projectId, id);
      _logger.i('projectId: $projectId Endpoint: $endpoint');
      final response = await _apiClient.get(endpoint);
      final data = Map<String, dynamic>.from(response.data as Map);
      data['id'] ??= id;
      data['form_id'] ??= id;
      final resolvedSections = _resolvedTopLevelSections(data);
      if (resolvedSections != null) {
        _hydrateActiveVersionSections(data, resolvedSections);
      }
      final hydratedSections = await _loadSections(projectId, id, data);
      if (hydratedSections != null) {
        data['sections'] = hydratedSections;
        _hydrateActiveVersionSections(data, hydratedSections);
      }

      final dto = FormDto.fromJson(data);

      return FormMapper.fromDto(dto);
    } catch (e, s) {
      _logger.e('Failed to load form', error: e, stackTrace: s);
      throw FormLoadException(id, originalError: e);
    }
  }

  List<dynamic>? _resolvedTopLevelSections(Map<String, dynamic> formData) {
    final rawSections = formData['sections'];
    if (rawSections is! List || rawSections.isEmpty) {
      return null;
    }
    return rawSections.every((section) => section is Map) ? rawSections : null;
  }

  Future<List<dynamic>?> _loadSections(
    String projectId,
    String formId,
    Map<String, dynamic> formData,
  ) async {
    final rawSections = formData['sections'];
    if (rawSections is! List || rawSections.isEmpty) {
      return null;
    }

    final sectionIds = rawSections.whereType<String>().toList();
    if (sectionIds.isEmpty) {
      return null;
    }

    final dynamic data;
    try {
      final response = await _apiClient.get(
        ApiEndpoints.listSections(projectId, formId),
      );
      data = response.data;
    } catch (e, s) {
      _logger.w(
        'Skipping section hydration for form $formId',
        error: e,
        stackTrace: s,
      );
      return null;
    }

    final sections = data is Map<String, dynamic>
        ? (data['section'] as List<dynamic>? ??
              data['sections'] as List<dynamic>? ??
              data['data'] as List<dynamic>? ??
              data['items'] as List<dynamic>? ??
              const [])
        : (data as List<dynamic>? ?? const []);

    if (sections.isEmpty) {
      return null;
    }

    final byId = <String, Map<String, dynamic>>{};
    for (final item in sections) {
      if (item is Map) {
        final section = Map<String, dynamic>.from(item);
        final sectionId = section['id']?.toString();
        if (sectionId != null && sectionId.isNotEmpty) {
          byId[sectionId] = section;
        }
      }
    }

    final hydrated = <Map<String, dynamic>>[];
    for (final sectionId in sectionIds) {
      final section = byId[sectionId];
      if (section != null) {
        hydrated.add(section);
      }
    }

    return hydrated.isEmpty ? null : hydrated;
  }

  void _hydrateActiveVersionSections(
    Map<String, dynamic> formData,
    List<dynamic> sections,
  ) {
    final versions = formData['versions'];
    if (versions is! List || versions.isEmpty) {
      return;
    }

    final activeVersion = formData['active_version']?.toString();
    final hydratedVersions = versions.map((version) {
      if (version is! Map) {
        return version;
      }

      final versionMap = Map<String, dynamic>.from(version);
      final versionName = versionMap['version']?.toString();
      final isActive =
          activeVersion == null ||
          activeVersion.isEmpty ||
          versionName == activeVersion;

      if (isActive) {
        versionMap['sections'] = sections;
      }
      return versionMap;
    }).toList();

    formData['versions'] = hydratedVersions;
  }

  @override
  Future<BuilderForm> saveForm(
    BuilderForm form, {
    required String projectId,
    String versionType = 'patch',
  }) async {
    try {
      final bool isNewForm =
          form.id.isEmpty || form.id == 'new' || form.updatedAt == null;

      _logger.i('isNewForm: $isNewForm');

      if (isNewForm) {
        // ── Create new form ──────────────────────────────────────────────
        // Backend: POST /projects/<projectId>/forms/ → 201 { "form_id": "uuid" }
        final payload = FormMapper.toBackendJson(form);
        payload['project'] = projectId;
        final response = await _apiClient.post(
          ApiEndpoints.createProjectForm(projectId),
          data: payload,
        );
        final data = response.data;
        final newFormId = _extractFormId(data);
        return getForm(projectId, newFormId);
      } else {
        _logger.i('Updating existing form');
        _logger.i('form: ${form.id}');
        _logger.i('projectId: $projectId');
        _logger.i(
          'endpoint: ${ApiEndpoints.saveFormDraft(projectId, form.id)}',
        );
        // ── Update existing form ─────────────────────────────────────────
        // Backend: PUT /projects/<projectId>/forms/<id>/draft for full canvas
        final payload = FormMapper.toBackendJson(form);
        await _apiClient.put(
          ApiEndpoints.saveFormDraft(projectId, form.id),
          data: payload,
        );

        // Fetch the updated form to return consistent state
        return getForm(projectId, form.id);
      }
    } catch (e, s) {
      _logger.e('Failed to save form', error: e, stackTrace: s);
      throw FormSaveException(form.id, originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> saveDraft(
    String projectId,
    BuilderForm form,
  ) async {
    try {
      final response = await _apiClient.put(
        ApiEndpoints.saveFormDraft(projectId, form.id),
        data: FormMapper.toBackendJson(form),
      );
      return Map<String, dynamic>.from(response.data as Map);
    } catch (e, s) {
      _logger.e('Failed to save draft', error: e, stackTrace: s);
      throw FormSaveException(form.id, originalError: e);
    }
  }

  /// Extract form_id from various backend response shapes.
  String _extractFormId(dynamic data) {
    if (data is Map) {
      // { "form_id": "uuid" } or { "id": "uuid" }
      final id = data['form_id'] ?? data['id'];
      if (id is String && id.isNotEmpty) return id;

      // Nested: { "form": { "form_id": "uuid" } }
      if (data['form'] is Map) {
        final nested = data['form'] as Map;
        final nestedId = nested['form_id'] ?? nested['id'];
        if (nestedId is String && nestedId.isNotEmpty) return nestedId;
      }
    }
    throw FormSaveException(
      '',
      originalError: Exception('Invalid response: missing form_id. Got: $data'),
    );
  }

  @override
  Future<void> updateFormVersion(
    String projectId,
    String formId,
    String version,
    Map<String, dynamic> data,
  ) async {
    try {
      await _apiClient.put(
        ApiEndpoints.updateFormVersion(projectId, formId, version),
        data: data,
      );
    } catch (e, s) {
      _logger.e(
        'Failed to update form version $version',
        error: e,
        stackTrace: s,
      );
      throw FormSaveException(formId, originalError: e);
    }
  }

  @override
  Future<void> createFormVersion(
    String projectId,
    String formId,
    Map<String, dynamic> data, {
    String type = 'patch',
    bool activate = true,
  }) async {
    try {
      final payload = Map<String, dynamic>.from(data);
      payload['type'] = type;
      payload['activate'] = activate;

      await _apiClient.post(
        ApiEndpoints.createFormVersion(projectId, formId),
        data: payload,
      );
    } catch (e, s) {
      _logger.e('Failed to create form version', error: e, stackTrace: s);
      throw FormSaveException(formId, originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> getBuilderMetadata() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.builderMetadata);
      return Map<String, dynamic>.from(response.data as Map);
    } catch (e, s) {
      _logger.e('Failed to load builder metadata', error: e, stackTrace: s);
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> exportSchema(
    String projectId,
    String formId,
  ) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.exportFormSchema(projectId, formId),
      );
      return Map<String, dynamic>.from(response.data as Map);
    } catch (e, s) {
      _logger.e('Failed to export schema', error: e, stackTrace: s);
      throw FormLoadException(formId, originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> publishForm(String projectId, String formId) async {
    try {
      // Backend: POST /projects/<projectId>/forms/<id>/publish → 202 { "task_id": "..." }
      // Body: { "major": bool, "minor": bool }
      final response = await _apiClient.post(
        ApiEndpoints.publishProjectForm(projectId, formId),
        data: {'major': false, 'minor': true},
        options: Options(headers: {'Idempotency-Key': _uuid.v4()}),
      );
      return response.data as Map<String, dynamic>;
    } catch (e, s) {
      _logger.e('Failed to publish form', error: e, stackTrace: s);
      throw FormLoadException(formId, originalError: e);
    }
  }

  @override
  Future<List<FormVersionHistory>> getVersionHistory(
    String projectId,
    String formId,
  ) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.getFormVersions(projectId, formId),
      );
      final data = response.data;
      if (data is List) {
        return data.map((e) => FormVersionHistory.fromJson(e)).toList();
      }
      return [];
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
  Future<BuilderForm> getFormVersion(
    String projectId,
    String formId,
    String version,
  ) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.getFormVersion(projectId, formId, version),
      );
      final data = response.data;
      final dto = FormDto.fromJson(data as Map<String, dynamic>);
      return FormMapper.fromDto(dto);
    } catch (e, s) {
      _logger.e('Failed to load form version', error: e, stackTrace: s);
      throw FormVersionException(formId, version, originalError: e);
    }
  }

  @override
  Future<BuilderForm> restoreFormVersion(
    String projectId,
    String formId,
    String version,
  ) async {
    try {
      await _apiClient.post(
        ApiEndpoints.restoreFormVersion(projectId, formId, version),
      );
      return getForm(projectId, formId);
    } catch (e, s) {
      _logger.e('Failed to restore form version', error: e, stackTrace: s);
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

  @override
  Future<List<CustomFieldTemplate>> getTemplates() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.listFieldTemplates);
      final data = response.data;
      if (data is List) {
        return data
            .map((e) => CustomFieldTemplate.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e, s) {
      _logger.e('Failed to get templates', error: e, stackTrace: s);
      return [];
    }
  }

  @override
  Future<void> saveTemplate(CustomFieldTemplate template) async {
    try {
      await _apiClient.post(
        ApiEndpoints.listFieldTemplates,
        data: template.toJson(),
      );
    } catch (e, s) {
      _logger.e('Failed to save template', error: e, stackTrace: s);
    }
  }

  @override
  Future<Map<String, dynamic>> getTranslations(
    String formId, {
    String? language,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.getFormTranslations(formId: formId, language: language),
      );
      return response.data as Map<String, dynamic>;
    } catch (e, s) {
      _logger.e('Failed to get form translations', error: e, stackTrace: s);
      return {};
    }
  }

  @override
  Future<void> saveTranslations(
    String formId,
    String language,
    Map<String, dynamic> translations,
  ) async {
    try {
      // Backend: POST /forms/translations
      // Body: { "form_id": "...", "language": "...", "translations": {...} }
      final payload = {
        'form_id': formId,
        'language': language,
        'translations': translations,
      };

      await _apiClient.post(ApiEndpoints.saveFormTranslations, data: payload);
    } catch (e, s) {
      _logger.e('Failed to save form translations', error: e, stackTrace: s);
      throw NetworkException('Failed to save form translations: $e');
    }
  }

  @override
  Future<BuilderForm> cloneForm(
    String projectId,
    String formId, {
    String? title,
    String? slug,
  }) async {
    try {
      // Backend: POST /forms/<id>/clone → 202 { "task_id": "..." }
      // We poll the original form until the clone appears, or return as-is.
      final payload = <String, dynamic>{};
      if (title != null) payload['title'] = title;
      if (slug != null) payload['slug'] = slug;

      final response = await _apiClient.post(
        ApiEndpoints.cloneProjectForm(projectId, formId),
        data: payload,
        options: Options(headers: {'Idempotency-Key': _uuid.v4()}),
      );
      final data = response.data;

      // Clone is async (202). The response contains task_id.
      // Return the original form as fallback — caller should navigate to forms list.
      if (data is Map && data.containsKey('task_id')) {
        _logger.i('Clone accepted with task_id: ${data['task_id']}');
        // Return current form as a fallback since clone is async
        return getForm(projectId, formId);
      }

      // If backend returns the cloned form directly
      if (data is Map && (data['form_id'] != null || data['id'] != null)) {
        return getForm(projectId, _extractFormId(data));
      }

      return getForm(projectId, formId);
    } catch (e, s) {
      _logger.e('Failed to clone form', error: e, stackTrace: s);
      throw FormSaveException(formId, originalError: e);
    }
  }
}
