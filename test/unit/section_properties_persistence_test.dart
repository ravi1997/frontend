import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/modules/forms/services/form_builder_controller.dart';
import 'package:frontend/modules/forms/services/form_builder_repository.dart';
import 'package:frontend/modules/forms/widgets/section_properties_widget.dart';
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
  testWidgets('section properties persist live edits and render the page', (
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
    final state = container
        .read(formBuilderControllerProvider('project-1::new'))
        .value!;
    final selectedSectionId = state.form.sections.first.id;

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Scaffold(
            body: SectionPropertiesWidget(
              projectId: 'project-1',
              controllerKey: 'project-1::new',
              formId: 'new',
              selectedSectionId: selectedSectionId,
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Section Properties'), findsOneWidget);
    expect(find.text('General'), findsOneWidget);
    expect(find.text('Style'), findsOneWidget);
    expect(find.text('Logic'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, 'Updated Section');
    await tester.pump();

    final afterTitle = container
        .read(formBuilderControllerProvider('project-1::new'))
        .value!;
    expect(afterTitle.form.sections.first.title, 'Updated Section');

    await tester.tap(find.text('Style'));
    await tester.pumpAndSettle();
    expect(find.text('Background color'), findsOneWidget);

    await notifier.saveForm();
    await tester.pumpAndSettle();

    expect(repo.savedForm, isNotNull);
    expect(repo.savedForm!.sections.first.title, 'Updated Section');
  });
}
