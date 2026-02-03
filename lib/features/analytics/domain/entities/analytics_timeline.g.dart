// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_timeline.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AnalyticsTimeline _$AnalyticsTimelineFromJson(Map<String, dynamic> json) =>
    _AnalyticsTimeline(
      formId: json['formId'] as String,
      dataPoints: (json['dataPoints'] as List<dynamic>)
          .map((e) => TimelineDataPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      period: json['period'] as String?,
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
    );

Map<String, dynamic> _$AnalyticsTimelineToJson(_AnalyticsTimeline instance) =>
    <String, dynamic>{
      'formId': instance.formId,
      'dataPoints': instance.dataPoints,
      'period': instance.period,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
    };

_TimelineDataPoint _$TimelineDataPointFromJson(Map<String, dynamic> json) =>
    _TimelineDataPoint(
      date: DateTime.parse(json['date'] as String),
      count: (json['count'] as num).toInt(),
      submissions: (json['submissions'] as num?)?.toInt(),
      completions: (json['completions'] as num?)?.toInt(),
      rate: (json['rate'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$TimelineDataPointToJson(_TimelineDataPoint instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'count': instance.count,
      'submissions': instance.submissions,
      'completions': instance.completions,
      'rate': instance.rate,
    };
