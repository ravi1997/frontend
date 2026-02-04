// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AnalyticsFilter _$AnalyticsFilterFromJson(Map<String, dynamic> json) =>
    _AnalyticsFilter(
      formId: json['formId'] as String,
      timeRange: $enumDecode(_$TimeRangeEnumMap, json['timeRange']),
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      status: json['status'] as String?,
      deviceType: json['deviceType'] as String?,
    );

Map<String, dynamic> _$AnalyticsFilterToJson(_AnalyticsFilter instance) =>
    <String, dynamic>{
      'formId': instance.formId,
      'timeRange': _$TimeRangeEnumMap[instance.timeRange]!,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'status': instance.status,
      'deviceType': instance.deviceType,
    };

const _$TimeRangeEnumMap = {
  TimeRange.last7Days: 'last7Days',
  TimeRange.last30Days: 'last30Days',
  TimeRange.last90Days: 'last90Days',
  TimeRange.custom: 'custom',
};
