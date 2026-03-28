import 'dart:io';

void main() {
  final file = File('lib/features/form_builder/presentation/controllers/form_builder_controller.dart');
  String content = file.readAsStringSync();

  // 1. Refactor updateQuestionLabel
  content = content.replaceAll(
    RegExp(r'void updateQuestionLabel\(String questionId, String label\) \{[\s\S]+?\}\n\n  void updateQuestionHelperText', dotAll: true),
    '''Future<void> updateQuestionLabel(String questionId, String label) async {
    if (state.value == null) return;
    final locale = state.value!.editingLocale;
    
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
  }

  Future<void> updateQuestionHelperText''',
  );

  // 2. Refactor updateQuestionHelperText
  content = content.replaceAll(
    RegExp(r'void updateQuestionHelperText\(String questionId, String helperText\) \{[\s\S]+?\}\n\n  void updateQuestionPlaceholder', dotAll: true),
    '''Future<void> updateQuestionHelperText(String questionId, String helperText) async {
    if (state.value == null) return;
    final locale = state.value!.editingLocale;
    
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
        helperText: _updateLocalizedField(targetQuestion.helperText, helperText, locale),
      );
      final updatedQuestions = targetSection.questions.map((q) => q.id == questionId ? updatedQuestion : q).toList();
      await _updateSectionAndState(targetSection.copyWith(questions: updatedQuestions));
    }
  }

  Future<void> updateQuestionPlaceholder''',
  );

  // 3. Refactor updateQuestionPlaceholder
  content = content.replaceAll(
    RegExp(r'void updateQuestionPlaceholder\(String questionId, String placeholder\) \{[\s\S]+?\}\n\n  void updateQuestionDefaultValue', dotAll: true),
    '''Future<void> updateQuestionPlaceholder(String questionId, String placeholder) async {
    if (state.value == null) return;
    final locale = state.value!.editingLocale;
    
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
        placeholder: _updateLocalizedField(targetQuestion.placeholder, placeholder, locale),
      );
      final updatedQuestions = targetSection.questions.map((q) => q.id == questionId ? updatedQuestion : q).toList();
      await _updateSectionAndState(targetSection.copyWith(questions: updatedQuestions));
    }
  }

  Future<void> updateQuestionDefaultValue''',
  );

  // 4. Refactor updateQuestionDefaultValue
  content = content.replaceAll(
    RegExp(r'void updateQuestionDefaultValue\(String questionId, dynamic defaultValue\) \{[\s\S]+?\}\n\n  void selectForm', dotAll: true),
    '''Future<void> updateQuestionDefaultValue(String questionId, dynamic defaultValue) async {
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
        defaultValue: defaultValue,
      );
      final updatedQuestions = targetSection.questions.map((q) => q.id == questionId ? updatedQuestion : q).toList();
      await _updateSectionAndState(targetSection.copyWith(questions: updatedQuestions));
    }
  }

  void selectForm''',
  );

  file.writeAsStringSync(content);
}
