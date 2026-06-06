import 'package:test/test.dart';
import 'package:ridp_api/ridp_api.dart';


/// tests for ViewApi
void main() {
  final instance = RidpApi().getViewApi();

  group(ViewApi, () {
    // View a form. Supports both public and authenticated access. Public forms are accessible without authentication. Private forms require authentication and organization match.
    //
    //Future formApiV1ViewFormIdGet(String formId) async
    test('test formApiV1ViewFormIdGet', () async {
      // TODO
    });

    // Get form metadata without authentication for public forms. Used for initial form discovery.
    //
    //Future formApiV1ViewFormIdInfoGet(String formId) async
    test('test formApiV1ViewFormIdInfoGet', () async {
      // TODO
    });

    //Future formApiV1ViewGet() async
    test('test formApiV1ViewGet', () async {
      // TODO
    });

  });
}
