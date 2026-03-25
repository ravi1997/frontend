import 'package:dio/dio.dart';
import '../../domain/entities/analysis_dashboard.dart';

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

  Future<void> createDashboard(AnalysisDashboard dashboard) async {
    await _dio.post('/dashboard/', data: dashboard.toJson());
  }

  Future<void> updateDashboard(String id, AnalysisDashboard dashboard) async {
    await _dio.put('/dashboard/$id', data: dashboard.toJson());
  }

  Future<void> deleteDashboard(String id) async {
    await _dio.delete('/dashboard/$id');
  }
}
