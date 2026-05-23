import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client_wrapper.dart';
import '../../../core/network/api_endpoints.dart';

class PlatformRepository {
  PlatformRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<Map<String, dynamic>> getTaskStatus(String taskId) async {
    final response = await _apiClient.get(ApiEndpoints.taskStatus(taskId));
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<List<Map<String, dynamic>>> listThemes() async {
    final response = await _apiClient.get(ApiEndpoints.themes);
    final data = response.data;
    if (data is List) {
      return data
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();
    }
    return const [];
  }

  Future<Map<String, dynamic>> createTheme(Map<String, dynamic> payload) async {
    final response = await _apiClient.post(ApiEndpoints.themes, data: payload);
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> updateTheme(
    String themeId,
    Map<String, dynamic> payload,
  ) async {
    final response = await _apiClient.put(
      ApiEndpoints.theme(themeId),
      data: payload,
    );
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<void> deleteTheme(String themeId) async {
    await _apiClient.delete(ApiEndpoints.theme(themeId));
  }

  Future<Map<String, dynamic>> applyFormTheme(
    String projectId,
    String formId,
    Map<String, dynamic> payload,
  ) async {
    final response = await _apiClient.post(
      ApiEndpoints.applyFormTheme(projectId, formId),
      data: payload,
    );
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> getFormAudit(
    String projectId,
    String formId, {
    int page = 1,
    int pageSize = 25,
    String? action,
    String? actorId,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.formAudit(projectId, formId),
      queryParameters: {
        'page': page,
        'page_size': pageSize,
        if (action != null && action.isNotEmpty) 'action': action,
        if (actorId != null && actorId.isNotEmpty) 'actor_id': actorId,
      },
    );
    return Map<String, dynamic>.from(response.data as Map);
  }
}

final platformRepositoryProvider = Provider<PlatformRepository>((ref) {
  return PlatformRepository(ref.watch(apiClientProvider));
});
