import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/builder_form.dart';
import '../../domain/entities/form_version_history.dart';
import '../../domain/entities/form_section.dart';
import '../../domain/entities/custom_field_template.dart';
import '../../../../core/network/api_client_wrapper.dart';
import '../../data/repositories/form_builder_repository_impl.dart';

part 'form_builder_repository.g.dart';

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

@riverpod
FormBuilderRepository formBuilderRepository(Ref ref) {
  // Use real implementation
  final apiClient = ref.watch(apiClientProvider);
  return FormBuilderRepositoryImpl(apiClient);
}
