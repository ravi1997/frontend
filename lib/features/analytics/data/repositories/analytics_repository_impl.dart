import 'package:logger/logger.dart';
import '../../domain/entities/form_analytics.dart';
import '../../domain/entities/analytics_summary.dart';
import '../../domain/entities/analytics_timeline.dart';
import '../../domain/entities/analytics_distribution.dart';
import '../../domain/repositories/analytics_repository.dart';
import '../../../../core/exceptions/app_exception.dart';
import '../../../../core/network/api_client_wrapper.dart';

/// Implementation of [AnalyticsRepository] for fetching form analytics data.
///
/// Handles data retrieval from the analytics API endpoints with proper
/// error handling and data transformation.
class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final ApiClient _apiClient;
  final Logger _logger = Logger();

  AnalyticsRepositoryImpl(this._apiClient);

  @override
  Future<FormAnalytics> getFormAnalytics(String formId) async {
    try {
      // Fetch all analytics data in parallel
      final results = await Future.wait([
        _apiClient.get('/forms/$formId/analytics/summary'),
        _apiClient.get(
          '/forms/$formId/analytics/timeline',
          queryParameters: {'days': 30},
        ),
        _apiClient.get('/forms/$formId/analytics/distribution'),
      ]);

      final summaryData = results[0].data as Map<String, dynamic>;
      final timelineData = results[1].data as Map<String, dynamic>;
      final distributionData = results[2].data as Map<String, dynamic>;

      // Parse summary
      final totalSubmissions = summaryData['total_responses'] as int? ?? 0;

      // Calculate completion rate (if we have status breakdown)
      final statusBreakdown =
          summaryData['status_breakdown'] as Map<String, dynamic>? ?? {};
      final completedCount =
          (statusBreakdown['approved'] as int? ?? 0) +
          (statusBreakdown['submitted'] as int? ?? 0);
      final completionRate = totalSubmissions > 0
          ? completedCount / totalSubmissions
          : 0.0;

      // Parse timeline
      final timelineList = timelineData['timeline'] as List<dynamic>? ?? [];
      final trends = timelineList.map((item) {
        return TimeSeriesData(
          date: DateTime.parse(item['date'] as String),
          value: item['count'] as int,
        );
      }).toList();

      // Parse distribution
      final distributionList =
          distributionData['distribution'] as List<dynamic>? ?? [];
      final fieldDistributions = <String, List<DistributionData>>{};

      for (var item in distributionList) {
        final label = item['label'] as String;
        final counts = item['counts'] as Map<String, dynamic>;

        // Calculate total for percentages
        final total = counts.values.fold<int>(
          0,
          (sum, count) => sum + (count as int),
        );

        final distributions = counts.entries.map((entry) {
          final count = entry.value as int;
          final percentage = total > 0 ? (count / total) * 100 : 0.0;

          return DistributionData(
            label: entry.key,
            count: count,
            percentage: percentage,
          );
        }).toList();

        // Sort by count descending
        distributions.sort((a, b) => b.count.compareTo(a.count));

        fieldDistributions[label] = distributions;
      }

      return FormAnalytics(
        formId: formId,
        totalSubmissions: totalSubmissions,
        completionRate: completionRate,
        trends: trends,
        fieldDistributions: fieldDistributions,
      );
    } catch (e, stack) {
      _logger.e('Failed to load analytics', error: e, stackTrace: stack);
      throw FormLoadException(formId, originalError: e, stackTrace: stack);
    }
  }

  @override
  Future<AnalyticsSummary> getAnalyticsSummary(String formId) async {
    try {
      final response = await _apiClient.get('/forms/$formId/analytics/summary');
      final data = response.data as Map<String, dynamic>;

      final totalSubmissions = data['total_responses'] as int? ?? 0;
      final statusBreakdown =
          data['status_breakdown'] as Map<String, dynamic>? ?? {};
      final completedCount =
          (statusBreakdown['approved'] as int? ?? 0) +
          (statusBreakdown['submitted'] as int? ?? 0);
      final completionRate = totalSubmissions > 0
          ? completedCount / totalSubmissions
          : 0.0;

      return AnalyticsSummary(
        formId: formId,
        totalSubmissions: totalSubmissions,
        completionRate: completionRate,
        statusBreakdown: statusBreakdown.map(
          (key, value) => MapEntry(key, value as int),
        ),
      );
    } catch (e, stack) {
      _logger.e(
        'Failed to load analytics summary',
        error: e,
        stackTrace: stack,
      );
      throw FormLoadException(formId, originalError: e, stackTrace: stack);
    }
  }

  @override
  Future<AnalyticsTimeline> getAnalyticsTimeline(
    String formId, {
    int days = 30,
  }) async {
    try {
      final response = await _apiClient.get(
        '/forms/$formId/analytics/timeline',
        queryParameters: {'days': days},
      );
      final data = response.data as Map<String, dynamic>;

      final timelineList = data['timeline'] as List<dynamic>? ?? [];
      final dataPoints = timelineList.map((item) {
        return TimelineDataPoint(
          date: DateTime.parse(item['date'] as String),
          count: item['count'] as int,
          submissions: item['submissions'] as int?,
          completions: item['completions'] as int?,
          rate: item['rate'] as double?,
        );
      }).toList();

      return AnalyticsTimeline(
        formId: formId,
        dataPoints: dataPoints,
        period: data['period'] as String?,
        startDate: data['start_date'] != null
            ? DateTime.parse(data['start_date'] as String)
            : null,
        endDate: data['end_date'] != null
            ? DateTime.parse(data['end_date'] as String)
            : null,
      );
    } catch (e, stack) {
      _logger.e(
        'Failed to load analytics timeline',
        error: e,
        stackTrace: stack,
      );
      throw FormLoadException(formId, originalError: e, stackTrace: stack);
    }
  }

  @override
  Future<AnalyticsDistribution> getAnalyticsDistribution(String formId) async {
    try {
      final response = await _apiClient.get(
        '/forms/$formId/analytics/distribution',
      );
      final data = response.data as Map<String, dynamic>;

      final distributionList = data['distribution'] as List<dynamic>? ?? [];
      final fieldDistributions = <FieldDistribution>[];

      for (var item in distributionList) {
        final label = item['label'] as String;
        final fieldId = item['field_id'] as String? ?? label;
        final counts = item['counts'] as Map<String, dynamic>;

        // Calculate total for percentages
        final total = counts.values.fold<int>(
          0,
          (sum, count) => sum + (count as int),
        );

        final options = counts.entries.map((entry) {
          final count = entry.value as int;
          final percentage = total > 0 ? (count / total) * 100 : 0.0;

          return DistributionOption(
            label: entry.key,
            count: count,
            percentage: percentage,
          );
        }).toList();

        // Sort by count descending
        options.sort((a, b) => b.count.compareTo(a.count));

        fieldDistributions.add(
          FieldDistribution(
            fieldId: fieldId,
            fieldLabel: label,
            options: options,
            totalResponses: total,
          ),
        );
      }

      return AnalyticsDistribution(
        formId: formId,
        fieldDistributions: fieldDistributions,
      );
    } catch (e, stack) {
      _logger.e(
        'Failed to load analytics distribution',
        error: e,
        stackTrace: stack,
      );
      throw FormLoadException(formId, originalError: e, stackTrace: stack);
    }
  }
}
