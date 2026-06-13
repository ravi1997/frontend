import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/modules/forms/widgets/form_submission_settings.dart';

void main() {
  testWidgets('submission settings validate redirect URL inline', (
    tester,
  ) async {
    var form = <String, dynamic>{
      'submissionSettings': {
        'confirmation_message': 'Thanks',
        'redirect_after_submit': true,
        'redirect_url': '',
        'save_and_resume': true,
        'draft_handling': {'autoSave': true},
      },
    };

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return FormSubmissionSettings(
                form: form,
                onChanged: (updated) => setState(() => form = updated),
              );
            },
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('submission-settings-redirect-url')),
      'not-a-valid-url',
    );
    await tester.pumpAndSettle();

    expect(find.text('Enter a valid http(s) URL.'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('submission-settings-redirect-url')),
      'https://example.com/thanks',
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Enter a valid http(s) URL.'),
      findsNothing,
    );
  });
}
