import 'package:test/test.dart';
import 'package:ridp_api/ridp_api.dart';


/// tests for SmsApi
void main() {
  final instance = RidpApi().getSmsApi();

  group(SmsApi, () {
    // Verify SMS provider connectivity.
    //
    //Future formApiV1SmsHealthGet() async
    test('test formApiV1SmsHealthGet', () async {
      // TODO
    });

    // Send triggered notifications.
    //
    //Future formApiV1SmsNotifyPost() async
    test('test formApiV1SmsNotifyPost', () async {
      // TODO
    });

    // Manually send an OTP. Restrict to admins to prevent spam.
    //
    //Future formApiV1SmsOtpPost() async
    test('test formApiV1SmsOtpPost', () async {
      // TODO
    });

    // Forward a single SMS request to the external provider.
    //
    //Future formApiV1SmsSinglePost() async
    test('test formApiV1SmsSinglePost', () async {
      // TODO
    });

  });
}
