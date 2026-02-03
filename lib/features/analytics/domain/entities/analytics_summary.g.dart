// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AnalyticsSummary _$AnalyticsSummaryFromJson(Map<String, dynamic> json) =>
    _AnalyticsSummary(
      formId: json['formId'] as String,
      totalSubmissions: (json['totalSubmissions'] as num).toInt(),
      completionRate: (json['completionRate'] as num).toDouble(),
      uniqueResponders: (json['uniqueResponders'] as num?)?.toInt(),
      averageCompletionTime: (json['averageCompletionTime'] as num?)
          ?.toDouble(),
      statusBreakdown: (json['statusBreakdown'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
    );

Map<String, dynamic> _$AnalyticsSummaryToJson(_AnalyticsSummary instance) =>
    <String, dynamic>{
      'formId': instance.formId,
      'totalSubmissions': instance.totalSubmissions,
      'completionRate': instance.completionRate,
      'uniqueResponders': instance.uniqueResponders,
      'averageCompletionTime': instance.averageCompletionTime,
      'statusBreakdown': instance.statusBreakdown,
    };
