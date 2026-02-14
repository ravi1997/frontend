import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/api_client_wrapper.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../domain/entities/dashboard_data.dart';
import '../../domain/entities/dashboard_stats.dart';
import '../../domain/entities/recent_form.dart';
import '../../domain/repositories/dashboard_repository.dart';

part 'dashboard_repository_impl.g.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final ApiClient _apiClient;

  DashboardRepositoryImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  DateTime _parseDate(dynamic date) {
    if (date == null) return DateTime.now();
    if (date is DateTime) return date;
    final dateStr = date.toString();
    try {
      return DateTime.parse(dateStr);
    } catch (_) {
      try {
        // Handle RFC 1123 format: "Sat, 14 Feb 2026 06:44:56 GMT"
        // Also handle cases where GMT might be missing or different
        // Using a pattern that matches the log provided
        return DateFormat(
          "EEE, dd MMM yyyy HH:mm:ss 'GMT'",
        ).parse(dateStr, true);
      } catch (e) {
        // Fallback
        return DateTime.now();
      }
    }
  }

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
        updatedAt: _parseDate(json['updated_at']),
        createdAt: json['created_at'] != null
            ? _parseDate(json['created_at'])
            : null,
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
