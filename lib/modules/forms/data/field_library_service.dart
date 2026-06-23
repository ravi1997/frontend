import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/networking/api_client.dart';
import 'package:frontend/core/networking/dio_provider.dart';
import 'package:logger/logger.dart';
import 'package:frontend/modules/forms/models/custom_field_template.dart';

/// Service for custom field template operations.
///
/// Handles CRUD operations for custom field templates via the backend API.
class FieldLibraryService {
  final ApiClient _apiClient;
  final Logger _logger = Logger();

  FieldLibraryService(this._apiClient);

  /// Gets all custom field templates.
  Future<List<CustomFieldTemplate>> getCustomFields() async {
    try {
      final data = await _apiClient.getList('/custom-fields/');

      final templates = data.map((item) {
        return CustomFieldTemplate.fromJson(item as Map<String, dynamic>);
      }).toList();

      _logger.i('Loaded ${templates.length} custom field templates');
      return templates;
    } catch (e, stack) {
      _logger.e('Failed to load custom fields', error: e, stackTrace: stack);
      throw _createException('Failed to load custom fields', e, stack);
    }
  }

  /// Creates a new custom field template.
  Future<CustomFieldTemplate> createCustomField(CustomFieldTemplate template) async {
    try {
      final createdTemplate =
          CustomFieldTemplate.fromJson(await _apiClient.postMap('/custom-fields/', data: template.toJson()));
      _logger.i('Created custom field template: ${createdTemplate.id}');
      return createdTemplate;
    } catch (e, stack) {
      _logger.e('Failed to create custom field', error: e, stackTrace: stack);
      throw _createException('Failed to create custom field', e, stack);
    }
  }

  /// Updates an existing custom field template.
  Future<CustomFieldTemplate> updateCustomField(
    String templateId,
    CustomFieldTemplate template,
  ) async {
    try {
      final updatedTemplate = CustomFieldTemplate.fromJson(
        await _apiClient.putMap('/custom-fields/$templateId', data: template.toJson()),
      );
      _logger.i('Updated custom field template: $templateId');
      return updatedTemplate;
    } catch (e, stack) {
      _logger.e('Failed to update custom field', error: e, stackTrace: stack);
      throw _createException('Failed to update custom field', e, stack);
    }
  }

  /// Deletes a custom field template.
  Future<void> deleteCustomField(String templateId) async {
    try {
      await _apiClient.deleteTemplate(templateId);
      _logger.i('Deleted custom field template: $templateId');
    } catch (e, stack) {
      _logger.e('Failed to delete custom field', error: e, stackTrace: stack);
      throw _createException('Failed to delete custom field', e, stack);
    }
  }

  Exception _createException(String message, dynamic error, StackTrace stack) {
    return Exception('$message: ${error.toString()}');
  }
}

final fieldLibraryServiceProvider = Provider<FieldLibraryService>((ref) {
  return FieldLibraryService(ref.watch(apiClientProvider));
});
