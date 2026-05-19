import 'dart:async';
import 'package:flutter/foundation.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/utils/error_handler.dart';
import '../../domain/entities/builder_form.dart';
import '../../domain/entities/form_builder_state.dart';
import '../../domain/entities/form_question.dart';
import '../../domain/entities/form_section.dart';
import '../../domain/entities/section_layout_type.dart';
import '../../domain/entities/question_type.dart';
import '../../domain/repositories/form_builder_repository.dart';
import '../../domain/entities/form_version_history.dart';
import '../../domain/services/field_registry.dart';
import '../../domain/entities/custom_field_template.dart';
import '../../domain/entities/access_policy.dart';

part 'form_builder_controller.g.dart';

@riverpod
class FormBuilderController extends _$FormBuilderController {
  final _uuid = const Uuid();
  String _projectId = '';
  String _formId = '';
  BuilderForm? _savedFormSnapshot;
  final List<BuilderForm> _undoStack = [];
  final List<BuilderForm> _redoStack = [];
  BuilderForm? _lastHistoryForm;

  @override
  FutureOr<FormBuilderState> build(String formKey) async {
    final parts = formKey.split('::');
    _projectId = parts.first;
    _formId = parts.sublist(1).join('::');

    // For now, let's create an empty form if formId is 'new'
    if (_formId == 'new') {
      final initialForm = BuilderForm(
        id: _uuid.v4(),
        title: 'Untitled Form',
        sections: [
          FormSection(id: _uuid.v4(), title: 'Untitled Section', questions: []),
        ],
      );
      _savedFormSnapshot = initialForm;
      _lastHistoryForm = initialForm;
      return FormBuilderState(form: initialForm);
    }

    // Otherwise fetch from repository
    final repository = ref.read(formBuilderRepositoryProvider);
    final form = await repository.getForm(_projectId, _formId);
    _savedFormSnapshot = form;
    _lastHistoryForm = form;
    return FormBuilderState(form: form);
  }

  void _captureHistorySnapshot() {
    if (state.value == null) return;
    final currentForm = state.value!.form;
    if (_lastHistoryForm != null && _lastHistoryForm == currentForm) return;
    if (_lastHistoryForm != null) {
      _undoStack.add(_lastHistoryForm!);
    }
    _lastHistoryForm = currentForm;
    _redoStack.clear();
  }

  void _setState(FormBuilderState nextState, {bool markDirty = false}) {
    state = AsyncValue.data(
      nextState.copyWith(
        isDirty: markDirty ? true : nextState.isDirty,
        canUndo: _undoStack.isNotEmpty,
        canRedo: _redoStack.isNotEmpty,
      ),
    );
  }

  void _markDirty() {
    if (state.value == null) return;
    _captureHistorySnapshot();
    _setState(state.value!, markDirty: true);
  }

  bool get canUndo => _undoStack.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;

  void undo() {
    if (state.value == null || _undoStack.isEmpty) return;
    final current = state.value!.form;
    final previous = _undoStack.removeLast();
    _redoStack.add(current);
    state = AsyncValue.data(
      state.value!.copyWith(
        form: previous,
        isDirty: _savedFormSnapshot != previous,
        canUndo: _undoStack.isNotEmpty,
        canRedo: _redoStack.isNotEmpty,
      ),
    );
    _lastHistoryForm = previous;
  }

  void redo() {
    if (state.value == null || _redoStack.isEmpty) return;
    final current = state.value!.form;
    final next = _redoStack.removeLast();
    _undoStack.add(current);
    state = AsyncValue.data(
      state.value!.copyWith(
        form: next,
        isDirty: _savedFormSnapshot != next,
        canUndo: _undoStack.isNotEmpty,
        canRedo: _redoStack.isNotEmpty,
      ),
    );
    _lastHistoryForm = next;
  }

  void discardChanges() {
    if (state.value == null || _savedFormSnapshot == null) return;
    _undoStack.clear();
    _redoStack.clear();
    _lastHistoryForm = _savedFormSnapshot;
    state = AsyncValue.data(
      state.value!.copyWith(
        form: _savedFormSnapshot!,
        selectedSectionId: null,
        selectedQuestionId: null,
        isFormSelected: false,
        isDirty: false,
        canUndo: false,
        canRedo: false,
      ),
    );
  }

  dynamic _updateLocalizedField(
    dynamic current,
    String newValue,
    String locale,
  ) {
    if (current is Map) {
      return {...Map<String, dynamic>.from(current), locale: newValue};
    }
    return {'en': current?.toString() ?? '', locale: newValue};
  }

  FormSection? _updateSectionById(
    String sectionId,
    FormSection Function(FormSection section) updater,
  ) {
    if (state.value == null) return null;

    final sections = [...state.value!.form.sections];
    final index = sections.indexWhere((section) => section.id == sectionId);
    if (index == -1) return null;

    final updatedSection = updater(sections[index]);
    sections[index] = updatedSection;

    state = AsyncValue.data(
      state.value!.copyWith(
        form: state.value!.form.copyWith(sections: sections),
      ),
    );
    _markDirty();
    return updatedSection;
  }

  void setEditingLocale(String locale) {
    if (state.value == null) return;
    state = AsyncValue.data(state.value!.copyWith(editingLocale: locale));
  }

  void updateFormTitle(String title) {
    if (state.value == null) return;
    final locale = state.value!.editingLocale;
    updateLocalizedFormTitle(title, locale);
  }

  void updateLocalizedFormTitle(String title, String locale) {
    if (state.value == null) return;
    state = AsyncValue.data(
      state.value!.copyWith(
        form: state.value!.form.copyWith(
          title: _updateLocalizedField(state.value!.form.title, title, locale),
        ),
      ),
    );
    _markDirty();
  }

  void updateLocalizedSectionTitle(
    String sectionId,
    String title,
    String locale,
  ) {
    _updateSectionById(
      sectionId,
      (section) => section.copyWith(
        title: _updateLocalizedField(section.title, title, locale),
      ),
    );
    _markDirty();
  }

  void updateLocalizedSectionDescription(
    String sectionId,
    String description,
    String locale,
  ) {
    _updateSectionById(
      sectionId,
      (section) => section.copyWith(
        description: _updateLocalizedField(
          section.description,
          description,
          locale,
        ),
      ),
    );
    _markDirty();
  }

  void updateLocalizedQuestionLabel(
    String questionId,
    String label,
    String locale,
  ) {
    _updateQuestion(
      questionId,
      (q) => q.copyWith(label: _updateLocalizedField(q.label, label, locale)),
    );
    _markDirty();
  }

  void updateLocalizedQuestionHelperText(
    String questionId,
    String text,
    String locale,
  ) {
    _updateQuestion(
      questionId,
      (q) => q.copyWith(
        helperText: _updateLocalizedField(q.helperText, text, locale),
      ),
    );
    _markDirty();
  }

  void updateLocalizedQuestionPlaceholder(
    String questionId,
    String text,
    String locale,
  ) {
    _updateQuestion(
      questionId,
      (q) => q.copyWith(
        placeholder: _updateLocalizedField(q.placeholder, text, locale),
      ),
    );
    _markDirty();
  }

  /// Generic helper to search for and update a question across all sections.
  void _updateQuestion(
    String questionId,
    FormQuestion Function(FormQuestion) updater,
  ) {
    if (state.value == null) return;
    final sections = state.value!.form.sections.map((s) {
      final qIndex = s.questions.indexWhere((q) => q.id == questionId);
      if (qIndex != -1) {
        final newQuestions = [...s.questions];
        newQuestions[qIndex] = updater(newQuestions[qIndex]);
        return s.copyWith(questions: newQuestions);
      }
      return s;
    }).toList();
    state = AsyncValue.data(
      state.value!.copyWith(
        form: state.value!.form.copyWith(sections: sections),
      ),
    );
    _markDirty();
  }

  void updateQuestionRequired(String questionId, bool required) {
    _updateQuestion(questionId, (q) => q.copyWith(isRequired: required));
  }

  Future<void> addSection({String? parentSectionId}) async {
    if (state.value == null) return;

    FormSection newSection = FormSection(
      id: _uuid.v4(),
      title: 'Untitled Section',
      questions: [],
      layout: SectionLayoutType.standard,
    );

    if (parentSectionId != null) {
      final sections = _addNestedSection(
        state.value!.form.sections,
        parentSectionId,
        newSection,
      );
      if (sections == null) return;
      state = AsyncValue.data(
        state.value!.copyWith(
          form: state.value!.form.copyWith(sections: sections),
          selectedSectionId: newSection.id,
          selectedQuestionId: null,
          isFormSelected: false,
        ),
      );
      _markDirty();
      return;
    }

    state = AsyncValue.data(
      state.value!.copyWith(
        form: state.value!.form.copyWith(
          sections: [...state.value!.form.sections, newSection],
        ),
        selectedSectionId: newSection.id,
        selectedQuestionId: null,
        isFormSelected: false,
      ),
    );
    _markDirty();
  }

  List<FormSection>? _addNestedSection(
    List<FormSection> sections,
    String parentSectionId,
    FormSection newSection,
  ) {
    return sections.map((section) {
      if (section.id == parentSectionId) {
        return section.copyWith(sections: [...section.sections, newSection]);
      }
      if (section.sections.isEmpty) return section;
      final nested = _addNestedSection(
        section.sections,
        parentSectionId,
        newSection,
      );
      return nested == null ? section : section.copyWith(sections: nested);
    }).toList();
  }

  Future<void> removeSection(String sectionId) async {
    if (state.value == null) return;

    final sections = _removeSectionRecursive(
      state.value!.form.sections,
      sectionId,
    );

    state = AsyncValue.data(
      state.value!.copyWith(
        form: state.value!.form.copyWith(sections: sections),
        selectedSectionId: state.value!.selectedSectionId == sectionId
            ? null
            : state.value!.selectedSectionId,
      ),
    );
    _markDirty();
  }

  List<FormSection> _removeSectionRecursive(
    List<FormSection> sections,
    String sectionId,
  ) {
    return sections.where((section) => section.id != sectionId).map((section) {
      if (section.sections.isEmpty) return section;
      final nested = _removeSectionRecursive(section.sections, sectionId);
      if (nested.length == section.sections.length) {
        return section;
      }
      return section.copyWith(sections: nested);
    }).toList();
  }

  void addQuestion(String sectionId, QuestionType type) {
    if (state.value == null) return;
    final newQuestion = FieldRegistry.getDefaultQuestion(type);

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
        isFormSelected: false,
      ),
    );
    _markDirty();
  }

  void addFromTemplate(String? sectionId, CustomFieldTemplate template) {
    if (state.value == null) return;

    if (template.template_type == 'question' && sectionId != null) {
      final question = FormQuestion.fromJson(template.data);
      final newQuestion = question.copyWith(id: _uuid.v4());

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
          isFormSelected: false,
        ),
      );
      _markDirty();
    } else if (template.template_type == 'section') {
      final section = FormSection.fromJson(template.data);
      final newSection = section.copyWith(id: _uuid.v4());

      state = AsyncValue.data(
        state.value!.copyWith(
          form: state.value!.form.copyWith(
            sections: [...state.value!.form.sections, newSection],
          ),
          selectedSectionId: newSection.id,
          selectedQuestionId: null,
          isFormSelected: false,
        ),
      );
      _markDirty();
    } else if (template.template_type == 'workflow') {
      final currentWorkflows = Map<String, dynamic>.from(
        state.value!.form.workflows,
      );
      currentWorkflows.addAll(template.data);
      state = AsyncValue.data(
        state.value!.copyWith(
          form: state.value!.form.copyWith(workflows: currentWorkflows),
        ),
      );
      _markDirty();
    }
  }

  // ---------------------------------------------------------------------------
  // Library click helpers — resolve insertion target from active state
  // ---------------------------------------------------------------------------

  /// Resolves the insertion section (selected → first → no-op) and calls
  /// [addQuestion].  Called by the field library on tile tap.
  void addQuestionToActiveSection(QuestionType type) {
    if (state.value == null) return;
    final sections = state.value!.form.sections;
    if (sections.isEmpty) {
      debugPrint(
        'addQuestionToActiveSection: no sections exist — add a section first.',
      );
      return;
    }
    final targetId = state.value!.selectedSectionId ?? sections.first.id;
    addQuestion(targetId, type);
  }

  /// Resolves the insertion section and calls [addFromTemplate].
  /// Section-type and workflow-type templates ignore the section target.
  void addTemplateToActiveSection(CustomFieldTemplate template) {
    if (state.value == null) return;
    final sections = state.value!.form.sections;
    final targetId = sections.isNotEmpty
        ? (state.value!.selectedSectionId ?? sections.first.id)
        : null;
    addFromTemplate(targetId, template);
  }

  void updateQuestionMetadata(
    String questionId,
    Map<String, dynamic> metadata,
  ) {
    if (state.value == null) return;
    final sections = state.value!.form.sections.map((s) {
      final qIndex = s.questions.indexWhere((q) => q.id == questionId);
      if (qIndex != -1) {
        final updatedQuestion = s.questions[qIndex].copyWith(
          metadata: {...s.questions[qIndex].metadata ?? {}, ...metadata},
        );
        final newQuestions = [...s.questions];
        newQuestions[qIndex] = updatedQuestion;
        return s.copyWith(questions: newQuestions);
      }
      return s;
    }).toList();

    state = AsyncValue.data(
      state.value!.copyWith(
        form: state.value!.form.copyWith(sections: sections),
      ),
    );
    _markDirty();
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
        selectedQuestionIds: state.value!.selectedQuestionIds
            .where((id) => id != questionId)
            .toList(),
      ),
    );
    _markDirty();
  }

  void selectQuestion(String? sectionId, String? questionId) {
    if (state.value == null) return;
    state = AsyncValue.data(
      state.value!.copyWith(
        selectedSectionId: sectionId,
        selectedQuestionId: questionId,
        selectedQuestionIds: questionId == null ? const [] : [questionId],
        isFormSelected: false,
      ),
    );
  }

  void toggleQuestionSelection(String sectionId, String questionId) {
    if (state.value == null) return;
    final selected = [...state.value!.selectedQuestionIds];
    if (selected.contains(questionId)) {
      selected.remove(questionId);
    } else {
      selected.add(questionId);
    }

    state = AsyncValue.data(
      state.value!.copyWith(
        selectedSectionId: selected.isEmpty ? sectionId : null,
        selectedQuestionId: selected.length == 1 ? selected.first : null,
        selectedQuestionIds: selected,
        isFormSelected: false,
      ),
    );
  }

  void clearQuestionSelections() {
    if (state.value == null) return;
    state = AsyncValue.data(
      state.value!.copyWith(
        selectedQuestionId: null,
        selectedQuestionIds: const [],
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
    _markDirty();
  }

  void convertQuestionType(String questionId, QuestionType newType) {
    if (state.value == null) return;

    final sections = state.value!.form.sections.map((s) {
      final questionIndex = s.questions.indexWhere((q) => q.id == questionId);
      if (questionIndex == -1) return s;

      final currentQuestion = s.questions[questionIndex];
      final convertedQuestion = FieldRegistry.convertQuestionType(
        currentQuestion,
        newType,
      );

      final newQuestions = [...s.questions];
      newQuestions[questionIndex] = convertedQuestion;
      return s.copyWith(questions: newQuestions);
    }).toList();

    state = AsyncValue.data(
      state.value!.copyWith(
        form: state.value!.form.copyWith(sections: sections),
      ),
    );
    _markDirty();
  }

  void updateQuestionsBulk(
    List<String> questionIds,
    FormQuestion Function(FormQuestion question) updater,
  ) {
    if (state.value == null || questionIds.isEmpty) return;
    final ids = questionIds.toSet();
    final sections = state.value!.form.sections.map((s) {
      final newQuestions = s.questions.map((q) {
        if (!ids.contains(q.id)) return q;
        return updater(q);
      }).toList();
      return s.copyWith(questions: newQuestions);
    }).toList();

    state = AsyncValue.data(
      state.value!.copyWith(
        form: state.value!.form.copyWith(sections: sections),
      ),
    );
    _markDirty();
  }

  void convertQuestionsBulk(List<String> questionIds, QuestionType newType) {
    updateQuestionsBulk(
      questionIds,
      (question) => FieldRegistry.convertQuestionType(question, newType),
    );
  }

  void updateQuestionLabel(String questionId, String label) {
    if (state.value == null) return;
    final locale = state.value!.editingLocale;
    final sections = state.value!.form.sections.map((s) {
      final qIndex = s.questions.indexWhere((q) => q.id == questionId);
      if (qIndex != -1) {
        final newQuestions = [...s.questions];
        newQuestions[qIndex] = newQuestions[qIndex].copyWith(
          label: _updateLocalizedField(
            newQuestions[qIndex].label,
            label,
            locale,
          ),
        );
        return s.copyWith(questions: newQuestions);
      }
      return s;
    }).toList();

    state = AsyncValue.data(
      state.value!.copyWith(
        form: state.value!.form.copyWith(sections: sections),
      ),
    );
    _markDirty();
  }

  void updateQuestionHelperText(String questionId, String helperText) {
    if (state.value == null) return;
    final locale = state.value!.editingLocale;
    final sections = state.value!.form.sections.map((s) {
      final qIndex = s.questions.indexWhere((q) => q.id == questionId);
      if (qIndex != -1) {
        final newQuestions = [...s.questions];
        newQuestions[qIndex] = newQuestions[qIndex].copyWith(
          helperText: _updateLocalizedField(
            newQuestions[qIndex].helperText,
            helperText,
            locale,
          ),
        );
        return s.copyWith(questions: newQuestions);
      }
      return s;
    }).toList();

    state = AsyncValue.data(
      state.value!.copyWith(
        form: state.value!.form.copyWith(sections: sections),
      ),
    );
    _markDirty();
  }

  void updateQuestionPlaceholder(String questionId, String placeholder) {
    if (state.value == null) return;
    final locale = state.value!.editingLocale;
    final sections = state.value!.form.sections.map((s) {
      final qIndex = s.questions.indexWhere((q) => q.id == questionId);
      if (qIndex != -1) {
        final newQuestions = [...s.questions];
        newQuestions[qIndex] = newQuestions[qIndex].copyWith(
          placeholder: _updateLocalizedField(
            newQuestions[qIndex].placeholder,
            placeholder,
            locale,
          ),
        );
        return s.copyWith(questions: newQuestions);
      }
      return s;
    }).toList();

    state = AsyncValue.data(
      state.value!.copyWith(
        form: state.value!.form.copyWith(sections: sections),
      ),
    );
    _markDirty();
  }

  void updateQuestionDefaultValue(String questionId, dynamic defaultValue) {
    if (state.value == null) return;
    final sections = state.value!.form.sections.map((s) {
      final qIndex = s.questions.indexWhere((q) => q.id == questionId);
      if (qIndex != -1) {
        final newQuestions = [...s.questions];
        newQuestions[qIndex] = newQuestions[qIndex].copyWith(
          defaultValue: defaultValue,
        );
        return s.copyWith(questions: newQuestions);
      }
      return s;
    }).toList();

    state = AsyncValue.data(
      state.value!.copyWith(
        form: state.value!.form.copyWith(sections: sections),
      ),
    );
    _markDirty();
  }

  void selectForm() {
    if (state.value == null) return;
    state = AsyncValue.data(
      state.value!.copyWith(
        selectedSectionId: null,
        selectedQuestionId: null,
        selectedQuestionIds: const [],
        isFormSelected: true,
      ),
    );
  }

  void selectSection(String sectionId) {
    if (state.value == null) return;
    state = AsyncValue.data(
      state.value!.copyWith(
        selectedSectionId: sectionId,
        selectedQuestionId: null,
        selectedQuestionIds: const [],
        isFormSelected: false,
      ),
    );
  }

  void updateSection(FormSection updatedSection) {
    _updateSectionById(updatedSection.id, (_) => updatedSection);
  }

  void updateSectionTitle(String sectionId, String title) {
    if (state.value == null) return;
    _updateSectionById(sectionId, (section) => section.copyWith(title: title));
  }

  void updateSectionDescription(String sectionId, String description) {
    if (state.value == null) return;
    _updateSectionById(
      sectionId,
      (section) => section.copyWith(description: description),
    );
  }

  void updateForm(BuilderForm updatedForm) {
    if (state.value == null) return;
    state = AsyncValue.data(
      state.value!.copyWith(
        form: updatedForm.copyWith(sections: state.value!.form.sections),
      ),
    );
    _markDirty();
  }

  void updateWorkflows(Map<String, dynamic> workflows) {
    if (state.value == null) return;
    state = AsyncValue.data(
      state.value!.copyWith(
        form: state.value!.form.copyWith(workflows: workflows),
      ),
    );
    _markDirty();
  }

  void reorderSections(int oldIndex, int newIndex) {
    if (state.value == null) return;

    final sections = [...state.value!.form.sections];
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = sections.removeAt(oldIndex);
    sections.insert(newIndex, item);

    state = AsyncValue.data(
      state.value!.copyWith(
        form: state.value!.form.copyWith(sections: sections),
      ),
    );
    _markDirty();
  }

  void reorderQuestions(String sectionId, int oldIndex, int newIndex) {
    if (state.value == null) return;

    final sections = state.value!.form.sections.map((s) {
      if (s.id == sectionId) {
        final questions = [...s.questions];
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        final item = questions.removeAt(oldIndex);
        questions.insert(newIndex, item);
        return s.copyWith(questions: questions);
      }
      return s;
    }).toList();

    state = AsyncValue.data(
      state.value!.copyWith(
        form: state.value!.form.copyWith(sections: sections),
      ),
    );
    _markDirty();
  }

  void moveQuestion(
    String fromSectionId,
    String toSectionId,
    String questionId,
    int newIndex,
  ) {
    if (state.value == null) return;

    FormQuestion? movingQuestion;

    // 1. Remove from source section
    final sectionsWithRemoved = state.value!.form.sections.map((s) {
      if (s.id == fromSectionId) {
        final qIndex = s.questions.indexWhere((q) => q.id == questionId);
        if (qIndex != -1) {
          movingQuestion = s.questions[qIndex];
          final questions = [...s.questions];
          questions.removeAt(qIndex);
          return s.copyWith(questions: questions);
        }
      }
      return s;
    }).toList();

    if (movingQuestion == null) return;

    // 2. Add to destination section
    final finalSections = sectionsWithRemoved.map((s) {
      if (s.id == toSectionId) {
        final questions = [...s.questions];
        if (newIndex > questions.length) newIndex = questions.length;
        questions.insert(newIndex, movingQuestion!);
        return s.copyWith(questions: questions);
      }
      return s;
    }).toList();

    state = AsyncValue.data(
      state.value!.copyWith(
        form: state.value!.form.copyWith(sections: finalSections),
        selectedSectionId: toSectionId,
        selectedQuestionId: questionId,
      ),
    );
    _markDirty();
  }

  void duplicateQuestion(String sectionId, FormQuestion question) {
    if (state.value == null) return;

    final newQuestion = question.copyWith(
      id: _uuid.v4(),
      label: '${question.label} (Copy)',
    );

    final sections = state.value!.form.sections.map((s) {
      if (s.id == sectionId) {
        final qIndex = s.questions.indexWhere((q) => q.id == question.id);
        if (qIndex != -1) {
          final questions = [...s.questions];
          questions.insert(qIndex + 1, newQuestion);
          return s.copyWith(questions: questions);
        }
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
    _markDirty();
  }

  Future<bool> saveForm({String versionType = 'patch'}) async {
    if (state.value == null) return false;
    final currentForm = state.value!.form;
    state = AsyncValue.data(state.value!.copyWith(isSaving: true));
    try {
      final repository = ref.read(formBuilderRepositoryProvider);
      await repository.saveForm(
        currentForm,
        projectId: _projectId,
        versionType: versionType,
      );
      state = AsyncValue.data(
        state.value!.copyWith(
          form: currentForm,
          isSaving: false,
          isDirty: false,
          canUndo: false,
          canRedo: false,
        ),
      );
      _savedFormSnapshot = currentForm;
      _undoStack.clear();
      _redoStack.clear();
      _lastHistoryForm = currentForm;
      return true;
    } catch (e) {
      final error = ErrorHandler.handle(e);
      state = AsyncValue.data(
        state.value!.copyWith(isSaving: false, error: error),
      );
      return false;
    }
  }

  Future<bool> promoteVersion(String type) async {
    return saveForm(versionType: type);
  }

  Future<bool> publishForm() async {
    if (state.value == null) return false;

    state = AsyncValue.data(state.value!.copyWith(isSaving: true));

    try {
      final repository = ref.read(formBuilderRepositoryProvider);
      final result = await repository.publishForm(state.value!.form.id);

      final publishedVersion =
          result['published_version'] as String? ?? state.value!.form.version;

      // We'll update the local state to reflect it's published.
      // Ideally we re-fetch the form, but let's update immediately for UX.

      final newHistoryEntry = FormVersionHistory(
        version: publishedVersion,
        created_at: DateTime.now(),
        changeLog: 'Form published',
      );

      final updatedForm = state.value!.form.copyWith(
        isPublished: true,
        status: 'published',
        version:
            publishedVersion, // Display published version or shift to next draft?
        // Usually after publish, we stay on the page. The page might switch to 'Draft Mode' for V2.
        // Let's assume we show the published state primarily.
        versionHistory: [...state.value!.form.versionHistory, newHistoryEntry],
      );

      state = AsyncValue.data(
        state.value!.copyWith(
          form: updatedForm,
          isSaving: false,
          isDirty: false,
          canUndo: false,
          canRedo: false,
        ),
      );
      _savedFormSnapshot = updatedForm;
      _undoStack.clear();
      _redoStack.clear();
      _lastHistoryForm = updatedForm;
      return true;
    } catch (e) {
      final error = ErrorHandler.handle(e);
      state = AsyncValue.data(
        state.value!.copyWith(isSaving: false, error: error),
      );
      return false;
    }
  }

  Future<void> generateFieldsWithAI(String prompt) async {
    if (state.value == null) return;

    try {
      final repository = ref.read(formBuilderRepositoryProvider);
      final generatedSections = await repository.generateFieldsWithAI(
        prompt,
        currentForm: state.value!.form,
      );

      final updatedSections = [
        ...state.value!.form.sections,
        ...generatedSections,
      ];

      state = AsyncValue.data(
        state.value!.copyWith(
          form: state.value!.form.copyWith(sections: updatedSections),
        ),
      );
      _markDirty();
    } catch (e) {
      final error = ErrorHandler.handle(e);
      state = AsyncValue.data(state.value!.copyWith(error: error));
    }
  }

  Future<List<Map<String, dynamic>>> getAISuggestions() async {
    if (state.value == null) return [];
    try {
      final repository = ref.read(formBuilderRepositoryProvider);
      return await repository.getAISuggestions(state.value!.form);
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> validateFormWithAI() async {
    if (state.value == null) return {};
    try {
      final repository = ref.read(formBuilderRepositoryProvider);
      return await repository.validateFormWithAI(state.value!.form);
    } catch (e) {
      return {
        'score': 0,
        'issues': [
          {'type': 'error', 'message': 'Validation failed: $e'},
        ],
        'suggestions': [],
      };
    }
  }

  void updateSectionMetadata(String sectionId, Map<String, dynamic> metadata) {
    if (state.value == null) return;
    final sections = state.value!.form.sections.map((s) {
      if (s.id == sectionId) {
        return s.copyWith(metaData: {...s.metaData, ...metadata});
      }
      return s;
    }).toList();

    state = AsyncValue.data(
      state.value!.copyWith(
        form: state.value!.form.copyWith(sections: sections),
      ),
    );
    _markDirty();
  }

  void updateFormMetadata(Map<String, dynamic> metadata) {
    if (state.value == null) return;
    state = AsyncValue.data(
      state.value!.copyWith(
        form: state.value!.form.copyWith(
          metadata: {...state.value!.form.metadata, ...metadata},
        ),
      ),
    );
    _markDirty();
  }

  void updateAccessPolicy(AccessPolicy policy) {
    if (state.value == null) return;
    state = AsyncValue.data(
      state.value!.copyWith(
        form: state.value!.form.copyWith(accessPolicy: policy),
      ),
    );
    _markDirty();
  }
}
