import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/networking/dio_provider.dart';
import '../../../core/networking/api_endpoints.dart';

class PlatformRepository {
  PlatformRepository(this._apiClient);

  final Dio _apiClient;

  Future<Map<String, dynamic>> getTaskStatus(String taskId) async {
    final response = await _apiClient.get(ApiEndpoints.taskStatus(taskId));
    final data = response.data;
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return const {};
  }

  Future<List<Map<String, dynamic>>> listThemes() async {
    final response = await _apiClient.get(ApiEndpoints.themes);
    final data = response.data;
    if (data is List) {
      return data
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }
    return const [];
  }

  Future<Map<String, dynamic>> createTheme(Map<String, dynamic> payload) async {
    final response = await _apiClient.post(ApiEndpoints.themes, data: payload);
    final data = response.data;
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return const {};
  }

  Future<Map<String, dynamic>> updateTheme(
    String themeId,
    Map<String, dynamic> payload,
  ) async {
    final response = await _apiClient.put(
      ApiEndpoints.theme(themeId),
      data: payload,
    );
    final data = response.data;
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return const {};
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
    final data = response.data;
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return const {};
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
    final data = response.data;
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return const {};
  }
}

final platformRepositoryProvider = Provider<PlatformRepository>((ref) {
  return PlatformRepository(ref.watch(dioProvider));
});
