import '../../domain/entities/form_analytics.dart';
import '../../domain/repositories/analytics_repository.dart';

class MockAnalyticsRepository implements AnalyticsRepository {
  @override
  Future<FormAnalytics> getFormAnalytics(String formId) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

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
