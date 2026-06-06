import 'package:test/test.dart';
import 'package:ridp_api/ridp_api.dart';


/// tests for AuthApi
void main() {
  final instance = RidpApi().getAuthApi();

  group(AuthApi, () {
    // Authenticate via password or OTP and issue JWT tokens.
    //
    // Authenticate via password or OTP and issue JWT tokens.
    //
    //Future<FormApiV1AuthLoginPost200Response> formApiV1AuthLoginPost(LoginRequest body) async
    test('test formApiV1AuthLoginPost', () async {
      // TODO
    });

    // Revoke the current JWT session.
    //
    // Revokes the user's access and refresh tokens.
    //
    //Future formApiV1AuthLogoutPost() async
    test('test formApiV1AuthLogoutPost', () async {
      // TODO
    });

    // Issue a new access token using a valid refresh token.
    //
    // Generates a new access token using a valid refresh token.
    //
    //Future<FormApiV1AuthRefreshPost200Response> formApiV1AuthRefreshPost() async
    test('test formApiV1AuthRefreshPost', () async {
      // TODO
    });

    // Register a new user account.
    //
    // Registers a new user and returns user details.
    //
    //Future<UserOut> formApiV1AuthRegisterPost(UserCreateSchema body) async
    test('test formApiV1AuthRegisterPost', () async {
      // TODO
    });

    // Generate and send an OTP to the given mobile/email.
    //
    // Generate and send an OTP to the given mobile/email.
    //
    //Future formApiV1AuthRequestOtpPost(FormApiV1AuthRequestOtpPostRequest body) async
    test('test formApiV1AuthRequestOtpPost', () async {
      // TODO
    });

    // Revoke all active sessions for the authenticated user.
    //
    // Revokes all active JWT sessions for the authenticated user.
    //
    //Future formApiV1AuthRevokeAllPost() async
    test('test formApiV1AuthRevokeAllPost', () async {
      // TODO
    });

  });
}
