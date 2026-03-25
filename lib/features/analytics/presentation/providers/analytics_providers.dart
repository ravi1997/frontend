import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/api_client.dart';
import '../../data/repositories/analysis_dashboard_repository.dart';
import '../controllers/analytics_controller.dart';
import '../../domain/entities/analytics_summary.dart';
import '../../domain/entities/analytics_timeline.dart';
import '../../domain/entities/analytics_distribution.dart';

part 'analytics_providers.g.dart';

@riverpod
AnalysisDashboardRepository analysisDashboardRepository(Ref ref) {
  final dioClient = ref.watch(dioProvider);
  return AnalysisDashboardRepository(dioClient);
}

@riverpod
AnalyticsState analyticsState(Ref ref, String formId) {
  return ref.watch(analyticsControllerProvider(formId));
}

@riverpod
AnalyticsSummary? analyticsSummary(Ref ref, String formId) {
  return ref.watch(analyticsControllerProvider(formId)).summary;
}

@riverpod
AnalyticsTimeline? analyticsTimeline(Ref ref, String formId) {
  return ref.watch(analyticsControllerProvider(formId)).timeline;
}

@riverpod
AnalyticsDistribution? analyticsDistribution(Ref ref, String formId) {
  return ref.watch(analyticsControllerProvider(formId)).distribution;
}

@riverpod
bool analyticsIsLoading(Ref ref, String formId) {
  return ref.watch(analyticsControllerProvider(formId)).isLoading;
}

@riverpod
String? analyticsError(Ref ref, String formId) {
  return ref.watch(analyticsControllerProvider(formId)).error;
}

@riverpod
bool analyticsHasError(Ref ref, String formId) {
  return ref.watch(analyticsControllerProvider(formId)).hasError;
}
