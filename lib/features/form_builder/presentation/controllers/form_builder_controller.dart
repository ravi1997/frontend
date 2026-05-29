import 'dart:async';
import 'package:flutter/foundation.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/utils/error_handler.dart';
import 'package:frontend/models/form_models.dart';
import '../../domain/entities/form_builder_state.dart';
import '../../domain/entities/section_layout_type.dart';
import '../../domain/entities/question_type.dart';
import '../../domain/repositories/form_builder_repository.dart';
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
      final initialSection = FormSection(
        id: _uuid.v4(),
        title: 'Untitled Section',
      );
      final initialVersion = FormVersion(
        id: _uuid.v4(),
        version: '1.0.0',
        sections: [initialSection],
      );
      final initialForm = BuilderForm(
        id: _uuid.v4(),
        title: 'Untitled Form',
        slug: _uuid.v4(),
        organizationId: _projectId,
        createdBy: 'system',
        activeVersion: initialVersion.version,
        versions: [initialVersion],
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

  BuilderForm _replaceFormSections(
    BuilderForm form,
    List<FormSection> sections,
  ) {
    if (form.versions.isEmpty) return form;
    final activeVersion = form.activeVersion ?? form.versions.first.version;
    final updatedVersions = form.versions.map((version) {
      if (version.version == activeVersion) {
        return version.copyWith(sections: sections);
      }
      return version;
    }).toList();
    return form.copyWith(
      activeVersion: activeVersion,
      versions: updatedVersions,
    );
  }

  List<FormSection> _currentSections(BuilderForm form) {
    if (form.versions.isEmpty) return const [];
    final activeVersion = form.activeVersion;
    if (activeVersion == null) return form.versions.first.sections;
    return form.versions.firstWhere(
      (version) => version.version == activeVersion,
      orElse: () => form.versions.first,
    ).sections;
  }

  FormSection? _updateSectionById(
    String sectionId,
    FormSection Function(FormSection section) updater,
  ) {
    if (state.value == null) return null;

    final result = _updateSectionRecursive(
      state.value!.form.sections,
      sectionId,
      updater,
    );
    if (result == null) return null;

    state = AsyncValue.data(
      state.value!.copyWith(
        form: _replaceFormSections(state.value!.form, result.sections),
      ),
    );
    _markDirty();
    return result.updatedSection;
  }

  ({List<FormSection> sections, FormSection updatedSection})?
  _updateSectionRecursive(
    List<FormSection> sections,
    String sectionId,
    FormSection Function(FormSection section) updater,
  ) {
    for (var i = 0; i < sections.length; i++) {
      final section = sections[i];
      if (section.id == sectionId) {
        final updatedSection = updater(section);
        final updatedSections = [...sections]..[i] = updatedSection;
        return (sections: updatedSections, updatedSection: updatedSection);
      }

      if (section.sections.isEmpty) continue;
      final nested = _updateSectionRecursive(
        section.sections,
        sectionId,
        updater,
      );
      if (nested != null) {
        final updatedSection = section.copyWith(sections: nested.sections);
        final updatedSections = [...sections]..[i] = updatedSection;
        return (sections: updatedSections, updatedSection: nested.updatedSection);
      }
    }
    return null;
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
        metadata: {
          ...q.metadata,
          'helper_text': _updateLocalizedField(
            q.metadata['helper_text'],
            text,
            locale,
          ),
        },
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
        metadata: {
          ...q.metadata,
          'placeholder': _updateLocalizedField(
            q.metadata['placeholder'],
            text,
            locale,
          ),
        },
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
        form: _replaceFormSections(state.value!.form, sections),
      ),
    );
    _markDirty();
  }

  void updateQuestionRequired(String questionId, bool required) {
    _updateQuestion(
      questionId,
      (q) => q.copyWith(
        validation: {
          ...q.validation,
          'is_required': required,
        },
      ),
    );
  }

  Future<void> addSection({String? parentSectionId}) async {
    if (state.value == null) return;

    FormSection newSection = FormSection(
      id: _uuid.v4(),
      title: 'Untitled Section',
      questions: [],
      layout: SectionLayoutType.standard.name,
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
          form: _replaceFormSections(state.value!.form, sections),
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
        form: _replaceFormSections(
          state.value!.form,
          [..._currentSections(state.value!.form), newSection],
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
        form: _replaceFormSections(state.value!.form, sections),
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
        form: _replaceFormSections(state.value!.form, sections),
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
          form: _replaceFormSections(state.value!.form, sections),
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
        form: _replaceFormSections(
          state.value!.form,
          [..._currentSections(state.value!.form), newSection],
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
    final sections = _updateQuestionRecursive(
      state.value!.form.sections,
      questionId,
      (question) => question.copyWith(
        metadata: {...question.metadata, ...metadata},
      ),
    );

    state = AsyncValue.data(
      state.value!.copyWith(
        form: _replaceFormSections(state.value!.form, sections),
      ),
    );
    _markDirty();
  }

  void removeQuestion(String sectionId, String questionId) {
    if (state.value == null) return;
    final sectionsResult = _updateSectionRecursive(
      state.value!.form.sections,
      sectionId,
      (section) => section.copyWith(
        questions: section.questions.where((q) => q.id != questionId).toList(),
      ),
    );

    final sections = sectionsResult?.sections;
    if (sections == null) return;

    state = AsyncValue.data(
      state.value!.copyWith(
        form: _replaceFormSections(state.value!.form, sections),
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
    final sections = _updateQuestionRecursive(
      state.value!.form.sections,
      updatedQuestion.id,
      (_) => updatedQuestion,
    );

    state = AsyncValue.data(
      state.value!.copyWith(
        form: _replaceFormSections(state.value!.form, sections),
      ),
    );
    _markDirty();
  }

  void convertQuestionType(String questionId, QuestionType newType) {
    if (state.value == null) return;
    final sections = _updateQuestionRecursive(
      state.value!.form.sections,
      questionId,
      (currentQuestion) => FieldRegistry.convertQuestionType(
        currentQuestion,
        newType,
      ),
    );

    state = AsyncValue.data(
      state.value!.copyWith(
        form: _replaceFormSections(state.value!.form, sections),
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
    final sections = _updateQuestionsRecursive(
      state.value!.form.sections,
      (question) => ids.contains(question.id) ? updater(question) : question,
    );

    state = AsyncValue.data(
      state.value!.copyWith(
        form: _replaceFormSections(state.value!.form, sections),
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
    final sections = _updateQuestionRecursive(
      state.value!.form.sections,
      questionId,
      (question) => question.copyWith(
        label: _updateLocalizedField(question.label, label, locale),
      ),
    );

    state = AsyncValue.data(
      state.value!.copyWith(
        form: _replaceFormSections(state.value!.form, sections),
      ),
    );
    _markDirty();
  }

  void updateQuestionHelperText(String questionId, String helperText) {
    if (state.value == null) return;
    final locale = state.value!.editingLocale;
    final sections = _updateQuestionRecursive(
      state.value!.form.sections,
      questionId,
      (question) => question.copyWith(
        metadata: {
          ...question.metadata,
          'helper_text': _updateLocalizedField(
            question.metadata['helper_text'],
            helperText,
            locale,
          ),
        },
      ),
    );

    state = AsyncValue.data(
      state.value!.copyWith(
        form: _replaceFormSections(state.value!.form, sections),
      ),
    );
    _markDirty();
  }

  void updateQuestionPlaceholder(String questionId, String placeholder) {
    if (state.value == null) return;
    final locale = state.value!.editingLocale;
    final sections = _updateQuestionRecursive(
      state.value!.form.sections,
      questionId,
      (question) => question.copyWith(
        metadata: {
          ...question.metadata,
          'placeholder': _updateLocalizedField(
            question.metadata['placeholder'],
            placeholder,
            locale,
          ),
        },
      ),
    );

    state = AsyncValue.data(
      state.value!.copyWith(
        form: _replaceFormSections(state.value!.form, sections),
      ),
    );
    _markDirty();
  }

  void updateQuestionDefaultValue(String questionId, dynamic defaultValue) {
    if (state.value == null) return;
    final sections = _updateQuestionRecursive(
      state.value!.form.sections,
      questionId,
      (question) => question.copyWith(defaultValue: defaultValue),
    );

    state = AsyncValue.data(
      state.value!.copyWith(
        form: _replaceFormSections(state.value!.form, sections),
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
        form: _replaceFormSections(updatedForm, _currentSections(state.value!.form)),
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
        form: _replaceFormSections(state.value!.form, sections),
      ),
    );
    _markDirty();
  }

  void reorderNestedSections(
    String parentSectionId,
    int oldIndex,
    int newIndex,
  ) {
    if (state.value == null) return;

    final result = _reorderNestedSectionsRecursive(
      state.value!.form.sections,
      parentSectionId,
      oldIndex,
      newIndex,
    );
    if (result == null) return;

    state = AsyncValue.data(
      state.value!.copyWith(
        form: _replaceFormSections(state.value!.form, result),
      ),
    );
    _markDirty();
  }

  List<FormSection>? _reorderNestedSectionsRecursive(
    List<FormSection> sections,
    String parentSectionId,
    int oldIndex,
    int newIndex,
  ) {
    for (var i = 0; i < sections.length; i++) {
      final section = sections[i];
      if (section.id == parentSectionId) {
        if (oldIndex < 0 ||
            oldIndex >= section.sections.length ||
            newIndex < 0 ||
            newIndex > section.sections.length) {
          return null;
        }

        final nested = [...section.sections];
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        final item = nested.removeAt(oldIndex);
        nested.insert(newIndex, item);

        final updatedSections = [...sections]
          ..[i] = section.copyWith(sections: nested);
        return updatedSections;
      }

      if (section.sections.isEmpty) continue;
      final nested = _reorderNestedSectionsRecursive(
        section.sections,
        parentSectionId,
        oldIndex,
        newIndex,
      );
      if (nested != null) {
        final updatedSections = [...sections]
          ..[i] = section.copyWith(sections: nested);
        return updatedSections;
      }
    }
    return null;
  }

  void reorderQuestions(String sectionId, int oldIndex, int newIndex) {
    if (state.value == null) return;
    final result = _updateSectionRecursive(
      state.value!.form.sections,
      sectionId,
      (section) {
        final questions = [...section.questions];
        if (oldIndex < 0 ||
            oldIndex >= questions.length ||
            newIndex < 0 ||
            newIndex > questions.length) {
          return section;
        }
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        final item = questions.removeAt(oldIndex);
        questions.insert(newIndex, item);
        return section.copyWith(questions: questions);
      },
    );
    if (result == null) return;

    state = AsyncValue.data(
      state.value!.copyWith(
        form: _replaceFormSections(state.value!.form, result.sections),
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
    final sectionsWithRemovedResult = _updateSectionRecursive(
      state.value!.form.sections,
      fromSectionId,
      (section) {
        final qIndex = section.questions.indexWhere((q) => q.id == questionId);
        if (qIndex == -1) return section;
        movingQuestion = section.questions[qIndex];
        final questions = [...section.questions]..removeAt(qIndex);
        return section.copyWith(questions: questions);
      },
    );

    final sectionsWithRemoved = sectionsWithRemovedResult?.sections;

    if (movingQuestion == null) return;
    if (sectionsWithRemoved == null) return;

    // 2. Add to destination section
    final finalSectionsResult = _updateSectionRecursive(
      sectionsWithRemoved,
      toSectionId,
      (section) {
        final questions = [...section.questions];
        if (newIndex > questions.length) newIndex = questions.length;
        questions.insert(newIndex, movingQuestion!);
        return section.copyWith(questions: questions);
      },
    );

    final finalSections = finalSectionsResult?.sections;
    if (finalSections == null) return;

    state = AsyncValue.data(
      state.value!.copyWith(
        form: _replaceFormSections(state.value!.form, finalSections),
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

    final sectionsResult = _updateSectionRecursive(
      state.value!.form.sections,
      sectionId,
      (section) {
        final qIndex = section.questions.indexWhere((q) => q.id == question.id);
        if (qIndex == -1) return section;
        final questions = [...section.questions];
        questions.insert(qIndex + 1, newQuestion);
        return section.copyWith(questions: questions);
      },
    );

    final sections = sectionsResult?.sections;
    if (sections == null) return;

    state = AsyncValue.data(
      state.value!.copyWith(
        form: _replaceFormSections(state.value!.form, sections),
        selectedQuestionId: newQuestion.id,
        selectedSectionId: sectionId,
      ),
    );
    _markDirty();
  }

  List<FormSection> _updateQuestionRecursive(
    List<FormSection> sections,
    String questionId,
    FormQuestion Function(FormQuestion question) updater,
  ) {
    return sections.map((section) {
      final questionIndex = section.questions.indexWhere(
        (question) => question.id == questionId,
      );
      if (questionIndex != -1) {
        final updatedQuestions = [...section.questions];
        updatedQuestions[questionIndex] = updater(updatedQuestions[questionIndex]);
        return section.copyWith(questions: updatedQuestions);
      }

      if (section.sections.isEmpty) return section;
      return section.copyWith(
        sections: _updateQuestionRecursive(
          section.sections,
          questionId,
          updater,
        ),
      );
    }).toList();
  }

  List<FormSection> _updateQuestionsRecursive(
    List<FormSection> sections,
    FormQuestion Function(FormQuestion question) updater,
  ) {
    return sections.map((section) {
      final updatedQuestions = section.questions.map(updater).toList();
      if (section.sections.isEmpty) {
        return section.copyWith(questions: updatedQuestions);
      }
      return section.copyWith(
        questions: updatedQuestions,
        sections: _updateQuestionsRecursive(section.sections, updater),
      );
    }).toList();
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
      final result = await repository.publishForm(
        _projectId,
        state.value!.form.id,
      );

      state = AsyncValue.data(
        state.value!.copyWith(
          isSaving: false,
          isDirty: false,
          canUndo: false,
          canRedo: false,
        ),
      );

      if (!result.containsKey('task_id')) {
        state = AsyncValue.data(
          state.value!.copyWith(
            error: 'Publish did not return a task_id',
          ),
        );
      }
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
          form: _replaceFormSections(state.value!.form, updatedSections),
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
        return s.copyWith(metadata: {...s.metadata, ...metadata});
      }
      return s;
    }).toList();

    state = AsyncValue.data(
      state.value!.copyWith(
        form: _replaceFormSections(state.value!.form, sections),
      ),
    );
    _markDirty();
  }

  void updateFormMetadata(Map<String, dynamic> metadata) {
    if (state.value == null) return;
    state = AsyncValue.data(
      state.value!.copyWith(
        form: state.value!.form.copyWith(
          workflows: {...state.value!.form.workflows, ...metadata},
        ),
      ),
    );
    _markDirty();
  }

  void updateAccessPolicy(AccessPolicy policy) {
    if (state.value == null) return;
    state = AsyncValue.data(
      state.value!.copyWith(
        form: state.value!.form.copyWith(accessPolicy: policy.toJson()),
      ),
    );
    _markDirty();
  }
}
