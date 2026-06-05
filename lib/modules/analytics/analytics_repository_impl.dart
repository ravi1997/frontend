import 'package:logger/logger.dart';

import '../../../../core/networking/api_client_wrapper.dart';
import 'analytics_distribution.dart';
import 'analytics_repository.dart';
import 'analytics_summary.dart';
import 'analytics_timeline.dart';
import 'form_analytics.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final ApiClient _apiClient;
  final Logger _logger = Logger();

  AnalyticsRepositoryImpl(this._apiClient);

  @override
  Future<FormAnalytics> getFormAnalytics(String formId) async {
    final summary = await getAnalyticsSummary(formId);
    final timeline = await getAnalyticsTimeline(formId);
    final distribution = await getAnalyticsDistribution(formId);
    return FormAnalytics(
      formId: formId,
      totalSubmissions: summary.totalSubmissions,
      completionRate: summary.completionRate,
      trends: timeline.dataPoints
          .map((p) => TimeSeriesData(date: p.date, value: p.count))
          .toList(),
      fieldDistributions: {
        for (final field in distribution.fieldDistributions)
          field.fieldLabel: field.options
              .map((o) => DistributionData(
                    label: o.label,
                    count: o.count,
                    percentage: o.percentage,
                  ))
              .toList(),
      },
    );
  }

  @override
  Future<AnalyticsSummary> getAnalyticsSummary(String formId) async {
    try {
      final response = await _apiClient.get('/forms/$formId/analytics/summary');
      final data = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : <String, dynamic>{};
      final total = (data['total_responses'] as num? ?? 0).toInt();
      return AnalyticsSummary(
        formId: formId,
        totalSubmissions: total,
        completionRate: total == 0 ? 0 : 1,
      );
    } catch (e, st) {
      _logger.e('analytics summary failed', error: e, stackTrace: st);
      return AnalyticsSummary(formId: formId, totalSubmissions: 0, completionRate: 0);
    }
  }

  @override
  Future<AnalyticsTimeline> getAnalyticsTimeline(String formId, {int days = 30}) async {
    try {
      await _apiClient.get('/forms/$formId/analytics/timeline');
      return AnalyticsTimeline(formId: formId, dataPoints: const []);
    } catch (e, st) {
      _logger.e('analytics timeline failed', error: e, stackTrace: st);
      return AnalyticsTimeline(formId: formId, dataPoints: const []);
    }
  }

  @override
  Future<AnalyticsDistribution> getAnalyticsDistribution(String formId) async {
    try {
      return AnalyticsDistribution(formId: formId, fieldDistributions: const []);
    } catch (e, st) {
      _logger.e('analytics distribution failed', error: e, stackTrace: st);
      return AnalyticsDistribution(formId: formId, fieldDistributions: const []);
    }
  }
}
