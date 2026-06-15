import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/modules/forms/widgets/llm_copilot_drawer.dart';

void main() {
  testWidgets('LlmCopilotDrawer renders prompt and generate action', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LlmCopilotDrawer(formId: 'form-123'),
        ),
      ),
    );

    expect(find.text('LLM Copilot'), findsOneWidget);
    expect(find.text('Generate'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });
}
