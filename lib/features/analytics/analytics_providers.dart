import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import 'analysis_dashboard_repository.dart';
import 'analytics_controller.dart';
import 'analytics_summary.dart';
import 'analytics_timeline.dart';
import 'analytics_distribution.dart';

final analysisDashboardRepositoryProvider =
    Provider<AnalysisDashboardRepository>((ref) {
      final dioClient = ref.watch(dioProvider);
      return AnalysisDashboardRepository(dioClient);
    });

final analyticsStateProvider = Provider.family<AnalyticsState, String>((
  ref,
  formId,
) {
  return ref.watch(analyticsControllerProvider(formId));
});

final analyticsSummaryProvider = Provider.family<AnalyticsSummary?, String>((
  ref,
  formId,
) {
  return ref.watch(analyticsControllerProvider(formId)).summary;
});

final analyticsTimelineProvider = Provider.family<AnalyticsTimeline?, String>((
  ref,
  formId,
) {
  return ref.watch(analyticsControllerProvider(formId)).timeline;
});

final analyticsDistributionProvider =
    Provider.family<AnalyticsDistribution?, String>((ref, formId) {
      return ref.watch(analyticsControllerProvider(formId)).distribution;
    });

final analyticsIsLoadingProvider = Provider.family<bool, String>((ref, formId) {
  return ref.watch(analyticsControllerProvider(formId)).isLoading;
});

final analyticsErrorProvider = Provider.family<String?, String>((ref, formId) {
  return ref.watch(analyticsControllerProvider(formId)).error;
});

final analyticsHasErrorProvider = Provider.family<bool, String>((ref, formId) {
  return ref.watch(analyticsControllerProvider(formId)).hasError;
});
