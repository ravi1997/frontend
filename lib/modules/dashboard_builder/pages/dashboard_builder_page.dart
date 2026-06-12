import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

import 'package:frontend/modules/dashboard_builder/models/dashboard_canvas_models.dart';
import 'package:frontend/modules/dashboard_builder/repositories/dashboard_builder_repository.dart';

// ─── State ────────────────────────────────────────────────────────────────────

class _BuilderState {
  final DashboardModel? dashboard;
  final List<DashboardWidget> widgets;
  final String? selectedId;
  final bool editMode;
  final bool saving;
  final String? error;
  final bool isDirty;

  const _BuilderState({
    this.dashboard,
    this.widgets = const [],
    this.selectedId,
    this.editMode = true,
    this.saving = false,
    this.error,
    this.isDirty = false,
  });

  _BuilderState copyWith({
    DashboardModel? dashboard,
    List<DashboardWidget>? widgets,
    String? selectedId,
    bool? editMode,
    bool? saving,
    String? error,
    bool? isDirty,
    bool clearSelectedId = false,
    bool clearError = false,
  }) =>
      _BuilderState(
        dashboard: dashboard ?? this.dashboard,
        widgets: widgets ?? this.widgets,
        selectedId: clearSelectedId ? null : (selectedId ?? this.selectedId),
        editMode: editMode ?? this.editMode,
        saving: saving ?? this.saving,
        error: clearError ? null : (error ?? this.error),
        isDirty: isDirty ?? this.isDirty,
      );
}

// ─── Page ─────────────────────────────────────────────────────────────────────

class DashboardBuilderPage extends ConsumerStatefulWidget {
  final String projectId;
  final String dashboardId;

  const DashboardBuilderPage({
    super.key,
    required this.projectId,
    required this.dashboardId,
  });

  @override
  ConsumerState<DashboardBuilderPage> createState() =>
      _DashboardBuilderPageState();
}

class _DashboardBuilderPageState extends ConsumerState<DashboardBuilderPage> {
  _BuilderState _state = const _BuilderState();
  final _uuid = const Uuid();
  final TransformationController _transformationController =
      TransformationController();
  Timer? _autoSaveTimer;
  Timer? _autoRefreshTimer;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    _autoRefreshTimer?.cancel();
    _transformationController.dispose();
    super.dispose();
  }

  // ── Load ──────────────────────────────────────────────────────────────────

  Future<void> _load({
    bool includeData = false,
    bool preserveLocalWidgets = false,
  }) async {
    final existingWidgets = List<DashboardWidget>.from(_state.widgets);
    setState(() => _state = _state.copyWith(error: null, clearError: true));
    try {
      final repo = ref.read(dashboardBuilderRepositoryProvider);
      final dash = await repo.getCanvas(
        widget.dashboardId,
        includeData: includeData,
      );
      final nextWidgets = includeData && preserveLocalWidgets
          ? _mergeResolvedWidgets(existingWidgets, dash.canvas.widgets)
          : List<DashboardWidget>.from(dash.canvas.widgets);
      setState(() {
        _state = _state.copyWith(
          dashboard: dash,
          widgets: nextWidgets,
          isDirty: preserveLocalWidgets ? _state.isDirty : false,
        );
      });
      _startAutoRefresh();
    } catch (e) {
      setState(() => _state = _state.copyWith(error: e.toString()));
    }
  }

  // ── Auto-refresh ──────────────────────────────────────────────────────────

  void _startAutoRefresh() {
    _autoRefreshTimer?.cancel();
    final settings = _state.dashboard?.settings;
    if (settings == null || !settings.autoRefresh || _state.editMode) return;
    _autoRefreshTimer = Timer.periodic(
      Duration(seconds: settings.refreshIntervalSeconds),
      (_) => _load(includeData: true, preserveLocalWidgets: true),
    );
  }

  // ── Save ──────────────────────────────────────────────────────────────────

  Future<void> _save() async {
    if (_state.saving) return;
    setState(() => _state = _state.copyWith(saving: true));
    try {
      final canvas = DashboardCanvas(
        width: _state.dashboard?.canvas.width ?? 1920,
        height: _state.dashboard?.canvas.height ?? 1080,
        backgroundColor: _state.dashboard?.canvas.backgroundColor ?? '#F5F5F5',
        widgets: _state.widgets,
      );
      await ref
          .read(dashboardBuilderRepositoryProvider)
          .saveCanvas(widget.dashboardId, canvas);
      setState(() => _state = _state.copyWith(saving: false, isDirty: false));
    } catch (e) {
      setState(() => _state = _state.copyWith(saving: false, error: e.toString()));
    }
  }

  void _scheduleSave() {
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer(const Duration(seconds: 2), _save);
    setState(() => _state = _state.copyWith(isDirty: true));
  }

  List<DashboardWidget> _mergeResolvedWidgets(
    List<DashboardWidget> localWidgets,
    List<DashboardWidget> resolvedWidgets,
  ) {
    final resolvedById = <String, dynamic>{
      for (final widget in resolvedWidgets)
        if (widget.id.isNotEmpty) widget.id: widget.resolvedData,
    };

    return localWidgets
        .map(
          (widget) {
            if (!resolvedById.containsKey(widget.id)) {
              return widget.copyWith(clearResolvedData: true);
            }
            return widget.copyWith(resolvedData: resolvedById[widget.id]);
          },
        )
        .toList();
  }

  // ── Widget management ─────────────────────────────────────────────────────

  void _addWidget(DashboardWidgetType type) {
    final id = _uuid.v4();
    final newWidget = DashboardWidget(
      id: id,
      type: type,
      x: 80 + math.Random().nextDouble() * 200,
      y: 80 + math.Random().nextDouble() * 200,
      width: _defaultWidth(type),
      height: _defaultHeight(type),
      properties: _defaultProps(type),
    );
    setState(() {
      _state = _state.copyWith(
        widgets: [..._state.widgets, newWidget],
        selectedId: id,
      );
    });
    _scheduleSave();
  }

  double _defaultWidth(DashboardWidgetType t) => switch (t) {
        DashboardWidgetType.kpiCard => 200,
        DashboardWidgetType.dataTable => 600,
        DashboardWidgetType.textLabel => 240,
        DashboardWidgetType.imageWidget => 300,
        DashboardWidgetType.filterWidget => 220,
        _ => 420,
      };

  double _defaultHeight(DashboardWidgetType t) => switch (t) {
        DashboardWidgetType.kpiCard => 120,
        DashboardWidgetType.dataTable => 300,
        DashboardWidgetType.textLabel => 60,
        DashboardWidgetType.imageWidget => 200,
        DashboardWidgetType.filterWidget => 80,
        _ => 280,
      };

  Map<String, dynamic> _defaultProps(DashboardWidgetType t) => switch (t) {
        DashboardWidgetType.kpiCard => {
            'title': 'KPI Metric',
            'calculation_type': 'count',
            'color_scheme': '#6366F1',
          },
        DashboardWidgetType.barChart => {'title': 'Bar Chart'},
        DashboardWidgetType.lineChart => {'title': 'Line Chart'},
        DashboardWidgetType.pieChart => {'title': 'Pie Chart'},
        DashboardWidgetType.dataTable => {
            'title': 'Data Table',
            'display_columns': <String>[],
          },
        DashboardWidgetType.textLabel => {
            'content': 'Text label',
            'font_size': 16.0,
            'color': '#1F2937',
          },
        DashboardWidgetType.imageWidget => {'url': '', 'alt': 'Image'},
        DashboardWidgetType.filterWidget => {
            'label': 'Filter',
            'field': '',
            'filter_type': 'select',
          },
      };

  void _deleteSelected() {
    final id = _state.selectedId;
    if (id == null) return;
    setState(() {
      _state = _state.copyWith(
        widgets: _state.widgets.where((w) => w.id != id).toList(),
        clearSelectedId: true,
      );
    });
    _scheduleSave();
  }

  void _updateWidget(DashboardWidget updated) {
    setState(() {
      _state = _state.copyWith(
        widgets: _state.widgets.map((w) => w.id == updated.id ? updated : w).toList(),
      );
    });
    _scheduleSave();
  }

  DashboardWidget? get _selectedWidget => _state.selectedId == null
      ? null
      : _state.widgets.where((w) => w.id == _state.selectedId).firstOrNull;

  // ── Share ─────────────────────────────────────────────────────────────────

  Future<void> _share() async {
    try {
      final token = await ref
          .read(dashboardBuilderRepositoryProvider)
          .share(widget.dashboardId);
      if (!mounted) return;
      final url = 'http://localhost:9600/d/$token';
      await Clipboard.setData(ClipboardData(text: url));
      _showSnack('Public link copied to clipboard!');
    } catch (e) {
      _showSnack('Share failed: $e', isError: true);
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isError ? Colors.red : Colors.green,
      behavior: SnackBarBehavior.floating,
    ));
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final dash = _state.dashboard;

    return Scaffold(
      backgroundColor: cs.surface,
      body: dash == null && _state.error == null
          ? const Center(child: CircularProgressIndicator())
          : _state.error != null && dash == null
              ? _ErrorView(message: _state.error!, onRetry: _load)
              : Column(
                  children: [
                    _TopBar(
                      dashboardName: dash?.name ?? 'Dashboard',
                      editMode: _state.editMode,
                      saving: _state.saving,
                      isDirty: _state.isDirty,
                      onBack: () => context.pop(),
                      onToggleMode: () {
                        final nextEditMode = !_state.editMode;
                        setState(() {
                          _state = _state.copyWith(
                            editMode: nextEditMode,
                            clearSelectedId: true,
                            widgets: nextEditMode
                                ? _state.widgets
                                    .map(
                                      (widget) => widget.copyWith(
                                        clearResolvedData: true,
                                      ),
                                    )
                                    .toList()
                                : _state.widgets,
                          );
                        });
                        _startAutoRefresh();
                        if (!nextEditMode) {
                          _load(
                            includeData: true,
                            preserveLocalWidgets: true,
                          );
                        }
                      },
                      onSave: _save,
                      onShare: _share,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          if (_state.editMode)
                            _WidgetLibrarySidebar(onAdd: _addWidget),
                          Expanded(
                            child: _Canvas(
                              widgets: _state.widgets,
                              selectedId: _state.selectedId,
                              editMode: _state.editMode,
                              canvas: dash?.canvas,
                              transformationController:
                                  _transformationController,
                              onSelect: (id) => setState(
                                () => _state = _state.copyWith(selectedId: id),
                              ),
                              onDeselect: () => setState(
                                () => _state =
                                    _state.copyWith(clearSelectedId: true),
                              ),
                              onMove: (id, dx, dy) {
                                final w = _state.widgets
                                    .firstWhere((x) => x.id == id);
                                _updateWidget(w.copyWith(
                                  x: (w.x + dx).clamp(0, 1820),
                                  y: (w.y + dy).clamp(0, 1000),
                                ));
                              },
                              onResize: (id, dw, dh) {
                                final w = _state.widgets
                                    .firstWhere((x) => x.id == id);
                                _updateWidget(w.copyWith(
                                  width: (w.width + dw).clamp(80, 1200),
                                  height: (w.height + dh).clamp(40, 900),
                                ));
                              },
                            ),
                          ),
                          if (_state.editMode && _selectedWidget != null)
                            _PropertyPanel(
                              widget: _selectedWidget!,
                              onUpdate: _updateWidget,
                              onDelete: _deleteSelected,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}

// ─── Top Bar ──────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final String dashboardName;
  final bool editMode;
  final bool saving;
  final bool isDirty;
  final VoidCallback onBack;
  final VoidCallback onToggleMode;
  final VoidCallback onSave;
  final VoidCallback onShare;

  const _TopBar({
    required this.dashboardName,
    required this.editMode,
    required this.saving,
    required this.isDirty,
    required this.onBack,
    required this.onToggleMode,
    required this.onSave,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: cs.surface,
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: onBack,
            tooltip: 'Back',
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              dashboardName,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: cs.onSurface,
              ),
            ),
          ),
          if (isDirty) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Unsaved',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: Colors.orange[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          const SizedBox(width: 12),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Mode toggle
                    Container(
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(3),
                      child: Row(
                        children: [
                          _ModeChip(
                            label: 'Edit',
                            icon: Icons.edit_outlined,
                            active: editMode,
                            onTap: editMode ? null : onToggleMode,
                          ),
                          _ModeChip(
                            label: 'Preview',
                            icon: Icons.visibility_outlined,
                            active: !editMode,
                            onTap: editMode ? onToggleMode : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (editMode) ...[
                      FilledButton.icon(
                        onPressed: saving ? null : onSave,
                        icon: saving
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.save_outlined, size: 18),
                        label: Text(saving ? 'Saving…' : 'Save'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    OutlinedButton.icon(
                      onPressed: onShare,
                      icon: const Icon(Icons.share_outlined, size: 18),
                      label: const Text('Share'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback? onTap;

  const _ModeChip({
    required this.label,
    required this.icon,
    required this.active,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: active ? cs.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: active ? cs.onPrimary : cs.onSurface),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: active ? cs.onPrimary : cs.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Widget Library Sidebar ───────────────────────────────────────────────────

class _WidgetLibrarySidebar extends StatelessWidget {
  final void Function(DashboardWidgetType) onAdd;

  const _WidgetLibrarySidebar({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const types = DashboardWidgetType.values;

    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        border: Border(right: BorderSide(color: cs.outlineVariant, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Widgets',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: cs.onSurfaceVariant,
                letterSpacing: 0.8,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              itemCount: types.length,
              itemBuilder: (context, i) {
                final type = types[i];
                return _WidgetLibraryItem(
                  type: type,
                  onTap: () => onAdd(type),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _WidgetLibraryItem extends StatefulWidget {
  final DashboardWidgetType type;
  final VoidCallback onTap;

  const _WidgetLibraryItem({required this.type, required this.onTap});

  @override
  State<_WidgetLibraryItem> createState() => _WidgetLibraryItemState();
}

class _WidgetLibraryItemState extends State<_WidgetLibraryItem> {
  bool _hover = false;

  IconData get _icon => switch (widget.type) {
        DashboardWidgetType.kpiCard => Icons.speed_outlined,
        DashboardWidgetType.barChart => Icons.bar_chart_rounded,
        DashboardWidgetType.lineChart => Icons.show_chart_rounded,
        DashboardWidgetType.pieChart => Icons.pie_chart_outline_rounded,
        DashboardWidgetType.dataTable => Icons.table_chart_outlined,
        DashboardWidgetType.textLabel => Icons.text_fields_rounded,
        DashboardWidgetType.imageWidget => Icons.image_outlined,
        DashboardWidgetType.filterWidget => Icons.filter_list_rounded,
      };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          margin: const EdgeInsets.symmetric(vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          decoration: BoxDecoration(
            color: _hover
                ? cs.primary.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                _icon,
                size: 18,
                color: _hover ? cs.primary : cs.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.type.label,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: _hover ? cs.primary : cs.onSurface,
                    fontWeight: _hover ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              Icon(Icons.add_rounded,
                  size: 14, color: _hover ? cs.primary : Colors.transparent),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Canvas ───────────────────────────────────────────────────────────────────

class _Canvas extends StatelessWidget {
  final List<DashboardWidget> widgets;
  final String? selectedId;
  final bool editMode;
  final DashboardCanvas? canvas;
  final TransformationController transformationController;
  final void Function(String id) onSelect;
  final VoidCallback onDeselect;
  final void Function(String id, double dx, double dy) onMove;
  final void Function(String id, double dw, double dh) onResize;

  const _Canvas({
    required this.widgets,
    required this.selectedId,
    required this.editMode,
    required this.canvas,
    required this.transformationController,
    required this.onSelect,
    required this.onDeselect,
    required this.onMove,
    required this.onResize,
  });

  Color _hexColor(String hex) {
    try {
      final h = hex.replaceAll('#', '');
      return Color(0xFF000000 | int.parse(h, radix: 16));
    } catch (_) {
      return const Color(0xFFF5F5F5);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _hexColor(canvas?.backgroundColor ?? '#F5F5F5');
    final canvasW = canvas?.width ?? 1920;
    final canvasH = canvas?.height ?? 1080;

    return GestureDetector(
      onTap: editMode ? onDeselect : null,
      child: Container(
        color: const Color(0xFF1A1A2E),
        child: InteractiveViewer(
          transformationController: transformationController,
          minScale: 0.2,
          maxScale: 2.5,
          constrained: false,
          child: Container(
            width: canvasW,
            height: canvasH,
            color: bgColor,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Grid dots in edit mode
                if (editMode)
                  Positioned.fill(
                    child: CustomPaint(painter: _GridPainter()),
                  ),
                // Widgets
                for (final w in widgets)
                  _CanvasWidget(
                    key: ValueKey(w.id),
                    widget: w,
                    isSelected: w.id == selectedId,
                    editMode: editMode,
                    onSelect: () => onSelect(w.id),
                    onMove: (dx, dy) => onMove(w.id, dx, dy),
                    onResize: (dw, dh) => onResize(w.id, dw, dh),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x22000000)
      ..strokeWidth = 1;
    const step = 20.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawCircle(Offset(x, 0), 0.5, paint);
      for (double y = 0; y < size.height; y += step) {
        canvas.drawCircle(Offset(x, y), 0.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_GridPainter _) => false;
}

// ─── Canvas Widget (draggable, resizable) ─────────────────────────────────────

class _CanvasWidget extends StatefulWidget {
  final DashboardWidget widget;
  final bool isSelected;
  final bool editMode;
  final VoidCallback onSelect;
  final void Function(double dx, double dy) onMove;
  final void Function(double dw, double dh) onResize;

  const _CanvasWidget({
    super.key,
    required this.widget,
    required this.isSelected,
    required this.editMode,
    required this.onSelect,
    required this.onMove,
    required this.onResize,
  });

  @override
  State<_CanvasWidget> createState() => _CanvasWidgetState();
}

class _CanvasWidgetState extends State<_CanvasWidget> {
  Offset? _dragStart;
  Offset? _resizeStart;
  double? _startW;
  double? _startH;

  @override
  Widget build(BuildContext context) {
    final w = widget.widget;
    final sel = widget.isSelected;
    final cs = Theme.of(context).colorScheme;

    return Positioned(
      left: w.x,
      top: w.y,
      child: GestureDetector(
        onTap: widget.editMode ? widget.onSelect : null,
        onPanStart: widget.editMode && !w.isLocked
            ? (d) {
                widget.onSelect();
                _dragStart = d.globalPosition;
              }
            : null,
        onPanUpdate: widget.editMode && !w.isLocked
            ? (d) {
                if (_dragStart == null) return;
                final delta = d.globalPosition - _dragStart!;
                _dragStart = d.globalPosition;
                widget.onMove(delta.dx, delta.dy);
              }
            : null,
        onPanEnd: widget.editMode ? (_) => _dragStart = null : null,
        child: SizedBox(
          width: w.width,
          height: w.height,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Widget body
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: sel
                      ? Border.all(color: cs.primary, width: 2)
                      : Border.all(color: Colors.transparent),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _WidgetContent(widget: w),
                ),
              ),
              // Resize handle (bottom-right)
              if (sel && widget.editMode && !w.isLocked)
                Positioned(
                  right: -6,
                  bottom: -6,
                  child: GestureDetector(
                    onPanStart: (d) {
                      _resizeStart = d.globalPosition;
                      _startW = w.width;
                      _startH = w.height;
                    },
                    onPanUpdate: (d) {
                      if (_resizeStart == null) return;
                      final delta = d.globalPosition - _resizeStart!;
                      final newW = (_startW! + delta.dx).clamp(80.0, 1200.0);
                      final newH = (_startH! + delta.dy).clamp(40.0, 900.0);
                      widget.onResize(newW - w.width, newH - w.height);
                    },
                    onPanEnd: (_) {
                      _resizeStart = null;
                      _startW = null;
                      _startH = null;
                    },
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: cs.primary,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Icon(Icons.open_in_full_rounded,
                          size: 8, color: cs.onPrimary),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Widget Content Renderer ──────────────────────────────────────────────────

class _WidgetContent extends StatelessWidget {
  final DashboardWidget widget;

  const _WidgetContent({required this.widget});

  @override
  Widget build(BuildContext context) {
    return switch (widget.type) {
      DashboardWidgetType.kpiCard => _KpiCard(widget: widget),
      DashboardWidgetType.barChart => _ChartPlaceholder(widget: widget, icon: Icons.bar_chart_rounded),
      DashboardWidgetType.lineChart => _ChartPlaceholder(widget: widget, icon: Icons.show_chart_rounded),
      DashboardWidgetType.pieChart => _ChartPlaceholder(widget: widget, icon: Icons.pie_chart_rounded),
      DashboardWidgetType.dataTable => _DataTableWidget(widget: widget),
      DashboardWidgetType.textLabel => _TextLabelWidget(widget: widget),
      DashboardWidgetType.imageWidget => _ImageWidget(widget: widget),
      DashboardWidgetType.filterWidget => _FilterWidget(widget: widget),
    };
  }
}

// ─── KPI Card ─────────────────────────────────────────────────────────────────

class _KpiCard extends StatelessWidget {
  final DashboardWidget widget;
  const _KpiCard({required this.widget});

  Color _hexColor(String? hex) {
    if (hex == null) return const Color(0xFF6366F1);
    try {
      return Color(0xFF000000 | int.parse(hex.replaceAll('#', ''), radix: 16));
    } catch (_) {
      return const Color(0xFF6366F1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final props = widget.properties;
    final title = props['title'] as String? ?? 'Metric';
    final accentColor = _hexColor(props['color_scheme'] as String?);
    final resolvedData = widget.resolvedData;
    String valueStr = '—';
    if (resolvedData is Map && resolvedData['value'] != null) {
      valueStr = resolvedData['value'].toString();
    } else if (resolvedData is num) {
      valueStr = resolvedData.toString();
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [accentColor.withOpacity(0.9), accentColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.white.withOpacity(0.85),
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            valueStr,
            style: GoogleFonts.inter(
              fontSize: 32,
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Chart Placeholder ────────────────────────────────────────────────────────

class _ChartPlaceholder extends StatelessWidget {
  final DashboardWidget widget;
  final IconData icon;
  const _ChartPlaceholder({required this.widget, required this.icon});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final props = widget.properties;
    final title = props['title'] as String? ?? 'Chart';

    return Container(
      color: cs.surfaceContainerLowest,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: cs.onSurface,
            ),
          ),
          Expanded(
            child: widget.resolvedData != null
                ? _SimpleBarChart(data: widget.resolvedData, widgetType: widget.type)
                : Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, size: 40, color: cs.outlineVariant),
                        const SizedBox(height: 8),
                        Text(
                          'Bind to an analysis node\nto see data',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _SimpleBarChart extends StatelessWidget {
  final dynamic data;
  final DashboardWidgetType widgetType;
  const _SimpleBarChart({required this.data, required this.widgetType});

  @override
  Widget build(BuildContext context) {
    // Render raw data as a simple visual representation
    final cs = Theme.of(context).colorScheme;
    if (data is! Map && data is! List) {
      return Center(child: Text(data.toString(), style: GoogleFonts.inter(fontSize: 10)));
    }
    final items = data is List ? data as List : (data as Map).entries.toList();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(
        math.min(items.length, 12),
        (i) {
          final h = (math.Random(i).nextDouble() * 0.8 + 0.1);
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: FractionallySizedBox(
                alignment: Alignment.bottomCenter,
                heightFactor: h,
                child: Container(
                  decoration: BoxDecoration(
                    color: cs.primary.withOpacity(0.7 + (i % 3) * 0.1),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── Data Table ───────────────────────────────────────────────────────────────

class _DataTableWidget extends StatelessWidget {
  final DashboardWidget widget;
  const _DataTableWidget({required this.widget});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final props = widget.properties;
    final title = props['title'] as String? ?? 'Data Table';
    final data = widget.resolvedData;

    return Container(
      color: cs.surfaceContainerLowest,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text(
              title,
              style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface),
            ),
          ),
          Expanded(
            child: data == null
                ? Center(
                    child: Text(
                      'No data bound',
                      style: GoogleFonts.inter(
                        color: cs.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    child: Text(
                      data.toString(),
                      style: GoogleFonts.sourceCodePro(fontSize: 10),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ─── Text Label ───────────────────────────────────────────────────────────────

class _TextLabelWidget extends StatelessWidget {
  final DashboardWidget widget;
  const _TextLabelWidget({required this.widget});

  @override
  Widget build(BuildContext context) {
    final props = widget.properties;
    final content = props['content'] as String? ?? 'Label';
    final fontSize = (props['font_size'] as num?)?.toDouble() ?? 16;
    final colorHex = props['color'] as String? ?? '#1F2937';
    Color textColor;
    try {
      textColor = Color(
          0xFF000000 | int.parse(colorHex.replaceAll('#', ''), radix: 16));
    } catch (_) {
      textColor = const Color(0xFF1F2937);
    }

    return Container(
      color: Colors.transparent,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        content,
        style: GoogleFonts.inter(
          fontSize: fontSize,
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ─── Image Widget ─────────────────────────────────────────────────────────────

class _ImageWidget extends StatelessWidget {
  final DashboardWidget widget;
  const _ImageWidget({required this.widget});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final props = widget.properties;
    final url = props['url'] as String? ?? '';
    final alt = props['alt'] as String? ?? 'Image';

    if (url.isEmpty) {
      return Container(
        color: cs.surfaceContainerHighest,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.image_outlined, size: 36, color: cs.outlineVariant),
              const SizedBox(height: 6),
              Text(alt, style: GoogleFonts.inter(fontSize: 12, color: cs.onSurfaceVariant)),
            ],
          ),
        ),
      );
    }
    return Image.network(url, fit: BoxFit.cover, errorBuilder: (_, __, ___) {
      return Container(
        color: cs.errorContainer,
        child: Center(child: Icon(Icons.broken_image_outlined, color: cs.error)),
      );
    });
  }
}

// ─── Filter Widget ────────────────────────────────────────────────────────────

class _FilterWidget extends StatelessWidget {
  final DashboardWidget widget;
  const _FilterWidget({required this.widget});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final props = widget.properties;
    final label = props['label'] as String? ?? 'Filter';

    return Container(
      color: cs.surfaceContainerLowest,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Icon(Icons.filter_list_rounded,
              size: 16, color: cs.onSurfaceVariant),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(fontSize: 13, color: cs.onSurface),
            ),
          ),
          Icon(Icons.arrow_drop_down, color: cs.onSurfaceVariant),
        ],
      ),
    );
  }
}

// ─── Property Panel ───────────────────────────────────────────────────────────

class _PropertyPanel extends StatefulWidget {
  final DashboardWidget widget;
  final void Function(DashboardWidget) onUpdate;
  final VoidCallback onDelete;

  const _PropertyPanel({
    required this.widget,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<_PropertyPanel> createState() => _PropertyPanelState();
}

class _PropertyPanelState extends State<_PropertyPanel> {
  late TextEditingController _titleCtrl;
  late TextEditingController _contentCtrl;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  @override
  void didUpdateWidget(_PropertyPanel old) {
    super.didUpdateWidget(old);
    if (old.widget.id != widget.widget.id) {
      _titleCtrl.dispose();
      _contentCtrl.dispose();
      _initControllers();
    }
  }

  void _initControllers() {
    _titleCtrl = TextEditingController(
      text: widget.widget.properties['title'] as String? ??
          widget.widget.properties['content'] as String? ??
          '',
    );
    _contentCtrl = TextEditingController(
      text: widget.widget.properties['content'] as String? ?? '',
    );
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  void _updateProp(String key, dynamic value) {
    final props = Map<String, dynamic>.from(widget.widget.properties);
    props[key] = value;
    widget.onUpdate(widget.widget.copyWith(properties: props));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final w = widget.widget;

    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        border: Border(left: BorderSide(color: cs.outlineVariant, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Text(
                  'Properties',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurfaceVariant,
                    letterSpacing: 0.8,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, size: 18),
                  color: cs.error,
                  onPressed: widget.onDelete,
                  tooltip: 'Delete widget',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              children: [
                // Type badge
                _PanelSection(
                  label: 'TYPE',
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: cs.primaryContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      w.type.label,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: cs.onPrimaryContainer,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Title / Content
                if (w.type != DashboardWidgetType.imageWidget &&
                    w.type != DashboardWidgetType.filterWidget)
                  _PanelSection(
                    label: w.type == DashboardWidgetType.textLabel
                        ? 'CONTENT'
                        : 'TITLE',
                    child: TextField(
                      controller: _titleCtrl,
                      onChanged: (v) => _updateProp(
                        w.type == DashboardWidgetType.textLabel
                            ? 'content'
                            : 'title',
                        v,
                      ),
                      decoration: _inputDec(context, 'Enter text'),
                      style: GoogleFonts.inter(fontSize: 13),
                    ),
                  ),
                const SizedBox(height: 12),
                // Position & Size
                _PanelSection(
                  label: 'POSITION & SIZE',
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _NumField(
                              label: 'X',
                              value: w.x,
                              onChanged: (v) =>
                                  widget.onUpdate(w.copyWith(x: v)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _NumField(
                              label: 'Y',
                              value: w.y,
                              onChanged: (v) =>
                                  widget.onUpdate(w.copyWith(y: v)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: _NumField(
                              label: 'W',
                              value: w.width,
                              onChanged: (v) =>
                                  widget.onUpdate(w.copyWith(width: v)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _NumField(
                              label: 'H',
                              value: w.height,
                              onChanged: (v) =>
                                  widget.onUpdate(w.copyWith(height: v)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Lock toggle
                _PanelSection(
                  label: 'LOCK',
                  child: Row(
                    children: [
                      Switch.adaptive(
                        value: w.isLocked,
                        onChanged: (v) =>
                            widget.onUpdate(w.copyWith(isLocked: v)),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        w.isLocked ? 'Locked' : 'Unlocked',
                        style: GoogleFonts.inter(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Data Binding
                _PanelSection(
                  label: 'DATA BINDING',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Refresh mode',
                        style: GoogleFonts.inter(
                            fontSize: 11, color: cs.onSurfaceVariant),
                      ),
                      const SizedBox(height: 4),
                      DropdownButtonFormField<String>(
                        value: w.dataBinding.refreshMode,
                        decoration: _inputDec(context, ''),
                        style: GoogleFonts.inter(fontSize: 12, color: cs.onSurface),
                        items: const [
                          DropdownMenuItem(
                              value: 'with_dashboard',
                              child: Text('With dashboard')),
                          DropdownMenuItem(
                              value: 'independent',
                              child: Text('Independent')),
                          DropdownMenuItem(
                              value: 'never', child: Text('Never')),
                        ],
                        onChanged: (v) {
                          if (v == null) return;
                          widget.onUpdate(w.copyWith(
                            dataBinding: w.dataBinding.copyWith(refreshMode: v),
                          ));
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDec(BuildContext context, String hint) {
    final cs = Theme.of(context).colorScheme;
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(
          fontSize: 12, color: cs.onSurfaceVariant.withOpacity(0.5)),
      filled: true,
      fillColor: cs.surfaceContainerHighest.withOpacity(0.4),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: cs.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: cs.outlineVariant),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      isDense: true,
    );
  }
}

class _PanelSection extends StatelessWidget {
  final String label;
  final Widget child;
  const _PanelSection({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: cs.onSurfaceVariant.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 4),
        child,
      ],
    );
  }
}

class _NumField extends StatelessWidget {
  final String label;
  final double value;
  final void Function(double) onChanged;
  const _NumField({required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return TextField(
      controller: TextEditingController(text: value.toStringAsFixed(0)),
      onChanged: (v) {
        final parsed = double.tryParse(v);
        if (parsed != null) onChanged(parsed);
      },
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.inter(fontSize: 11),
        filled: true,
        fillColor: cs.surfaceContainerHighest.withOpacity(0.4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        isDense: true,
      ),
      style: GoogleFonts.inter(fontSize: 12),
    );
  }
}

// ─── Error view ───────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 12),
          Text(message),
          const SizedBox(height: 16),
          FilledButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
