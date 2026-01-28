import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/builder_form.dart';

part 'form_builder_repository.g.dart';

abstract class FormBuilderRepository {
  Future<BuilderForm> getForm(String id);
  Future<void> saveForm(BuilderForm form);
}

@riverpod
FormBuilderRepository formBuilderRepository(Ref ref) {
  // Implementation will be provided in data layer
  throw UnimplementedError();
}
