import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/networking/api_client.dart';
import '../../core/networking/api_requests.dart';
import '../../core/networking/dio_provider.dart';

class OrganizationRepository {
  OrganizationRepository(this._apiClient);

  final ApiClient _apiClient;

  /// Creates a new enterprise organization.
  Future<Map<String, dynamic>> createOrg(Map<String, dynamic> payload) async {
    return _apiClient.createOrg(
      OrgRequest(
        name: payload['name']?.toString() ?? '',
        description: payload['description']?.toString(),
      ),
    );
  }

  /// Lists all enterprise organizations.
  Future<List<Map<String, dynamic>>> listOrgs() async {
    return (await _apiClient.listOrgs())
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  /// Suspends or activates an organization.
  Future<Map<String, dynamic>> updateOrgStatus(
    String orgId,
    String status,
  ) async {
    return _apiClient.updateOrgStatus(orgId, status);
  }

  /// Assigns a primary organization administrator.
  Future<Map<String, dynamic>> assignOrgAdmin(
    String orgId,
    String adminEmail,
  ) async {
    return _apiClient.assignOrgAdmin(orgId, adminEmail);
  }

  /// Retrieves usage statistics for a specific organization.
  Future<Map<String, dynamic>> getOrgStats(String orgId) async {
    return _apiClient.getOrgStats(orgId);
  }
}

final organizationRepositoryProvider = Provider<OrganizationRepository>((ref) {
  return OrganizationRepository(ref.watch(apiClientProvider));
});
