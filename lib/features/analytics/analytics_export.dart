import 'package:json_annotation/json_annotation.dart';

/// Represents export format options for analytics data.
enum ExportFormat { pdf, png, csv }

/// Represents export configuration for analytics data.
///
/// Allows users to configure what and how to export analytics data.
class AnalyticsExport {
  final String formId;
  final ExportFormat format;
  final DateTimeRange dateRange;
  final bool includeCharts;
  final bool includeRawData;
  final bool includeSummary;
  final List<String>? selectedFields;

  const AnalyticsExport({
    required this.formId,
    required this.format,
    required this.dateRange,
    this.includeCharts = false,
    this.includeRawData = false,
    this.includeSummary = false,
    this.selectedFields,
  });

  AnalyticsExport copyWith({
    String? formId,
    ExportFormat? format,
    DateTimeRange? dateRange,
    bool? includeCharts,
    bool? includeRawData,
    bool? includeSummary,
    List<String>? selectedFields,
  }) {
    return AnalyticsExport(
      formId: formId ?? this.formId,
      format: format ?? this.format,
      dateRange: dateRange ?? this.dateRange,
      includeCharts: includeCharts ?? this.includeCharts,
      includeRawData: includeRawData ?? this.includeRawData,
      includeSummary: includeSummary ?? this.includeSummary,
      selectedFields: selectedFields ?? this.selectedFields,
    );
  }

  factory AnalyticsExport.fromJson(Map<String, dynamic> json) {
    return AnalyticsExport(
      formId: json['form_id'] as String,
      format: ExportFormat.values.firstWhere(
        (e) => e.name == json['format'],
        orElse: () => ExportFormat.pdf,
      ),
      dateRange: DateTimeRange.fromJson(Map<String, dynamic>.from(json['date_range'])),
      includeCharts: json['include_charts'] ?? false,
      includeRawData: json['include_raw_data'] ?? false,
      includeSummary: json['include_summary'] ?? false,
      selectedFields: json['selected_fields'] != null
          ? List<String>.from(json['selected_fields'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'form_id': formId,
      'format': format.name,
      'date_range': dateRange.toJson(),
      'include_charts': includeCharts,
      'include_raw_data': includeRawData,
      'include_summary': includeSummary,
      'selected_fields': selectedFields,
    };
  }
}

/// Represents a date range for filtering.
class DateTimeRange {
  final DateTime start;
  final DateTime end;

  const DateTimeRange({
    required this.start,
    required this.end,
  });

  DateTimeRange copyWith({
    DateTime? start,
    DateTime? end,
  }) {
    return DateTimeRange(
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }

  factory DateTimeRange.fromJson(Map<String, dynamic> json) {
    return DateTimeRange(
      start: DateTime.parse(json['start']),
      end: DateTime.parse(json['end']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start': start.toIso8601String(),
      'end': end.toIso8601String(),
    };
  }
}