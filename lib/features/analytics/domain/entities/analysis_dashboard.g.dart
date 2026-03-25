// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analysis_dashboard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AnalysisDashboard _$AnalysisDashboardFromJson(Map<String, dynamic> json) =>
    _AnalysisDashboard(
      id: json['id'] as String,
      title: json['title'] as String,
      slug: json['slug'] as String?,
      description: json['description'] as String?,
      roles:
          (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      layout: json['layout'] as String? ?? 'grid',
      widgets:
          (json['widgets'] as List<dynamic>?)
              ?.map((e) => AnalysisWidget.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      globalFilters:
          (json['globalFilters'] as List<dynamic>?)
              ?.map((e) => GlobalFilter.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdBy: json['createdBy'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$AnalysisDashboardToJson(_AnalysisDashboard instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'slug': instance.slug,
      'description': instance.description,
      'roles': instance.roles,
      'layout': instance.layout,
      'widgets': instance.widgets,
      'globalFilters': instance.globalFilters,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_AnalysisWidget _$AnalysisWidgetFromJson(Map<String, dynamic> json) =>
    _AnalysisWidget(
      id: json['id'] as String,
      title: json['title'] as String,
      type: json['type'] as String,
      formId: json['formId'] as String?,
      groupByField: json['groupByField'] as String?,
      aggregateField: json['aggregateField'] as String?,
      calculationType: json['calculationType'] as String? ?? 'count',
      filters: json['filters'] as Map<String, dynamic>? ?? const {},
      size: json['size'] as String? ?? 'medium',
      colorScheme: json['colorScheme'] as String? ?? 'ocean',
      positionX: (json['positionX'] as num?)?.toInt() ?? 0,
      positionY: (json['positionY'] as num?)?.toInt() ?? 0,
      width: (json['width'] as num?)?.toInt() ?? 2,
      height: (json['height'] as num?)?.toInt() ?? 2,
      displayColumns:
          (json['displayColumns'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      config: json['config'] as Map<String, dynamic>? ?? const {},
      interactivityEnabled: json['interactivityEnabled'] as bool? ?? true,
      linkedWidgetIds:
          (json['linkedWidgetIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      data: json['data'],
    );

Map<String, dynamic> _$AnalysisWidgetToJson(_AnalysisWidget instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'type': instance.type,
      'formId': instance.formId,
      'groupByField': instance.groupByField,
      'aggregateField': instance.aggregateField,
      'calculationType': instance.calculationType,
      'filters': instance.filters,
      'size': instance.size,
      'colorScheme': instance.colorScheme,
      'positionX': instance.positionX,
      'positionY': instance.positionY,
      'width': instance.width,
      'height': instance.height,
      'displayColumns': instance.displayColumns,
      'config': instance.config,
      'interactivityEnabled': instance.interactivityEnabled,
      'linkedWidgetIds': instance.linkedWidgetIds,
      'data': instance.data,
    };
