import 'package:test/test.dart';
import 'package:ridp_api/ridp_api.dart';


/// tests for ExternalApiApi
void main() {
  final instance = RidpApi().getExternalApiApi();

  group(ExternalApiApi, () {
    // Fetch details of EMPLOYEE (Empty Route Placeholder).
    //
    //Future formApiV1ExternalEmployeeEmployeeIdGet(String employeeId) async
    test('test formApiV1ExternalEmployeeEmployeeIdGet', () async {
      // TODO
    });

    // Send mail (Empty Route Placeholder).
    //
    //Future formApiV1ExternalMailPost() async
    test('test formApiV1ExternalMailPost', () async {
      // TODO
    });

    // Send SMS (Empty Route Placeholder).
    //
    //Future formApiV1ExternalSmsPost() async
    test('test formApiV1ExternalSmsPost', () async {
      // TODO
    });

    // Fetch details of UHID (Empty Route Placeholder).
    //
    //Future formApiV1ExternalUhidUhidGet(String uhid) async
    test('test formApiV1ExternalUhidUhidGet', () async {
      // TODO
    });

  });
}
