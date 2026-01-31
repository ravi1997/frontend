import '../entities/form_response.dart';

abstract class ResponseRepository {
  Future<List<FormResponse>> getResponsesForForm(String formId);
  Future<FormResponse> getResponseDetail(String responseId);
}
