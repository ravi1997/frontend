import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/modules/analytics/analysis_dashboard.dart';
import 'package:frontend/modules/analytics/analysis_dashboard_repository.dart';
import 'package:frontend/modules/analytics/analytics_providers.dart';
import 'package:frontend/modules/analytics/pages/analysis_boards_list_page.dart';

class _FakeAnalysisDashboardRepository extends AnalysisDashboardRepository {
  AnalysisDashboard? createdDashboard;

  _FakeAnalysisDashboardRepository() : super(Dio());

  @override
  Future<List<AnalysisDashboard>> listDashboards() async => <AnalysisDashboard>[];

  @override
  Future<AnalysisDashboard> createDashboard(
    AnalysisDashboard dashboard,
  ) async {
    createdDashboard = dashboard;
    return dashboard.copyWith(id: 'dashboard-1', slug: 'new-analysis-board');
  }
}

void main() {
  testWidgets('analysis boards page creates a board from the hero action', (
    tester,
  ) async {
    final fakeRepository = _FakeAnalysisDashboardRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          analysisDashboardRepositoryProvider.overrideWithValue(fakeRepository),
        ],
        child: const MaterialApp(
          home: ProjectAnalysisBoardsListPage(projectId: 'project-1'),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Create board'), findsOneWidget);

    await tester.tap(find.text('Create board'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Operations board');
    await tester.enterText(find.byType(TextField).last, 'Weekly KPIs');
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();

    expect(fakeRepository.createdDashboard, isNotNull);
    expect(fakeRepository.createdDashboard!.title, 'Operations board');
    expect(fakeRepository.createdDashboard!.description, 'Weekly KPIs');
    expect(find.text('Created Operations board'), findsOneWidget);
  });
}
