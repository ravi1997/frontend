// lib/features/dashboard/dashboard_controller.dart

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/networking/dio_provider.dart';
import 'package:frontend/core/networking/api_endpoints.dart';
import 'package:frontend/modules/dashboard/dashboard_models.dart';
import 'package:frontend/modules/dashboard/dashboard_service.dart';

final dashboardControllerProvider =
    AsyncNotifierProvider<DashboardController, DashboardData>(
  DashboardController.new,
);

final dashboardSearchQueryProvider =
    NotifierProvider<DashboardSearchQuery, String>(DashboardSearchQuery.new);
final dashboardSortByProvider = NotifierProvider<DashboardSortBy, String>(
  DashboardSortBy.new,
);

final filteredRecentFormsProvider = Provider<List<RecentForm>>((ref) {
  final dashboardData = ref.watch(dashboardControllerProvider).value;
  if (dashboardData == null) return const [];

  final query = ref.watch(dashboardSearchQueryProvider).toLowerCase();
  final sortBy = ref.watch(dashboardSortByProvider);

  List<RecentForm> forms = List.from(dashboardData.recentForms);

  if (query.isNotEmpty) {
    forms = forms.where((f) => f.title.toLowerCase().contains(query)).toList();
  }

  if (sortBy == 'Alphabetical' || sortBy == 'A-Z') {
    forms.sort(
      (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
    );
  } else if (sortBy == 'Oldest First') {
    forms.sort(
      (a, b) =>
          (a.createdAt ?? a.updatedAt).compareTo(b.createdAt ?? b.updatedAt),
    );
  } else if (sortBy == 'Newest First') {
    forms.sort(
      (a, b) =>
          (b.createdAt ?? b.updatedAt).compareTo(a.createdAt ?? a.updatedAt),
    );
  }

  return forms;
});

class DashboardController extends AsyncNotifier<DashboardData> {
  @override
  FutureOr<DashboardData> build() async => _fetch();

  Future<DashboardData> _fetch() async {
    final service = ref.read(dashboardServiceProvider);
    return await service.getDashboardData();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<void> deleteForm(String id) async {
    final service = ref.read(dashboardServiceProvider);
    await service.deleteForm(id);
    await refresh();
  }

  Future<void> duplicateForm(String id, String title) async {
    final api = ref.read(dioProvider);
    await api.post(
      ApiEndpoints.cloneForm(id),
      data: {'title': '$title (Copy)'},
    );
    await refresh();
  }
}

class DashboardSearchQuery extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
}

class DashboardSortBy extends Notifier<String> {
  @override
  String build() => 'Newest First';

  void setSort(String sort) => state = sort;
}
