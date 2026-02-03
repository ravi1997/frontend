import 'package:logger/logger.dart';
import '../../domain/entities/custom_field_template.dart';
import '../../domain/repositories/field_library_repository.dart';
import '../../../../core/network/api_client_wrapper.dart';

/// Implementation of [FieldLibraryRepository] for custom field templates.
///
/// Handles CRUD operations for custom field templates via the backend API.
class FieldLibraryRepositoryImpl implements FieldLibraryRepository {
  final ApiClient _apiClient;
  final Logger _logger = Logger();

  FieldLibraryRepositoryImpl(this._apiClient);

  @override
  Future<List<CustomFieldTemplate>> getCustomFields() async {
    try {
      final response = await _apiClient.get('/custom-fields');
      final data = response.data as List<dynamic>;

      final templates = data.map((item) {
        return CustomFieldTemplate.fromJson(item as Map<String, dynamic>);
      }).toList();

      _logger.i('Loaded ${templates.length} custom field templates');
      return templates;
    } catch (e, stack) {
      _logger.e('Failed to load custom fields: $e');
      throw _createException('Failed to load custom fields', e, stack);
    }
  }

  @override
  Future<CustomFieldTemplate> createCustomField(
    CustomFieldTemplate template,
  ) async {
    try {
      final response = await _apiClient.post(
        '/custom-fields',
        data: template.toJson(),
      );

      _logger.i('Created custom field template: ${template.name}');
      return CustomFieldTemplate.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (e, stack) {
      _logger.e('Failed to create custom field: $e');
      throw _createException(
        'Failed to create custom field: ${template.name}',
        e,
        stack,
      );
    }
  }

  @override
  Future<void> deleteCustomField(String templateId) async {
    try {
      await _apiClient.delete('/custom-fields/$templateId');
      _logger.i('Deleted custom field template: $templateId');
    } catch (e, stack) {
      _logger.e('Failed to delete custom field: $e');
      throw _createException('Failed to delete custom field', e, stack);
    }
  }

  @override
  Future<CustomFieldTemplate> updateCustomField(
    String templateId,
    CustomFieldTemplate template,
  ) async {
    try {
      final response = await _apiClient.put(
        '/custom-fields/$templateId',
        data: template.toJson(),
      );

      _logger.i('Updated custom field template: $templateId');
      return CustomFieldTemplate.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (e, stack) {
      _logger.e('Failed to update custom field: $e');
      throw _createException('Failed to update custom field', e, stack);
    }
  }

  Exception _createException(String message, Object error, StackTrace stack) {
    return Exception('$message: $error');
  }
}
