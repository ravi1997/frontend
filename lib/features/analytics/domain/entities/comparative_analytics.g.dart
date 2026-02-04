// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comparative_analytics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PercentageChange _$PercentageChangeFromJson(Map<String, dynamic> json) =>
    _PercentageChange(
      value: (json['value'] as num).toDouble(),
      isPositive: json['isPositive'] as bool,
      label: json['label'] as String?,
    );

Map<String, dynamic> _$PercentageChangeToJson(_PercentageChange instance) =>
    <String, dynamic>{
      'value': instance.value,
      'isPositive': instance.isPositive,
      'label': instance.label,
    };

_ComparativeAnalytics _$ComparativeAnalyticsFromJson(
  Map<String, dynamic> json,
) => _ComparativeAnalytics(
  formId: json['formId'] as String,
  currentPeriod: AnalyticsSummary.fromJson(
    json['currentPeriod'] as Map<String, dynamic>,
  ),
  previousPeriod: AnalyticsSummary.fromJson(
    json['previousPeriod'] as Map<String, dynamic>,
  ),
  submissionsChange: PercentageChange.fromJson(
    json['submissionsChange'] as Map<String, dynamic>,
  ),
  completionRateChange: PercentageChange.fromJson(
    json['completionRateChange'] as Map<String, dynamic>,
  ),
  avgTimeChange: PercentageChange.fromJson(
    json['avgTimeChange'] as Map<String, dynamic>,
  ),
  uniqueRespondersChange: PercentageChange.fromJson(
    json['uniqueRespondersChange'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$ComparativeAnalyticsToJson(
  _ComparativeAnalytics instance,
) => <String, dynamic>{
  'formId': instance.formId,
  'currentPeriod': instance.currentPeriod,
  'previousPeriod': instance.previousPeriod,
  'submissionsChange': instance.submissionsChange,
  'completionRateChange': instance.completionRateChange,
  'avgTimeChange': instance.avgTimeChange,
  'uniqueRespondersChange': instance.uniqueRespondersChange,
};
