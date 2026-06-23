import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/networking/api_client.dart';
import '../../core/networking/api_requests.dart';
import '../../core/networking/dio_provider.dart';

class ApiKeyRepository {
  ApiKeyRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<List<Map<String, dynamic>>> listApiKeys() async {
    return (await _apiClient.listApiKeys())
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  Future<Map<String, dynamic>> createApiKey({
    required String name,
    List<String> scopes = const [],
  }) async {
    return _apiClient.createApiKey(
      ApiKeyCreateRequest(name: name, scopes: scopes),
    );
  }
}

final apiKeyRepositoryProvider = Provider<ApiKeyRepository>((ref) {
  return ApiKeyRepository(ref.watch(apiClientProvider));
});
