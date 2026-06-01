import '../entities/form_response.dart';
import '../entities/response_history.dart';

/// Repository interface handling form response retrieval, submission, filtering, and history.
///
/// Implemented by data layer classes to interact with the backend API or local database.
abstract class ResponseRepository {
  /// Fetches a list of [FormResponse] objects submitted for a specific form.
  Future<List<FormResponse>> getResponsesForForm(String formId);

  /// Fetches a list of [FormResponse] objects submitted for a specific form within a project.
  Future<List<FormResponse>> getProjectResponses(
    String projectId,
    String formId,
  );

  /// Retrieves details for a specific response under a form.
  Future<FormResponse> getResponseDetail(String formId, String responseId);

  /// Retrieves details for a specific response under a form within a project.
  Future<FormResponse> getProjectResponseDetail(
    String projectId,
    String formId,
    String responseId,
  );

  /// Submits a new form response to the backend.
  Future<void> submitResponse(FormResponse response);

  /// Submits a new form response within the context of a project.
  Future<void> submitProjectResponse(String projectId, FormResponse response);

  /// Performs an AI-powered search over the responses of a form.
  Future<List<FormResponse>> aiSearch(String formId, String query);

  /// Retrieves the edit history of a response.
  Future<List<ResponseHistory>> getResponseHistory(
    String formId,
    String responseId,
  );

  /// Retrieves the edit history of a response within a project context.
  Future<List<ResponseHistory>> getProjectResponseHistory(
    String projectId,
    String formId,
    String responseId,
  );

  /// Retrieves responses filtered by a set of dynamic filter criteria.
  Future<List<FormResponse>> getFilteredResponses(
    String projectId,
    String formId,
    List<Map<String, dynamic>> filters,
  );
}
