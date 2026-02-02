import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_distribution.freezed.dart';
part 'analytics_distribution.g.dart';

/// Represents distribution data for form analytics.
///
/// Contains field-level response distributions showing how respondents
/// answered different questions in the form.
@freezed
class AnalyticsDistribution with _$AnalyticsDistribution {
  const factory AnalyticsDistribution({
    required String formId,
    required List<FieldDistribution> fieldDistributions,
  }) = _AnalyticsDistribution;

  factory AnalyticsDistribution.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsDistributionFromJson(json);
}

/// Represents the distribution of responses for a single field/question.
@freezed
class FieldDistribution with _$FieldDistribution {
  const factory FieldDistribution({
    required String fieldId,
    required String fieldLabel,
    required List<DistributionOption> options,
    int? totalResponses,
  }) = _FieldDistribution;

  factory FieldDistribution.fromJson(Map<String, dynamic> json) =>
      _$FieldDistributionFromJson(json);
}

/// Represents a single option's distribution data.
@freezed
class DistributionOption with _$DistributionOption {
  const factory DistributionOption({
    required String label,
    required int count,
    required double percentage,
  }) = _DistributionOption;

  factory DistributionOption.fromJson(Map<String, dynamic> json) =>
      _$DistributionOptionFromJson(json);
}
