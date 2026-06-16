import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/modules/dashboard/widgets/analysis_boards_entry_card.dart';

void main() {
  testWidgets('analysis boards entry card triggers open callback', (
    tester,
  ) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AnalysisBoardsEntryCard(
            projectId: 'project-1',
            onOpen: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text('Analysis boards'), findsOneWidget);
    expect(find.text('Project ID: project-1'), findsOneWidget);

    await tester.tap(find.text('Open analysis boards'));
    await tester.pumpAndSettle();

    expect(tapped, isTrue);
  });
}
