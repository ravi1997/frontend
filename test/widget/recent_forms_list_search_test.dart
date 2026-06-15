import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/modules/dashboard/dashboard_controller.dart';
import 'package:frontend/modules/dashboard/dashboard_models.dart';
import 'package:frontend/modules/dashboard/widgets/recent_forms_list.dart';

class _FakeDashboardController extends DashboardController {
  _FakeDashboardController(this._data);

  final DashboardData _data;

  @override
  FutureOr<DashboardData> build() async => _data;
}

void main() {
  testWidgets('recent forms list filters by dashboard search query', (
    tester,
  ) async {
    final data = DashboardData(
      stats: const DashboardStats(
        totalForms: 2,
        totalResponses: 8,
        activeForms: 1,
      ),
      recentForms: [
        RecentForm(
          id: 'form-1',
          title: 'Patient Intake',
          status: 'draft',
          updatedAt: DateTime(2026, 6, 1),
        ),
        RecentForm(
          id: 'form-2',
          title: 'Lab Request',
          status: 'published',
          updatedAt: DateTime(2026, 6, 2),
        ),
      ],
      projects: [
        ProjectSummary(
          id: 'project-1',
          title: 'Patient Intake',
          description: 'Intake workflow',
          helpText: null,
          status: 'draft',
          forms: 1,
          responses: 4,
          members: 2,
          collaborators: const [],
          tags: const [],
          updatedAt: '2026-06-01T00:00:00Z',
        ),
        ProjectSummary(
          id: 'project-2',
          title: 'Lab Request',
          description: 'Lab workflow',
          helpText: null,
          status: 'published',
          forms: 1,
          responses: 4,
          members: 2,
          collaborators: const [],
          tags: const [],
          updatedAt: '2026-06-02T00:00:00Z',
        ),
      ],
    );

    final container = ProviderContainer(
      overrides: [
        dashboardControllerProvider.overrideWith(
          () => _FakeDashboardController(data),
        ),
      ],
    );
    addTearDown(container.dispose);

    final sub = container.listen(
      dashboardControllerProvider,
      (_, _) {},
      fireImmediately: true,
    );
    addTearDown(sub.close);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(body: RecentFormsList()),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Patient Intake'), findsOneWidget);
    expect(find.text('Lab Request'), findsOneWidget);

    container.read(dashboardSearchQueryProvider.notifier).setQuery('Lab');
    await tester.pumpAndSettle();

    expect(find.text('Lab Request'), findsOneWidget);
    expect(find.text('Patient Intake'), findsNothing);
  });

  testWidgets('recent forms list sorts alphabetically via provider', (
    tester,
  ) async {
    final data = DashboardData(
      stats: const DashboardStats(
        totalForms: 2,
        totalResponses: 8,
        activeForms: 1,
      ),
      recentForms: [
        RecentForm(
          id: 'form-1',
          title: 'Zeta Intake',
          status: 'draft',
          updatedAt: DateTime(2026, 6, 1),
        ),
        RecentForm(
          id: 'form-2',
          title: 'Alpha Intake',
          status: 'published',
          updatedAt: DateTime(2026, 6, 2),
        ),
      ],
      projects: [
        ProjectSummary(
          id: 'project-1',
          title: 'Zeta Intake',
          description: 'Intake workflow',
          helpText: null,
          status: 'draft',
          forms: 1,
          responses: 4,
          members: 2,
          collaborators: const [],
          tags: const [],
          updatedAt: '2026-06-01T00:00:00Z',
        ),
        ProjectSummary(
          id: 'project-2',
          title: 'Alpha Intake',
          description: 'Lab workflow',
          helpText: null,
          status: 'published',
          forms: 1,
          responses: 4,
          members: 2,
          collaborators: const [],
          tags: const [],
          updatedAt: '2026-06-02T00:00:00Z',
        ),
      ],
    );

    final container = ProviderContainer(
      overrides: [
        dashboardControllerProvider.overrideWith(
          () => _FakeDashboardController(data),
        ),
      ],
    );
    addTearDown(container.dispose);

    final sub = container.listen(
      dashboardControllerProvider,
      (_, _) {},
      fireImmediately: true,
    );
    addTearDown(sub.close);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(body: RecentFormsList()),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Zeta Intake'), findsOneWidget);
    expect(find.text('Alpha Intake'), findsOneWidget);

    container.read(dashboardSortByProvider.notifier).setSort('Alphabetical');
    await tester.pumpAndSettle();

    final alphaTop = tester.getTopLeft(find.text('Alpha Intake')).dy;
    final zetaTop = tester.getTopLeft(find.text('Zeta Intake')).dy;
    expect(alphaTop, lessThan(zetaTop));
  });
}
