import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/networking/api_client.dart';
import '../../../core/networking/dio_provider.dart';

class PlatformRepository {
  PlatformRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<Map<String, dynamic>> getTaskStatus(String taskId) async {
    return _apiClient.getTaskStatus(taskId);
  }

  Future<List<Map<String, dynamic>>> listThemes() async {
    return (await _apiClient.listThemes())
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  Future<Map<String, dynamic>> createTheme(Map<String, dynamic> payload) async {
    return _apiClient.createTheme(payload);
  }

  Future<Map<String, dynamic>> updateTheme(
    String themeId,
    Map<String, dynamic> payload,
  ) async {
    return _apiClient.updateTheme(themeId, payload);
  }

  Future<void> deleteTheme(String themeId) async {
    await _apiClient.deleteTheme(themeId);
  }

  Future<Map<String, dynamic>> applyFormTheme(
    String projectId,
    String formId,
    Map<String, dynamic> payload,
  ) async {
    return _apiClient.applyFormTheme(projectId, formId, payload);
  }

  Future<Map<String, dynamic>> getFormAudit(
    String projectId,
    String formId, {
    int page = 1,
    int pageSize = 25,
    String? action,
    String? actorId,
  }) async {
    return _apiClient.getFormAudit(
      projectId,
      formId,
      page: page,
      pageSize: pageSize,
      action: action,
      actorId: actorId,
    );
  }
}

final platformRepositoryProvider = Provider<PlatformRepository>((ref) {
  return PlatformRepository(ref.watch(apiClientProvider));
});
