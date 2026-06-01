import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_client_wrapper.dart';
import 'package:frontend/core/network/api_endpoints.dart';
import 'package:frontend/features/responses/domain/entities/form_response.dart';
import 'package:frontend/features/responses/domain/repositories/response_repository.dart';

import 'package:frontend/features/responses/domain/entities/response_history.dart';

class ResponseRepositoryImpl implements ResponseRepository {
  final ApiClient _apiClient;

  ResponseRepositoryImpl(this._apiClient);

  @override
  Future<List<FormResponse>> getResponsesForForm(String formId) async {
    final response = await _apiClient.get(ApiEndpoints.listResponses(formId));
    final List<dynamic> data = _items(response.data);
    return data.map((json) => FormResponse.fromJson(json)).toList();
  }

  @override
  Future<List<FormResponse>> getProjectResponses(
    String projectId,
    String formId,
  ) async {
    final response = await _apiClient.get(
      ApiEndpoints.listProjectResponses(projectId, formId),
    );
    final List<dynamic> data = _items(response.data);
    return data.map((json) => FormResponse.fromJson(json)).toList();
  }

  @override
  Future<FormResponse> getResponseDetail(
    String formId,
    String responseId,
  ) async {
    final response = await _apiClient.get(
      ApiEndpoints.getResponse(formId, responseId),
    );
    return FormResponse.fromJson(_map(response.data));
  }

  @override
  Future<FormResponse> getProjectResponseDetail(
    String projectId,
    String formId,
    String responseId,
  ) async {
    final response = await _apiClient.get(
      ApiEndpoints.getProjectResponse(projectId, formId, responseId),
    );
    return FormResponse.fromJson(_map(response.data));
  }

  @override
  Future<void> submitResponse(FormResponse response) async {
    await _apiClient.post(
      ApiEndpoints.submitResponse(response.formId),
      data: response.toJson(),
    );
  }

  @override
  Future<void> submitProjectResponse(
    String projectId,
    FormResponse response,
  ) async {
    await _apiClient.post(
      ApiEndpoints.submitProjectResponse(projectId, response.formId),
      data: response.toJson(),
    );
  }

  @override
  Future<List<FormResponse>> aiSearch(String formId, String query) async {
    final response = await _apiClient.post(
      ApiEndpoints.aiPoweredSearch(formId),
      data: {'query': query},
    );
    final List<dynamic> results = _items(response.data);
    return results.map((json) => FormResponse.fromJson(json)).toList();
  }

  @override
  Future<List<ResponseHistory>> getResponseHistory(
    String formId,
    String responseId,
  ) async {
    final response = await _apiClient.get(
      ApiEndpoints.getResponseHistory(formId, responseId),
    );
    final List<dynamic> data = _items(response.data);
    return data.map((json) => ResponseHistory.fromJson(json)).toList();
  }

  @override
  Future<List<ResponseHistory>> getProjectResponseHistory(
    String projectId,
    String formId,
    String responseId,
  ) async {
    final response = await _apiClient.get(
      ApiEndpoints.getResponseHistory(formId, responseId),
    );
    final List<dynamic> data = _items(response.data);
    return data.map((json) => ResponseHistory.fromJson(json)).toList();
  }

  @override
  Future<List<FormResponse>> getFilteredResponses(
    String projectId,
    String formId,
    List<Map<String, dynamic>> filters,
  ) async {
    final response = await _apiClient.post(
      ApiEndpoints.filterResponses(formId),
      data: {'filters': filters},
    );
    final List<dynamic> data = _items(response.data);
    return data.map((json) => FormResponse.fromJson(json)).toList();
  }

  Map<String, dynamic> _map(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data.containsKey('data') && data['data'] is Map) {
        return Map<String, dynamic>.from(data['data'] as Map);
      }
      if (data.containsKey('response') && data['response'] is Map) {
        return Map<String, dynamic>.from(data['response'] as Map);
      }
      return data;
    }
    if (data is Map) {
      if (data.containsKey('data') && data['data'] is Map) {
        return Map<String, dynamic>.from(data['data'] as Map);
      }
      if (data.containsKey('response') && data['response'] is Map) {
        return Map<String, dynamic>.from(data['response'] as Map);
      }
      return Map<String, dynamic>.from(data);
    }
    return const {};
  }

  List<dynamic> _items(dynamic data) {
    if (data is List) return data;
    if (data is Map<String, dynamic>) {
      return data['items'] as List<dynamic>? ??
          data['responses'] as List<dynamic>? ??
          data['results'] as List<dynamic>? ??
          data['data'] as List<dynamic>? ??
          const [];
    }
    return const [];
  }
}

final responseRepositoryProvider = Provider<ResponseRepository>((ref) {
  return ResponseRepositoryImpl(ref.watch(apiClientProvider));
});
