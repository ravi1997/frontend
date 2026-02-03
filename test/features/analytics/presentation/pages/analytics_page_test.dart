import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/analytics/presentation/pages/analytics_page.dart';

void main() {
  testWidgets('AnalyticsPage should show loading and then data', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: AnalyticsPage(formId: '1')),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Pump enough times to bypass the simulated loading in MockAnalyticsRepository
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    expect(find.text('Form Analytics'), findsOneWidget);
    expect(find.text('Total Submissions'), findsOneWidget);
  });
}
