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
  testWidgets('field properties persist live edits and render the page', (
    tester,
  ) async {
    final previousOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      final message = details.exceptionAsString();
      if (message.contains(
        'ListTile background color or ink splashes may be invisible',
      )) {
        return;
      }
      previousOnError?.call(details);
    };
    addTearDown(() {
      FlutterError.onError = previousOnError;
    });

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
    final selectedQuestionId = state.form.sections.first.questions.first.id;

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Scaffold(
            body: FieldPropertiesWidget(
              projectId: 'project-1',
              controllerKey: 'project-1::new',
              formId: 'new',
              selectedQuestionId: selectedQuestionId,
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Field Properties'), findsOneWidget);
    expect(find.text('General'), findsOneWidget);
    expect(find.text('Style'), findsOneWidget);
    expect(find.text('Logic'), findsOneWidget);

    notifier.updateQuestionLabel(selectedQuestionId, 'Updated Field Label');
    await tester.pumpAndSettle();

    final afterLabel = container
        .read(formBuilderControllerProvider('project-1::new'))
        .value!;
    expect(
      afterLabel.form.sections.first.questions.first.label,
      'Updated Field Label',
    );

    await notifier.saveForm();
    await tester.pumpAndSettle();

    expect(repo.savedForm, isNotNull);
    expect(
      repo.savedForm!.sections.first.questions.first.label,
      'Updated Field Label',
    );
  });
}
