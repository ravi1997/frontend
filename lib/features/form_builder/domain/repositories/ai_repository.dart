abstract class AIRepository {
  Future<Map<String, dynamic>> analyzeResponse(
    String formId,
    String responseId,
  );
  Future<Map<String, dynamic>> moderateResponse(
    String formId,
    String responseId,
  );
  Future<Map<String, dynamic>> getFormSentimentTrends(String formId);
  Future<Map<String, dynamic>> detectAnomalies(String formId);
}
