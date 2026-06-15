import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/networking/api_endpoints.dart';
import '../../core/networking/dio_provider.dart';

class ApiKeyRepository {
  ApiKeyRepository(this._apiClient);

  final Dio _apiClient;

  Future<List<Map<String, dynamic>>> listApiKeys() async {
    final response = await _apiClient.get(ApiEndpoints.listApiKeys);
    final data = response.data;
    if (data is List) {
      return data
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }
    return const [];
  }

  Future<Map<String, dynamic>> createApiKey({
    required String name,
    List<String> scopes = const [],
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.createApiKey,
      data: {'name': name, 'scopes': scopes},
    );
    final data = response.data;
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return const {};
  }
}

final apiKeyRepositoryProvider = Provider<ApiKeyRepository>((ref) {
  return ApiKeyRepository(ref.watch(dioProvider));
});
