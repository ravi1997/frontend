import '../entities/form_response.dart';
import '../entities/response_history.dart';

abstract class ResponseRepository {
  Future<List<FormResponse>> getResponsesForForm(String formId);
  Future<FormResponse> getResponseDetail(String formId, String responseId);
  Future<void> submitResponse(FormResponse response);
  Future<List<FormResponse>> aiSearch(String formId, String query);
  Future<List<ResponseHistory>> getResponseHistory(
    String formId,
    String responseId,
  );
}
