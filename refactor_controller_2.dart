import 'dart:io';

void main() {
  final file = File('lib/features/form_builder/presentation/controllers/form_builder_controller.dart');
  String content = file.readAsStringSync();

  // Fix updateLocalizedQuestionLabel
  content = content.replaceAll(
    RegExp(r'void updateLocalizedQuestionLabel\([\s\S]+?state = AsyncValue\.data\([\s\S]+?\}\);', dotAll: true),
    '''Future<void> updateLocalizedQuestionLabel(
    String questionId,
    String label,
    String locale,
  ) async {
    if (state.value == null) return;
    FormSection? targetSection;
    FormQuestion? targetQuestion;
    
    for (final s in state.value!.form.sections) {
      final qIndex = s.questions.indexWhere((q) => q.id == questionId);
      if (qIndex != -1) {
        targetSection = s;
        targetQuestion = s.questions[qIndex];
        break;
      }
    }

    if (targetSection != null && targetQuestion != null) {
      final updatedQuestion = targetQuestion.copyWith(
        label: _updateLocalizedField(targetQuestion.label, label, locale),
      );
      final updatedQuestions = targetSection.questions.map((q) => q.id == questionId ? updatedQuestion : q).toList();
      await _updateSectionAndState(targetSection.copyWith(questions: updatedQuestions));
    }
  }'''
  );

  // Fix updateLocalizedQuestionHelperText
  content = content.replaceAll(
    RegExp(r'void updateLocalizedQuestionHelperText\([\s\S]+?state = AsyncValue\.data\([\s\S]+?\}\);', dotAll: true),
    '''Future<void> updateLocalizedQuestionHelperText(
    String questionId,
    String text,
    String locale,
  ) async {
    if (state.value == null) return;
    FormSection? targetSection;
    FormQuestion? targetQuestion;
    
    for (final s in state.value!.form.sections) {
      final qIndex = s.questions.indexWhere((q) => q.id == questionId);
      if (qIndex != -1) {
        targetSection = s;
        targetQuestion = s.questions[qIndex];
        break;
      }
    }

    if (targetSection != null && targetQuestion != null) {
      final updatedQuestion = targetQuestion.copyWith(
        helperText: _updateLocalizedField(targetQuestion.helperText, text, locale),
      );
      final updatedQuestions = targetSection.questions.map((q) => q.id == questionId ? updatedQuestion : q).toList();
      await _updateSectionAndState(targetSection.copyWith(questions: updatedQuestions));
    }
  }'''
  );

  // Fix updateLocalizedQuestionPlaceholder
  content = content.replaceAll(
    RegExp(r'void updateLocalizedQuestionPlaceholder\([\s\S]+?state = AsyncValue\.data\([\s\S]+?\}\);', dotAll: true),
    '''Future<void> updateLocalizedQuestionPlaceholder(
    String questionId,
    String text,
    String locale,
  ) async {
    if (state.value == null) return;
    FormSection? targetSection;
    FormQuestion? targetQuestion;
    
    for (final s in state.value!.form.sections) {
      final qIndex = s.questions.indexWhere((q) => q.id == questionId);
      if (qIndex != -1) {
        targetSection = s;
        targetQuestion = s.questions[qIndex];
        break;
      }
    }

    if (targetSection != null && targetQuestion != null) {
      final updatedQuestion = targetQuestion.copyWith(
        placeholder: _updateLocalizedField(targetQuestion.placeholder, text, locale),
      );
      final updatedQuestions = targetSection.questions.map((q) => q.id == questionId ? updatedQuestion : q).toList();
      await _updateSectionAndState(targetSection.copyWith(questions: updatedQuestions));
    }
  }'''
  );

  file.writeAsStringSync(content);
}
