import 'package:frontend/shared/models/form_models.dart';
import 'package:frontend/modules/forms/models/form_version_history.dart';
import 'package:frontend/modules/forms/models/custom_field_template.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/networking/dio_provider.dart';
import 'package:frontend/modules/forms/data/repositories/form_builder_repository_impl.dart';

abstract class FormBuilderRepository {
  Future<BuilderForm> getForm(String projectId, String id);
  Future<List<FormVersionHistory>> getVersionHistory(
    String projectId,
    String formId,
  );
  Future<BuilderForm> getFormVersion(
    String projectId,
    String formId,
    String version,
  );
  Future<BuilderForm> saveForm(
    BuilderForm form, {
    required String projectId,
    String versionType = 'patch',
  });
  Future<void> updateFormVersion(
    String projectId,
    String formId,
    String version,
    Map<String, dynamic> data,
  );
  Future<void> createFormVersion(
    String projectId,
    String formId,
    Map<String, dynamic> data, {
    String type = 'patch',
    bool activate = true,
  });
  Future<Map<String, dynamic>> saveDraft(String projectId, BuilderForm form);
  Future<Map<String, dynamic>> getBuilderMetadata();
  Future<bool> isSlugAvailable(
    String slug, {
    String? formId,
    String? projectId,
  });
  Future<Map<String, dynamic>> exportSchema(String projectId, String formId);
  Future<BuilderForm> restoreFormVersion(
    String projectId,
    String formId,
    String version,
  );
  Future<Map<String, dynamic>> publishForm(String projectId, String formId);
  Future<List<FormSection>> generateFieldsWithAI(
    String prompt, {
    BuilderForm? currentForm,
  });
  Future<List<Map<String, dynamic>>> getAISuggestions(BuilderForm form);
  Future<Map<String, dynamic>> validateFormWithAI(BuilderForm form);

  // Templates
  Future<List<CustomFieldTemplate>> getTemplates();
  Future<void> saveTemplate(CustomFieldTemplate template);

  // Translations
  Future<Map<String, dynamic>> getTranslations(
    String formId, {
    String? language,
  });
  Future<void> saveTranslations(
    String formId,
    String language,
    Map<String, dynamic> translations,
  );

  // Clone
  Future<BuilderForm> cloneForm(
    String projectId,
    String formId, {
    String? title,
    String? slug,
  });
}

final formBuilderRepositoryProvider = Provider<FormBuilderRepository>((ref) {
  // Use real implementation
  return FormBuilderRepositoryImpl(ref.watch(apiClientProvider));
});
