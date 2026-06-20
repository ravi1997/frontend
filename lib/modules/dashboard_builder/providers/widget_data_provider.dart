import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:frontend/modules/dashboard_builder/repositories/dashboard_builder_repository.dart';
import 'package:frontend/modules/dashboard_builder/providers/filter_state_provider.dart';

class WidgetDataState {
  final Map<String, dynamic> data;
  final bool isLoading;
  final String? error;

  WidgetDataState({
    required this.data,
    this.isLoading = false,
    this.error,
  });

  WidgetDataState copyWith({
    Map<String, dynamic>? data,
    bool? isLoading,
    String? error,
  }) {
    return WidgetDataState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class WidgetDataNotifier extends StateNotifier<WidgetDataState> {
  final DashboardBuilderRepository _repository;
  final Ref _ref;
  Timer? _refreshTimer;

  WidgetDataNotifier(this._repository, this._ref) : super(WidgetDataState(data: {}));

  Future<void> fetchDashboardData(String dashboardId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final filters = _ref.read(filterStateProvider);
      final resp = await _repository.getDashboardData(dashboardId, filterState: filters);
      final widgetData = resp['widget_data'] as Map<String, dynamic>? ?? {};
      
      final mappedData = <String, dynamic>{};
      widgetData.forEach((key, value) {
        if (value is Map) {
          mappedData[key] = value['data'];
        } else {
          mappedData[key] = value;
        }
      });

      state = WidgetDataState(data: mappedData, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void startAutoRefresh(String dashboardId, int intervalSeconds) {
    _refreshTimer?.cancel();
    if (intervalSeconds < 10) intervalSeconds = 10; // server min validation clamp
    _refreshTimer = Timer.periodic(Duration(seconds: intervalSeconds), (timer) {
      fetchDashboardData(dashboardId);
    });
  }

  void stopAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }
}

final widgetDataProvider = StateNotifierProvider<WidgetDataNotifier, WidgetDataState>((ref) {
  final repo = ref.watch(dashboardBuilderRepositoryProvider);
  return WidgetDataNotifier(repo, ref);
});
