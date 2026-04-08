import 'dart:async';
import 'package:flutter/foundation.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/utils/error_handler.dart';
import '../../domain/entities/builder_form.dart';
import '../../domain/entities/form_builder_state.dart';
import '../../domain/entities/form_question.dart';
import '../../domain/entities/form_section.dart';
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
  }

  void updateLocalizedSectionTitle(
    String sectionId,
    String title,
    String locale,
  ) {
    if (state.value == null) return;
    final sections = state.value!.form.sections.map((s) {
      if (s.id == sectionId) {
        return s.copyWith(title: _updateLocalizedField(s.title, title, locale));
      }
      return s;
    }).toList();
    state = AsyncValue.data(
      state.value!.copyWith(
        form: state.value!.form.copyWith(sections: sections),
      ),
    );
  }

  void updateLocalizedSectionDescription(
    String sectionId,
    String description,
    String locale,
  ) {
    if (state.value == null) return;
    final sections = state.value!.form.sections.map((s) {
      if (s.id == sectionId) {
        return s.copyWith(
          description: _updateLocalizedField(
            s.description,
            description,
            locale,
          ),
        );
      }
      return s;
    }).toList();
    state = AsyncValue.data(
      state.value!.copyWith(
        form: state.value!.form.copyWith(sections: sections),
      ),
    );
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
  }

  void updateQuestionRequired(String questionId, bool required) {
    _updateQuestion(questionId, (q) => q.copyWith(isRequired: required));
  }

  Future<void> addSection() async {
    if (state.value == null) return;

    FormSection newSection = FormSection(
      id: _uuid.v4(),
      title: 'Untitled Section',
      questions: [],
    );

    // If form is persisted, call backend
    if (formId != 'new') {
      try {
        final repository = ref.read(formBuilderRepositoryProvider);
        newSection = await repository.createSection(formId, newSection);
      } catch (e) {
        final error = ErrorHandler.handle(e);
        state = AsyncValue.data(state.value!.copyWith(error: error));
        return;
      }
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
  }

  Future<void> removeSection(String sectionId) async {
    if (state.value == null) return;

    // If form is persisted, call backend
    if (formId != 'new') {
      try {
        final repository = ref.read(formBuilderRepositoryProvider);
        await repository.deleteSection(formId, sectionId);
      } catch (e) {
        final error = ErrorHandler.handle(e);
        state = AsyncValue.data(state.value!.copyWith(error: error));
        return;
      }
    }

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
    }
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
        isFormSelected: false,
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
  }

  void selectForm() {
    if (state.value == null) return;
    state = AsyncValue.data(
      state.value!.copyWith(
        selectedSectionId: null,
        selectedQuestionId: null,
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
        isFormSelected: false,
      ),
    );
  }

  Timer? _sectionDebounceTimer;

  void _syncSectionWithBackend(FormSection section) {
    if (formId == 'new') return;
    _sectionDebounceTimer?.cancel();
    _sectionDebounceTimer = Timer(const Duration(milliseconds: 1000), () async {
      try {
        final repository = ref.read(formBuilderRepositoryProvider);
        await repository.updateSection(formId, section);
      } catch (e) {
        debugPrint('Failed to sync section: $e');
      }
    });
  }

  void updateSection(FormSection updatedSection) {
    if (state.value == null) return;
    final sections = state.value!.form.sections.map((s) {
      if (s.id == updatedSection.id) {
        return updatedSection;
      }
      return s;
    }).toList();

    state = AsyncValue.data(
      state.value!.copyWith(
        form: state.value!.form.copyWith(sections: sections),
      ),
    );

    _syncSectionWithBackend(updatedSection);
  }

  void updateSectionTitle(String sectionId, String title) {
    if (state.value == null) return;
    final locale = state.value!.editingLocale;
    FormSection? updatedSection;
    final sections = state.value!.form.sections.map((s) {
      if (s.id == sectionId) {
        updatedSection = s.copyWith(
          title: _updateLocalizedField(s.title, title, locale),
        );
        return updatedSection!;
      }
      return s;
    }).toList();

    state = AsyncValue.data(
      state.value!.copyWith(
        form: state.value!.form.copyWith(sections: sections),
      ),
    );

    if (updatedSection != null) _syncSectionWithBackend(updatedSection!);
  }

  void updateSectionDescription(String sectionId, String description) {
    if (state.value == null) return;
    final locale = state.value!.editingLocale;
    FormSection? updatedSection;
    final sections = state.value!.form.sections.map((s) {
      if (s.id == sectionId) {
        updatedSection = s.copyWith(
          description: _updateLocalizedField(
            s.description,
            description,
            locale,
          ),
        );
        return updatedSection!;
      }
      return s;
    }).toList();

    state = AsyncValue.data(
      state.value!.copyWith(
        form: state.value!.form.copyWith(sections: sections),
      ),
    );

    if (updatedSection != null) _syncSectionWithBackend(updatedSection!);
  }

  void updateForm(BuilderForm updatedForm) {
    if (state.value == null) return;
    state = AsyncValue.data(
      state.value!.copyWith(
        form: updatedForm.copyWith(sections: state.value!.form.sections),
      ),
    );
  }

  void updateWorkflows(Map<String, dynamic> workflows) {
    if (state.value == null) return;
    state = AsyncValue.data(
      state.value!.copyWith(
        form: state.value!.form.copyWith(workflows: workflows),
      ),
    );
  }

  Future<void> reorderSections(int oldIndex, int newIndex) async {
    if (state.value == null) return;

    final sections = [...state.value!.form.sections];
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = sections.removeAt(oldIndex);
    sections.insert(newIndex, item);

    // If form is persisted, call backend
    if (formId != 'new') {
      try {
        final repository = ref.read(formBuilderRepositoryProvider);
        await repository.reorderSections(
          formId,
          sections.map((s) => s.id).toList(),
        );
      } catch (e) {
        final error = ErrorHandler.handle(e);
        state = AsyncValue.data(state.value!.copyWith(error: error));
        // We might want to revert local state if it fails,
        // but for now we'll just keep local state and show error.
      }
    }

    state = AsyncValue.data(
      state.value!.copyWith(
        form: state.value!.form.copyWith(sections: sections),
      ),
    );
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
  }

  Future<bool> saveForm({String versionType = 'patch'}) async {
    if (state.value == null) return false;
    state = AsyncValue.data(state.value!.copyWith(isSaving: true));
    try {
      final repository = ref.read(formBuilderRepositoryProvider);
      final savedForm = await repository.saveForm(
        state.value!.form,
        versionType: versionType,
      );
      state = AsyncValue.data(
        state.value!.copyWith(form: savedForm, isSaving: false),
      );
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
        state.value!.copyWith(form: updatedForm, isSaving: false),
      );
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
    FormSection? updatedSection;
    final sections = state.value!.form.sections.map((s) {
      if (s.id == sectionId) {
        updatedSection = s.copyWith(metadata: {...s.metadata, ...metadata});
        return updatedSection!;
      }
      return s;
    }).toList();

    state = AsyncValue.data(
      state.value!.copyWith(
        form: state.value!.form.copyWith(sections: sections),
      ),
    );

    if (updatedSection != null) _syncSectionWithBackend(updatedSection!);
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
  }

  void updateAccessPolicy(AccessPolicy policy) {
    if (state.value == null) return;
    state = AsyncValue.data(
      state.value!.copyWith(
        form: state.value!.form.copyWith(accessPolicy: policy),
      ),
    );
  }
}
