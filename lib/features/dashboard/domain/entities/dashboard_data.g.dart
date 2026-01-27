// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DashboardData _$DashboardDataFromJson(Map<String, dynamic> json) =>
    _DashboardData(
      stats: DashboardStats.fromJson(json['stats'] as Map<String, dynamic>),
      recentForms: (json['recentForms'] as List<dynamic>)
          .map((e) => RecentForm.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DashboardDataToJson(_DashboardData instance) =>
    <String, dynamic>{
      'stats': instance.stats,
      'recentForms': instance.recentForms,
    };
