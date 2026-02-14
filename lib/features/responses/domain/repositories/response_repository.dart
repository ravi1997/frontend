import '../entities/form_response.dart';

abstract class ResponseRepository {
  Future<List<FormResponse>> getResponsesForForm(String formId);
  Future<FormResponse> getResponseDetail(String responseId);
  Future<void> submitResponse(FormResponse response);
  Future<List<FormResponse>> aiSearch(String formId, String query);
}
