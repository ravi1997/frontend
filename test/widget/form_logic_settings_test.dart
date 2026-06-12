import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/modules/forms/widgets/form_logic_settings.dart';

void main() {
  testWidgets('form logic settings shows workflow summary and dialog', (
    tester,
  ) async {
    final form = {
      'sections': [
        {'id': 'section-1', 'title': 'Section 1', 'questions': const []},
      ],
      'workflows': {
        'email_notification': {'enabled': true},
        'webhook': {'enabled': false},
      },
    };

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FormLogicSettings(form: form, onChanged: (_) {}),
        ),
      ),
    );

    expect(find.text('Logic Settings'), findsOneWidget);
    expect(find.text('1 workflow configured for this form.'), findsOneWidget);
    expect(find.text('Email: enabled'), findsOneWidget);
    expect(find.text('Webhook: disabled'), findsOneWidget);

    await tester.tap(find.text('Edit workflows'));
    await tester.pumpAndSettle();

    expect(find.text('Form Workflows'), findsOneWidget);
    expect(find.textContaining('Configure automated actions'), findsOneWidget);
  });
}
