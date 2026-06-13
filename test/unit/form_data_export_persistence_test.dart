import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/modules/forms/models/question_type.dart';
import 'package:frontend/modules/forms/services/form_builder_controller.dart';
import 'package:frontend/modules/forms/services/form_builder_repository.dart';
import 'package:frontend/modules/forms/widgets/form_properties_widget.dart';
import 'package:frontend/shared/models/form_models.dart';

class _FakeFormBuilderRepository implements FormBuilderRepository {
  BuilderForm? savedForm;

  @override
  Future<BuilderForm> getForm(String projectId, String id) async {
    throw UnimplementedError('Not needed for this test');
  }

  @override
  Future<BuilderForm> saveForm(
    BuilderForm form, {
    required String projectId,
    String versionType = 'patch',
  }) async {
    savedForm = form;
    return form;
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Future<ProviderContainer> _makeContainer(
  _FakeFormBuilderRepository repo,
) async {
  final container = ProviderContainer(
    overrides: [formBuilderRepositoryProvider.overrideWithValue(repo)],
  );
  final sub = container.listen(
    formBuilderControllerProvider('project-1::new'),
    (_, _) {},
    fireImmediately: true,
  );

  while (container
      .read(formBuilderControllerProvider('project-1::new'))
      .isLoading) {
    await Future<void>.delayed(const Duration(milliseconds: 1));
  }

  addTearDown(sub.close);
  return container;
}

void main() {
  testWidgets('form data export settings persist live edits and save', (
    tester,
  ) async {
    final repo = _FakeFormBuilderRepository();
    final container = await _makeContainer(repo);
    addTearDown(container.dispose);

    final notifier = container.read(
      formBuilderControllerProvider('project-1::new').notifier,
    );
    notifier.addQuestionToActiveSection(QuestionType.shortText);

    final state = container
        .read(formBuilderControllerProvider('project-1::new'))
        .value!;
    final questionId = state.form.sections.first.questions.first.id;

    notifier.updateQuestionLabel(questionId, 'Case Code');

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Scaffold(
            body: FormPropertiesWidget(
              projectId: 'project-1',
              controllerKey: 'project-1::new',
              formId: 'new',
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Data / Export'), findsOneWidget);

    await tester.ensureVisible(find.text('Data / Export'));
    await tester.tap(find.text('Data / Export'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('data-export-retention-days')),
      '45',
    );
    final switches = find.byType(Switch);
    await tester.ensureVisible(switches.first);
    await tester.tap(switches.first);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(Key('data-export-field-$questionId')),
      'email_address',
    );
    await tester.ensureVisible(find.text('Anonymize this field'));
    await tester.tap(find.byType(Switch).last);
    await tester.pumpAndSettle();

    final afterUpdate = container
        .read(formBuilderControllerProvider('project-1::new'))
        .value!;
    final exportSettings = afterUpdate.form.dataExportSettings;
    final csvDefaults = exportSettings['csv_defaults'] as Map<String, dynamic>;
    final mappings = exportSettings['field_mapping'] as Map<String, dynamic>;
    final anonymization =
        exportSettings['anonymization'] as Map<String, dynamic>;
    final anonymizedFields = anonymization['fields'] as List<dynamic>;

    expect(exportSettings['retention_days'], 45);
    expect(csvDefaults['delimiter'], ',');
    expect(csvDefaults['include_attachments'], isTrue);
    expect(mappings[questionId], 'email_address');
    expect(anonymizedFields, contains(questionId));

    await notifier.saveForm();
    await tester.pumpAndSettle();

    expect(repo.savedForm, isNotNull);
    final savedExportSettings = repo.savedForm!.dataExportSettings;
    final savedMappings =
        savedExportSettings['field_mapping'] as Map<String, dynamic>;

    expect(savedExportSettings['retention_days'], 45);
    expect(
      (savedExportSettings['csv_defaults'] as Map<String, dynamic>)[
        'include_attachments'
      ],
      isTrue,
    );
    expect(savedMappings[questionId], 'email_address');
    expect(
      (savedExportSettings['anonymization'] as Map<String, dynamic>)['fields'],
      contains(questionId),
    );
  });
}
