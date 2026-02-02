import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../entities/form_analytics.dart';
import '../../../../core/network/api_client_wrapper.dart';
import '../../data/repositories/analytics_repository_impl.dart';

part 'analytics_repository.g.dart';

abstract class AnalyticsRepository {
  Future<FormAnalytics> getFormAnalytics(String formId);
}

@riverpod
AnalyticsRepository analyticsRepository(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AnalyticsRepositoryImpl(apiClient);
}
