import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../entities/user.dart';

part 'auth_repository.g.dart';

abstract class AuthRepository {
  Future<User> login(String identifier, String password);
  Future<User> loginWithOtp(String mobile, String otp);
  Future<void> generateOtp(String mobile);
  Future<void> logout();
  Future<User?> getCurrentUser();
  Future<void> register({
    required String username,
    required String email,
    required String password,
    required String userType,
    String? employeeId,
    String? mobile,
  });
  Future<void> requestPasswordReset(String email);
  Future<String> refreshToken(String refreshToken);
}

@riverpod
AuthRepository authRepository(Ref ref) {
  throw UnimplementedError(
    'authRepository must be overridden by a provider scope',
  );
}
