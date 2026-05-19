import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/api_client_wrapper.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/utils/date_utils.dart';
import '../../domain/entities/dashboard_data.dart';
import '../../domain/entities/dashboard_stats.dart';
import '../../domain/entities/project_summary.dart';
import '../../domain/entities/recent_form.dart';
import '../../domain/repositories/dashboard_repository.dart';

part 'dashboard_repository_impl.g.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final ApiClient _apiClient;

  DashboardRepositoryImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<DashboardData> getDashboardData() async {
    // Fetch dashboard stats from analytics endpoint
    final statsResponse = await _apiClient.get(ApiEndpoints.getDashboardStats);
    final statsData = statsResponse.data as Map<String, dynamic>;

    // Fetch projects as the primary dashboard source.
    final projectsResponse = await _apiClient.get(ApiEndpoints.listProjects);
    final List<dynamic> projectsJson = projectsResponse.data is List
        ? projectsResponse.data as List<dynamic>
        : ((projectsResponse.data as Map<String, dynamic>)['items']
                as List<dynamic>? ??
            []);

    final List<ProjectSummary> projects = projectsJson.map((json) {
      final map = Map<String, dynamic>.from(json as Map);
      return ProjectSummary.fromJson(map);
    }).toList();

    projects.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));

    // Keep the dashboard usable even if analytics returns partial data.
    final recentForms = projects.map((project) {
      return RecentForm(
        id: project.id,
        title: project.title,
        status: project.status,
        updatedAt:
            AppDateUtils.parse(project.updatedAt) ?? DateTime.now(),
        createdAt: AppDateUtils.parse(project.updatedAt),
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

  @override
  Future<void> deleteForm(String id) async {
    await _apiClient.delete(ApiEndpoints.deleteForm(id));
  }

  @override
  Future<void> duplicateForm(String originalFormId, String newTitle) async {
    await _apiClient.post(
      ApiEndpoints.cloneForm(originalFormId),
      data: {'title': newTitle},
    );
  }
}

@riverpod
DashboardRepository dashboardRepository(Ref ref) {
  return DashboardRepositoryImpl(apiClient: ref.watch(apiClientProvider));
}
