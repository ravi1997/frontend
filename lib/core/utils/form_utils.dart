import 'package:uuid/uuid.dart';
import '../form_models.dart';

/// A utility library offering absolute freedom to perform deeply-nested immutable CRUD,
/// drag-and-drop reordering, cloning, search traversal, and batch operations on the
/// unified Form, Section, and Question tree structure.
class FormUtils {
  static const _uuid = Uuid();

  /// =========================================================================
  /// 1. READ / QUERY OPERATIONS
  /// =========================================================================

  /// Traverses the form hierarchy to find a Section by its unique ID.
  static Section? findSection(Form form, String sectionId) {
    for (final version in form.versions) {
      for (final section in version.sections) {
        final found = _findSectionInTree(section, sectionId);
        if (found != null) return found;
      }
    }
    return null;
  }

  static Section? _findSectionInTree(Section current, String sectionId) {
    if (current.id == sectionId) return current;
    for (final child in current.sections) {
      final found = _findSectionInTree(child, sectionId);
      if (found != null) return found;
    }
    return null;
  }

  /// Traverses the form hierarchy to find a Question by its unique ID.
  static Question? findQuestion(Form form, String questionId) {
    for (final version in form.versions) {
      for (final section in version.sections) {
        final found = _findQuestionInTree(section, questionId);
        if (found != null) return found;
      }
    }
    return null;
  }

  static Question? _findQuestionInTree(Section current, String questionId) {
    for (final q in current.questions) {
      if (q.id == questionId) return q;
    }
    for (final child in current.sections) {
      final found = _findQuestionInTree(child, questionId);
      if (found != null) return found;
    }
    return null;
  }

  /// Finds the parent Section of a specific Question ID.
  static Section? findParentSectionOfQuestion(Form form, String questionId) {
    for (final version in form.versions) {
      for (final section in version.sections) {
        final parent = _findParentSectionOfQuestionInTree(section, questionId);
        if (parent != null) return parent;
      }
    }
    return null;
  }

  static Section? _findParentSectionOfQuestionInTree(
    Section current,
    String questionId,
  ) {
    for (final q in current.questions) {
      if (q.id == questionId) return current;
    }
    for (final child in current.sections) {
      final parent = _findParentSectionOfQuestionInTree(child, questionId);
      if (parent != null) return parent;
    }
    return null;
  }

  /// Returns a completely flat list of all Questions in the Form.
  static List<Question> getAllQuestions(Form form) {
    final List<Question> all = [];
    for (final version in form.versions) {
      for (final section in version.sections) {
        _collectQuestions(section, all);
      }
    }
    return all;
  }

  static void _collectQuestions(Section section, List<Question> list) {
    list.addAll(section.questions);
    for (final child in section.sections) {
      _collectQuestions(child, list);
    }
  }

  /// =========================================================================
  /// 2. CREATE OPERATIONS
  /// =========================================================================

  /// Inserts a new Section either at the top-level active version or nested inside a parent.
  static Form addSection(
    Form form,
    Section newSection, {
    String? parentSectionId,
  }) {
    if (form.versions.isEmpty) {
      // If no version exists, initialize one
      final version = FormVersion(
        id: _uuid.v4(),
        version: '1.0.0',
        sections: [newSection],
      );
      return form.copyWith(versions: [version], activeVersion: '1.0.0');
    }

    final targetVersion = form.activeVersion ?? form.versions.first.version;

    return form.copyWith(
      versions: form.versions.map((v) {
        if (form.versions.length == 1 || v.version == targetVersion) {
          if (parentSectionId == null) {
            return v.copyWith(sections: [...v.sections, newSection]);
          } else {
            return v.copyWith(
              sections: v.sections
                  .map(
                    (s) =>
                        _addNestedSectionInTree(s, parentSectionId, newSection),
                  )
                  .toList(),
            );
          }
        }
        return v;
      }).toList(),
    );
  }

  static Section _addNestedSectionInTree(
    Section current,
    String targetParentId,
    Section newSection,
  ) {
    if (current.id == targetParentId) {
      return current.copyWith(sections: [...current.sections, newSection]);
    }
    return current.copyWith(
      sections: current.sections
          .map((s) => _addNestedSectionInTree(s, targetParentId, newSection))
          .toList(),
    );
  }

  /// Inserts a new Question inside a target Section.
  static Form addQuestion(Form form, String sectionId, Question newQuestion) {
    final targetVersion = form.activeVersion ?? form.versions.first.version;

    return form.copyWith(
      versions: form.versions.map((v) {
        if (form.versions.length == 1 || v.version == targetVersion) {
          return v.copyWith(
            sections: v.sections
                .map((s) => _addQuestionInTree(s, sectionId, newQuestion))
                .toList(),
          );
        }
        return v;
      }).toList(),
    );
  }

  static Section _addQuestionInTree(
    Section current,
    String targetSectionId,
    Question newQuestion,
  ) {
    if (current.id == targetSectionId) {
      return current.copyWith(questions: [...current.questions, newQuestion]);
    }
    return current.copyWith(
      sections: current.sections
          .map((s) => _addQuestionInTree(s, targetSectionId, newQuestion))
          .toList(),
    );
  }

  /// =========================================================================
  /// 3. UPDATE OPERATIONS
  /// =========================================================================

  /// Updates an existing Question anywhere in the tree.
  static Form updateQuestion(Form form, Question updatedQuestion) {
    return form.copyWith(
      versions: form.versions.map((v) {
        return v.copyWith(
          sections: v.sections
              .map((s) => _updateQuestionInTree(s, updatedQuestion))
              .toList(),
        );
      }).toList(),
    );
  }

  static Section _updateQuestionInTree(Section current, Question target) {
    final updatedQuestions = current.questions
        .map((q) => q.id == target.id ? target : q)
        .toList();
    return current.copyWith(
      questions: updatedQuestions,
      sections: current.sections
          .map((s) => _updateQuestionInTree(s, target))
          .toList(),
    );
  }

  /// Updates an existing Section anywhere in the tree.
  static Form updateSection(Form form, Section updatedSection) {
    return form.copyWith(
      versions: form.versions.map((v) {
        return v.copyWith(
          sections: v.sections
              .map((s) => _updateSectionInTree(s, updatedSection))
              .toList(),
        );
      }).toList(),
    );
  }

  static Section _updateSectionInTree(Section current, Section target) {
    if (current.id == target.id) {
      return target;
    }
    return current.copyWith(
      sections: current.sections
          .map((s) => _updateSectionInTree(s, target))
          .toList(),
    );
  }

  /// =========================================================================
  /// 4. DELETE OPERATIONS
  /// =========================================================================

  /// Deletes a Question anywhere in the tree.
  static Form deleteQuestion(Form form, String questionId) {
    return form.copyWith(
      versions: form.versions.map((v) {
        return v.copyWith(
          sections: v.sections
              .map((s) => _deleteQuestionInTree(s, questionId))
              .toList(),
        );
      }).toList(),
    );
  }

  static Section _deleteQuestionInTree(Section current, String targetId) {
    return current.copyWith(
      questions: current.questions.where((q) => q.id != targetId).toList(),
      sections: current.sections
          .map((s) => _deleteQuestionInTree(s, targetId))
          .toList(),
    );
  }

  /// Deletes a Section anywhere in the tree.
  static Form deleteSection(Form form, String sectionId) {
    return form.copyWith(
      versions: form.versions.map((v) {
        return v.copyWith(
          sections: v.sections
              .where((s) => s.id != sectionId)
              .map((s) => _deleteSectionInTree(s, sectionId))
              .toList(),
        );
      }).toList(),
    );
  }

  static Section _deleteSectionInTree(Section current, String targetId) {
    return current.copyWith(
      sections: current.sections
          .where((s) => s.id != targetId)
          .map((s) => _deleteSectionInTree(s, targetId))
          .toList(),
    );
  }

  /// =========================================================================
  /// 5. MOVE & REORDER OPERATIONS (Drag and Drop)
  /// =========================================================================

  /// Moves a question from its source section to a new index in a target section.
  static Form moveQuestion(
    Form form, {
    required String questionId,
    required String targetSectionId,
    required int targetIndex,
  }) {
    final question = findQuestion(form, questionId);
    if (question == null) return form;

    // 1. Remove the question from its current home
    final cleanedForm = deleteQuestion(form, questionId);

    // 2. Insert at target location
    return cleanedForm.copyWith(
      versions: cleanedForm.versions.map((v) {
        return v.copyWith(
          sections: v.sections
              .map(
                (s) => _insertQuestionAtIndex(
                  s,
                  targetSectionId,
                  question,
                  targetIndex,
                ),
              )
              .toList(),
        );
      }).toList(),
    );
  }

  static Section _insertQuestionAtIndex(
    Section current,
    String targetSectionId,
    Question question,
    int index,
  ) {
    if (current.id == targetSectionId) {
      final List<Question> mutableQs = List.from(current.questions);
      final safeIndex = index.clamp(0, mutableQs.length);
      mutableQs.insert(safeIndex, question);
      return current.copyWith(questions: mutableQs);
    }
    return current.copyWith(
      sections: current.sections
          .map(
            (s) => _insertQuestionAtIndex(s, targetSectionId, question, index),
          )
          .toList(),
    );
  }

  /// =========================================================================
  /// 6. CLONING & DUPLICATION
  /// =========================================================================

  /// Duplicates an existing Question, generating a new ID and appending it right next to the original.
  static Form duplicateQuestion(Form form, String questionId) {
    final original = findQuestion(form, questionId);
    final parent = findParentSectionOfQuestion(form, questionId);
    if (original == null || parent == null) return form;

    final copy = original.copyWith(
      id: _uuid.v4(),
      label: '${original.label} (Copy)',
      variableName: original.variableName != null
          ? '${original.variableName}_copy'
          : null,
    );

    return form.copyWith(
      versions: form.versions.map((v) {
        return v.copyWith(
          sections: v.sections.map((s) {
            if (s.id == parent.id) {
              final idx = s.questions.indexWhere((q) => q.id == questionId);
              final List<Question> list = List.from(s.questions);
              list.insert(idx + 1, copy);
              return s.copyWith(questions: list);
            }
            return _insertQuestionClone(s, parent.id, questionId, copy);
          }).toList(),
        );
      }).toList(),
    );
  }

  static Section _insertQuestionClone(
    Section current,
    String parentId,
    String originalId,
    Question clone,
  ) {
    if (current.id == parentId) {
      final idx = current.questions.indexWhere((q) => q.id == originalId);
      final List<Question> list = List.from(current.questions);
      list.insert(idx + 1, clone);
      return current.copyWith(questions: list);
    }
    return current.copyWith(
      sections: current.sections
          .map((s) => _insertQuestionClone(s, parentId, originalId, clone))
          .toList(),
    );
  }

  /// Duplicates an entire Section recursively with new IDs.
  static Form duplicateSection(Form form, String sectionId) {
    final original = findSection(form, sectionId);
    if (original == null) return form;

    final clone = _cloneSectionTree(original);

    return form.copyWith(
      versions: form.versions.map((v) {
        final idx = v.sections.indexWhere((s) => s.id == sectionId);
        if (idx != -1) {
          final List<Section> list = List.from(v.sections);
          list.insert(idx + 1, clone);
          return v.copyWith(sections: list);
        }
        return v.copyWith(
          sections: v.sections
              .map((s) => _insertSectionCloneInTree(s, sectionId, clone))
              .toList(),
        );
      }).toList(),
    );
  }

  static Section _insertSectionCloneInTree(
    Section current,
    String originalId,
    Section clone,
  ) {
    final idx = current.sections.indexWhere((s) => s.id == originalId);
    if (idx != -1) {
      final List<Section> list = List.from(current.sections);
      list.insert(idx + 1, clone);
      return current.copyWith(sections: list);
    }
    return current.copyWith(
      sections: current.sections
          .map((s) => _insertSectionCloneInTree(s, originalId, clone))
          .toList(),
    );
  }

  static Section _cloneSectionTree(Section original) {
    final List<Question> clonedQuestions = original.questions.map((q) {
      return q.copyWith(
        id: _uuid.v4(),
        variableName: q.variableName != null ? '${q.variableName}_copy' : null,
      );
    }).toList();

    final List<Section> clonedSubsections = original.sections
        .map((s) => _cloneSectionTree(s))
        .toList();

    return original.copyWith(
      id: _uuid.v4(),
      title: '${original.title} (Copy)',
      questions: clonedQuestions,
      sections: clonedSubsections,
    );
  }
}
