import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/networking/api_client.dart';
import 'package:frontend/core/networking/dio_provider.dart';

/// AI Service for form analysis and AI-powered features
class AIService {
  final ApiClient _apiClient;

  AIService(this._apiClient);

  /// Analyze a form response using AI
  Future<Map<String, dynamic>> analyzeResponse(
    String formId,
    String responseId,
  ) async {
    return _apiClient.postMap('/ai/$formId/responses/$responseId/analyze');
  }

  /// Moderate a form response for inappropriate content
  Future<Map<String, dynamic>> moderateResponse(
    String formId,
    String responseId,
  ) async {
    return _apiClient.postMap('/ai/$formId/responses/$responseId/moderate');
  }

  /// Get sentiment trends for a form
  Future<Map<String, dynamic>> getFormSentimentTrends(String formId) async {
    return _apiClient.getMap('/ai/$formId/sentiment');
  }

  /// Detect anomalies in form responses
  Future<Map<String, dynamic>> detectAnomalies(String formId) async {
    return _apiClient.postMap('/ai/$formId/anomalies');
  }
}

final aiServiceProvider = Provider<AIService>((ref) {
  return AIService(ref.watch(apiClientProvider));
});
