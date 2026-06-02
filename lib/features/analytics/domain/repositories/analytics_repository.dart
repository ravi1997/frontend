import 'package:frontend/features/analytics/domain/entities/analysis_dashboard.dart';
import 'package:frontend/features/analytics/domain/entities/analytics_summary.dart';
import 'package:frontend/features/analytics/domain/entities/analytics_timeline.dart';
import 'package:frontend/features/analytics/domain/entities/analytics_distribution.dart';

abstract class AnalyticsRepository {
  Future<AnalysisDashboard> getAnalysisDashboard({
    required String projectId,
    required String formId,
  });

  Future<AnalyticsSummary> getAnalyticsSummary({
    required String projectId,
    required String formId,
  });

  Future<List<AnalyticsTimeline>> getAnalyticsTimeline({
    required String projectId,
    required String formId,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<List<AnalyticsDistribution>> getAnalyticsDistribution({
    required String projectId,
    required String formId,
    List<String>? fieldNames,
  });
}