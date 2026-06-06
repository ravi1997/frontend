import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/networking/api_client.dart';
import '../../../core/networking/api_endpoints.dart';

class OrganizationRepository {
  OrganizationRepository(this._apiClient);

  final ApiClient _apiClient;

  /// Creates a new enterprise organization.
  Future<Map<String, dynamic>> createOrg(Map<String, dynamic> payload) async {
    final response = await _apiClient.post(
      ApiEndpoints.createOrg,
      data: payload,
    );
    final data = response.data;
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return const {};
  }

  /// Lists all enterprise organizations.
  Future<List<Map<String, dynamic>>> listOrgs() async {
    final response = await _apiClient.get(ApiEndpoints.listOrgs);
    final data = response.data;
    if (data is List) {
      return data
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }
    return const [];
  }

  /// Suspends or activates an organization.
  Future<Map<String, dynamic>> updateOrgStatus(
    String orgId,
    String status,
  ) async {
    final response = await _apiClient.put(
      ApiEndpoints.updateOrgStatus(orgId),
      data: {'status': status},
    );
    final data = response.data;
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return const {};
  }

  /// Assigns a primary organization administrator.
  Future<Map<String, dynamic>> assignOrgAdmin(
    String orgId,
    String adminEmail,
  ) async {
    final response = await _apiClient.put(
      ApiEndpoints.assignOrgAdmin(orgId),
      data: {'admin_email': adminEmail},
    );
    final data = response.data;
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return const {};
  }

  /// Retrieves usage statistics for a specific organization.
  Future<Map<String, dynamic>> getOrgStats(String orgId) async {
    final response = await _apiClient.get(ApiEndpoints.getOrgStats(orgId));
    final data = response.data;
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return const {};
  }
}

final organizationRepositoryProvider = Provider<OrganizationRepository>((ref) {
  return OrganizationRepository(ref.watch(apiClientProvider));
});
