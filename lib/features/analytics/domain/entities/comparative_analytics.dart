import 'package:freezed_annotation/freezed_annotation.dart';
import 'analytics_summary.dart';

part 'comparative_analytics.freezed.dart';
part 'comparative_analytics.g.dart';

/// Represents the percentage change between two periods.
@freezed
abstract class PercentageChange with _$PercentageChange {
  const factory PercentageChange({
    required double value,
    required bool isPositive,
    String? label,
  }) = _PercentageChange;

  factory PercentageChange.fromJson(Map<String, dynamic> json) =>
      _$PercentageChangeFromJson(json);
}

/// Represents comparative analytics between two time periods.
///
/// Allows users to compare current period metrics against previous period.
@freezed
abstract class ComparativeAnalytics with _$ComparativeAnalytics {
  const factory ComparativeAnalytics({
    required String formId,
    required AnalyticsSummary currentPeriod,
    required AnalyticsSummary previousPeriod,
    required PercentageChange submissionsChange,
    required PercentageChange completionRateChange,
    required PercentageChange avgTimeChange,
    required PercentageChange uniqueRespondersChange,
  }) = _ComparativeAnalytics;

  factory ComparativeAnalytics.fromJson(Map<String, dynamic> json) =>
      _$ComparativeAnalyticsFromJson(json);
}
