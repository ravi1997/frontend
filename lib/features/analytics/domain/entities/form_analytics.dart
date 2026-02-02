import 'package:freezed_annotation/freezed_annotation.dart';

part 'form_analytics.freezed.dart';
part 'form_analytics.g.dart';

/// Represents analytics data for a form including submission metrics and trends.
///
/// Contains total submissions, completion rate, time series trends for
/// submissions, and field-level distribution data.
@freezed
abstract class FormAnalytics with _$FormAnalytics {
  const factory FormAnalytics({
    required String formId,
    required int totalSubmissions,
    required double completionRate,
    @Default([]) List<TimeSeriesData> trends,
    @Default({}) Map<String, List<DistributionData>> fieldDistributions,
  }) = _FormAnalytics;

  factory FormAnalytics.fromJson(Map<String, dynamic> json) =>
      _$FormAnalyticsFromJson(json);
}

@freezed
abstract class TimeSeriesData with _$TimeSeriesData {
  const factory TimeSeriesData({required DateTime date, required int value}) =
      _TimeSeriesData;

  factory TimeSeriesData.fromJson(Map<String, dynamic> json) =>
      _$TimeSeriesDataFromJson(json);
}

@freezed
abstract class DistributionData with _$DistributionData {
  const factory DistributionData({
    required String label,
    required int count,
    required double percentage,
  }) = _DistributionData;

  factory DistributionData.fromJson(Map<String, dynamic> json) =>
      _$DistributionDataFromJson(json);
}
