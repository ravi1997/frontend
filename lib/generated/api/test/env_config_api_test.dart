import 'package:test/test.dart';
import 'package:ridp_api/ridp_api.dart';


/// tests for EnvConfigApi
void main() {
  final instance = RidpApi().getEnvConfigApi();

  group(EnvConfigApi, () {
    // Retrieve all backend environment configurations. SUPERADMIN ONLY.
    //
    //Future formApiV1AdminEnvConfigGet() async
    test('test formApiV1AdminEnvConfigGet', () async {
      // TODO
    });

    // Update backend environment configurations. SUPERADMIN ONLY.
    //
    //Future formApiV1AdminEnvConfigPost() async
    test('test formApiV1AdminEnvConfigPost', () async {
      // TODO
    });

    // Update backend environment configurations. SUPERADMIN ONLY.
    //
    //Future formApiV1AdminEnvConfigPut() async
    test('test formApiV1AdminEnvConfigPut', () async {
      // TODO
    });

  });
}
