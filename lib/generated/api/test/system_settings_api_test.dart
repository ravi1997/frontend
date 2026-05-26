import 'package:test/test.dart';
import 'package:ridp_api/ridp_api.dart';


/// tests for SystemSettingsApi
void main() {
  final instance = RidpApi().getSystemSettingsApi();

  group(SystemSettingsApi, () {
    // Retrieve the global system configuration.
    //
    //Future formApiV1AdminSystemSettingsGet() async
    test('test formApiV1AdminSystemSettingsGet', () async {
      // TODO
    });

    // Update the global system configuration.
    //
    //Future formApiV1AdminSystemSettingsPut({ SystemSettingsUpdateSchema body }) async
    test('test formApiV1AdminSystemSettingsPut', () async {
      // TODO
    });

  });
}
