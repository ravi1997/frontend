import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/networking/api_client.dart';
import 'package:frontend/core/networking/dio_provider.dart';

class AIRepository {
  final ApiClient _dio;

  AIRepository(this._dio);

  Future<Map<String, dynamic>> analyzeResponse(
    String formId,
    String responseId,
  ) async {
    return _dio.postMap('/ai/$formId/responses/$responseId/analyze');
  }

  Future<Map<String, dynamic>> generateInsights(String formId) async {
    return _dio.getMap('/ai/generate-insights/$formId');
  }

  Future<Map<String, dynamic>> classifyResponse(String responseId) async {
    return _dio.postMap('/ai/classify-response/$responseId');
  }

  Future<Map<String, dynamic>> moderateResponse(
    String formId,
    String responseId,
  ) async {
    return _dio.postMap('/ai/$formId/responses/$responseId/moderate');
  }

  Future<Map<String, dynamic>> getFormSentimentTrends(String formId) async {
    return _dio.getMap('/ai/sentiment-trends/$formId');
  }

  Future<Map<String, dynamic>> detectAnomalies(String formId) async {
    return _dio.getMap('/ai/anomalies/$formId');
  }
}

final aiRepositoryProvider = Provider<AIRepository>((ref) {
  return AIRepository(ref.watch(apiClientProvider));
});
