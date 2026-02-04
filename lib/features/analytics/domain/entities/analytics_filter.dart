import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_filter.freezed.dart';
part 'analytics_filter.g.dart';

/// Represents time range options for analytics filtering.
enum TimeRange { last7Days, last30Days, last90Days, custom }

/// Represents filter options for analytics queries.
///
/// Allows users to filter analytics data by time range and other criteria.
@freezed
abstract class AnalyticsFilter with _$AnalyticsFilter {
  const factory AnalyticsFilter({
    required String formId,
    required TimeRange timeRange,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    String? deviceType,
  }) = _AnalyticsFilter;

  factory AnalyticsFilter.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsFilterFromJson(json);

  /// Creates a filter for the last 7 days.
  factory AnalyticsFilter.last7Days(String formId) {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    return AnalyticsFilter(
      formId: formId,
      timeRange: TimeRange.last7Days,
      startDate: sevenDaysAgo,
      endDate: now,
    );
  }

  /// Creates a filter for the last 30 days.
  factory AnalyticsFilter.last30Days(String formId) {
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));
    return AnalyticsFilter(
      formId: formId,
      timeRange: TimeRange.last30Days,
      startDate: thirtyDaysAgo,
      endDate: now,
    );
  }

  /// Creates a filter for the last 90 days.
  factory AnalyticsFilter.last90Days(String formId) {
    final now = DateTime.now();
    final ninetyDaysAgo = now.subtract(const Duration(days: 90));
    return AnalyticsFilter(
      formId: formId,
      timeRange: TimeRange.last90Days,
      startDate: ninetyDaysAgo,
      endDate: now,
    );
  }

  /// Creates a custom date range filter.
  factory AnalyticsFilter.customRange(
    String formId,
    DateTime startDate,
    DateTime endDate,
  ) {
    return AnalyticsFilter(
      formId: formId,
      timeRange: TimeRange.custom,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
