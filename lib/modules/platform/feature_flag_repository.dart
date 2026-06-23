import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/networking/api_client.dart';
import '../../../core/networking/dio_provider.dart';

class FeatureFlagRepository {
  FeatureFlagRepository(this._apiClient);

  final ApiClient _apiClient;

  /// Retrieves all feature flags and overrides.
  Future<List<Map<String, dynamic>>> listFeatureFlags() async {
    return (await _apiClient.listFeatureFlags())
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  /// Updates a global feature flag default state.
  Future<Map<String, dynamic>> updateGlobalFeatureFlag(
    String flagKey,
    bool isEnabled,
  ) async {
    return _apiClient.updateGlobalFeatureFlag(flagKey, isEnabled);
  }

  /// Configures a feature flag override for a specific organization.
  Future<Map<String, dynamic>> updateFeatureFlagOverride(
    String flagKey,
    String orgId,
    bool isEnabled,
  ) async {
    return _apiClient.updateFeatureFlagOverride(flagKey, orgId, isEnabled);
  }
}

final featureFlagRepositoryProvider = Provider<FeatureFlagRepository>((ref) {
  return FeatureFlagRepository(ref.watch(apiClientProvider));
});
