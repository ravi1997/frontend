// Dashboard Builder Canvas Models
// Matches the backend `_docs_dashboard` / `_docs_widget` response shapes exactly.

// ─── Widget Types ──────────────────────────────────────────────────────────────

enum DashboardWidgetType {
  kpiCard('kpi_card'),
  barChart('bar_chart'),
  lineChart('line_chart'),
  pieChart('pie_chart'),
  dataTable('data_table'),
  textLabel('text_label'),
  imageWidget('image'),
  filterWidget('filter_widget');

  final String value;
  const DashboardWidgetType(this.value);

  static DashboardWidgetType fromString(String v) {
    final normalized = v.trim().toLowerCase();
    final alias = switch (normalized) {
      'counter' => 'kpi_card',
      'kpi' => 'kpi_card',
      'kpi_card' => 'kpi_card',
      'chart_bar' => 'bar_chart',
      'bar_chart' => 'bar_chart',
      'chart_line' => 'line_chart',
      'line_chart' => 'line_chart',
      'chart_pie' => 'pie_chart',
      'pie_chart' => 'pie_chart',
      'table' => 'data_table',
      'list_view' => 'data_table',
      'data_table' => 'data_table',
      'text_label' => 'text_label',
      'label' => 'text_label',
      'image' => 'image',
      'image_widget' => 'image',
      'filter_widget' => 'filter_widget',
      'filter' => 'filter_widget',
      _ => normalized,
    };
    return DashboardWidgetType.values.firstWhere(
      (e) => e.value == alias,
      orElse: () => DashboardWidgetType.kpiCard,
    );
  }

  String get label => switch (this) {
        DashboardWidgetType.kpiCard => 'KPI Card',
        DashboardWidgetType.barChart => 'Bar Chart',
        DashboardWidgetType.lineChart => 'Line Chart',
        DashboardWidgetType.pieChart => 'Pie Chart',
        DashboardWidgetType.dataTable => 'Data Table',
        DashboardWidgetType.textLabel => 'Text / Label',
        DashboardWidgetType.imageWidget => 'Image',
        DashboardWidgetType.filterWidget => 'Filter Widget',
      };
}

// ─── Widget Data Binding ───────────────────────────────────────────────────────

class WidgetDataBinding {
  final String? analysisId;
  final String? nodeId;
  final String refreshMode; // with_dashboard | independent | never

  const WidgetDataBinding({
    this.analysisId,
    this.nodeId,
    this.refreshMode = 'with_dashboard',
  });

  factory WidgetDataBinding.fromJson(Map<String, dynamic> j) =>
      WidgetDataBinding(
        analysisId: j['analysis_id'] as String?,
        nodeId: j['node_id'] as String?,
        refreshMode: j['refresh_mode'] as String? ?? 'with_dashboard',
      );

  Map<String, dynamic> toJson() => {
        'analysis_id': analysisId,
        'node_id': nodeId,
        'refresh_mode': refreshMode,
      };

  WidgetDataBinding copyWith({
    String? analysisId,
    String? nodeId,
    String? refreshMode,
  }) =>
      WidgetDataBinding(
        analysisId: analysisId ?? this.analysisId,
        nodeId: nodeId ?? this.nodeId,
        refreshMode: refreshMode ?? this.refreshMode,
      );
}

// ─── Dashboard Widget ──────────────────────────────────────────────────────────

class DashboardWidget {
  final String id;
  final DashboardWidgetType type;
  double x;
  double y;
  double width;
  double height;
  int zIndex;
  bool isLocked;
  Map<String, dynamic> properties; // type-specific
  WidgetDataBinding dataBinding;
  dynamic resolvedData; // data returned by backend resolve

  DashboardWidget({
    required this.id,
    required this.type,
    this.x = 100,
    this.y = 100,
    this.width = 320,
    this.height = 200,
    this.zIndex = 0,
    this.isLocked = false,
    Map<String, dynamic>? properties,
    WidgetDataBinding? dataBinding,
    this.resolvedData,
  })  : properties = properties ?? {},
        dataBinding = dataBinding ?? const WidgetDataBinding();

  factory DashboardWidget.fromJson(Map<String, dynamic> j) {
    final pos = j['position'] is Map
        ? Map<String, dynamic>.from(j['position'] as Map)
        : const <String, dynamic>{};
    final size = j['size'] is Map
        ? Map<String, dynamic>.from(j['size'] as Map)
        : const <String, dynamic>{};
    final properties = j['properties'] is Map
        ? Map<String, dynamic>.from(j['properties'] as Map)
        : <String, dynamic>{};
    if (properties.isEmpty) {
      for (final entry in <String, dynamic>{
        'title': j['title'],
        'content': j['content'],
        'url': j['url'],
        'alt': j['alt'],
        'label': j['label'],
        'group_by_field': j['group_by_field'],
        'aggregate_field': j['aggregate_field'],
        'calculation_type': j['calculation_type'],
        'filters': j['filters'],
        'size': j['size'] is String ? j['size'] : null,
        'color_scheme': j['color_scheme'],
        'display_columns': j['display_columns'],
        'config': j['config'],
      }.entries) {
        if (entry.value != null) {
          properties[entry.key] = entry.value;
        }
      }
    } else {
      for (final entry in <String, dynamic>{
        'title': j['title'],
        'content': j['content'],
        'url': j['url'],
        'alt': j['alt'],
        'label': j['label'],
      }.entries) {
        if (entry.value != null && !properties.containsKey(entry.key)) {
          properties[entry.key] = entry.value;
        }
      }
    }
    return DashboardWidget(
      id: j['id'] as String? ?? '',
      type: DashboardWidgetType.fromString(j['type'] as String? ?? ''),
      x: (pos['x'] as num?)?.toDouble() ??
          (j['position_x'] as num?)?.toDouble() ??
          100,
      y: (pos['y'] as num?)?.toDouble() ??
          (j['position_y'] as num?)?.toDouble() ??
          100,
      width: (size['width'] as num?)?.toDouble() ??
          (j['width'] as num?)?.toDouble() ??
          320,
      height: (size['height'] as num?)?.toDouble() ??
          (j['height'] as num?)?.toDouble() ??
          200,
      zIndex: j['z_index'] as int? ?? 0,
      isLocked: j['is_locked'] as bool? ?? false,
      properties: properties,
      dataBinding: j['data_binding'] is Map
          ? WidgetDataBinding.fromJson(
              Map<String, dynamic>.from(j['data_binding'] as Map))
          : WidgetDataBinding(
              analysisId: j['analysis_id']?.toString(),
              nodeId: j['node_id']?.toString(),
              refreshMode: j['refresh_mode']?.toString() ?? 'with_dashboard',
            ),
      resolvedData: j['data'] ?? j['resolved_data'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.value,
        'position': {'x': x, 'y': y},
        'size': {'width': width, 'height': height},
        'z_index': zIndex,
        'is_locked': isLocked,
        'properties': properties,
        'data_binding': dataBinding.toJson(),
      };

  DashboardWidget copyWith({
    DashboardWidgetType? type,
    double? x,
    double? y,
    double? width,
    double? height,
    int? zIndex,
    bool? isLocked,
    Map<String, dynamic>? properties,
    WidgetDataBinding? dataBinding,
    dynamic resolvedData,
    bool clearResolvedData = false,
  }) =>
      DashboardWidget(
        id: id,
        type: type ?? this.type,
        x: x ?? this.x,
        y: y ?? this.y,
        width: width ?? this.width,
        height: height ?? this.height,
        zIndex: zIndex ?? this.zIndex,
        isLocked: isLocked ?? this.isLocked,
        properties: properties ?? Map.from(this.properties),
        dataBinding: dataBinding ?? this.dataBinding,
        resolvedData:
            clearResolvedData ? null : (resolvedData ?? this.resolvedData),
      );
}

// ─── Canvas ────────────────────────────────────────────────────────────────────

class DashboardCanvas {
  final double width;
  final double height;
  final String backgroundColor;
  final List<DashboardWidget> widgets;

  const DashboardCanvas({
    this.width = 1920,
    this.height = 1080,
    this.backgroundColor = '#F5F5F5',
    this.widgets = const [],
  });

  factory DashboardCanvas.fromJson(Map<String, dynamic> j) => DashboardCanvas(
        width: (j['width'] as num?)?.toDouble() ?? 1920,
        height: (j['height'] as num?)?.toDouble() ?? 1080,
        backgroundColor: j['background_color'] as String? ?? '#F5F5F5',
        widgets: (j['widgets'] as List?)
                ?.map((e) =>
                    DashboardWidget.fromJson(Map<String, dynamic>.from(e as Map)))
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
        'width': width,
        'height': height,
        'background_color': backgroundColor,
        'widgets': widgets.map((w) => w.toJson()).toList(),
      };
}

// ─── Dashboard Settings ────────────────────────────────────────────────────────

class DashboardSettings {
  final bool autoRefresh;
  final int refreshIntervalSeconds;
  final Map<String, dynamic> theme;

  const DashboardSettings({
    this.autoRefresh = false,
    this.refreshIntervalSeconds = 60,
    this.theme = const {},
  });

  factory DashboardSettings.fromJson(Map<String, dynamic> j) =>
      DashboardSettings(
        autoRefresh: j['auto_refresh'] as bool? ?? false,
        refreshIntervalSeconds:
            j['refresh_interval_seconds'] as int? ?? 60,
        theme: j['theme'] is Map
            ? Map<String, dynamic>.from(j['theme'] as Map)
            : {},
      );

  Map<String, dynamic> toJson() => {
        'auto_refresh': autoRefresh,
        'refresh_interval_seconds': refreshIntervalSeconds,
        'theme': theme,
      };

  DashboardSettings copyWith({
    bool? autoRefresh,
    int? refreshIntervalSeconds,
    Map<String, dynamic>? theme,
  }) =>
      DashboardSettings(
        autoRefresh: autoRefresh ?? this.autoRefresh,
        refreshIntervalSeconds:
            refreshIntervalSeconds ?? this.refreshIntervalSeconds,
        theme: theme ?? this.theme,
      );
}

// ─── Dashboard (top-level model) ───────────────────────────────────────────────

class DashboardModel {
  final String id;
  final String? projectId;
  final String name;
  final String description;
  final bool isPublic;
  final String? publicToken;
  final DashboardCanvas canvas;
  final DashboardSettings settings;

  const DashboardModel({
    required this.id,
    this.projectId,
    required this.name,
    this.description = '',
    this.isPublic = false,
    this.publicToken,
    this.canvas = const DashboardCanvas(),
    this.settings = const DashboardSettings(),
  });

  factory DashboardModel.fromJson(Map<String, dynamic> j) {
    final dashJ = j['dashboard'] is Map
        ? Map<String, dynamic>.from(j['dashboard'] as Map)
        : j;
    final canvasMap = dashJ['canvas'] is Map
        ? Map<String, dynamic>.from(dashJ['canvas'] as Map)
        : <String, dynamic>{
            'width': dashJ['canvas_width'] ??
                dashJ['width'] ??
                dashJ['canvasWidth'] ??
                1920,
            'height': dashJ['canvas_height'] ??
                dashJ['height'] ??
                dashJ['canvasHeight'] ??
                1080,
            'background_color': dashJ['background_color'] ??
                dashJ['backgroundColor'] ??
                '#F5F5F5',
            'widgets': dashJ['widgets'] ?? const [],
          };
    final settingsMap = dashJ['settings'] is Map
        ? Map<String, dynamic>.from(dashJ['settings'] as Map)
        : <String, dynamic>{
            'auto_refresh': dashJ['auto_refresh'] ?? dashJ['autoRefresh'] ?? false,
            'refresh_interval_seconds': dashJ['refresh_interval_seconds'] ??
                dashJ['refreshIntervalSeconds'] ??
                60,
            'theme': dashJ['theme'] is Map
                ? Map<String, dynamic>.from(dashJ['theme'] as Map)
                : <String, dynamic>{},
          };
    return DashboardModel(
      id: dashJ['_id'] as String? ??
          dashJ['id'] as String? ??
          dashJ['dashboard_id'] as String? ??
          dashJ['snapshot_id'] as String? ??
          '',
      projectId: dashJ['project_id'] as String? ?? dashJ['projectId'] as String?,
      name: dashJ['name'] as String? ?? dashJ['title'] as String? ?? '',
      description: dashJ['description'] as String? ?? '',
      isPublic: dashJ['is_public'] as bool? ??
          dashJ['is_shared'] as bool? ??
          dashJ['isPublic'] as bool? ??
          false,
      publicToken:
          dashJ['public_token'] as String? ?? dashJ['share_token'] as String?,
      canvas: DashboardCanvas.fromJson(canvasMap),
      settings: DashboardSettings.fromJson(settingsMap),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'project_id': projectId,
        'name': name,
        'description': description,
        'is_public': isPublic,
        'public_token': publicToken,
        'canvas': canvas.toJson(),
        'settings': settings.toJson(),
      };

  DashboardModel copyWith({
    String? name,
    String? description,
    bool? isPublic,
    String? publicToken,
    DashboardCanvas? canvas,
    DashboardSettings? settings,
  }) =>
      DashboardModel(
        id: id,
        projectId: projectId,
        name: name ?? this.name,
        description: description ?? this.description,
        isPublic: isPublic ?? this.isPublic,
        publicToken: publicToken ?? this.publicToken,
        canvas: canvas ?? this.canvas,
        settings: settings ?? this.settings,
      );
}
