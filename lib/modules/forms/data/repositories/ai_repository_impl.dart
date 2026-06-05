import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/networking/api_client.dart';
import 'package:frontend/core/networking/api_endpoints.dart';

class AIRepository {
  final Dio _dio;

  AIRepository(this._dio);

  Future<Map<String, dynamic>> analyzeResponse(
    String formId,
    String responseId,
  ) async {
    final response = await _dio.post(
      ApiEndpoints.analyzeResponseAI(formId, responseId),
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> generateInsights(String formId) async {
    final response = await _dio.get('/ai/generate-insights/$formId');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> classifyResponse(String responseId) async {
    final response = await _dio.post('/ai/classify-response/$responseId');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> moderateResponse(
    String formId,
    String responseId,
  ) async {
    final response = await _dio.post(
      ApiEndpoints.moderateResponseAI(formId, responseId),
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getFormSentimentTrends(String formId) async {
    final response = await _dio.get('/ai/sentiment-trends/$formId');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> detectAnomalies(String formId) async {
    final response = await _dio.get('/ai/anomalies/$formId');
    return response.data as Map<String, dynamic>;
  }
}

final aiRepositoryProvider = Provider<AIRepository>((ref) {
  final dioClient = ref.watch(dioProvider);
  return AIRepository(dioClient);
});
