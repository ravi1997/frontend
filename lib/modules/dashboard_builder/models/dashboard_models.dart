class DashboardWidgetModel {
  final String id;
  final String widgetType;
  final String? title;
  final String? description;
  final WidgetPosition position;
  final WidgetDataSource? dataSource;
  final WidgetConfig? config;
  final bool isVisible;
  final bool isLocked;
  final Map<String, dynamic> metaData;

  DashboardWidgetModel({
    required this.id,
    required this.widgetType,
    this.title,
    this.description,
    required this.position,
    this.dataSource,
    this.config,
    this.isVisible = true,
    this.isLocked = false,
    this.metaData = const {},
  });

  factory DashboardWidgetModel.fromJson(Map<String, dynamic> json) {
    return DashboardWidgetModel(
      id: json['id'],
      widgetType: json['widget_type'],
      title: json['title'],
      description: json['description'],
      position: WidgetPosition.fromJson(json['position']),
      dataSource: json['data_source'] != null 
          ? WidgetDataSource.fromJson(json['data_source']) 
          : null,
      config: json['config'] != null 
          ? WidgetConfig.fromJson(json['config']) 
          : null,
      isVisible: json['is_visible'] ?? true,
      isLocked: json['is_locked'] ?? false,
      metaData: json['meta_data'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'widget_type': widgetType,
      'title': title,
      'description': description,
      'position': position.toJson(),
      'data_source': dataSource?.toJson(),
      'config': config?.toJson(),
      'is_visible': isVisible,
      'is_locked': isLocked,
      'meta_data': metaData,
    };
  }

  DashboardWidgetModel copyWith({
    String? id,
    String? widgetType,
    String? title,
    String? description,
    WidgetPosition? position,
    WidgetDataSource? dataSource,
    WidgetConfig? config,
    bool? isVisible,
    bool? isLocked,
    Map<String, dynamic>? metaData,
  }) {
    return DashboardWidgetModel(
      id: id ?? this.id,
      widgetType: widgetType ?? this.widgetType,
      title: title ?? this.title,
      description: description ?? this.description,
      position: position ?? this.position,
      dataSource: dataSource ?? this.dataSource,
      config: config ?? this.config,
      isVisible: isVisible ?? this.isVisible,
      isLocked: isLocked ?? this.isLocked,
      metaData: metaData ?? this.metaData,
    );
  }
}

class WidgetPosition {
  final double x;
  final double y;
  final double width;
  final double height;
  final int zIndex;

  WidgetPosition({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.zIndex = 0,
  });

  factory WidgetPosition.fromJson(Map<String, dynamic> json) {
    return WidgetPosition(
      x: (json['x'] ?? 0.0).toDouble(),
      y: (json['y'] ?? 0.0).toDouble(),
      width: (json['width'] ?? 200.0).toDouble(),
      height: (json['height'] ?? 150.0).toDouble(),
      zIndex: json['z_index'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
      'width': width,
      'height': height,
      'z_index': zIndex,
    };
  }

  WidgetPosition copyWith({
    double? x,
    double? y,
    double? width,
    double? height,
    int? zIndex,
  }) {
    return WidgetPosition(
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      zIndex: zIndex ?? this.zIndex,
    );
  }

  Offset toOffset() {
    return Offset(x, y);
  }

  Size toSize() {
    return Size(width, height);
  }
}

class WidgetDataSource {
  final String? analysisId;
  final String? nodeId;
  final String? formId;
  final String refreshMode;
  final int? refreshInterval;
  final Map<String, dynamic> filters;
  final List<Map<String, dynamic>> transformations;

  WidgetDataSource({
    this.analysisId,
    this.nodeId,
    this.formId,
    this.refreshMode = 'with_dashboard',
    this.refreshInterval,
    this.filters = const {},
    this.transformations = const [],
  });

  factory WidgetDataSource.fromJson(Map<String, dynamic> json) {
    return WidgetDataSource(
      analysisId: json['analysis_id'],
      nodeId: json['node_id'],
      formId: json['form_id'],
      refreshMode: json['refresh_mode'] ?? 'with_dashboard',
      refreshInterval: json['refresh_interval'],
      filters: Map<String, dynamic>.from(json['filters'] ?? {}),
      transformations: List<Map<String, dynamic>>.from(json['transformations'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'analysis_id': analysisId,
      'node_id': nodeId,
      'form_id': formId,
      'refresh_mode': refreshMode,
      'refresh_interval': refreshInterval,
      'filters': filters,
      'transformations': transformations,
    };
  }
}

class WidgetConfig {
  final String? chartType;
  final String? aggregationType;
  final String? groupByField;
  final String? valueField;
  final String? colorScheme;
  final bool showLegend;
  final bool showLabels;
  final int maxItems;
  final String? sortBy;
  final String sortOrder;
  final List<String> displayColumns;
  final Map<String, dynamic> themeOverrides;
  final Map<String, dynamic> customStyling;

  WidgetConfig({
    this.chartType,
    this.aggregationType,
    this.groupByField,
    this.valueField,
    this.colorScheme,
    this.showLegend = true,
    this.showLabels = true,
    this.maxItems = 10,
    this.sortBy,
    this.sortOrder = 'desc',
    this.displayColumns = const [],
    this.themeOverrides = const {},
    this.customStyling = const {},
  });

  WidgetConfig copyWith({
    String? chartType,
    String? aggregationType,
    String? groupByField,
    String? valueField,
    String? colorScheme,
    bool? showLegend,
    bool? showLabels,
    int? maxItems,
    String? sortBy,
    String? sortOrder,
    List<String>? displayColumns,
    Map<String, dynamic>? themeOverrides,
    Map<String, dynamic>? customStyling,
  }) {
    return WidgetConfig(
      chartType: chartType ?? this.chartType,
      aggregationType: aggregationType ?? this.aggregationType,
      groupByField: groupByField ?? this.groupByField,
      valueField: valueField ?? this.valueField,
      colorScheme: colorScheme ?? this.colorScheme,
      showLegend: showLegend ?? this.showLegend,
      showLabels: showLabels ?? this.showLabels,
      maxItems: maxItems ?? this.maxItems,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
      displayColumns: displayColumns ?? this.displayColumns,
      themeOverrides: themeOverrides ?? this.themeOverrides,
      customStyling: customStyling ?? this.customStyling,
    );
  }

  factory WidgetConfig.fromJson(Map<String, dynamic> json) {
    return WidgetConfig(
      chartType: json['chart_type'],
      aggregationType: json['aggregation_type'],
      groupByField: json['group_by_field'],
      valueField: json['value_field'],
      colorScheme: json['color_scheme'],
      showLegend: json['show_legend'] ?? true,
      showLabels: json['show_labels'] ?? true,
      maxItems: json['max_items'] ?? 10,
      sortBy: json['sort_by'],
      sortOrder: json['sort_order'] ?? 'desc',
      displayColumns: List<String>.from(json['display_columns'] ?? []),
      themeOverrides: Map<String, dynamic>.from(json['theme_overrides'] ?? {}),
      customStyling: Map<String, dynamic>.from(json['custom_styling'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chart_type': chartType,
      'aggregation_type': aggregationType,
      'group_by_field': groupByField,
      'value_field': valueField,
      'color_scheme': colorScheme,
      'show_legend': showLegend,
      'show_labels': showLabels,
      'max_items': maxItems,
      'sort_by': sortBy,
      'sort_order': sortOrder,
      'display_columns': displayColumns,
      'theme_overrides': themeOverrides,
      'custom_styling': customStyling,
    };
  }
}

class DashboardCanvasModel {
  final double width;
  final double height;
  final String backgroundColor;
  final bool gridEnabled;
  final double gridSize;
  final bool snapToGrid;
  final Map<String, dynamic> theme;

  DashboardCanvasModel({
    required this.width,
    required this.height,
    this.backgroundColor = '#ffffff',
    this.gridEnabled = true,
    this.gridSize = 20.0,
    this.snapToGrid = true,
    this.theme = const {},
  });

  factory DashboardCanvasModel.fromJson(Map<String, dynamic> json) {
    return DashboardCanvasModel(
      width: (json['width'] ?? 1200.0).toDouble(),
      height: (json['height'] ?? 800.0).toDouble(),
      backgroundColor: json['background_color'] ?? '#ffffff',
      gridEnabled: json['grid_enabled'] ?? true,
      gridSize: (json['grid_size'] ?? 20.0).toDouble(),
      snapToGrid: json['snap_to_grid'] ?? true,
      theme: Map<String, dynamic>.from(json['theme'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'width': width,
      'height': height,
      'background_color': backgroundColor,
      'grid_enabled': gridEnabled,
      'grid_size': gridSize,
      'snap_to_grid': snapTo_grid,
      'theme': theme,
    };
  }
}

class DashboardModel {
  final String id;
  final String title;
  final String slug;
  final String organizationId;
  final String? projectId;
  final String? description;
  final DashboardCanvasModel canvas;
  final List<DashboardWidgetModel> widgets;
  final List<DashboardFilterModel> filters;
  final List<String> linkedAnalysisIds;
  final bool isPublic;
  final String? publicToken;
  final DashboardSettings settings;
  final String status;
  final Map<String, dynamic> metaData;
  final DateTime createdAt;
  final DateTime updatedAt;

  DashboardModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.organizationId,
    this.projectId,
    this.description,
    required this.canvas,
    this.widgets = const [],
    this.filters = const [],
    this.linkedAnalysisIds = const [],
    this.isPublic = false,
    this.publicToken,
    required this.settings,
    this.status = 'draft',
    this.metaData = const {},
    required this.createdAt,
    required this.updatedAt,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      id: json['id'],
      title: json['title'],
      slug: json['slug'],
      organizationId: json['organization_id'],
      projectId: json['project_id'],
      description: json['description'],
      canvas: DashboardCanvasModel.fromJson(json['canvas']),
      widgets: (json['widgets'] as List?)
          ?.map((w) => DashboardWidgetModel.fromJson(w))
          .toList() ?? [],
      filters: (json['filters'] as List?)
          ?.map((f) => DashboardFilterModel.fromJson(f))
          .toList() ?? [],
      linkedAnalysisIds: List<String>.from(json['linked_analysis_ids'] ?? []),
      isPublic: json['is_public'] ?? false,
      publicToken: json['public_token'],
      settings: DashboardSettings.fromJson(json['settings'] ?? {}),
      status: json['status'] ?? 'draft',
      metaData: Map<String, dynamic>.from(json['meta_data'] ?? {}),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'organization_id': organizationId,
      'project_id': projectId,
      'description': description,
      'canvas': canvas.toJson(),
      'widgets': widgets.map((w) => w.toJson()).toList(),
      'filters': filters.map((f) => f.toJson()).toList(),
      'linked_analysis_ids': linkedAnalysisIds,
      'is_public': isPublic,
      'public_token': publicToken,
      'settings': settings.toJson(),
      'status': status,
      'meta_data': metaData,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  DashboardModel copyWith({
    String? id,
    String? title,
    String? slug,
    String? organizationId,
    String? projectId,
    String? description,
    DashboardCanvasModel? canvas,
    List<DashboardWidgetModel>? widgets,
    List<DashboardFilterModel>? filters,
    List<String>? linkedAnalysisIds,
    bool? isPublic,
    String? publicToken,
    DashboardSettings? settings,
    String? status,
    Map<String, dynamic>? metaData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DashboardModel(
      id: id ?? this.id,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      organizationId: organizationId ?? this.organizationId,
      projectId: projectId ?? this.projectId,
      description: description ?? this.description,
      canvas: canvas ?? this.canvas,
      widgets: widgets ?? this.widgets,
      filters: filters ?? this.filters,
      linkedAnalysisIds: linkedAnalysisIds ?? this.linkedAnalysisIds,
      isPublic: isPublic ?? this.isPublic,
      publicToken: publicToken ?? this.publicToken,
      settings: settings ?? this.settings,
      status: status ?? this.status,
      metaData: metaData ?? this.metaData,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class DashboardSettings {
  final bool autoRefresh;
  final int? refreshIntervalSeconds;
  final String? refreshCronExpression;
  final Map<String, dynamic> theme;

  DashboardSettings({
    this.autoRefresh = false,
    this.refreshIntervalSeconds,
    this.refreshCronExpression,
    this.theme = const {},
  });

  factory DashboardSettings.fromJson(Map<String, dynamic> json) {
    return DashboardSettings(
      autoRefresh: json['auto_refresh'] ?? false,
      refreshIntervalSeconds: json['refresh_interval_seconds'],
      refreshCronExpression: json['refresh_cron_expression'],
      theme: Map<String, dynamic>.from(json['theme'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'auto_refresh': autoRefresh,
      'refresh_interval_seconds': refreshIntervalSeconds,
      'refresh_cron_expression': refreshCronExpression,
      'theme': theme,
    };
  }

  DashboardSettings copyWith({
    bool? autoRefresh,
    int? refreshIntervalSeconds,
    String? refreshCronExpression,
    Map<String, dynamic>? theme,
  }) {
    return DashboardSettings(
      autoRefresh: autoRefresh ?? this.autoRefresh,
      refreshIntervalSeconds: refreshIntervalSeconds ?? this.refreshIntervalSeconds,
      refreshCronExpression: refreshCronExpression ?? this.refreshCronExpression,
      theme: theme ?? this.theme,
    );
  }
}

class DashboardFilterModel {
  final String id;
  final String name;
  final String filterType;
  final String fieldName;
  final List<Map<String, dynamic>> options;
  final String? defaultValue;
  final bool isRequired;
  final List<String> affectsWidgets;
  final Map<String, dynamic> metaData;

  DashboardFilterModel({
    required this.id,
    required this.name,
    required this.filterType,
    required this.fieldName,
    this.options = const [],
    this.defaultValue,
    this.isRequired = false,
    this.affectsWidgets = const [],
    this.metaData = const {},
  });

  factory DashboardFilterModel.fromJson(Map<String, dynamic> json) {
    return DashboardFilterModel(
      id: json['id'],
      name: json['name'],
      filterType: json['filter_type'],
      fieldName: json['field_name'],
      options: List<Map<String, dynamic>>.from(json['options'] ?? []),
      defaultValue: json['default_value'],
      isRequired: json['is_required'] ?? false,
      affectsWidgets: List<String>.from(json['affects_widgets'] ?? []),
      metaData: Map<String, dynamic>.from(json['meta_data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'filter_type': filterType,
      'field_name': fieldName,
      'options': options,
      'default_value': defaultValue,
      'is_required': isRequired,
      'affects_widgets': affectsWidgets,
      'meta_data': metaData,
    };
  }
}