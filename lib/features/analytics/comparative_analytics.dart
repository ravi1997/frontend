import 'package:json_annotation/json_annotation.dart';
import 'analytics_summary.dart';

/// Represents the percentage change between two periods.
class PercentageChange {
  final double value;
  final bool isPositive;
  final String? label;

  const PercentageChange({
    required this.value,
    required this.isPositive,
    this.label,
  });

  PercentageChange copyWith({
    double? value,
    bool? isPositive,
    String? label,
  }) {
    return PercentageChange(
      value: value ?? this.value,
      isPositive: isPositive ?? this.isPositive,
      label: label ?? this.label,
    );
  }

  factory PercentageChange.fromJson(Map<String, dynamic> json) {
    return PercentageChange(
      value: (json['value'] as num).toDouble(),
      isPositive: json['is_positive'] as bool,
      label: json['label'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'is_positive': isPositive,
      'label': label,
    };
  }
}

/// Represents comparative analytics between two time periods.
///
/// Allows users to compare current period metrics against previous period.
class ComparativeAnalytics {
  final String formId;
  final AnalyticsSummary currentPeriod;
  final AnalyticsSummary previousPeriod;
  final PercentageChange submissionsChange;
  final PercentageChange completionRateChange;
  final PercentageChange avgTimeChange;
  final PercentageChange uniqueRespondersChange;

  const ComparativeAnalytics({
    required this.formId,
    required this.currentPeriod,
    required this.previousPeriod,
    required this.submissionsChange,
    required this.completionRateChange,
    required this.avgTimeChange,
    required this.uniqueRespondersChange,
  });

  ComparativeAnalytics copyWith({
    String? formId,
    AnalyticsSummary? currentPeriod,
    AnalyticsSummary? previousPeriod,
    PercentageChange? submissionsChange,
    PercentageChange? completionRateChange,
    PercentageChange? avgTimeChange,
    PercentageChange? uniqueRespondersChange,
  }) {
    return ComparativeAnalytics(
      formId: formId ?? this.formId,
      currentPeriod: currentPeriod ?? this.currentPeriod,
      previousPeriod: previousPeriod ?? this.previousPeriod,
      submissionsChange: submissionsChange ?? this.submissionsChange,
      completionRateChange: completionRateChange ?? this.completionRateChange,
      avgTimeChange: avgTimeChange ?? this.avgTimeChange,
      uniqueRespondersChange: uniqueRespondersChange ?? this.uniqueRespondersChange,
    );
  }

  factory ComparativeAnalytics.fromJson(Map<String, dynamic> json) {
    return ComparativeAnalytics(
      formId: json['form_id'] as String,
      currentPeriod: AnalyticsSummary.fromJson(Map<String, dynamic>.from(json['current_period'])),
      previousPeriod: AnalyticsSummary.fromJson(Map<String, dynamic>.from(json['previous_period'])),
      submissionsChange: PercentageChange.fromJson(Map<String, dynamic>.from(json['submissions_change'])),
      completionRateChange: PercentageChange.fromJson(Map<String, dynamic>.from(json['completion_rate_change'])),
      avgTimeChange: PercentageChange.fromJson(Map<String, dynamic>.from(json['avg_time_change'])),
      uniqueRespondersChange: PercentageChange.fromJson(Map<String, dynamic>.from(json['unique_responders_change'])),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'form_id': formId,
      'current_period': currentPeriod.toJson(),
      'previous_period': previousPeriod.toJson(),
      'submissions_change': submissionsChange.toJson(),
      'completion_rate_change': completionRateChange.toJson(),
      'avg_time_change': avgTimeChange.toJson(),
      'unique_responders_change': uniqueRespondersChange.toJson(),
    };
  }
}