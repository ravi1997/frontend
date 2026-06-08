import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/networking/dio_provider.dart';
import '../../../../core/networking/api_endpoints.dart';

/// AI Service for form analysis and AI-powered features
class AIService {
  final Dio _apiClient;

  AIService(this._apiClient);

  /// Analyze a form response using AI
  Future<Map<String, dynamic>> analyzeResponse(
    String formId,
    String responseId,
  ) async {
    final response = await _apiClient.post(
      ApiEndpoints.analyzeResponseAI(formId, responseId),
    );
    return response.data as Map<String, dynamic>;
  }

  /// Moderate a form response for inappropriate content
  Future<Map<String, dynamic>> moderateResponse(
    String formId,
    String responseId,
  ) async {
    final response = await _apiClient.post(
      ApiEndpoints.moderateResponseAI(formId, responseId),
    );
    return response.data as Map<String, dynamic>;
  }

  /// Get sentiment trends for a form
  Future<Map<String, dynamic>> getFormSentimentTrends(String formId) async {
    final response = await _apiClient.get(
      ApiEndpoints.getFormSentimentTrends(formId),
    );
    return response.data as Map<String, dynamic>;
  }

  /// Detect anomalies in form responses
  Future<Map<String, dynamic>> detectAnomalies(String formId) async {
    final response = await _apiClient.post(
      ApiEndpoints.detectFormAnomalies(formId),
    );
    return response.data as Map<String, dynamic>;
  }
}

final aiServiceProvider = Provider<AIService>((ref) {
  return AIService(ref.watch(dioProvider));
});
