import 'package:test/test.dart';
import 'package:ridp_api/ridp_api.dart';


/// tests for AnalyticsApi
void main() {
  final instance = RidpApi().getAnalyticsApi();

  group(AnalyticsApi, () {
    // Compute and return system-wide dashboard statistics. Restricted to privileged users to prevent sensitive data leakage.
    //
    //Future formApiV1AnalyticsDashboardGet() async
    test('test formApiV1AnalyticsDashboardGet', () async {
      // TODO
    });

    // Returns organization-wide summary statistics.
    //
    //Future formApiV1AnalyticsSummaryGet() async
    test('test formApiV1AnalyticsSummaryGet', () async {
      // TODO
    });

  });
}
