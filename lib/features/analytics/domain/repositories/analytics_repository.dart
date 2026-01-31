import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../entities/form_analytics.dart';

part 'analytics_repository.g.dart';

abstract class AnalyticsRepository {
  Future<FormAnalytics> getAnalytics(String formId);
}

class MockAnalyticsRepository implements AnalyticsRepository {
  @override
  Future<FormAnalytics> getAnalytics(String formId) async {
    await Future.delayed(const Duration(seconds: 1));

    final now = DateTime.now();
    final trends = List.generate(7, (index) {
      return TimeSeriesData(
        date: now.subtract(Duration(days: 6 - index)),
        count: (index + 1) * 12 + (index % 2 == 0 ? 5 : -3),
      );
    });

    final fbDist = [
      const DistributionData(
        label: 'Very Satisfied',
        count: 45,
        percentage: 45,
      ),
      const DistributionData(label: 'Satisfied', count: 30, percentage: 30),
      const DistributionData(label: 'Neutral', count: 15, percentage: 15),
      const DistributionData(label: 'Unsatisfied', count: 10, percentage: 10),
    ];

    return FormAnalytics(
      formId: formId,
      totalSubmissions: 150,
      completionRate: 85.5,
      trends: trends,
      fieldDistributions: {
        'Satisfaction Level': fbDist,
        'Found via': [
          const DistributionData(
            label: 'Social Media',
            count: 60,
            percentage: 40,
          ),
          const DistributionData(
            label: 'Search Engine',
            count: 50,
            percentage: 33.3,
          ),
          const DistributionData(
            label: 'Direct Link',
            count: 40,
            percentage: 26.7,
          ),
        ],
      },
    );
  }
}

@riverpod
AnalyticsRepository analyticsRepository(Ref ref) {
  return MockAnalyticsRepository();
}
