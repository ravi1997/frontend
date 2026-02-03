import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_timeline.freezed.dart';
part 'analytics_timeline.g.dart';

/// Represents timeline data for form analytics.
///
/// Contains a list of data points showing metrics over time.
@freezed
abstract class AnalyticsTimeline with _$AnalyticsTimeline {
  const factory AnalyticsTimeline({
    required String formId,
    required List<TimelineDataPoint> dataPoints,
    String? period,
    DateTime? startDate,
    DateTime? endDate,
  }) = _AnalyticsTimeline;

  factory AnalyticsTimeline.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsTimelineFromJson(json);
}

/// Represents a single data point in the timeline.
@freezed
abstract class TimelineDataPoint with _$TimelineDataPoint {
  const factory TimelineDataPoint({
    required DateTime date,
    required int count,
    int? submissions,
    int? completions,
    double? rate,
  }) = _TimelineDataPoint;

  factory TimelineDataPoint.fromJson(Map<String, dynamic> json) =>
      _$TimelineDataPointFromJson(json);
}
