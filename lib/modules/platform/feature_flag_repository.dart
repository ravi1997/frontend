import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/networking/api_client.dart';
import '../../../core/networking/api_endpoints.dart';

class FeatureFlagRepository {
  FeatureFlagRepository(this._apiClient);

  final ApiClient _apiClient;

  /// Retrieves all feature flags and overrides.
  Future<List<Map<String, dynamic>>> listFeatureFlags() async {
    final response = await _apiClient.get(ApiEndpoints.listFeatureFlags);
    final data = response.data;
    if (data is List) {
      return data
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }
    return const [];
  }

  /// Updates a global feature flag default state.
  Future<Map<String, dynamic>> updateGlobalFeatureFlag(
    String flagKey,
    bool isEnabled,
  ) async {
    final response = await _apiClient.put(
      ApiEndpoints.updateGlobalFeatureFlag(flagKey),
      data: {'is_enabled': isEnabled},
    );
    final data = response.data;
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return const {};
  }

  /// Configures a feature flag override for a specific organization.
  Future<Map<String, dynamic>> updateFeatureFlagOverride(
    String flagKey,
    String orgId,
    bool isEnabled,
  ) async {
    final response = await _apiClient.put(
      ApiEndpoints.updateFeatureFlagOverride(flagKey, orgId),
      data: {'is_enabled': isEnabled},
    );
    final data = response.data;
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return const {};
  }
}

final featureFlagRepositoryProvider = Provider<FeatureFlagRepository>((ref) {
  return FeatureFlagRepository(ref.watch(apiClientProvider));
});
