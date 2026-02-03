import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../controllers/analytics_controller.dart';
import '../../domain/entities/analytics_summary.dart';
import '../../domain/entities/analytics_timeline.dart';
import '../../domain/entities/analytics_distribution.dart';

part 'analytics_providers.g.dart';

/// Provider for accessing the analytics state.
///
/// This provider watches the analytics controller and provides
/// access to the current analytics state including summary,
/// timeline, and distribution data.
@riverpod
AnalyticsState analyticsState(Ref ref, String formId) {
  return ref.watch(analyticsControllerProvider(formId));
}

/// Provider for accessing the summary analytics data.
///
/// This provider provides access to the summary statistics
/// for a specific form.
@riverpod
AnalyticsSummary? analyticsSummary(Ref ref, String formId) {
  return ref.watch(analyticsControllerProvider(formId)).summary;
}

/// Provider for accessing the timeline analytics data.
///
/// This provider provides access to the timeline data
/// for a specific form.
@riverpod
AnalyticsTimeline? analyticsTimeline(Ref ref, String formId) {
  return ref.watch(analyticsControllerProvider(formId)).timeline;
}

/// Provider for accessing the distribution analytics data.
///
/// This provider provides access to the distribution data
/// for a specific form.
@riverpod
AnalyticsDistribution? analyticsDistribution(Ref ref, String formId) {
  return ref.watch(analyticsControllerProvider(formId)).distribution;
}

/// Provider for accessing the loading state.
///
/// This provider provides access to the loading state
/// for analytics data.
@riverpod
bool analyticsIsLoading(Ref ref, String formId) {
  return ref.watch(analyticsControllerProvider(formId)).isLoading;
}

/// Provider for accessing the error state.
///
/// This provider provides access to any error that occurred
/// while loading analytics data.
@riverpod
String? analyticsError(Ref ref, String formId) {
  return ref.watch(analyticsControllerProvider(formId)).error;
}

/// Provider for checking if there is an error.
///
/// This provider returns true if there is an error state.
@riverpod
bool analyticsHasError(Ref ref, String formId) {
  return ref.watch(analyticsControllerProvider(formId)).hasError;
}
