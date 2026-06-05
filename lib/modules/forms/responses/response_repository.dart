import 'form_response.dart';

abstract class ResponseRepository {
  Future<List<FormResponse>> getResponsesForForm(String formId);
  Future<List<FormResponse>> getProjectResponses(String projectId, String formId);
  Future<FormResponse> getResponseDetail(String formId, String responseId);
  Future<FormResponse> getProjectResponseDetail(
    String projectId,
    String formId,
    String responseId,
  );
  Future<void> submitResponse(FormResponse response);
  Future<void> submitProjectResponse(String projectId, FormResponse response);
  Future<List<FormResponse>> aiSearch(String formId, String query);
  Future<List<ResponseHistory>> getResponseHistory(String formId, String responseId);
  Future<List<ResponseHistory>> getProjectResponseHistory(
    String projectId,
    String formId,
    String responseId,
  );
  Future<List<FormResponse>> getFilteredResponses(
    String projectId,
    String formId,
    List<Map<String, dynamic>> filters,
  );
}
