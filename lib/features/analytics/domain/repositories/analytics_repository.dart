import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../entities/form_analytics.dart';
import '../entities/analytics_summary.dart';
import '../entities/analytics_timeline.dart';
import '../entities/analytics_distribution.dart';
import '../../../../core/network/api_client_wrapper.dart';
import '../../data/repositories/analytics_repository_impl.dart';

part 'analytics_repository.g.dart';

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

@riverpod
AnalyticsRepository analyticsRepository(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AnalyticsRepositoryImpl(apiClient);
}
