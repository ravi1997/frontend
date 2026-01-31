// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_analytics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FormAnalytics _$FormAnalyticsFromJson(Map<String, dynamic> json) =>
    _FormAnalytics(
      formId: json['formId'] as String,
      totalSubmissions: (json['totalSubmissions'] as num).toInt(),
      completionRate: (json['completionRate'] as num).toDouble(),
      trends:
          (json['trends'] as List<dynamic>?)
              ?.map((e) => TimeSeriesData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      fieldDistributions:
          (json['fieldDistributions'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
              k,
              (e as List<dynamic>)
                  .map(
                    (e) => DistributionData.fromJson(e as Map<String, dynamic>),
                  )
                  .toList(),
            ),
          ) ??
          const {},
    );

Map<String, dynamic> _$FormAnalyticsToJson(_FormAnalytics instance) =>
    <String, dynamic>{
      'formId': instance.formId,
      'totalSubmissions': instance.totalSubmissions,
      'completionRate': instance.completionRate,
      'trends': instance.trends,
      'fieldDistributions': instance.fieldDistributions,
    };

_TimeSeriesData _$TimeSeriesDataFromJson(Map<String, dynamic> json) =>
    _TimeSeriesData(
      date: DateTime.parse(json['date'] as String),
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$TimeSeriesDataToJson(_TimeSeriesData instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'count': instance.count,
    };

_DistributionData _$DistributionDataFromJson(Map<String, dynamic> json) =>
    _DistributionData(
      label: json['label'] as String,
      count: (json['count'] as num).toInt(),
      percentage: (json['percentage'] as num).toDouble(),
    );

Map<String, dynamic> _$DistributionDataToJson(_DistributionData instance) =>
    <String, dynamic>{
      'label': instance.label,
      'count': instance.count,
      'percentage': instance.percentage,
    };
