import 'package:json_annotation/json_annotation.dart';

/// Represents distribution data for form analytics.
///
/// Contains field-level response distributions showing how respondents
/// answered different questions in the form.
class AnalyticsDistribution {
  final String formId;
  final List<FieldDistribution> fieldDistributions;

  const AnalyticsDistribution({
    required this.formId,
    required this.fieldDistributions,
  });

  AnalyticsDistribution copyWith({
    String? formId,
    List<FieldDistribution>? fieldDistributions,
  }) {
    return AnalyticsDistribution(
      formId: formId ?? this.formId,
      fieldDistributions: fieldDistributions ?? this.fieldDistributions,
    );
  }

  factory AnalyticsDistribution.fromJson(Map<String, dynamic> json) {
    return AnalyticsDistribution(
      formId: json['form_id'] as String,
      fieldDistributions: (json['field_distributions'] as List?)
          ?.map((e) => FieldDistribution.fromJson(Map<String, dynamic>.from(e)))
          .toList() ?? <FieldDistribution>[],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'form_id': formId,
      'field_distributions': fieldDistributions.map((e) => e.toJson()).toList(),
    };
  }
}

/// Represents the distribution of responses for a single field/question.
class FieldDistribution {
  final String fieldId;
  final String fieldLabel;
  final List<DistributionOption> options;
  final int? totalResponses;

  const FieldDistribution({
    required this.fieldId,
    required this.fieldLabel,
    required this.options,
    this.totalResponses,
  });

  FieldDistribution copyWith({
    String? fieldId,
    String? fieldLabel,
    List<DistributionOption>? options,
    int? totalResponses,
  }) {
    return FieldDistribution(
      fieldId: fieldId ?? this.fieldId,
      fieldLabel: fieldLabel ?? this.fieldLabel,
      options: options ?? this.options,
      totalResponses: totalResponses ?? this.totalResponses,
    );
  }

  factory FieldDistribution.fromJson(Map<String, dynamic> json) {
    return FieldDistribution(
      fieldId: json['field_id'] as String,
      fieldLabel: json['field_label'] as String,
      options: (json['options'] as List?)
          ?.map((e) => DistributionOption.fromJson(Map<String, dynamic>.from(e)))
          .toList() ?? <DistributionOption>[],
      totalResponses: json['total_responses'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'field_id': fieldId,
      'field_label': fieldLabel,
      'options': options.map((e) => e.toJson()).toList(),
      'total_responses': totalResponses,
    };
  }
}

/// Represents a single option's distribution data.
class DistributionOption {
  final String label;
  final int count;
  final double percentage;

  const DistributionOption({
    required this.label,
    required this.count,
    required this.percentage,
  });

  DistributionOption copyWith({
    String? label,
    int? count,
    double? percentage,
  }) {
    return DistributionOption(
      label: label ?? this.label,
      count: count ?? this.count,
      percentage: percentage ?? this.percentage,
    );
  }

  factory DistributionOption.fromJson(Map<String, dynamic> json) {
    return DistributionOption(
      label: json['label'] as String,
      count: json['count'] as int,
      percentage: (json['percentage'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'count': count,
      'percentage': percentage,
    };
  }
}