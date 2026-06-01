import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String identifier, String password);
  Future<User> loginWithOtp(String mobile, String otp);
  Future<void> requestOtp(String mobile);
  Future<void> logout();
  Future<User?> getCurrentUser();
  Future<void> register({
    required String username,
    required String email,
    required String password,
    String? employeeId,
    String? mobile,
  });
  Future<void> requestPasswordReset(String email);
  Future<String> refreshToken(String refreshToken);
  Future<void> revokeAll();
  Future<void> changePassword(String currentPassword, String newPassword);
}
