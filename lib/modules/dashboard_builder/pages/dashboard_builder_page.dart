import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/modules/dashboard_builder/models/dashboard_canvas_models.dart';
import 'package:frontend/modules/dashboard_builder/providers/canvas_state_provider.dart';
import 'package:frontend/modules/dashboard_builder/providers/widget_data_provider.dart';
import 'package:frontend/modules/dashboard_builder/repositories/dashboard_builder_repository.dart';
import 'package:frontend/modules/dashboard_builder/widgets/sharing_dialog.dart';
import 'package:frontend/core/services/collaboration_service.dart';

class DashboardBuilderPage extends ConsumerStatefulWidget {
  final String dashboardId;
  final String? organizationId;

  const DashboardBuilderPage({
    super.key,
    required this.dashboardId,
    this.organizationId,
  });

  @override
  ConsumerState<DashboardBuilderPage> createState() =>
      _DashboardBuilderPageState();
}

class _DashboardBuilderPageState extends ConsumerState<DashboardBuilderPage> {
  late Future<DashboardModel> _loadDashboardFuture;
  late WidgetDataNotifier _widgetDataNotifier;
  ProviderSubscription<dynamic>? _collisionSubscription;
  ProviderSubscription<String?>? _selectionSubscription;

  @override
  void initState() {
    super.initState();
    // Initialize room subscription
    Future.microtask(() {
      ref.read(
        collaborationProvider('dashboard:${widget.dashboardId}').notifier,
      );
    });
    _widgetDataNotifier = ref.read(widgetDataProvider.notifier);
    final repo = ref.read(dashboardBuilderRepositoryProvider);
    _loadDashboardFuture = repo
        .getCanvas(widget.dashboardId, includeData: true)
        .then((model) {
          // Start auto-refresh if configured
          if (model.settings.autoRefresh) {
            _widgetDataNotifier.startAutoRefresh(
              widget.dashboardId,
              model.settings.refreshIntervalSeconds,
            );
          }
          // Populate widget data cache initially
          _widgetDataNotifier.fetchDashboardData(widget.dashboardId);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _attachListeners(model);
            }
          });
          return model;
        });
  }

  @override
  void dispose() {
    _collisionSubscription?.close();
    _selectionSubscription?.close();
    // Stop refresh timer
    _widgetDataNotifier.stopAutoRefresh();
    super.dispose();
  }

  void _attachListeners(DashboardModel model) {
    final collaborationKey = 'dashboard:${widget.dashboardId}';
    _collisionSubscription?.close();
    _selectionSubscription?.close();

    _collisionSubscription = ref.listenManual(
      collaborationProvider(collaborationKey),
      (previous, next) {
        if (next.collisionTarget != null) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Edit Collision Warning'),
              content: Text(
                'This widget is currently locked by ${next.collisionHeldBy}. Please wait or edit a different widget.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    ref
                        .read(collaborationProvider(collaborationKey).notifier)
                        .clearCollision();
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      },
    );

    final initialCanvas = model.canvas;
    _selectionSubscription = ref.listenManual<String?>(
      canvasStateProvider(
        initialCanvas,
      ).select((state) => state.selectedWidgetId),
      (previous, next) {
        final collabNotifier = ref.read(
          collaborationProvider(collaborationKey).notifier,
        );
        if (previous != null) {
          collabNotifier.releaseLease(previous);
        }
        if (next != null) {
          collabNotifier.acquireLease(next);
          collabNotifier.updateCursor(next);
        }
      },
    );
  }

  Future<bool> _onWillPop(CanvasState state) async {
    if (state.isDirty) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Unsaved Changes'),
          content: const Text(
            'You have unsaved changes. Do you want to discard them and leave?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Discard'),
            ),
          ],
        ),
      );
      return confirm ?? false;
    }
    return true;
  }

  Future<void> _saveCanvas(CanvasState state) async {
    try {
      final repo = ref.read(dashboardBuilderRepositoryProvider);
      await repo.saveCanvas(widget.dashboardId, state.canvas);
      ref.read(canvasStateProvider(state.canvas).notifier).markClean();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Canvas saved successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to save canvas: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FutureBuilder<DashboardModel>(
      future: _loadDashboardFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error loading dashboard: ${snapshot.error}'),
            ),
          );
        }

        final model = snapshot.data!;
        final initialCanvas = model.canvas;
        final canvasState = ref.watch(canvasStateProvider(initialCanvas));
        final canvasNotifier = ref.read(
          canvasStateProvider(initialCanvas).notifier,
        );
        final widgetData = ref.watch(widgetDataProvider);

        return PopScope(
          canPop: !canvasState.isDirty,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;
            final shouldPop = await _onWillPop(canvasState);
            if (shouldPop && context.mounted) {
              Navigator.of(context).pop();
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(model.name),
              actions: [
                // Zoom out
                IconButton(
                  icon: const Icon(Icons.zoom_out),
                  tooltip: 'Zoom Out',
                  onPressed: () =>
                      canvasNotifier.setScale(canvasState.scale - 0.1),
                ),
                Text(
                  '${(canvasState.scale * 100).toInt()}%',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Zoom in
                IconButton(
                  icon: const Icon(Icons.zoom_in),
                  tooltip: 'Zoom In',
                  onPressed: () =>
                      canvasNotifier.setScale(canvasState.scale + 0.1),
                ),
                const VerticalDivider(width: 20),
                // Preview / Edit mode toggle
                SegmentedButton<CanvasMode>(
                  segments: const [
                    ButtonSegment(
                      value: CanvasMode.preview,
                      label: Text('Preview'),
                      icon: Icon(Icons.visibility),
                    ),
                    ButtonSegment(
                      value: CanvasMode.edit,
                      label: Text('Edit'),
                      icon: Icon(Icons.edit),
                    ),
                  ],
                  selected: {canvasState.mode},
                  onSelectionChanged: (modes) {
                    canvasNotifier.setMode(modes.first);
                  },
                ),
                const SizedBox(width: 12),
                // Share dashboard
                IconButton.filledTonal(
                  icon: const Icon(Icons.share),
                  tooltip: 'Share options',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => SharingDialog(
                        dashboardId: widget.dashboardId,
                        initialIsPublic: model.isPublic,
                        initialToken: model.publicToken,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 12),
                // Save button
                if (canvasState.isDirty)
                  ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: const Text('Save'),
                    onPressed: () => _saveCanvas(canvasState),
                  ),
                const SizedBox(width: 16),
              ],
            ),
            body: Row(
              children: [
                // Left widget library (only in edit mode)
                if (canvasState.mode == CanvasMode.edit)
                  _buildWidgetLibrary(canvasState, canvasNotifier),

                // Main canvas workspace
                Expanded(
                  child: Container(
                    color: theme.colorScheme.surfaceContainerLow,
                    child: InteractiveViewer(
                      transformationController: TransformationController(
                        Matrix4.diagonal3Values(
                          canvasState.scale,
                          canvasState.scale,
                          1.0,
                        ),
                      ),
                      minScale: 0.5,
                      maxScale: 2.0,
                      child: Center(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Container(
                              width: canvasState.canvas.width,
                              height: canvasState.canvas.height,
                              margin: const EdgeInsets.all(40),
                              decoration: BoxDecoration(
                                color: Color(
                                  int.parse(
                                    canvasState.canvas.backgroundColor
                                        .replaceFirst('#', '0xff'),
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 16,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: canvasState.canvas.widgets.map((
                                  widget,
                                ) {
                                  final data =
                                      widgetData.data[widget.id] ??
                                      widget.resolvedData;
                                  return Positioned(
                                    left: widget.x,
                                    top: widget.y,
                                    width: widget.width,
                                    height: widget.height,
                                    child: _buildWidgetWrapper(
                                      widget,
                                      data,
                                      canvasState,
                                      canvasNotifier,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Right properties panel (only in edit mode)
                if (canvasState.mode == CanvasMode.edit)
                  _buildPropertiesPanel(canvasState, canvasNotifier),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWidgetLibrary(CanvasState state, CanvasStateNotifier notifier) {
    final theme = Theme.of(context);
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          right: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Widgets',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: DashboardWidgetType.values.map((type) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Icon(_getWidgetIcon(type)),
                    title: Text(type.label),
                    onTap: () {
                      final newWidget = DashboardWidget(
                        id: UniqueKey().toString(),
                        type: type,
                        x: 100,
                        y: 100,
                        width: 320,
                        height: 200,
                        properties: {'title': type.label},
                      );
                      notifier.updateCanvas(
                        DashboardCanvas(
                          width: state.canvas.width,
                          height: state.canvas.height,
                          backgroundColor: state.canvas.backgroundColor,
                          widgets: [...state.canvas.widgets, newWidget],
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetWrapper(
    DashboardWidget widget,
    dynamic data,
    CanvasState state,
    CanvasStateNotifier notifier,
  ) {
    final theme = Theme.of(context);
    final collabState = ref.watch(
      collaborationProvider('dashboard:${this.widget.dashboardId}'),
    );
    final lease = collabState.leases[widget.id];
    final isLocked = lease != null && lease['user_id'] != collabState.myUserId;
    final lockedByName = lease != null
        ? (lease['display_name'] ?? 'Someone')
        : null;
    final isSelected = state.selectedWidgetId == widget.id;

    return GestureDetector(
      onTap: () {
        if (state.mode == CanvasMode.edit) {
          if (isLocked) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Widget is locked by $lockedByName'),
                backgroundColor: Colors.amber.shade800,
              ),
            );
            return;
          }
          notifier.selectWidget(widget.id);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? (isLocked ? Colors.amber.shade700 : theme.colorScheme.primary)
                : (isLocked
                      ? Colors.amber.shade700
                      : theme.colorScheme.outlineVariant),
            width: isSelected ? 2 : (isLocked ? 1.5 : 1),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  if (isLocked)
                    Padding(
                      padding: const EdgeInsets.only(right: 6.0),
                      child: Icon(
                        Icons.lock,
                        size: 14,
                        color: Colors.amber.shade800,
                      ),
                    ),
                  Icon(_getWidgetIcon(widget.type), size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.properties['title'] ?? widget.type.label,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isLocked && lockedByName != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 1.5,
                      ),
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.amber.shade300),
                      ),
                      child: Text(
                        lockedByName,
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.amber.shade900,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  if (state.mode == CanvasMode.edit && !isLocked)
                    IconButton(
                      icon: const Icon(Icons.delete, size: 16),
                      onPressed: () {
                        final newWidgets = state.canvas.widgets
                            .where((w) => w.id != widget.id)
                            .toList();
                        notifier.updateCanvas(
                          DashboardCanvas(
                            width: state.canvas.width,
                            height: state.canvas.height,
                            backgroundColor: state.canvas.backgroundColor,
                            widgets: newWidgets,
                          ),
                        );
                        notifier.selectWidget(null);
                      },
                    ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: state.mode == CanvasMode.edit
                    ? Text(
                        'No Live Data (Edit)',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      )
                    : ((data == null &&
                              widget.type != DashboardWidgetType.llmPrompt &&
                              widget.type != DashboardWidgetType.textLabel)
                          ? Text(
                              'No Data',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            )
                          : _renderWidgetData(widget, data)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertiesPanel(
    CanvasState state,
    CanvasStateNotifier notifier,
  ) {
    final theme = Theme.of(context);
    final selectedWidget = state.selectedWidgetId != null
        ? state.canvas.widgets.firstWhere((w) => w.id == state.selectedWidgetId)
        : null;

    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          left: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: selectedWidget == null
          ? const Center(child: Text('Select a widget to edit properties'))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Properties',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Text(
                        'Widget ID: ${selectedWidget.id}',
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: TextEditingController(
                          text: selectedWidget.properties['title'] ?? '',
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (val) {
                          selectedWidget.properties['title'] = val;
                          notifier.updateCanvas(state.canvas);
                        },
                      ),
                      const SizedBox(height: 16),
                      // Position controls
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: TextEditingController(
                                text: selectedWidget.x.toString(),
                              ),
                              decoration: const InputDecoration(labelText: 'X'),
                              keyboardType: TextInputType.number,
                              onSubmitted: (val) {
                                selectedWidget.x =
                                    double.tryParse(val) ?? selectedWidget.x;
                                notifier.updateCanvas(state.canvas);
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: TextEditingController(
                                text: selectedWidget.y.toString(),
                              ),
                              decoration: const InputDecoration(labelText: 'Y'),
                              keyboardType: TextInputType.number,
                              onSubmitted: (val) {
                                selectedWidget.y =
                                    double.tryParse(val) ?? selectedWidget.y;
                                notifier.updateCanvas(state.canvas);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: TextEditingController(
                                text: selectedWidget.width.toString(),
                              ),
                              decoration: const InputDecoration(
                                labelText: 'Width',
                              ),
                              keyboardType: TextInputType.number,
                              onSubmitted: (val) {
                                selectedWidget.width =
                                    double.tryParse(val) ??
                                    selectedWidget.width;
                                notifier.updateCanvas(state.canvas);
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: TextEditingController(
                                text: selectedWidget.height.toString(),
                              ),
                              decoration: const InputDecoration(
                                labelText: 'Height',
                              ),
                              keyboardType: TextInputType.number,
                              onSubmitted: (val) {
                                selectedWidget.height =
                                    double.tryParse(val) ??
                                    selectedWidget.height;
                                notifier.updateCanvas(state.canvas);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  IconData _getWidgetIcon(DashboardWidgetType type) {
    return switch (type) {
      DashboardWidgetType.kpiCard => Icons.speed,
      DashboardWidgetType.barChart => Icons.bar_chart,
      DashboardWidgetType.lineChart => Icons.show_chart,
      DashboardWidgetType.pieChart => Icons.pie_chart,
      DashboardWidgetType.dataTable => Icons.table_chart,
      DashboardWidgetType.textLabel => Icons.text_fields,
      DashboardWidgetType.imageWidget => Icons.image,
      DashboardWidgetType.filterWidget => Icons.filter_alt,
      DashboardWidgetType.llmPrompt => Icons.psychology,
    };
  }

  Widget _renderWidgetData(DashboardWidget widget, dynamic data) {
    final theme = Theme.of(context);
    if (widget.type == DashboardWidgetType.kpiCard) {
      final displayVal = (data is Map && data.containsKey('value'))
          ? data['value']
          : data;
      return Text(
        displayVal.toString(),
        style: theme.textTheme.displayMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary,
        ),
      );
    }
    if (widget.type == DashboardWidgetType.llmPrompt) {
      final text = (data != null && data.toString().isNotEmpty)
          ? data.toString()
          : (widget.properties['prompt'] ?? '');
      return Text(text, maxLines: 5, overflow: TextOverflow.ellipsis);
    }
    if (widget.type == DashboardWidgetType.textLabel) {
      return Text(
        widget.properties['text'] ?? '',
        maxLines: 5,
        overflow: TextOverflow.ellipsis,
      );
    }
    if (data is Map &&
        data.containsKey('labels') &&
        data.containsKey('values')) {
      final labels = List<String>.from(data['labels'] as List);
      final values = List<num>.from(data['values'] as List);
      return Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(labels.length.clamp(0, 3), (idx) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(labels[idx], overflow: TextOverflow.ellipsis),
                  Text(
                    values[idx].toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }),
        ),
      );
    }
    return Text(data.toString(), maxLines: 3, overflow: TextOverflow.ellipsis);
  }
}
