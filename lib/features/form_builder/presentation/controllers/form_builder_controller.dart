import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/builder_form.dart';
import '../../domain/entities/form_builder_state.dart';
import '../../domain/entities/form_question.dart';
import '../../domain/entities/form_section.dart';
import '../../domain/entities/question_type.dart';
import '../../domain/repositories/form_builder_repository.dart';

part 'form_builder_controller.g.dart';

@riverpod
class FormBuilderController extends _$FormBuilderController {
  final _uuid = const Uuid();

  @override
  FutureOr<FormBuilderState> build(String formId) async {
    // For now, let's create an empty form if formId is 'new'
    if (formId == 'new') {
      return FormBuilderState(
        form: BuilderForm(
          id: _uuid.v4(),
          title: 'Untitled Form',
          sections: [
            FormSection(
              id: _uuid.v4(),
              title: 'Untitled Section',
              questions: [],
            ),
          ],
        ),
      );
    }

    // Otherwise fetch from repository
    final repository = ref.read(formBuilderRepositoryProvider);
    final form = await repository.getForm(formId);
    return FormBuilderState(form: form);
  }

  void updateFormTitle(String title) {
    if (state.value == null) return;
    state = AsyncValue.data(
      state.value!.copyWith(form: state.value!.form.copyWith(title: title)),
    );
  }

  void addSection() {
    if (state.value == null) return;
    final newSection = FormSection(
      id: _uuid.v4(),
      title: 'Untitled Section',
      questions: [],
    );
    state = AsyncValue.data(
      state.value!.copyWith(
        form: state.value!.form.copyWith(
          sections: [...state.value!.form.sections, newSection],
        ),
        selectedSectionId: newSection.id,
        selectedQuestionId: null,
      ),
    );
  }

  void removeSection(String sectionId) {
    if (state.value == null) return;
    state = AsyncValue.data(
      state.value!.copyWith(
        form: state.value!.form.copyWith(
          sections: state.value!.form.sections
              .where((s) => s.id != sectionId)
              .toList(),
        ),
        selectedSectionId: state.value!.selectedSectionId == sectionId
            ? null
            : state.value!.selectedSectionId,
      ),
    );
  }

  void addQuestion(String sectionId, QuestionType type) {
    if (state.value == null) return;
    final newQuestion = FormQuestion(
      id: _uuid.v4(),
      label: 'Untitled ${type.name.toLowerCase().replaceAll('_', ' ')}',
      type: type,
      placeholder: '${type.label} input placeholder...',
    );

    final sections = state.value!.form.sections.map((s) {
      if (s.id == sectionId) {
        return s.copyWith(questions: [...s.questions, newQuestion]);
      }
      return s;
    }).toList();

    state = AsyncValue.data(
      state.value!.copyWith(
        form: state.value!.form.copyWith(sections: sections),
        selectedQuestionId: newQuestion.id,
        selectedSectionId: sectionId,
      ),
    );
  }

  void removeQuestion(String sectionId, String questionId) {
    if (state.value == null) return;
    final sections = state.value!.form.sections.map((s) {
      if (s.id == sectionId) {
        return s.copyWith(
          questions: s.questions.where((q) => q.id != questionId).toList(),
        );
      }
      return s;
    }).toList();

    state = AsyncValue.data(
      state.value!.copyWith(
        form: state.value!.form.copyWith(sections: sections),
        selectedQuestionId: state.value!.selectedQuestionId == questionId
            ? null
            : state.value!.selectedQuestionId,
      ),
    );
  }

  void selectQuestion(String? sectionId, String? questionId) {
    if (state.value == null) return;
    state = AsyncValue.data(
      state.value!.copyWith(
        selectedSectionId: sectionId,
        selectedQuestionId: questionId,
      ),
    );
  }

  void updateQuestion(FormQuestion updatedQuestion) {
    if (state.value == null) return;
    final sections = state.value!.form.sections.map((s) {
      final questionIndex = s.questions.indexWhere(
        (q) => q.id == updatedQuestion.id,
      );
      if (questionIndex != -1) {
        final newQuestions = [...s.questions];
        newQuestions[questionIndex] = updatedQuestion;
        return s.copyWith(questions: newQuestions);
      }
      return s;
    }).toList();

    state = AsyncValue.data(
      state.value!.copyWith(
        form: state.value!.form.copyWith(sections: sections),
      ),
    );
  }

  Future<void> saveForm() async {
    if (state.value == null) return;
    state = AsyncValue.data(state.value!.copyWith(isSaving: true));
    try {
      final repository = ref.read(formBuilderRepositoryProvider);
      await repository.saveForm(state.value!.form);
      state = AsyncValue.data(state.value!.copyWith(isSaving: false));
    } catch (e) {
      state = AsyncValue.data(
        state.value!.copyWith(isSaving: false, error: e.toString()),
      );
    }
  }
}
