import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/analysis_dashboard.dart';

part 'analysis_builder_state.freezed.dart';

@freezed
abstract class AnalysisBuilderState with _$AnalysisBuilderState {
  const factory AnalysisBuilderState({
    required AnalysisDashboard dashboard,
    String? selectedWidgetId,
    @Default(false) bool isSaving,
    @Default(false) bool isLoading,
    @Default([]) List<AnalysisDashboard> undoStack,
    @Default([]) List<AnalysisDashboard> redoStack,
    String? error,
  }) = _AnalysisBuilderState;
}
