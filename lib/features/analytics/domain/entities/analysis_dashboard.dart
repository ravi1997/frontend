import 'package:freezed_annotation/freezed_annotation.dart';
import 'global_filter.dart';

part 'analysis_dashboard.freezed.dart';
part 'analysis_dashboard.g.dart';

@freezed
abstract class AnalysisDashboard with _$AnalysisDashboard {
  const factory AnalysisDashboard({
    required String id,
    required String title,
    String? slug,
    String? description,
    @Default([]) List<String> roles,
    @Default('grid') String layout,
    @Default([]) List<AnalysisWidget> widgets,
    @Default([]) List<GlobalFilter> globalFilters,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _AnalysisDashboard;

  factory AnalysisDashboard.fromJson(Map<String, dynamic> json) =>
      _$AnalysisDashboardFromJson(json);
}

@freezed
abstract class AnalysisWidget with _$AnalysisWidget {
  const factory AnalysisWidget({
    required String id,
    required String title,
    required String
    type, // chart_bar, chart_line, chart_pie, kpi, table, text, ai_insight
    String? formId,
    String? groupByField,
    String? aggregateField,
    @Default('count') String calculationType,
    @Default({}) Map<String, dynamic> filters,
    @Default('medium') String size,
    @Default('ocean') String colorScheme,
    @Default(0) int positionX,
    @Default(0) int positionY,
    @Default(2) int width,
    @Default(2) int height,
    @Default([]) List<String> displayColumns,
    @Default({}) Map<String, dynamic> config,
    @Default(true) bool interactivityEnabled,
    @Default([]) List<String> linkedWidgetIds,
    dynamic data, // Calculated result from backend
  }) = _AnalysisWidget;

  factory AnalysisWidget.fromJson(Map<String, dynamic> json) =>
      _$AnalysisWidgetFromJson(json);
}
