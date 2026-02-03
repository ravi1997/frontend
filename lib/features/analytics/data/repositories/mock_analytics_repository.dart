import '../../domain/entities/form_analytics.dart';
import '../../domain/entities/analytics_summary.dart';
import '../../domain/entities/analytics_timeline.dart';
import '../../domain/entities/analytics_distribution.dart';
import '../../domain/repositories/analytics_repository.dart';

/// Mock implementation of [AnalyticsRepository] for testing and development.
///
/// Provides simulated analytics data without making actual API calls.
class MockAnalyticsRepository implements AnalyticsRepository {
  @override
  Future<FormAnalytics> getFormAnalytics(String formId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    return FormAnalytics(
      formId: formId,
      totalSubmissions: 124,
      completionRate: 0.85,
      trends: _generateTrends(),
      fieldDistributions: {
        'Satisfaction': [
          const DistributionData(
            label: 'Very Satisfied',
            count: 45,
            percentage: 36.3,
          ),
          const DistributionData(
            label: 'Satisfied',
            count: 52,
            percentage: 41.9,
          ),
          const DistributionData(label: 'Neutral', count: 18, percentage: 14.5),
          const DistributionData(
            label: 'Unsatisfied',
            count: 9,
            percentage: 7.3,
          ),
        ],
        'Likely to recommend': [
          const DistributionData(
            label: '9-10 (Promoters)',
            count: 80,
            percentage: 64.5,
          ),
          const DistributionData(
            label: '7-8 (Passives)',
            count: 30,
            percentage: 24.2,
          ),
          const DistributionData(
            label: '0-6 (Detractors)',
            count: 14,
            percentage: 11.3,
          ),
        ],
      },
    );
  }

  @override
  Future<AnalyticsSummary> getAnalyticsSummary(String formId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    return AnalyticsSummary(
      formId: formId,
      totalSubmissions: 124,
      completionRate: 0.85,
      uniqueResponders: 98,
      averageCompletionTime: 4.5,
      statusBreakdown: {
        'approved': 85,
        'submitted': 20,
        'draft': 10,
        'rejected': 9,
      },
    );
  }

  @override
  Future<AnalyticsTimeline> getAnalyticsTimeline(
    String formId, {
    int days = 30,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final now = DateTime.now();
    final dataPoints = List.generate(days, (index) {
      return TimelineDataPoint(
        date: now.subtract(Duration(days: days - 1 - index)),
        count: 10 + (index * 3) + (index % 3 == 0 ? 5 : -2),
        submissions: 8 + (index * 2),
        completions: 6 + (index * 2),
        rate: 0.7 + (index % 5) * 0.05,
      );
    });

    return AnalyticsTimeline(
      formId: formId,
      dataPoints: dataPoints,
      period: 'Last $days days',
      startDate: now.subtract(Duration(days: days)),
      endDate: now,
    );
  }

  @override
  Future<AnalyticsDistribution> getAnalyticsDistribution(String formId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    return AnalyticsDistribution(
      formId: formId,
      fieldDistributions: [
        FieldDistribution(
          fieldId: 'satisfaction',
          fieldLabel: 'How satisfied are you?',
          options: [
            const DistributionOption(
              label: 'Very Satisfied',
              count: 45,
              percentage: 36.3,
            ),
            const DistributionOption(
              label: 'Satisfied',
              count: 52,
              percentage: 41.9,
            ),
            const DistributionOption(
              label: 'Neutral',
              count: 18,
              percentage: 14.5,
            ),
            const DistributionOption(
              label: 'Unsatisfied',
              count: 9,
              percentage: 7.3,
            ),
          ],
          totalResponses: 124,
        ),
        FieldDistribution(
          fieldId: 'recommend',
          fieldLabel: 'How likely are you to recommend?',
          options: [
            const DistributionOption(
              label: '9-10 (Promoters)',
              count: 80,
              percentage: 64.5,
            ),
            const DistributionOption(
              label: '7-8 (Passives)',
              count: 30,
              percentage: 24.2,
            ),
            const DistributionOption(
              label: '0-6 (Detractors)',
              count: 14,
              percentage: 11.3,
            ),
          ],
          totalResponses: 124,
        ),
      ],
    );
  }

  List<TimeSeriesData> _generateTrends() {
    final now = DateTime.now();
    return List.generate(7, (index) {
      return TimeSeriesData(
        date: now.subtract(Duration(days: 6 - index)),
        value: 10 + (index * 5) + (index % 2 == 0 ? 3 : -2),
      );
    });
  }
}
