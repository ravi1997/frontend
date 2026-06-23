import 'package:frontend/core/networking/api_client.dart';
import 'package:frontend/core/networking/api_requests.dart';
import '../../form_response.dart';
import '../../response_repository.dart';

class ResponseRepositoryImpl implements ResponseRepository {
  final ApiClient _apiClient;

  ResponseRepositoryImpl(this._apiClient);

  @override
  Future<List<FormResponse>> getResponsesForForm(String formId) async {
    final items = await _apiClient.listResponses('', formId);
    return items.map((e) => FormResponse.fromJson(_map(e))).toList();
  }

  @override
  Future<List<FormResponse>> getProjectResponses(
    String projectId,
    String formId,
  ) async {
    return (await _apiClient.listResponses(projectId, formId))
        .map((e) => FormResponse.fromJson(_map(e)))
        .toList();
  }

  @override
  Future<FormResponse> getResponseDetail(
    String formId,
    String responseId,
  ) async {
    return FormResponse.fromJson(
      _map(await _apiClient.getResponse('', formId, responseId)),
    );
  }

  @override
  Future<FormResponse> getProjectResponseDetail(
    String projectId,
    String formId,
    String responseId,
  ) async {
    return FormResponse.fromJson(
      _map(await _apiClient.getResponse(projectId, formId, responseId)),
    );
  }

  @override
  Future<void> submitResponse(FormResponse response) async {
    await _apiClient.postMap('/responses', data: response.toJson());
  }

  @override
  Future<void> submitProjectResponse(
    String projectId,
    FormResponse response,
  ) async {
    await _apiClient.postMap(
      '/projects/$projectId/responses',
      data: response.toJson(),
    );
  }

  @override
  Future<List<FormResponse>> aiSearch(String formId, String query) async {
    final response = await _apiClient.postList(
      '/responses/search',
      data: {'form_id': formId, 'query': query},
    );
    return response.map((e) => FormResponse.fromJson(_map(e))).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> lookupSameFormResponses(
    String formId,
    String questionId,
    String value,
  ) async {
    return (await _apiClient.sameFormLookup(formId, questionId, value))
        .map(_map)
        .toList();
  }

  @override
  Future<List<ResponseHistory>> getResponseHistory(
    String formId,
    String responseId,
  ) async {
    return (await _apiClient.responseHistory('', formId, responseId))
        .map((e) => ResponseHistory.fromJson(_map(e)))
        .toList();
  }

  @override
  Future<List<ResponseHistory>> getProjectResponseHistory(
    String projectId,
    String formId,
    String responseId,
  ) async {
    return (await _apiClient.responseHistory(projectId, formId, responseId))
        .map((e) => ResponseHistory.fromJson(_map(e)))
        .toList();
  }

  @override
  Future<List<FormResponse>> getFilteredResponses(
    String projectId,
    String formId,
    List<Map<String, dynamic>> filters,
  ) async {
    return (await _apiClient.filteredResponses(
      projectId,
      formId,
      ResponseFilterRequest(filters: filters),
    ))
        .map((e) => FormResponse.fromJson(_map(e)))
        .toList();
  }

  Map<String, dynamic> _map(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return const {};
  }
}
