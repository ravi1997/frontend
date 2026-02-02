import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/form_analytics.dart';
import '../../domain/repositories/analytics_repository.dart';

part 'analytics_controller.g.dart';

/// Controller for managing form analytics data using Riverpod state management.
///
/// Provides async access to [FormAnalytics] for a given form and supports
/// manual refresh of analytics data.
@riverpod
class AnalyticsController extends _$AnalyticsController {
  @override
  FutureOr<FormAnalytics> build(String formId) async {
    final repository = ref.watch(analyticsRepositoryProvider);
    return repository.getFormAnalytics(formId);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.watch(analyticsRepositoryProvider);
      return repository.getFormAnalytics(formId);
    });
  }
}
