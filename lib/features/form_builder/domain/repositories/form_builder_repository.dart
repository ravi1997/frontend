import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/builder_form.dart';
import '../../domain/entities/form_version_history.dart';
import '../../data/repositories/mock_form_builder_repository.dart';

part 'form_builder_repository.g.dart';

abstract class FormBuilderRepository {
  Future<BuilderForm> getForm(String id);
  Future<List<FormVersionHistory>> getVersionHistory(String formId);
  Future<BuilderForm> getFormVersion(String formId, String version);
  Future<void> saveForm(BuilderForm form);
}

@riverpod
FormBuilderRepository formBuilderRepository(Ref ref) {
  return MockFormBuilderRepository();
}
