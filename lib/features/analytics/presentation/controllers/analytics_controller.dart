import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/analytics_summary.dart';
import '../../domain/entities/analytics_timeline.dart';
import '../../domain/entities/analytics_distribution.dart';
import '../../domain/repositories/analytics_repository.dart';

part 'analytics_controller.g.dart';

const Object _analyticsErrorUnset = Object();

/// State class for analytics data containing all three analytics types.
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
    Object? error = _analyticsErrorUnset,
  }) {
    return AnalyticsState(
      summary: summary ?? this.summary,
      timeline: timeline ?? this.timeline,
      distribution: distribution ?? this.distribution,
      isLoadingSummary: isLoadingSummary ?? this.isLoadingSummary,
      isLoadingTimeline: isLoadingTimeline ?? this.isLoadingTimeline,
      isLoadingDistribution:
          isLoadingDistribution ?? this.isLoadingDistribution,
      error: identical(error, _analyticsErrorUnset)
          ? this.error
          : error as String?,
    );
  }

  bool get isLoading =>
      isLoadingSummary || isLoadingTimeline || isLoadingDistribution;

  bool get hasError => error != null;
}

/// Controller for managing analytics data using Riverpod state management.
///
/// Provides async access to all three types of analytics data:
/// - Summary statistics
/// - Timeline data
/// - Distribution data
///
/// Supports individual loading of each analytics type and batch refresh.
@riverpod
class AnalyticsController extends _$AnalyticsController {
  @override
  AnalyticsState build(String formId) {
    // Don't load data in build - it causes circular dependency
    // Load initial data asynchronously via refresh() if needed
    return const AnalyticsState();
  }

  /// Loads all three types of analytics data in parallel.
  Future<void> _loadAllAnalytics(String formId) async {
    state = state.copyWith(
      isLoadingSummary: true,
      isLoadingTimeline: true,
      isLoadingDistribution: true,
      error: null,
    );

    try {
      final repository = ref.read(analyticsRepositoryProvider);

      final results = await Future.wait([
        repository.getAnalyticsSummary(formId),
        repository.getAnalyticsTimeline(formId, days: 30),
        repository.getAnalyticsDistribution(formId),
      ]);

      if (!ref.mounted) return;

      state = AnalyticsState(
        summary: results[0] as AnalyticsSummary,
        timeline: results[1] as AnalyticsTimeline,
        distribution: results[2] as AnalyticsDistribution,
        isLoadingSummary: false,
        isLoadingTimeline: false,
        isLoadingDistribution: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingSummary: false,
        isLoadingTimeline: false,
        isLoadingDistribution: false,
        error: e.toString(),
      );
    }
  }

  /// Loads summary statistics for the form.
  Future<void> loadSummary() async {
    state = state.copyWith(isLoadingSummary: true, error: null);

    try {
      final repository = ref.read(analyticsRepositoryProvider);
      final summary = await repository.getAnalyticsSummary(formId);

      if (!ref.mounted) return;

      state = state.copyWith(summary: summary, isLoadingSummary: false);
    } catch (e) {
      state = state.copyWith(isLoadingSummary: false, error: e.toString());
    }
  }

  /// Loads timeline data for the form.
  ///
  /// [days] specifies the number of days to include in the timeline.
  /// Defaults to 30 days.
  Future<void> loadTimeline({int days = 30}) async {
    state = state.copyWith(isLoadingTimeline: true, error: null);

    try {
      final repository = ref.read(analyticsRepositoryProvider);
      final timeline = await repository.getAnalyticsTimeline(
        formId,
        days: days,
      );

      if (!ref.mounted) return;

      state = state.copyWith(timeline: timeline, isLoadingTimeline: false);
    } catch (e) {
      state = state.copyWith(isLoadingTimeline: false, error: e.toString());
    }
  }

  /// Loads distribution data for the form.
  Future<void> loadDistribution() async {
    state = state.copyWith(isLoadingDistribution: true, error: null);

    try {
      final repository = ref.read(analyticsRepositoryProvider);
      final distribution = await repository.getAnalyticsDistribution(formId);

      if (!ref.mounted) return;

      state = state.copyWith(
        distribution: distribution,
        isLoadingDistribution: false,
      );
    } catch (e) {
      state = state.copyWith(isLoadingDistribution: false, error: e.toString());
    }
  }

  /// Refreshes all analytics data.
  Future<void> refresh() async {
    await _loadAllAnalytics(formId);
  }

  /// Clears any error state.
  void clearError() {
    state = state.copyWith(error: null);
  }
}
