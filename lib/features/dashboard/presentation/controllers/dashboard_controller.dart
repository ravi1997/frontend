import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/dashboard_data.dart';
import '../../domain/entities/recent_form.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../../../core/controllers/base_controller_mixin.dart';

part 'dashboard_controller.g.dart';

@Riverpod(keepAlive: true)
class DashboardController extends _$DashboardController
    with BaseControllerMixin {
  @override
  FutureOr<DashboardData> build() async {
    return _fetch();
  }

  Future<DashboardData> _fetch() async {
    final repo = ref.read(dashboardRepositoryProvider);
    return await repo.getDashboardData();
  }

  Future<void> refresh() async {
    await executeRefresh(
      refreshOperation: () async {
        state = const AsyncValue.loading();
        state = await AsyncValue.guard(() => _fetch());
      },
    );
  }

  Future<void> deleteForm(String id) async {
    await executeDelete(
      id: id,
      deleteOperation: (formId) async {
        final repo = ref.read(dashboardRepositoryProvider);
        await repo.deleteForm(formId);
      },
      refreshAfterDelete: refresh,
      entityName: 'form',
    );
  }

  Future<void> duplicateForm(String id, String title) async {
    await executeOperation(
      operation: () async {
        final repo = ref.read(dashboardRepositoryProvider);
        await repo.duplicateForm(id, '$title (Copy)');
        await refresh();
      },
    );
  }
}

@riverpod
class DashboardSearchQuery extends _$DashboardSearchQuery {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
}

@riverpod
class DashboardSortBy extends _$DashboardSortBy {
  @override
  String build() => 'Newest First';

  void setSort(String sort) => state = sort;
}

@riverpod
List<RecentForm> filteredRecentForms(Ref ref) {
  final dashboardData = ref.watch(dashboardControllerProvider).value;
  if (dashboardData == null) return [];

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
}
