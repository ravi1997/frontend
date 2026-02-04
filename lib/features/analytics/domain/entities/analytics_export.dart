import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_export.freezed.dart';
part 'analytics_export.g.dart';

/// Represents export format options for analytics data.
enum ExportFormat { pdf, png, csv }

/// Represents export configuration for analytics data.
///
/// Allows users to configure what and how to export analytics data.
@freezed
abstract class AnalyticsExport with _$AnalyticsExport {
  const factory AnalyticsExport({
    required String formId,
    required ExportFormat format,
    required DateTimeRange dateRange,
    @Default(false) bool includeCharts,
    @Default(false) bool includeRawData,
    @Default(false) bool includeSummary,
    List<String>? selectedFields,
  }) = _AnalyticsExport;

  factory AnalyticsExport.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsExportFromJson(json);
}

/// Represents a date range for filtering.
@freezed
abstract class DateTimeRange with _$DateTimeRange {
  const factory DateTimeRange({
    required DateTime start,
    required DateTime end,
  }) = _DateTimeRange;

  factory DateTimeRange.fromJson(Map<String, dynamic> json) =>
      _$DateTimeRangeFromJson(json);
}
