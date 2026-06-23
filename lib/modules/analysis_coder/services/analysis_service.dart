// lib/modules/analysis_coder/services/analysis_service.dart
// API integration service for visual data analysis pipelines.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/networking/api_client.dart';
import 'package:frontend/core/networking/dio_provider.dart';
import '../models/analysis_models.dart';

final analysisServiceProvider = Provider<AnalysisService>((ref) {
  return AnalysisService(ref.watch(apiClientProvider));
});

class AnalysisService {
  final ApiClient _apiClient;

  AnalysisService(this._apiClient);

  /// Fetch analysis details by ID
  Future<Analysis?> getAnalysis(String analysisId, {required String projectId}) async {
    try {
      final data = await _apiClient.getMap('/projects/$projectId/analyses/$analysisId');
      final nested = data['data'];
      if (nested is Map<String, dynamic>) {
        return Analysis.fromJson(nested);
      }
      return Analysis.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  /// Create a new analysis
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
    final payload = {
      'project_id': projectId,
      'name': name,
      'description': description,
      'linked_form_ids': linkedFormIds ?? const [],
      'execution_modes': executionModes ?? const ['on_demand'],
      'schedule': schedule,
      'reactive_debounce_ms': reactiveDebounceMs,
      'graph': graph.toJson(),
    };
    final data = await _apiClient.postMap('/projects/$projectId/analyses', data: payload);
    final nested = data['data'];
    if (nested is Map<String, dynamic>) {
      return Analysis.fromJson(nested);
    }
    return Analysis.fromJson(data);
  }

  /// Update an existing analysis
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
    final payload = <String, dynamic>{};
    if (name != null) payload['name'] = name;
    if (description != null) payload['description'] = description;
    if (linkedFormIds != null) payload['linked_form_ids'] = linkedFormIds;
    if (executionModes != null) payload['execution_modes'] = executionModes;
    if (schedule != null) payload['schedule'] = schedule;
    if (reactiveDebounceMs != null) payload['reactive_debounce_ms'] = reactiveDebounceMs;
    if (graph != null) payload['graph'] = graph.toJson();

    final data = await _apiClient.putMap('/projects/$projectId/analyses/$analysisId', data: payload);
    final nested = data['data'];
    if (nested is Map<String, dynamic>) {
      return Analysis.fromJson(nested);
    }
    return Analysis.fromJson(data);
  }

  /// Delete an analysis
  Future<void> deleteAnalysis(String projectId, String analysisId) async {
    await _apiClient.delete('/projects/$projectId/analyses/$analysisId');
  }

  /// Trigger manual execution of the analysis
  Future<Map<String, dynamic>> executeAnalysis(String projectId, String analysisId) async {
    final data = await _apiClient.postMap('/projects/$projectId/analyses/$analysisId/execute');
    final nested = data['data'];
    if (nested is Map<String, dynamic>) {
      return nested;
    }
    return data;
  }

  /// Get status & results of a specific analysis run
  Future<Map<String, dynamic>> getAnalysisRun(String projectId, String analysisId, String runId) async {
    final data = await _apiClient.getMap('/projects/$projectId/analyses/$analysisId/runs/$runId');
    final nested = data['data'];
    if (nested is Map<String, dynamic>) {
      return nested;
    }
    return data;
  }
}
