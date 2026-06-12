import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frontend/modules/dashboard_builder/models/dashboard_canvas_models.dart';
import 'package:frontend/modules/dashboard_builder/pages/dashboard_builder_page.dart';
import 'package:frontend/modules/dashboard_builder/repositories/dashboard_builder_repository.dart';

class _FakeDashboardBuilderRepository extends DashboardBuilderRepository {
  int includeDataRequests = 0;

  _FakeDashboardBuilderRepository() : super(Dio());

  @override
  Future<DashboardModel> getCanvas(
    String dashboardId, {
    bool includeData = false,
  }) async {
    if (includeData) {
      includeDataRequests++;
    }

    return DashboardModel(
      id: dashboardId,
      name: 'Operations Dashboard',
      canvas: DashboardCanvas(
        width: 1200,
        height: 800,
        widgets: [
          DashboardWidget(
            id: 'widget-1',
            type: DashboardWidgetType.kpiCard,
            properties: const {'title': 'Completed submissions'},
            resolvedData: includeData ? {'value': 42} : null,
          ),
        ],
      ),
      settings: const DashboardSettings(autoRefresh: false),
    );
  }

  @override
  Future<void> saveCanvas(String dashboardId, DashboardCanvas canvas) async {}

  @override
  Future<String?> share(String dashboardId) async => 'share-token';
}

void main() {
  testWidgets('dashboard builder preview mode renders resolved data',
      (tester) async {
    final repo = _FakeDashboardBuilderRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dashboardBuilderRepositoryProvider.overrideWithValue(repo),
        ],
        child: const MaterialApp(
          home: DashboardBuilderPage(
            projectId: 'project-1',
            dashboardId: 'dashboard-1',
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Operations Dashboard'), findsOneWidget);
    expect(find.text('42'), findsNothing);

    await tester.tap(find.text('Preview'));
    await tester.pumpAndSettle();

    expect(repo.includeDataRequests, greaterThanOrEqualTo(1));
    expect(find.text('42'), findsOneWidget);
  });
}
