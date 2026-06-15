import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/modules/forms/services/form_builder_controller.dart';
import 'package:frontend/modules/forms/services/form_builder_repository.dart';
import 'package:frontend/modules/forms/widgets/form_properties_widget.dart';
import 'package:frontend/shared/models/form_models.dart';

class _FakeFormBuilderRepository implements FormBuilderRepository {
  BuilderForm? savedForm;

  @override
  Future<BuilderForm> getForm(String projectId, String id) async {
    return BuilderForm.fromJson({
      'id': id,
      'title': 'Demo Form',
      'sections': const [],
      'quickResponses': [
        {
          'name': 'Follow-up intake',
          'description': 'Prefill intake fields',
          'field_values': {
            'patient_name': 'Jane Doe',
          },
        },
      ],
    });
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
  testWidgets('form properties quick responses tab renders existing items', (
    tester,
  ) async {
    final repo = _FakeFormBuilderRepository();
    final container = await _makeContainer(repo);
    addTearDown(container.dispose);

    final notifier = container.read(
      formBuilderControllerProvider('project-1::new').notifier,
    );
    final currentState = container
        .read(formBuilderControllerProvider('project-1::new'))
        .value!;
    notifier.updateForm(
      currentState.form.copyWith(
        quickResponses: [
          {
            'name': 'Follow-up intake',
            'description': 'Prefill intake fields',
            'field_values': {
              'patient_name': 'Jane Doe',
            },
          },
        ],
      ),
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
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

    await tester.ensureVisible(find.text('Quick Responses'));
    await tester.tap(find.text('Quick Responses'));
    await tester.pumpAndSettle();

    expect(find.text('Quick Responses'), findsWidgets);
    expect(find.text('Follow-up intake'), findsOneWidget);
    expect(find.textContaining('Prefill intake fields'), findsOneWidget);
  });
}
