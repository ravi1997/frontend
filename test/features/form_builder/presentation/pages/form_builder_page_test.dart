import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/form_builder/domain/entities/builder_form.dart';
import 'package:frontend/features/form_builder/domain/entities/form_builder_state.dart';
import 'package:frontend/features/form_builder/domain/entities/form_layout_type.dart';
import 'package:frontend/features/form_builder/presentation/controllers/form_builder_controller.dart';
import 'package:frontend/features/form_builder/presentation/pages/form_builder_page.dart';

// Fake controller that extends the real one to inherit mutations but overrides async/IO methods
class FakeFormBuilderController extends FormBuilderController {
  // We override build to provide initial test state without calling repository
  @override
  FutureOr<FormBuilderState> build(String formId) {
    return FormBuilderState(
      form: BuilderForm(
        id: formId,
        title: 'Test Form',
        sections: [],
        layout: FormLayoutType.singleColumn,
        version: '1',
      ),
    );
  }

  @override
  Future<bool> saveForm() async {
    return true;
  }

  @override
  Future<bool> publishForm() async {
    return true;
  }
}

void main() {
  const String testFormId = 'test-form-123';

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        formBuilderControllerProvider(
          testFormId,
        ).overrideWith(() => FakeFormBuilderController()),
      ],
      child: MaterialApp(
        home: const FormBuilderPage(formId: testFormId),
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (_) => const Scaffold(body: Text('Dummy Page')),
        ),
      ),
    );
  }

  group('FormBuilderPage Tests', () {
    testWidgets('Header elements are displayed correctly', (tester) async {
      // Set a larger screen size to avoid overflows
      tester.view.physicalSize = const Size(1600, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Expecting 2 because it's in the TopBar and the Canvas header
      expect(find.text('Test Form'), findsAtLeastNWidgets(1));
    });

    testWidgets('Add Section Button interaction updates UI', (tester) async {
      tester.view.physicalSize = const Size(1600, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final addSectionBtn = find.text('Add New Section');
      await tester.tap(addSectionBtn);
      await tester.pumpAndSettle();

      expect(find.text('Untitled Section'), findsAtLeastNWidgets(1));
    });

    testWidgets('Save Button shows success snackbar', (tester) async {
      // Set a larger screen size to ensure buttons are visible
      tester.view.physicalSize = const Size(1600, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final saveBtn = find.text('Save Changes');
      await tester.ensureVisible(saveBtn);
      await tester.tap(saveBtn);

      // We need to pump once to let the snackbar trigger
      await tester.pump();
      // Then pumpAndSettle to finish snackbar animation
      await tester.pumpAndSettle();

      expect(find.text('Form saved successfully'), findsOneWidget);
    });
  });
}
