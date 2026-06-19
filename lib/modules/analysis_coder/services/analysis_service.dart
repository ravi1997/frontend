import '../models/analysis_models.dart';

class AnalysisService {
  Future<Analysis?> getAnalysis(String analysisId, {String? projectId}) async {
    return null;
  }

  Future<Analysis> createAnalysis({
    required String projectId,
    required String name,
    String? description,
    List<String>? linkedFormIds,
    List<String>? executionModes,
    String? schedule,
    int reactiveDebounceMs = 1000,
    required AnalysisGraph graph,
  }) async {
    return Analysis(
      id: '',
      orgId: '',
      projectId: projectId,
      name: name,
      description: description,
      linkedFormIds: linkedFormIds ?? const [],
      executionModes: executionModes ?? const ['on_demand'],
      schedule: schedule,
      reactiveDebounceMs: reactiveDebounceMs,
      graph: graph,
      lastRunId: null,
      status: 'idle',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      createdBy: '',
    );
  }

  Future<Analysis> updateAnalysis({
    required String analysisId,
    required String projectId,
    String? name,
    String? description,
    List<String>? linkedFormIds,
    List<String>? executionModes,
    String? schedule,
    int? reactiveDebounceMs,
    AnalysisGraph? graph,
  }) async {
    return createAnalysis(
      projectId: projectId,
      name: name ?? 'Analysis',
      description: description,
      linkedFormIds: linkedFormIds,
      executionModes: executionModes,
      schedule: schedule,
      reactiveDebounceMs: reactiveDebounceMs ?? 1000,
      graph: graph ?? AnalysisGraph(nodes: [], edges: []),
    );
  }
}
