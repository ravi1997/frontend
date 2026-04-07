import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/api_client_wrapper.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/utils/date_utils.dart';
import '../../domain/entities/dashboard_data.dart';
import '../../domain/entities/dashboard_stats.dart';
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

    // Fetch forms to list recent forms
    final formsResponse = await _apiClient.get(ApiEndpoints.listForms);
    final List<dynamic> formsJson = formsResponse.data as List<dynamic>;

    final List<RecentForm> recentForms = formsJson.map((json) {
      return RecentForm(
        id: json['id'] ?? json['_id'] ?? '',
        title: json['title'] ?? 'Untitled Form',
        status: json['status'] ?? 'Draft',
        updatedAt: AppDateUtils.parse(json['updated_at']) ?? DateTime.now(),
        createdAt: AppDateUtils.parse(json['created_at']),
      );
    }).toList();

    // Sort by updatedAt descending
    recentForms.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    return DashboardData(
      stats: DashboardStats(
        totalForms: (statsData['total_forms'] as num? ?? recentForms.length)
            .toInt(),
        activeForms:
            (statsData['active_forms'] as num? ??
                    recentForms
                        .where((f) => f.status.toLowerCase() == 'published')
                        .length)
                .toInt(),
        totalResponses: (statsData['total_responses'] as num? ?? 0).toInt(),
      ),
      recentForms: recentForms.take(20).toList(),
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
