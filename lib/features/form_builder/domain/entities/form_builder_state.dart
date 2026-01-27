import 'package:freezed_annotation/freezed_annotation.dart';
import 'builder_form.dart';

part 'form_builder_state.freezed.dart';

@freezed
abstract class FormBuilderState with _$FormBuilderState {
  const factory FormBuilderState({
    required BuilderForm form,
    String? selectedSectionId,
    String? selectedQuestionId,
    @Default(false) bool isSaving,
    @Default(false) bool isLoading,
    String? error,
  }) = _FormBuilderState;
}
