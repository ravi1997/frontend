// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DashboardStats _$DashboardStatsFromJson(Map<String, dynamic> json) =>
    _DashboardStats(
      totalForms: (json['totalForms'] as num?)?.toInt() ?? 0,
      totalResponses: (json['totalResponses'] as num?)?.toInt() ?? 0,
      activeForms: (json['activeForms'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$DashboardStatsToJson(_DashboardStats instance) =>
    <String, dynamic>{
      'totalForms': instance.totalForms,
      'totalResponses': instance.totalResponses,
      'activeForms': instance.activeForms,
    };
