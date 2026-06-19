"""
lib/modules/analysis_coder/services/analysis_service.dart
Service for analysis API operations.
"""

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../models/analysis_models.dart';
import '../../core/services/api_service.dart';
import '../../core/providers/auth_provider.dart';

class AnalysisService {
  final ApiService _apiService;
  final String _baseUrl;
  
  AnalysisService() : _apiService = ApiService(), _baseUrl = '/api/v1';
  
  Future<List<Analysis>> getAnalyses({String? projectId}) async {
    try {
      final response = await _apiService.get(
        Uri.parse('$_baseUrl/projects/$projectId/analyses'),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final items = data['items'] as List;
        return items.map((item) => Analysis.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load analyses: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error loading analyses: $e');
      rethrow;
    }
  }
  
  Future<Analysis> getAnalysis(String analysisId, {String? projectId}) async {
    try {
      final response = await _apiService.get(
        Uri.parse('$_baseUrl/projects/$projectId/analyses/$analysisId'),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return Analysis.fromJson(data);
      } else {
        throw Exception('Failed to load analysis: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error loading analysis: $e');
      rethrow;
    }
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
    try {
      final response = await _apiService.post(
        Uri.parse('$_baseUrl/projects/$projectId/analyses'),
        body: jsonEncode({
          'project_id': projectId,
          'name': name,
          'description': description,
          'linked_form_ids': linkedFormIds ?? [],
          'execution_modes': executionModes ?? ['on_demand'],
          'schedule': schedule,
          'reactive_debounce_ms': reactiveDebounceMs,
          'graph': graph.toJson(),
        }),
      );
      
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return Analysis.fromJson(data);
      } else {
        throw Exception('Failed to create analysis: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error creating analysis: $e');
      rethrow;
    }
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
    try {
      final body = <String, dynamic>{};
      
      if (name != null) body['name'] = name;
      if (description != null) body['description'] = description;
      if (linkedFormIds != null) body['linked_form_ids'] = linkedFormIds;
      if (executionModes != null) body['execution_modes'] = executionModes;
      if (schedule != null) body['schedule'] = schedule;
      if (reactiveDebounceMs != null) body['reactive_debounce_ms'] = reactiveDebounceMs;
      if (graph != null) body['graph'] = graph.toJson();
      
      final response = await _apiService.put(
        Uri.parse('$_baseUrl/projects/$projectId/analyses/$analysisId'),
        body: jsonEncode(body),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return Analysis.fromJson(data);
      } else {
        throw Exception('Failed to update analysis: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error updating analysis: $e');
      rethrow;
    }
  }
  
  Future<void> deleteAnalysis({
    required String analysisId,
    required String projectId,
  }) async {
    try {
      final response = await _apiService.delete(
        Uri.parse('$_baseUrl/projects/$projectId/analyses/$analysisId'),
      );
      
      if (response.statusCode != 200) {
        throw Exception('Failed to delete analysis: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error deleting analysis: $e');
      rethrow;
    }
  }
  
  Future<String> executeAnalysis({
    required String analysisId,
    required String projectId,
  }) async {
    try {
      final response = await _apiService.post(
        Uri.parse('$_baseUrl/projects/$projectId/analyses/$analysisId/execute'),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return data['task_id'] as String;
      } else {
        throw Exception('Failed to execute analysis: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error executing analysis: $e');
      rethrow;
    }
  }
  
  Future<List<AnalysisRun>> getAnalysisRuns({
    required String analysisId,
    required String projectId,
    int page = 1,
    int pageSize = 50,
  }) async {
    try {
      final response = await _apiService.get(
        Uri.parse('$_baseUrl/projects/$projectId/analyses/$analysisId/runs'
            '?page=$page&page_size=$pageSize'),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final items = data['items'] as List;
        return items.map((item) => AnalysisRun.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load analysis runs: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error loading analysis runs: $e');
      rethrow;
    }
  }
  
  Future<AnalysisRun> getAnalysisRun({
    required String analysisId,
    required String projectId,
    required String runId,
  }) async {
    try {
      final response = await _apiService.get(
        Uri.parse('$_baseUrl/projects/$projectId/analyses/$analysisId/runs/$runId'),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return AnalysisRun.fromJson(data['run']);
      } else {
        throw Exception('Failed to load analysis run: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error loading analysis run: $e');
      rethrow;
    }
  }
  
  Future<List<AnalysisResult>> getAnalysisResults({
    required String analysisId,
    required String projectId,
    String? runId,
  }) async {
    try {
      String url = '$_baseUrl/projects/$projectId/analyses/$analysisId/runs';
      if (runId != null) {
        url += '/$runId';
      }
      
      final response = await _apiService.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final results = data['results'] as List;
        return results.map((item) => AnalysisResult.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load analysis results: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error loading analysis results: $e');
      rethrow;
    }
  }
  
  Future<AnalysisExport> createExport({
    required String analysisId,
    required String projectId,
    required String format,
    List<String>? nodeIds,
    String? runId,
    String? filename,
  }) async {
    try {
      final response = await _apiService.post(
        Uri.parse('$_baseUrl/projects/$projectId/analyses/$analysisId/exports'),
        body: jsonEncode({
          'format': format,
          'node_ids': nodeIds ?? [],
          'run_id': runId,
          'filename': filename,
        }),
      );
      
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return AnalysisExport.fromJson(data);
      } else {
        throw Exception('Failed to create export: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error creating export: $e');
      rethrow;
    }
  }
  
  Future<AnalysisExport> getExport({
    required String analysisId,
    required String projectId,
    required String exportId,
  }) async {
    try {
      final response = await _apiService.get(
        Uri.parse('$_baseUrl/projects/$projectId/analyses/$analysisId/exports/$exportId'),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return AnalysisExport.fromJson(data);
      } else {
        throw Exception('Failed to load export: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error loading export: $e');
      rethrow;
    }
  }
  
  Future<String> downloadExport({
    required String analysisId,
    required String projectId,
    required String exportId,
  }) async {
    try {
      final response = await _apiService.get(
        Uri.parse('$_baseUrl/projects/$projectId/analyses/$analysisId/exports/$exportId/download'),
      );
      
      if (response.statusCode == 200) {
        // Return the file URL or handle download
        return response.body;
      } else {
        throw Exception('Failed to download export: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error downloading export: $e');
      rethrow;
    }
  }
  
  Future<Map<String, dynamic>> getAnalysisStats({
    required String analysisId,
    required String projectId,
  }) async {
    try {
      final response = await _apiService.get(
        Uri.parse('$_baseUrl/projects/$projectId/analyses/$analysisId/stats'),
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load analysis stats: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error loading analysis stats: $e');
      rethrow;
    }
  }
  
  Stream<List<AnalysisRun>> getAnalysisRunsStream(String analysisId) {
    // Simulate real-time updates with periodic polling
    return Stream.periodic(
      const Duration(seconds: 5),
      (_) => getAnalysisRuns(analysisId: analysisId, projectId: ''),
    ).asyncMap((event) async {
      try {
        return await event;
      } catch (e) {
        debugPrint('Error in analysis runs stream: $e');
        return <AnalysisRun>[];
      }
    });
  }
  
  String generateNodeId() {
    return 'node_${const Uuid().v4()}';
  }
  
  AnalysisGraph createEmptyGraph() {
    return AnalysisGraph(
      nodes: [],
      edges: [],
    );
  }
  
  AnalysisNode createNodeFromDefinition(NodeDefinition definition, Offset position) {
    return AnalysisNode(
      id: generateNodeId(),
      nodeType: definition.type,
      name: definition.name,
      description: definition.description,
      config: Map<String, dynamic>.from(definition.defaultConfig),
      inputPorts: definition.inputPorts,
      outputPorts: definition.outputPorts,
      position: {'x': position.dx, 'y': position.dy},
    );
  }
  
  bool validateGraph(AnalysisGraph graph) {
    // Check for cycles and validate connections
    final nodes = graph.nodes;
    final edges = graph.edges;
    
    // Build adjacency list
    final adjacency = <String, List<String>>{};
    for (final node in nodes) {
      adjacency[node.id] = [];
    }
    
    for (final edge in edges) {
      adjacency[edge.source]?.add(edge.target);
    }
    
    // Check for cycles using DFS
    final visited = <String>{};
    final recursionStack = <String>{};
    
    bool hasCycle(String nodeId) {
      visited.add(nodeId);
      recursionStack.add(nodeId);
      
      for (final neighbor in adjacency[nodeId]!) {
        if (!visited.contains(neighbor)) {
          if (hasCycle(neighbor)) {
            return true;
          }
        } else if (recursionStack.contains(neighbor)) {
          return true;
        }
      }
      
      recursionStack.remove(nodeId);
      return false;
    }
    
    for (final node in nodes) {
      if (!visited.contains(node.id) && hasCycle(node.id)) {
        return false;
      }
    }
    
    return true;
  }
}