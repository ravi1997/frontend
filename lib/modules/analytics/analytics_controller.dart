import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'analytics_distribution.dart';
import 'analytics_repository.dart';
import 'analytics_summary.dart';
import 'analytics_timeline.dart';

class AnalyticsState {
  final AnalyticsSummary? summary;
  final AnalyticsTimeline? timeline;
  final AnalyticsDistribution? distribution;
  final bool isLoadingSummary;
  final bool isLoadingTimeline;
  final bool isLoadingDistribution;
  final String? error;

  const AnalyticsState({
    this.summary,
    this.timeline,
    this.distribution,
    this.isLoadingSummary = false,
    this.isLoadingTimeline = false,
    this.isLoadingDistribution = false,
    this.error,
  });

  AnalyticsState copyWith({
    AnalyticsSummary? summary,
    AnalyticsTimeline? timeline,
    AnalyticsDistribution? distribution,
    bool? isLoadingSummary,
    bool? isLoadingTimeline,
    bool? isLoadingDistribution,
    String? error,
  }) {
    return AnalyticsState(
      summary: summary ?? this.summary,
      timeline: timeline ?? this.timeline,
      distribution: distribution ?? this.distribution,
      isLoadingSummary: isLoadingSummary ?? this.isLoadingSummary,
      isLoadingTimeline: isLoadingTimeline ?? this.isLoadingTimeline,
      isLoadingDistribution:
          isLoadingDistribution ?? this.isLoadingDistribution,
      error: error ?? this.error,
    );
  }

  bool get isLoading =>
      isLoadingSummary || isLoadingTimeline || isLoadingDistribution;

  bool get hasError => error != null;
}

final analyticsControllerProvider =
    StateNotifierProvider.family<AnalyticsController, AnalyticsState, String>(
  (ref, formId) => AnalyticsController(ref, formId),
);

class AnalyticsController extends StateNotifier<AnalyticsState> {
  final Ref ref;
  final String formId;

  AnalyticsController(this.ref, this.formId) : super(const AnalyticsState());

  Future<void> loadSummary() async {
    final repository = ref.read(analyticsRepositoryProvider);
    state = state.copyWith(isLoadingSummary: true, error: null);
    final summary = await repository.getAnalyticsSummary(formId);
    state = state.copyWith(summary: summary, isLoadingSummary: false);
  }

  Future<void> loadTimeline({int days = 30}) async {
    final repository = ref.read(analyticsRepositoryProvider);
    state = state.copyWith(isLoadingTimeline: true, error: null);
    final timeline = await repository.getAnalyticsTimeline(formId, days: days);
    state = state.copyWith(timeline: timeline, isLoadingTimeline: false);
  }

  Future<void> loadDistribution() async {
    final repository = ref.read(analyticsRepositoryProvider);
    state = state.copyWith(isLoadingDistribution: true, error: null);
    final distribution = await repository.getAnalyticsDistribution(formId);
    state = state.copyWith(
      distribution: distribution,
      isLoadingDistribution: false,
    );
  }

  Future<void> refresh() async {
    await Future.wait([loadSummary(), loadTimeline(), loadDistribution()]);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
