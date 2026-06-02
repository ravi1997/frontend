// lib/features/dashboard/dashboard_service.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/core/network/api_endpoints.dart';
import 'package:frontend/features/dashboard/dashboard_models.dart';

class DashboardService {
  final ApiClient _apiClient;

  DashboardService(this._apiClient);

  Future<DashboardData> getDashboardData() async {
    // Fetch dashboard stats from analytics endpoint
    final statsResponse = await _apiClient.get(ApiEndpoints.getDashboardStats);
    final statsData = _asMap(statsResponse.data);

    // Fetch projects as the primary dashboard source.
    final projectsResponse = await _apiClient.get(ApiEndpoints.listProjects);
    final projectsData = projectsResponse.data;
    final projectsMap = _asMap(projectsData);
    final List<dynamic> projectsJson = projectsData is List
        ? projectsData
        : _asList(
            projectsMap['items'] ??
                projectsMap['data'] ??
                projectsMap['results'],
          );

    final dashboardProjects = projectsJson.map((json) {
      final map = _asMap(json);
      return MapEntry(ProjectSummary.fromJson(map), map);
    }).toList();

    dashboardProjects.sort(
      (a, b) => a.key.title.toLowerCase().compareTo(b.key.title.toLowerCase()),
    );

    final List<ProjectSummary> projects = dashboardProjects
        .map((entry) => entry.key)
        .toList();

    // Keep the dashboard usable even if analytics returns partial data.
    final recentForms = dashboardProjects.map((entry) {
      final project = entry.key;
      final projectMap = entry.value;
      return RecentForm(
        id: project.id,
        title: project.title,
        status: project.status,
        updatedAt:
            _parseDate(project.updatedAt) ??
            _parseDate(projectMap['created_at']) ??
            DateTime.now(),
        createdAt: _parseDate(projectMap['created_at']),
      );
    }).toList();

    return DashboardData(
      stats: DashboardStats(
        totalForms: (statsData['total_forms'] as num? ?? projects.length)
            .toInt(),
        activeForms:
            (statsData['active_forms'] as num? ??
                    projects
                        .where((f) => f.status.toLowerCase() == 'published')
                        .length)
                .toInt(),
        totalResponses: (statsData['total_responses'] as num? ?? 0).toInt(),
      ),
      recentForms: recentForms.take(20).toList(),
      projects: projects,
    );
  }

  Future<void> deleteForm(String id) async {
    // Dashboard cards are project summaries in the current API contract.
    await _apiClient.delete(ApiEndpoints.deleteProject(id));
  }

  Future<void> duplicateForm(String originalFormId, String newTitle) async {
    throw UnsupportedError(
      'Duplicating a form requires project context and must use cloneProjectForm.',
    );
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return <String, dynamic>{};
  }

  List<dynamic> _asList(dynamic value) {
    if (value is List) {
      return value;
    }
    return const [];
  }

  DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }
}

final dashboardServiceProvider = Provider<DashboardService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return DashboardService(apiClient);
});
