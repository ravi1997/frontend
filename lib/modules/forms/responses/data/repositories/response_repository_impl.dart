import 'package:frontend/core/networking/api_client.dart';
import '../../form_response.dart';
import '../../response_repository.dart';

class ResponseRepositoryImpl implements ResponseRepository {
  final ApiClient _apiClient;

  ResponseRepositoryImpl(this._apiClient);

  @override
  Future<List<FormResponse>> getResponsesForForm(String formId) async {
    final response = await _apiClient.get('/responses/form/$formId');
    final items = _items(response.data);
    return items.map((e) => FormResponse.fromJson(_map(e))).toList();
  }

  @override
  Future<List<FormResponse>> getProjectResponses(
    String projectId,
    String formId,
  ) async {
    final response = await _apiClient.get('/projects/$projectId/forms/$formId/responses');
    return _items(response.data).map((e) => FormResponse.fromJson(_map(e))).toList();
  }

  @override
  Future<FormResponse> getResponseDetail(String formId, String responseId) async {
    final response = await _apiClient.get('/responses/$responseId');
    return FormResponse.fromJson(_map(response.data));
  }

  @override
  Future<FormResponse> getProjectResponseDetail(
    String projectId,
    String formId,
    String responseId,
  ) async {
    final response = await _apiClient.get('/projects/$projectId/forms/$formId/responses/$responseId');
    return FormResponse.fromJson(_map(response.data));
  }

  @override
  Future<void> submitResponse(FormResponse response) async {
    await _apiClient.post('/responses', data: response.toJson());
  }

  @override
  Future<void> submitProjectResponse(String projectId, FormResponse response) async {
    await _apiClient.post('/projects/$projectId/responses', data: response.toJson());
  }

  @override
  Future<List<FormResponse>> aiSearch(String formId, String query) async {
    final response = await _apiClient.post('/responses/search', data: {'form_id': formId, 'query': query});
    return _items(response.data).map((e) => FormResponse.fromJson(_map(e))).toList();
  }

  @override
  Future<List<ResponseHistory>> getResponseHistory(String formId, String responseId) async {
    final response = await _apiClient.get('/responses/$responseId/history');
    return _items(response.data).map((e) => ResponseHistory.fromJson(_map(e))).toList();
  }

  @override
  Future<List<ResponseHistory>> getProjectResponseHistory(
    String projectId,
    String formId,
    String responseId,
  ) async {
    final response = await _apiClient.get('/projects/$projectId/forms/$formId/responses/$responseId/history');
    return _items(response.data).map((e) => ResponseHistory.fromJson(_map(e))).toList();
  }

  @override
  Future<List<FormResponse>> getFilteredResponses(
    String projectId,
    String formId,
    List<Map<String, dynamic>> filters,
  ) async {
    final response = await _apiClient.post(
      '/projects/$projectId/forms/$formId/responses/filter',
      data: {'filters': filters},
    );
    return _items(response.data).map((e) => FormResponse.fromJson(_map(e))).toList();
  }

  Map<String, dynamic> _map(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return const {};
  }

  List<dynamic> _items(dynamic data) {
    if (data is List) return data;
    if (data is Map<String, dynamic>) {
      final items = data['items'] ?? data['responses'] ?? data['results'] ?? data['data'];
      if (items is List) return items;
    }
    return const [];
  }
}
