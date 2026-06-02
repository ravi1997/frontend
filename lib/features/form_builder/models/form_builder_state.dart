import 'package:frontend/core/form_models.dart';

class FormBuilderState {
  final Form form;
  final String? selectedSectionId;
  final String? selectedQuestionId;
  final List<String> selectedQuestionIds;
  final bool isFormSelected;
  final bool isDirty;
  final bool canUndo;
  final bool canRedo;
  final bool isSaving;
  final bool isLoading;
  final String editingLocale;
  final String? error;

  FormBuilderState({
    required this.form,
    this.selectedSectionId,
    this.selectedQuestionId,
    this.selectedQuestionIds = const [],
    this.isFormSelected = false,
    this.isDirty = false,
    this.canUndo = false,
    this.canRedo = false,
    this.isSaving = false,
    this.isLoading = false,
    this.editingLocale = 'en',
    this.error,
  });

  FormBuilderState copyWith({
    Form? form,
    String? selectedSectionId,
    String? selectedQuestionId,
    List<String>? selectedQuestionIds,
    bool? isFormSelected,
    bool? isDirty,
    bool? canUndo,
    bool? canRedo,
    bool? isSaving,
    bool? isLoading,
    String? editingLocale,
    String? error,
  }) {
    return FormBuilderState(
      form: form ?? this.form,
      selectedSectionId: selectedSectionId ?? this.selectedSectionId,
      selectedQuestionId: selectedQuestionId ?? this.selectedQuestionId,
      selectedQuestionIds: selectedQuestionIds ?? this.selectedQuestionIds,
      isFormSelected: isFormSelected ?? this.isFormSelected,
      isDirty: isDirty ?? this.isDirty,
      canUndo: canUndo ?? this.canUndo,
      canRedo: canRedo ?? this.canRedo,
      isSaving: isSaving ?? this.isSaving,
      isLoading: isLoading ?? this.isLoading,
      editingLocale: editingLocale ?? this.editingLocale,
      error: error ?? this.error,
    );
  }
}
