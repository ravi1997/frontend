import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/modules/forms/widgets/form_render_widget.dart';
import 'package:frontend/shared/models/form_models.dart';

void main() {
  testWidgets('form render applies branding settings', (tester) async {
    final form = BuilderForm.fromJson({
      'id': 'form-1',
      'title': 'Branded Form',
      'slug': 'branded-form',
      'style': {
        'backgroundColor': '#FAFAFA',
        'accentColor': '#123456',
        'logoUrl': 'https://example.com/logo.png',
        'coverImageUrl': 'https://example.com/cover.png',
        'headerStyle': 'banner',
        'thankYouTheme': 'celebratory',
      },
      'sections': const [],
    });

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(body: FormRenderWidget(form: form)),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(Image), findsAtLeastNWidgets(2));
    expect(find.text('Branded Form'), findsOneWidget);
  });
}
