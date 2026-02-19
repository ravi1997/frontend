import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/builder_form.dart';
import '../../domain/entities/form_version_history.dart';
import '../../domain/entities/form_section.dart';
import '../../../../core/network/api_client_wrapper.dart';
import '../../data/repositories/form_builder_repository_impl.dart';

part 'form_builder_repository.g.dart';

abstract class FormBuilderRepository {
  Future<BuilderForm> getForm(String id);
  Future<List<FormVersionHistory>> getVersionHistory(String formId);
  Future<BuilderForm> getFormVersion(String formId, String version);
  Future<BuilderForm> saveForm(
    BuilderForm form, {
    String versionType = 'patch',
  });
  Future<void> updateFormVersion(
    String formId,
    String version,
    Map<String, dynamic> data,
  );
  Future<void> createFormVersion(
    String formId,
    Map<String, dynamic> data, {
    String type = 'patch',
    bool activate = true,
  });
  Future<Map<String, dynamic>> publishForm(String formId);
  Future<List<FormSection>> generateFieldsWithAI(
    String prompt, {
    BuilderForm? currentForm,
  });
  Future<List<Map<String, dynamic>>> getAISuggestions(BuilderForm form);
  Future<Map<String, dynamic>> validateFormWithAI(BuilderForm form);
}

@riverpod
FormBuilderRepository formBuilderRepository(Ref ref) {
  // Use real implementation
  final apiClient = ref.watch(apiClientProvider);
  return FormBuilderRepositoryImpl(apiClient);
}
