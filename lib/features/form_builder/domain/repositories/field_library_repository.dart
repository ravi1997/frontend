import '../entities/custom_field_template.dart';

/// Repository interface for custom field template operations.
///
/// Provides methods to CRUD custom field templates from the backend API.
abstract class FieldLibraryRepository {
  /// Gets all custom field templates.
  Future<List<CustomFieldTemplate>> getCustomFields();

  /// Creates a new custom field template.
  Future<CustomFieldTemplate> createCustomField(CustomFieldTemplate template);

  /// Updates an existing custom field template.
  Future<CustomFieldTemplate> updateCustomField(
    String templateId,
    CustomFieldTemplate template,
  );

  /// Deletes a custom field template.
  Future<void> deleteCustomField(String templateId);
}
