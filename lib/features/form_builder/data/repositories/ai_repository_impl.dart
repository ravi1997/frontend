import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client_wrapper.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../domain/repositories/ai_repository.dart';

class AIRepositoryImpl implements AIRepository {
  final ApiClient _apiClient;

  AIRepositoryImpl(this._apiClient);

  @override
  Future<Map<String, dynamic>> analyzeResponse(
    String formId,
    String responseId,
  ) async {
    final response = await _apiClient.post(
      ApiEndpoints.analyzeResponseAI(formId, responseId),
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> moderateResponse(
    String formId,
    String responseId,
  ) async {
    final response = await _apiClient.post(
      ApiEndpoints.moderateResponseAI(formId, responseId),
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> getFormSentimentTrends(String formId) async {
    final response = await _apiClient.get(
      ApiEndpoints.getFormSentimentTrends(formId),
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> detectAnomalies(String formId) async {
    final response = await _apiClient.post(
      ApiEndpoints.detectFormAnomalies(formId),
    );
    return response.data as Map<String, dynamic>;
  }
}

final aiRepositoryProvider = Provider<AIRepository>((ref) {
  return AIRepositoryImpl(ref.watch(apiClientProvider));
});
