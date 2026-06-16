import 'package:dio/dio.dart';
import 'analysis_dashboard.dart';

class AnalysisDashboardRepository {
  final Dio _dio;

  AnalysisDashboardRepository(this._dio);

  Future<List<AnalysisDashboard>> listDashboards() async {
    final response = await _dio.get('/dashboard/');
    return (response.data as List)
        .map((json) => AnalysisDashboard.fromJson(json))
        .toList();
  }

  Future<AnalysisDashboard> getDashboard(String slug) async {
    final response = await _dio.get('/dashboard/$slug');
    return AnalysisDashboard.fromJson(response.data);
  }

  Future<AnalysisDashboard> createDashboard(
    AnalysisDashboard dashboard,
  ) async {
    final payload = Map<String, dynamic>.from(dashboard.toJson())
      ..removeWhere((_, value) => value == null);
    final response = await _dio.post('/dashboard/', data: payload);
    final data = Map<String, dynamic>.from(response.data['data'] as Map);
    return AnalysisDashboard.fromJson(
      Map<String, dynamic>.from(data['dashboard'] as Map),
    );
  }

  Future<void> updateDashboard(String id, AnalysisDashboard dashboard) async {
    await _dio.put('/dashboard/$id', data: dashboard.toJson());
  }

  Future<void> deleteDashboard(String id) async {
    await _dio.delete('/dashboard/$id');
  }

  Future<Map<String, dynamic>> executeBoard(
    String projectId,
    String boardId,
  ) async {
    final response = await _dio.get(
      '/api/v1/projects/$projectId/analysis-boards/$boardId/execute',
    );
    return Map<String, dynamic>.from(response.data as Map);
  }
}
