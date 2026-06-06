import 'package:test/test.dart';
import 'package:ridp_api/ridp_api.dart';


/// tests for FeatureFlagsApi
void main() {
  final instance = RidpApi().getFeatureFlagsApi();

  group(FeatureFlagsApi, () {
    // Configure feature flag override for a specific organization (Superadmin only)
    //
    //Future mahasangrahaApiV1AdminFeatureFlagsFlagKeyOverrideOrgIdPut(String flagKey, String orgId, MahasangrahaApiV1AdminFeatureFlagsFlagKeyPutRequest body) async
    test('test mahasangrahaApiV1AdminFeatureFlagsFlagKeyOverrideOrgIdPut', () async {
      // TODO
    });

    // Update global feature flag default state (Superadmin only)
    //
    //Future mahasangrahaApiV1AdminFeatureFlagsFlagKeyPut(String flagKey, MahasangrahaApiV1AdminFeatureFlagsFlagKeyPutRequest body) async
    test('test mahasangrahaApiV1AdminFeatureFlagsFlagKeyPut', () async {
      // TODO
    });

    // Get all feature flags and overrides (Superadmin only)
    //
    //Future mahasangrahaApiV1AdminFeatureFlagsGet() async
    test('test mahasangrahaApiV1AdminFeatureFlagsGet', () async {
      // TODO
    });

  });
}
