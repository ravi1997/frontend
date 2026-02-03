// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_distribution.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AnalyticsDistribution _$AnalyticsDistributionFromJson(
  Map<String, dynamic> json,
) => _AnalyticsDistribution(
  formId: json['formId'] as String,
  fieldDistributions: (json['fieldDistributions'] as List<dynamic>)
      .map((e) => FieldDistribution.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$AnalyticsDistributionToJson(
  _AnalyticsDistribution instance,
) => <String, dynamic>{
  'formId': instance.formId,
  'fieldDistributions': instance.fieldDistributions,
};

_FieldDistribution _$FieldDistributionFromJson(Map<String, dynamic> json) =>
    _FieldDistribution(
      fieldId: json['fieldId'] as String,
      fieldLabel: json['fieldLabel'] as String,
      options: (json['options'] as List<dynamic>)
          .map((e) => DistributionOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalResponses: (json['totalResponses'] as num?)?.toInt(),
    );

Map<String, dynamic> _$FieldDistributionToJson(_FieldDistribution instance) =>
    <String, dynamic>{
      'fieldId': instance.fieldId,
      'fieldLabel': instance.fieldLabel,
      'options': instance.options,
      'totalResponses': instance.totalResponses,
    };

_DistributionOption _$DistributionOptionFromJson(Map<String, dynamic> json) =>
    _DistributionOption(
      label: json['label'] as String,
      count: (json['count'] as num).toInt(),
      percentage: (json['percentage'] as num).toDouble(),
    );

Map<String, dynamic> _$DistributionOptionToJson(_DistributionOption instance) =>
    <String, dynamic>{
      'label': instance.label,
      'count': instance.count,
      'percentage': instance.percentage,
    };
