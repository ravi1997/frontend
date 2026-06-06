import 'package:test/test.dart';
import 'package:ridp_api/ridp_api.dart';


/// tests for DashboardApi
void main() {
  final instance = RidpApi().getDashboardApi();

  group(DashboardApi, () {
    // Update Dashboard configuration.
    //
    //Future formApiV1DashboardsDashboardIdPut(String dashboardId, { Map<String, Object> body }) async
    test('test formApiV1DashboardsDashboardIdPut', () async {
      // TODO
    });

    // Create a new Dashboard configuration.
    //
    //Future formApiV1DashboardsPost({ Map<String, Object> body }) async
    test('test formApiV1DashboardsPost', () async {
      // TODO
    });

    // Get dashboard details AND fetch data for widgets.
    //
    //Future formApiV1DashboardsSlugGet(String slug) async
    test('test formApiV1DashboardsSlugGet', () async {
      // TODO
    });

  });
}
