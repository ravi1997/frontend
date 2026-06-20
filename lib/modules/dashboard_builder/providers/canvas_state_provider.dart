import 'package:flutter_riverpod/legacy.dart';
import 'package:frontend/modules/dashboard_builder/models/dashboard_canvas_models.dart';

enum CanvasMode { edit, preview }

class CanvasState {
  final CanvasMode mode;
  final DashboardCanvas canvas;
  final bool isDirty;
  final double scale;
  final String? selectedWidgetId;

  CanvasState({
    required this.mode,
    required this.canvas,
    this.isDirty = false,
    this.scale = 1.0,
    this.selectedWidgetId,
  });

  CanvasState copyWith({
    CanvasMode? mode,
    DashboardCanvas? canvas,
    bool? isDirty,
    double? scale,
    String? selectedWidgetId,
    bool clearSelection = false,
  }) {
    return CanvasState(
      mode: mode ?? this.mode,
      canvas: canvas ?? this.canvas,
      isDirty: isDirty ?? this.isDirty,
      scale: scale ?? this.scale,
      selectedWidgetId: clearSelection ? null : (selectedWidgetId ?? this.selectedWidgetId),
    );
  }
}

class CanvasStateNotifier extends StateNotifier<CanvasState> {
  final DashboardCanvas canvasArg;
  CanvasStateNotifier(this.canvasArg)
      : super(
          CanvasState(
            mode: CanvasMode.edit,
            canvas: canvasArg,
            isDirty: false,
            scale: 1.0,
          ),
        );

  void setMode(CanvasMode mode) {
    state = state.copyWith(mode: mode);
  }

  void updateCanvas(DashboardCanvas newCanvas) {
    state = state.copyWith(canvas: newCanvas, isDirty: true);
  }

  void setScale(double scale) {
    state = state.copyWith(scale: scale.clamp(0.5, 2.0));
  }

  void selectWidget(String? id) {
    if (id == null) {
      state = state.copyWith(clearSelection: true);
    } else {
      state = state.copyWith(selectedWidgetId: id);
    }
  }

  void markClean() {
    state = state.copyWith(isDirty: false);
  }
}

final canvasStateProvider = StateNotifierProvider.family<
    CanvasStateNotifier,
    CanvasState,
    DashboardCanvas>(
  (ref, canvas) => CanvasStateNotifier(canvas),
);
