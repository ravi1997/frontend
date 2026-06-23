import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/networking/dio_provider.dart';
import 'form_analytics.dart';
import 'analytics_summary.dart';
import 'analytics_timeline.dart';
import 'analytics_distribution.dart';
import 'analytics_repository_impl.dart';

/// Repository interface for analytics data operations.
///
/// Provides methods to fetch different types of analytics data
/// from the backend API endpoints.
abstract class AnalyticsRepository {
  /// Gets comprehensive analytics data for a form.
  /// Combines summary, timeline, and distribution data.
  Future<FormAnalytics> getFormAnalytics(String formId);

  /// Gets summary statistics for a form.
  /// Endpoint: GET /forms/{id}/analytics/summary
  Future<AnalyticsSummary> getAnalyticsSummary(String formId);

  /// Gets timeline data for form submissions.
  /// Endpoint: GET /forms/{id}/analytics/timeline
  Future<AnalyticsTimeline> getAnalyticsTimeline(
    String formId, {
    int days = 30,
  });

  /// Gets distribution data for form responses.
  /// Endpoint: GET /forms/{id}/analytics/distribution
  Future<AnalyticsDistribution> getAnalyticsDistribution(String formId);
}

final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AnalyticsRepositoryImpl(apiClient);
});
