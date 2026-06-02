import 'package:json_annotation/json_annotation.dart';
import 'global_filter.dart';

class AnalysisDashboard {
  final String id;
  final String title;
  final String? slug;
  final String? description;
  final List<String> roles;
  final String layout;
  final List<AnalysisWidget> widgets;
  final List<GlobalFilter> globalFilters;
  final String? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AnalysisDashboard({
    required this.id,
    required this.title,
    this.slug,
    this.description,
    this.roles = const [],
    this.layout = 'grid',
    this.widgets = const [],
    this.globalFilters = const [],
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  AnalysisDashboard copyWith({
    String? id,
    String? title,
    String? slug,
    String? description,
    List<String>? roles,
    String? layout,
    List<AnalysisWidget>? widgets,
    List<GlobalFilter>? globalFilters,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AnalysisDashboard(
      id: id ?? this.id,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      roles: roles ?? this.roles,
      layout: layout ?? this.layout,
      widgets: widgets ?? this.widgets,
      globalFilters: globalFilters ?? this.globalFilters,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory AnalysisDashboard.fromJson(Map<String, dynamic> json) {
    return AnalysisDashboard(
      id: json['id'] as String,
      title: json['title'] as String,
      slug: json['slug'] as String?,
      description: json['description'] as String?,
      roles: List<String>.from(json['roles'] ?? []),
      layout: json['layout'] as String? ?? 'grid',
      widgets: (json['widgets'] as List?)
          ?.map((e) => AnalysisWidget.fromJson(Map<String, dynamic>.from(e)))
          .toList() ?? <AnalysisWidget>[],
      globalFilters: (json['global_filters'] as List?)
          ?.map((e) => GlobalFilter.fromJson(Map<String, dynamic>.from(e)))
          .toList() ?? <GlobalFilter>[],
      createdBy: json['created_by'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'description': description,
      'roles': roles,
      'layout': layout,
      'widgets': widgets.map((e) => e.toJson()).toList(),
      'global_filters': globalFilters.map((e) => e.toJson()).toList(),
      'created_by': createdBy,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class AnalysisWidget {
  final String id;
  final String title;
  final String type; // chart_bar, chart_line, chart_pie, kpi, table, text, ai_insight
  final String? formId;
  final String? groupByField;
  final String? aggregateField;
  final String calculationType;
  final Map<String, dynamic> filters;
  final String size;
  final String colorScheme;
  final int positionX;
  final int positionY;
  final int width;
  final int height;
  final List<String> displayColumns;
  final Map<String, dynamic> config;
  final bool interactivityEnabled;
  final List<String> linkedWidgetIds;
  final dynamic data; // Calculated result from backend

  const AnalysisWidget({
    required this.id,
    required this.title,
    required this.type,
    this.formId,
    this.groupByField,
    this.aggregateField,
    this.calculationType = 'count',
    this.filters = const {},
    this.size = 'medium',
    this.colorScheme = 'ocean',
    this.positionX = 0,
    this.positionY = 0,
    this.width = 2,
    this.height = 2,
    this.displayColumns = const [],
    this.config = const {},
    this.interactivityEnabled = true,
    this.linkedWidgetIds = const [],
    this.data,
  });

  AnalysisWidget copyWith({
    String? id,
    String? title,
    String? type,
    String? formId,
    String? groupByField,
    String? aggregateField,
    String? calculationType,
    Map<String, dynamic>? filters,
    String? size,
    String? colorScheme,
    int? positionX,
    int? positionY,
    int? width,
    int? height,
    List<String>? displayColumns,
    Map<String, dynamic>? config,
    bool? interactivityEnabled,
    List<String>? linkedWidgetIds,
    dynamic data,
  }) {
    return AnalysisWidget(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      formId: formId ?? this.formId,
      groupByField: groupByField ?? this.groupByField,
      aggregateField: aggregateField ?? this.aggregateField,
      calculationType: calculationType ?? this.calculationType,
      filters: filters ?? this.filters,
      size: size ?? this.size,
      colorScheme: colorScheme ?? this.colorScheme,
      positionX: positionX ?? this.positionX,
      positionY: positionY ?? this.positionY,
      width: width ?? this.width,
      height: height ?? this.height,
      displayColumns: displayColumns ?? this.displayColumns,
      config: config ?? this.config,
      interactivityEnabled: interactivityEnabled ?? this.interactivityEnabled,
      linkedWidgetIds: linkedWidgetIds ?? this.linkedWidgetIds,
      data: data ?? this.data,
    );
  }

  factory AnalysisWidget.fromJson(Map<String, dynamic> json) {
    return AnalysisWidget(
      id: json['id'] as String,
      title: json['title'] as String,
      type: json['type'] as String,
      formId: json['form_id'] as String?,
      groupByField: json['group_by_field'] as String?,
      aggregateField: json['aggregate_field'] as String?,
      calculationType: json['calculation_type'] as String? ?? 'count',
      filters: Map<String, dynamic>.from(json['filters'] ?? {}),
      size: json['size'] as String? ?? 'medium',
      colorScheme: json['color_scheme'] as String? ?? 'ocean',
      positionX: json['position_x'] as int? ?? 0,
      positionY: json['position_y'] as int? ?? 0,
      width: json['width'] as int? ?? 2,
      height: json['height'] as int? ?? 2,
      displayColumns: List<String>.from(json['display_columns'] ?? []),
      config: Map<String, dynamic>.from(json['config'] ?? {}),
      interactivityEnabled: json['interactivity_enabled'] ?? true,
      linkedWidgetIds: List<String>.from(json['linked_widget_ids'] ?? []),
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'form_id': formId,
      'group_by_field': groupByField,
      'aggregate_field': aggregateField,
      'calculation_type': calculationType,
      'filters': filters,
      'size': size,
      'color_scheme': colorScheme,
      'position_x': positionX,
      'position_y': positionY,
      'width': width,
      'height': height,
      'display_columns': displayColumns,
      'config': config,
      'interactivity_enabled': interactivityEnabled,
      'linked_widget_ids': linkedWidgetIds,
      'data': data,
    };
  }
}