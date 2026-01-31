import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/dashboard/domain/entities/dashboard_data.dart';
import 'package:frontend/features/dashboard/domain/entities/dashboard_stats.dart';
import 'package:frontend/features/dashboard/domain/entities/recent_form.dart';
import 'package:frontend/features/dashboard/presentation/controllers/dashboard_controller.dart';

class FakeDashboardController extends DashboardController {
  final DashboardData data;
  FakeDashboardController(this.data);

  @override
  FutureOr<DashboardData> build() => data;
}

void main() {
  group('Dashboard Filter & Sort Logic', () {
    late ProviderContainer container;

    final mockForms = [
      RecentForm(
        id: '1',
        title: 'Beta Form',
        status: 'draft',
        updatedAt: DateTime(2023, 1, 1),
        createdAt: DateTime(2023, 1, 1),
      ),
      RecentForm(
        id: '2',
        title: 'Alpha Form',
        status: 'published',
        updatedAt: DateTime(2023, 2, 1),
        createdAt: DateTime(2023, 2, 1),
      ),
      RecentForm(
        id: '3',
        title: 'Gamma Form',
        status: 'published',
        updatedAt: DateTime(2023, 3, 1),
        createdAt: DateTime(2023, 3, 1),
      ),
    ];

    setUp(() {
      final dashboardData = DashboardData(
        stats: const DashboardStats(
          totalForms: 3,
          totalResponses: 10,
          activeForms: 2,
        ),
        recentForms: mockForms,
      );

      container = ProviderContainer(
        overrides: [
          dashboardControllerProvider.overrideWith(
            () => FakeDashboardController(dashboardData),
          ),
        ],
      );
    });

    test('should filter forms by query', () {
      container.read(dashboardSearchQueryProvider.notifier).setQuery('Alpha');
      final filtered = container.read(filteredRecentFormsProvider);

      expect(filtered.length, 1);
      expect(filtered.first.title, 'Alpha Form');
    });

    test('should sort forms Alphabetically', () {
      container.read(dashboardSortByProvider.notifier).setSort('A-Z');
      final filtered = container.read(filteredRecentFormsProvider);

      expect(filtered[0].title, 'Alpha Form');
      expect(filtered[1].title, 'Beta Form');
      expect(filtered[2].title, 'Gamma Form');
    });

    test('should sort forms Newest First', () {
      container.read(dashboardSortByProvider.notifier).setSort('Newest First');
      final filtered = container.read(filteredRecentFormsProvider);

      expect(filtered[0].id, '3');
      expect(filtered[1].id, '2');
      expect(filtered[2].id, '1');
    });
  });
}
