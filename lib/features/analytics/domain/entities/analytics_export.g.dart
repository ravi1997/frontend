// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_export.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AnalyticsExport _$AnalyticsExportFromJson(Map<String, dynamic> json) =>
    _AnalyticsExport(
      formId: json['formId'] as String,
      format: $enumDecode(_$ExportFormatEnumMap, json['format']),
      dateRange: DateTimeRange.fromJson(
        json['dateRange'] as Map<String, dynamic>,
      ),
      includeCharts: json['includeCharts'] as bool? ?? false,
      includeRawData: json['includeRawData'] as bool? ?? false,
      includeSummary: json['includeSummary'] as bool? ?? false,
      selectedFields: (json['selectedFields'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$AnalyticsExportToJson(_AnalyticsExport instance) =>
    <String, dynamic>{
      'formId': instance.formId,
      'format': _$ExportFormatEnumMap[instance.format]!,
      'dateRange': instance.dateRange,
      'includeCharts': instance.includeCharts,
      'includeRawData': instance.includeRawData,
      'includeSummary': instance.includeSummary,
      'selectedFields': instance.selectedFields,
    };

const _$ExportFormatEnumMap = {
  ExportFormat.pdf: 'pdf',
  ExportFormat.png: 'png',
  ExportFormat.csv: 'csv',
};

_DateTimeRange _$DateTimeRangeFromJson(Map<String, dynamic> json) =>
    _DateTimeRange(
      start: DateTime.parse(json['start'] as String),
      end: DateTime.parse(json['end'] as String),
    );

Map<String, dynamic> _$DateTimeRangeToJson(_DateTimeRange instance) =>
    <String, dynamic>{
      'start': instance.start.toIso8601String(),
      'end': instance.end.toIso8601String(),
    };
