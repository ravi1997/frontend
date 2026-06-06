import 'package:test/test.dart';
import 'package:ridp_api/ridp_api.dart';


/// tests for OrganizationManagementApi
void main() {
  final instance = RidpApi().getOrganizationManagementApi();

  group(OrganizationManagementApi, () {
    // List all organizations (Superadmin only)
    //
    //Future mahasangrahaApiV1AdminOrgsGet() async
    test('test mahasangrahaApiV1AdminOrgsGet', () async {
      // TODO
    });

    // Assign an administrator user to an organization (Superadmin only)
    //
    //Future mahasangrahaApiV1AdminOrgsOrgIdAdminPut(String orgId, MahasangrahaApiV1AdminOrgsOrgIdAdminPutRequest body) async
    test('test mahasangrahaApiV1AdminOrgsOrgIdAdminPut', () async {
      // TODO
    });

    // Retrieve standard organization metrics (Admin and Superadmin)
    //
    //Future mahasangrahaApiV1AdminOrgsOrgIdStatsGet(String orgId) async
    test('test mahasangrahaApiV1AdminOrgsOrgIdStatsGet', () async {
      // TODO
    });

    // Suspend or activate an organization (Superadmin only)
    //
    //Future mahasangrahaApiV1AdminOrgsOrgIdStatusPut(String orgId, MahasangrahaApiV1AdminOrgsOrgIdStatusPutRequest body) async
    test('test mahasangrahaApiV1AdminOrgsOrgIdStatusPut', () async {
      // TODO
    });

    // Create an Enterprise Organization (Superadmin only)
    //
    // Registers a new organization and atomically configures its default tenant settings/quotas.
    //
    //Future mahasangrahaApiV1AdminOrgsPost(MahasangrahaApiV1AdminOrgsPostRequest body) async
    test('test mahasangrahaApiV1AdminOrgsPost', () async {
      // TODO
    });

  });
}
