import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/form_builder/models/custom_field_template.dart';
import 'package:frontend/features/form_builder/models/question_type.dart';
import 'package:frontend/features/form_builder/services/form_builder_controller.dart';
import 'package:frontend/core/form_models.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Creates a ProviderContainer with the FormBuilderController already
/// initialized for an in-memory ("new") form so no repository/HTTP calls
/// are needed.
Future<ProviderContainer> _makeContainer() async {
  // The controller key format is "projectId::formId".
  // When formId is "new" the controller builds an empty form locally.
  const key = '::new';
  final container = ProviderContainer();
  // Wait until initialization finishes (state transitions from loading).
  while (container.read(formBuilderControllerProvider(key)).isLoading) {
    await Future<void>.delayed(const Duration(milliseconds: 1));
  }
  return container;
}

const _key = '::new';

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('FormBuilderController — addQuestionToActiveSection', () {
    test(
      'inserts a question into the first section when none is selected',
      () async {
        final container = await _makeContainer();
        addTearDown(container.dispose);

        final notifier = container.read(
          formBuilderControllerProvider(_key).notifier,
        );

        // No section selected by default.
        final stateBefore = container
            .read(formBuilderControllerProvider(_key))
            .value!;
        expect(stateBefore.selectedSectionId, isNull);
        expect(stateBefore.form.sections.length, 1);
        expect(stateBefore.form.sections[0].questions, isEmpty);

        notifier.addQuestionToActiveSection(QuestionType.mobile);

        final stateAfter = container
            .read(formBuilderControllerProvider(_key))
            .value!;
        expect(stateAfter.form.sections[0].questions, hasLength(1));
        expect(
          stateAfter.form.sections[0].questions[0].type,
          QuestionType.mobile,
        );
        // Insertion selects the new question for the properties panel.
        expect(stateAfter.selectedQuestionId, isNotNull);
        expect(stateAfter.selectedSectionId, stateAfter.form.sections[0].id);
      },
    );

    test(
      'inserts into the explicitly selected section (not always the first)',
      () async {
        final container = await _makeContainer();
        addTearDown(container.dispose);

        final notifier = container.read(
          formBuilderControllerProvider(_key).notifier,
        );

        // Add a second section and select it.
        await notifier.addSection();
        final stateWithTwo = container
            .read(formBuilderControllerProvider(_key))
            .value!;
        expect(stateWithTwo.form.sections, hasLength(2));
        final secondId = stateWithTwo.form.sections[1].id;
        expect(
          stateWithTwo.selectedSectionId,
          secondId,
        ); // addSection selects new section

        notifier.addQuestionToActiveSection(QuestionType.email);

        final stateAfter = container
            .read(formBuilderControllerProvider(_key))
            .value!;
        // First section remains empty.
        expect(stateAfter.form.sections[0].questions, isEmpty);
        // Second section received the question.
        expect(stateAfter.form.sections[1].questions, hasLength(1));
        expect(
          stateAfter.form.sections[1].questions[0].type,
          QuestionType.email,
        );
      },
    );

    test('does not change state when form has no sections', () async {
      // Bootstrap with a normal form key then manually remove the section.
      final container = await _makeContainer();
      addTearDown(container.dispose);

      final notifier = container.read(
        formBuilderControllerProvider(_key).notifier,
      );

      // Remove the only section that was auto-created.
      final sectionId = container
          .read(formBuilderControllerProvider(_key))
          .value!
          .form
          .sections[0]
          .id;
      await notifier.removeSection(sectionId);

      final stateBefore = container
          .read(formBuilderControllerProvider(_key))
          .value!;
      expect(stateBefore.form.sections, isEmpty);

      // Should no-op gracefully.
      notifier.addQuestionToActiveSection(QuestionType.shortText);

      final stateAfter = container
          .read(formBuilderControllerProvider(_key))
          .value!;
      expect(stateAfter.form.sections, isEmpty);
    });
  });

  group('FormBuilderController — addTemplateToActiveSection', () {
    test('inserts a question-type template into the first section', () async {
      final container = await _makeContainer();
      addTearDown(container.dispose);

      final notifier = container.read(
        formBuilderControllerProvider(_key).notifier,
      );

      final template = CustomFieldTemplate(
        id: 'tpl-1',
        name: 'Patient Name',
        category: 'My Fields',
        template_type: 'question',
        data: {
          'id': 'q-template',
          // FormQuestion.fromJson uses 'field_type' (not 'type') for the enum.
          'field_type': 'short_text',
          'label': 'Patient Name',
          'is_required': true,
        },
      );

      notifier.addTemplateToActiveSection(template);

      final stateAfter = container
          .read(formBuilderControllerProvider(_key))
          .value!;
      expect(stateAfter.form.sections[0].questions, hasLength(1));
      expect(stateAfter.selectedQuestionId, isNotNull);
    });

    test(
      'a section-type template appends a new section regardless of selection',
      () async {
        final container = await _makeContainer();
        addTearDown(container.dispose);

        final notifier = container.read(
          formBuilderControllerProvider(_key).notifier,
        );

        final template = CustomFieldTemplate(
          id: 'tpl-sec',
          name: 'Patient Details',
          category: 'System',
          template_type: 'section',
          data: {
            // FormSection.fromJson requires 'id' and 'title'.
            'id': 'sec-from-template',
            'title': 'Patient Details',
            'questions': <dynamic>[],
          },
        );

        notifier.addTemplateToActiveSection(template);

        final stateAfter = container
            .read(formBuilderControllerProvider(_key))
            .value!;
        // Original section + new template section = 2.
        expect(stateAfter.form.sections, hasLength(2));
        expect(stateAfter.selectedSectionId, stateAfter.form.sections[1].id);
      },
    );
  });

  group('FormBuilderController — addQuestion (direct, section-specific)', () {
    test(
      'click insert is distinct from selection-only: state has both new question and selection',
      () async {
        final container = await _makeContainer();
        addTearDown(container.dispose);

        final notifier = container.read(
          formBuilderControllerProvider(_key).notifier,
        );
        final sectionId = container
            .read(formBuilderControllerProvider(_key))
            .value!
            .form
            .sections[0]
            .id;

        notifier.addQuestion(sectionId, QuestionType.date);

        final state = container
            .read(formBuilderControllerProvider(_key))
            .value!;
        // Insertion produces exactly one question.
        expect(state.form.sections[0].questions, hasLength(1));
        // And the right panel would open for this question (selectedQuestionId set).
        expect(
          state.selectedQuestionId,
          state.form.sections[0].questions[0].id,
        );
        // isFormSelected must NOT be accidentally flipped to true.
        expect(state.isFormSelected, isFalse);
      },
    );
  });
}
