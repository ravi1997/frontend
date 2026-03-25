import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/analysis_dashboard.dart';
import 'analysis_builder_state.dart';
import '../providers/analytics_providers.dart';
import '../../../form_builder/domain/repositories/form_builder_repository.dart';

part 'analysis_builder_controller.g.dart';

@riverpod
class AnalysisBuilderController extends _$AnalysisBuilderController {
  @override
  AnalysisBuilderState build(String? dashboardId) {
    if (dashboardId == null) {
      return AnalysisBuilderState(
        dashboard: AnalysisDashboard(
          id: '',
          title: 'New Dashboard',
          layout: 'grid',
          widgets: [],
        ),
      );
    }

    _loadDashboard(dashboardId);

    return AnalysisBuilderState(
      isLoading: true,
      dashboard: AnalysisDashboard(
        id: dashboardId,
        title: 'Loading...',
        widgets: [],
      ),
    );
  }

  Future<void> _loadDashboard(String id) async {
    // Repository call would go here
    state = state.copyWith(isLoading: false);
  }

  Future<void> saveDashboard() async {
    state = state.copyWith(isSaving: true);
    try {
      final repo = ref.read(analysisDashboardRepositoryProvider);
      if (state.dashboard.id.isEmpty) {
        await repo.createDashboard(state.dashboard);
      } else {
        await repo.updateDashboard(state.dashboard.id, state.dashboard);
      }
      state = state.copyWith(isSaving: false);
    } catch (e) {
      state = state.copyWith(isSaving: false, error: e.toString());
    }
  }

  void _saveToHistory() {
    final history = [...state.undoStack, state.dashboard];
    if (history.length > 50) history.removeAt(0);
    state = state.copyWith(undoStack: history, redoStack: []);
  }

  void undo() {
    if (state.undoStack.isEmpty) return;
    final previous = state.undoStack.last;
    final newUndo = List<AnalysisDashboard>.from(state.undoStack)..removeLast();
    state = state.copyWith(
      redoStack: [state.dashboard, ...state.redoStack],
      undoStack: newUndo,
      dashboard: previous,
    );
  }

  void redo() {
    if (state.redoStack.isEmpty) return;
    final next = state.redoStack.first;
    final newRedo = List<AnalysisDashboard>.from(state.redoStack)..removeAt(0);
    state = state.copyWith(
      undoStack: [...state.undoStack, state.dashboard],
      redoStack: newRedo,
      dashboard: next,
    );
  }

  void addWidget(String type) {
    _saveToHistory();
    final newWidget = AnalysisWidget(
      id: const Uuid().v4(),
      title: 'New $type',
      type: type,
      positionX: 0,
      positionY: state.dashboard.widgets.length * 2,
      width: (type == 'kpi' || type == 'ai_insight') ? 2 : 4,
      height: (type == 'kpi' || type == 'ai_insight') ? 2 : 4,
    );

    final updatedWidgets = [...state.dashboard.widgets, newWidget];
    state = state.copyWith(
      dashboard: state.dashboard.copyWith(widgets: updatedWidgets),
      selectedWidgetId: newWidget.id,
    );
  }

  void applyTemplate(String templateName) {
    _saveToHistory();
    List<AnalysisWidget> templateWidgets = [];

    if (templateName == 'response_summary') {
      templateWidgets = [
        AnalysisWidget(
          id: const Uuid().v4(),
          title: 'Total Submissions',
          type: 'kpi',
          positionX: 0,
          positionY: 0,
          width: 2,
          height: 2,
          calculationType: 'count',
        ),
        AnalysisWidget(
          id: const Uuid().v4(),
          title: 'Submission Trend',
          type: 'chart_line',
          positionX: 2,
          positionY: 0,
          width: 6,
          height: 4,
          groupByField: 'created_at',
        ),
        AnalysisWidget(
          id: const Uuid().v4(),
          title: 'AI Summary',
          type: 'ai_insight',
          positionX: 0,
          positionY: 2,
          width: 2,
          height: 2,
        ),
      ];
    } else if (templateName == 'completion_funnel') {
      templateWidgets = [
        AnalysisWidget(
          id: const Uuid().v4(),
          title: 'Completion Rate',
          type: 'kpi',
          positionX: 0,
          positionY: 0,
          width: 2,
          height: 2,
          calculationType: 'average',
        ),
        AnalysisWidget(
          id: const Uuid().v4(),
          title: 'Field Participation',
          type: 'chart_bar',
          positionX: 2,
          positionY: 0,
          width: 6,
          height: 4,
        ),
      ];
    }

    state = state.copyWith(
      dashboard: state.dashboard.copyWith(widgets: templateWidgets),
    );
  }

  void selectWidget(String? id) {
    state = state.copyWith(selectedWidgetId: id);
  }

  void updateWidget(AnalysisWidget updatedWidget) {
    _saveToHistory();
    final updatedWidgets = state.dashboard.widgets.map((w) {
      return w.id == updatedWidget.id ? updatedWidget : w;
    }).toList();

    state = state.copyWith(
      dashboard: state.dashboard.copyWith(widgets: updatedWidgets),
    );
  }

  void removeWidget(String id) {
    _saveToHistory();
    final updatedWidgets = state.dashboard.widgets
        .where((w) => w.id != id)
        .toList();
    state = state.copyWith(
      dashboard: state.dashboard.copyWith(widgets: updatedWidgets),
      selectedWidgetId: state.selectedWidgetId == id
          ? null
          : state.selectedWidgetId,
    );
  }

  void updateDashboardTitle(String title) {
    _saveToHistory();
    state = state.copyWith(dashboard: state.dashboard.copyWith(title: title));
  }

  void updateWidgetPosition(String id, int x, int y) {
    // We don't save history for every drag step to avoid flood,
    // but maybe on position finish? Current implementation calls this in onPanEnd.
    _saveToHistory();
    final updatedWidgets = state.dashboard.widgets.map((w) {
      if (w.id == id) {
        return w.copyWith(positionX: x, positionY: y);
      }
      return w;
    }).toList();

    state = state.copyWith(
      dashboard: state.dashboard.copyWith(widgets: updatedWidgets),
    );
  }

  void updateWidgetSize(String id, int width, int height) {
    _saveToHistory();
    final updatedWidgets = state.dashboard.widgets.map((w) {
      if (w.id == id) {
        return w.copyWith(width: width, height: height);
      }
      return w;
    }).toList();

    state = state.copyWith(
      dashboard: state.dashboard.copyWith(widgets: updatedWidgets),
    );
  }
}

@riverpod
Future<List<String>> formFields(Ref ref, String? formId) async {
  if (formId == null) return [];
  try {
    final repo = ref.read(formBuilderRepositoryProvider);
    final form = await repo.getForm(formId);
    final List<String> fields = [];
    for (var section in form.sections) {
      for (var question in section.questions) {
        if (question.variableName != null &&
            question.variableName!.isNotEmpty) {
          fields.add(question.variableName!);
        } else {
          fields.add(question.label.toString());
        }
      }
    }
    return fields;
  } catch (e) {
    return [];
  }
}
