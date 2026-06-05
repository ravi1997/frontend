import 'package:frontend/modules/forms/models/form_template.dart';

/// Repository interface for form template library operations.
///
/// Provides methods to manage pre-built form templates including
/// retrieval, preview, and creation of forms from templates.
abstract class TemplateLibraryRepository {
  /// Gets all available form templates.
  Future<List<FormTemplate>> getAllTemplates();

  /// Gets templates filtered by category.
  Future<List<FormTemplate>> getTemplatesByCategory(
    FormTemplateCategory category,
  );

  /// Gets templates filtered by tag.
  Future<List<FormTemplate>> getTemplatesByTag(String tag);

  /// Gets a specific template by ID.
  Future<FormTemplate> getTemplateById(String templateId);

  /// Creates a new form from a template.
  /// Returns the ID of the newly created form.
  Future<String> createFormFromTemplate(String templateId, String formName);

  /// Increments the usage count for a template.
  Future<void> incrementUsageCount(String templateId);

  /// Creates a custom template from an existing form.
  Future<FormTemplate> createCustomTemplate(
    String formId,
    String templateName,
    String description,
    FormTemplateCategory category,
    List<String> tags,
  );

  /// Deletes a custom template.
  Future<void> deleteTemplate(String templateId);

  /// Searches templates by name or description.
  Future<List<FormTemplate>> searchTemplates(String query);
}
