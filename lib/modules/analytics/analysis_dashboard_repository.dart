import 'package:frontend/core/networking/api_client.dart';
import 'analysis_dashboard.dart';

class AnalysisDashboardRepository {
  final ApiClient _dio;

  AnalysisDashboardRepository(this._dio);

  Future<List<AnalysisDashboard>> listDashboards() async {
    return (await _dio.getList('/dashboard/'))
        .map((json) => AnalysisDashboard.fromJson(json))
        .toList();
  }

  Future<AnalysisDashboard> getDashboard(String slug) async {
    return AnalysisDashboard.fromJson(await _dio.getMap('/dashboard/$slug'));
  }

  Future<AnalysisDashboard> createDashboard(
    AnalysisDashboard dashboard,
  ) async {
    final payload = Map<String, dynamic>.from(dashboard.toJson())
      ..removeWhere((_, value) => value == null);
    final data = await _dio.postMap('/dashboard/', data: payload);
    return AnalysisDashboard.fromJson(
      Map<String, dynamic>.from(data['dashboard'] as Map),
    );
  }

  Future<void> updateDashboard(String id, AnalysisDashboard dashboard) async {
    await _dio.putMap('/dashboard/$id', data: dashboard.toJson());
  }

  Future<void> deleteDashboard(String id) async {
    await _dio.delete('/dashboard/$id');
  }

  Future<Map<String, dynamic>> executeBoard(
    String projectId,
    String boardId,
  ) async {
    return _dio.getMap(
      '/api/v1/projects/$projectId/analysis-boards/$boardId/execute',
    );
  }
}
