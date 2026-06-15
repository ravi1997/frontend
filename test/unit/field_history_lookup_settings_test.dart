import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/modules/forms/models/question_type.dart';
import 'package:frontend/modules/forms/services/form_builder_controller.dart';
import 'package:frontend/modules/forms/services/form_builder_repository.dart';
import 'package:frontend/modules/forms/widgets/field_properties_widget.dart';
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
  testWidgets('field specific settings exposes history lookup controls', (
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

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Scaffold(
            body: FieldPropertiesWidget(
              projectId: 'project-1',
              controllerKey: 'project-1::new',
              formId: 'project-1::new',
              selectedQuestionId: questionId,
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.text('Specific'));
    await tester.pumpAndSettle();

    expect(find.text('History lookup'), findsOneWidget);
    expect(find.text('Enable searchable lookup'), findsOneWidget);

    await tester.tap(find.byType(Switch).last);
    await tester.pumpAndSettle();

    final updated = container
        .read(formBuilderControllerProvider('project-1::new'))
        .value!;
    final metadata = updated.form.sections.first.questions.first.metadata;

    expect(metadata['actionConfig'], isA<Map>());
    expect((metadata['actionConfig'] as Map<String, dynamic>)['hasButton'], true);
  });
}
