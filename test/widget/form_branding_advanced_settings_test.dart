import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/modules/forms/widgets/form_advanced_settings.dart';
import 'package:frontend/modules/forms/widgets/form_branding_settings.dart';

void main() {
  testWidgets('branding and advanced settings render without overflow', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListView(
            children: [
              FormBrandingSettings(
                form: const {'style': {}},
                onChanged: (_) {},
              ),
              const SizedBox(height: 24),
              FormAdvancedSettings(
                form: const {'advancedSettings': {}},
                onChanged: (_) {},
              ),
            ],
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Branding'), findsOneWidget);
    expect(find.text('Advanced'), findsOneWidget);
    expect(find.text('Form slug'), findsOneWidget);
    expect(find.text('Logo URL'), findsOneWidget);
  });
}
