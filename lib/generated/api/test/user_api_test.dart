import 'package:test/test.dart';
import 'package:ridp_api/ridp_api.dart';


/// tests for UserApi
void main() {
  final instance = RidpApi().getUserApi();

  group(UserApi, () {
    // Securely change current user's password.
    //
    //Future<UserOut> formApiV1UserChangePasswordPost() async
    test('test formApiV1UserChangePasswordPost', () async {
      // TODO
    });

    // Return currently authenticated user's profile.
    //
    //Future<UserOut> formApiV1UserProfileGet() async
    test('test formApiV1UserProfileGet', () async {
      // TODO
    });

    // Get account lock status for a specific user. Admin only.
    //
    //Future<FormApiV1UserSecurityLockStatusUserIdGet200Response> formApiV1UserSecurityLockStatusUserIdGet(String userId) async
    test('test formApiV1UserSecurityLockStatusUserIdGet', () async {
      // TODO
    });

    // Return currently authenticated user's profile.
    //
    //Future<UserOut> formApiV1UserStatusGet() async
    test('test formApiV1UserStatusGet', () async {
      // TODO
    });

    // List all registered users. Admin only.
    //
    //Future<UserOut> formApiV1UserUsersGet() async
    test('test formApiV1UserUsersGet', () async {
      // TODO
    });

    // Provision a new user account. Admin only.
    //
    //Future<UserOut> formApiV1UserUsersPost({ UserUpdateSchema body }) async
    test('test formApiV1UserUsersPost', () async {
      // TODO
    });

    // Soft-delete a user account. Superadmin only.
    //
    //Future formApiV1UserUsersUserIdDelete(String userId) async
    test('test formApiV1UserUsersUserIdDelete', () async {
      // TODO
    });

    // Fetch details of a specific user. Admin only.
    //
    //Future<UserOut> formApiV1UserUsersUserIdGet(String userId) async
    test('test formApiV1UserUsersUserIdGet', () async {
      // TODO
    });

    // Manually lock a user account. Admin only.
    //
    //Future formApiV1UserUsersUserIdLockPost(String userId) async
    test('test formApiV1UserUsersUserIdLockPost', () async {
      // TODO
    });

    // Update user attributes. Admin only.
    //
    //Future<UserOut> formApiV1UserUsersUserIdPut(String userId, { UserUpdateSchema body }) async
    test('test formApiV1UserUsersUserIdPut', () async {
      // TODO
    });

    // Update user roles. Admin only.
    //
    //Future<UserOut> formApiV1UserUsersUserIdRolesPut(String userId) async
    test('test formApiV1UserUsersUserIdRolesPut', () async {
      // TODO
    });

    // Manually unlock a user account. Admin only.
    //
    //Future formApiV1UserUsersUserIdUnlockPost(String userId) async
    test('test formApiV1UserUsersUserIdUnlockPost', () async {
      // TODO
    });

    // Securely change current user's password.
    //
    //Future<UserOut> formApiV1UsersChangePasswordPost() async
    test('test formApiV1UsersChangePasswordPost', () async {
      // TODO
    });

    // Return currently authenticated user's profile.
    //
    //Future<UserOut> formApiV1UsersProfileGet() async
    test('test formApiV1UsersProfileGet', () async {
      // TODO
    });

    // Get account lock status for a specific user. Admin only.
    //
    //Future<FormApiV1UserSecurityLockStatusUserIdGet200Response> formApiV1UsersSecurityLockStatusUserIdGet(String userId) async
    test('test formApiV1UsersSecurityLockStatusUserIdGet', () async {
      // TODO
    });

    // Return currently authenticated user's profile.
    //
    //Future<UserOut> formApiV1UsersStatusGet() async
    test('test formApiV1UsersStatusGet', () async {
      // TODO
    });

    // List all registered users. Admin only.
    //
    //Future<UserOut> formApiV1UsersUsersGet() async
    test('test formApiV1UsersUsersGet', () async {
      // TODO
    });

    // Provision a new user account. Admin only.
    //
    //Future<UserOut> formApiV1UsersUsersPost({ UserUpdateSchema body }) async
    test('test formApiV1UsersUsersPost', () async {
      // TODO
    });

    // Soft-delete a user account. Superadmin only.
    //
    //Future formApiV1UsersUsersUserIdDelete(String userId) async
    test('test formApiV1UsersUsersUserIdDelete', () async {
      // TODO
    });

    // Fetch details of a specific user. Admin only.
    //
    //Future<UserOut> formApiV1UsersUsersUserIdGet(String userId) async
    test('test formApiV1UsersUsersUserIdGet', () async {
      // TODO
    });

    // Manually lock a user account. Admin only.
    //
    //Future formApiV1UsersUsersUserIdLockPost(String userId) async
    test('test formApiV1UsersUsersUserIdLockPost', () async {
      // TODO
    });

    // Update user attributes. Admin only.
    //
    //Future<UserOut> formApiV1UsersUsersUserIdPut(String userId, { UserUpdateSchema body }) async
    test('test formApiV1UsersUsersUserIdPut', () async {
      // TODO
    });

    // Update user roles. Admin only.
    //
    //Future<UserOut> formApiV1UsersUsersUserIdRolesPut(String userId) async
    test('test formApiV1UsersUsersUserIdRolesPut', () async {
      // TODO
    });

    // Manually unlock a user account. Admin only.
    //
    //Future formApiV1UsersUsersUserIdUnlockPost(String userId) async
    test('test formApiV1UsersUsersUserIdUnlockPost', () async {
      // TODO
    });

  });
}
