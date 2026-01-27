import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/dashboard_data.dart';
import '../../data/repositories/dashboard_repository_impl.dart';

part 'dashboard_controller.g.dart';

@riverpod
class DashboardController extends _$DashboardController {
  @override
  FutureOr<DashboardData> build() async {
    return _fetch();
  }

  Future<DashboardData> _fetch() async {
    final repo = ref.read(dashboardRepositoryProvider);
    return await repo.getDashboardData();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetch());
  }
}
