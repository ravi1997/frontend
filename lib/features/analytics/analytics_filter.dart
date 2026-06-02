import 'package:json_annotation/json_annotation.dart';

/// Represents time range options for analytics filtering.
enum TimeRange { last7Days, last30Days, last90Days, custom }

/// Represents filter options for analytics queries.
///
/// Allows users to filter analytics data by time range and other criteria.
class AnalyticsFilter {
  final String formId;
  final TimeRange timeRange;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? status;
  final String? deviceType;

  const AnalyticsFilter({
    required this.formId,
    required this.timeRange,
    this.startDate,
    this.endDate,
    this.status,
    this.deviceType,
  });

  AnalyticsFilter copyWith({
    String? formId,
    TimeRange? timeRange,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    String? deviceType,
  }) {
    return AnalyticsFilter(
      formId: formId ?? this.formId,
      timeRange: timeRange ?? this.timeRange,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      deviceType: deviceType ?? this.deviceType,
    );
  }

  factory AnalyticsFilter.fromJson(Map<String, dynamic> json) {
    return AnalyticsFilter(
      formId: json['form_id'] as String,
      timeRange: TimeRange.values.firstWhere(
        (e) => e.name == json['time_range'],
        orElse: () => TimeRange.last7Days,
      ),
      startDate: json['start_date'] != null ? DateTime.parse(json['start_date']) : null,
      endDate: json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      status: json['status'] as String?,
      deviceType: json['device_type'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'form_id': formId,
      'time_range': timeRange.name,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'status': status,
      'device_type': deviceType,
    };
  }

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