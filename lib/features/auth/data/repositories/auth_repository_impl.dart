import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/token_service.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_source.dart';

part 'auth_repository_impl.g.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteSource _remoteSource;
  final TokenService _tokenService;

  AuthRepositoryImpl(this._remoteSource, this._tokenService);

  @override
  Future<User> login(String identifier, String password) async {
    final response = await _remoteSource.login(identifier, password);
    final token = response['access_token'] as String;
    await _tokenService.setToken(token);

    // After login, we might want to fetch user data if the login response doesn't have it
    // The current documentation says /login returns access_token.
    // Let's assume we need to fetch user status.
    final user = await getCurrentUser();
    if (user == null) {
      throw Exception('Failed to retrieve user info after login');
    }
    return user;
  }

  @override
  Future<User> loginWithOtp(String mobile, String otp) async {
    final response = await _remoteSource.loginWithOtp(mobile, otp);
    final token = response['access_token'] as String;
    await _tokenService.setToken(token);

    final user = await getCurrentUser();
    if (user == null) {
      throw Exception('Failed to retrieve user info after login');
    }
    return user;
  }

  @override
  Future<void> generateOtp(String mobile) async {
    await _remoteSource.generateOtp(mobile);
  }

  @override
  Future<void> logout() async {
    try {
      await _remoteSource.logout();
    } finally {
      await _tokenService.clearToken();
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    return _remoteSource.getCurrentUser();
  }

  @override
  Future<void> register({
    required String username,
    required String email,
    required String password,
    required String userType,
    String? employeeId,
    String? mobile,
  }) async {
    await _remoteSource.register(
      username: username,
      email: email,
      password: password,
      userType: userType,
      employeeId: employeeId,
      mobile: mobile,
    );
  }

  @override
  Future<void> requestPasswordReset(String email) async {
    await _remoteSource.requestPasswordReset(email);
  }
}

@riverpod
AuthRepository authRepositoryImpl(Ref ref) {
  final remote = ref.watch(authRemoteSourceProvider);
  final tokenService = ref.watch(tokenServiceProvider.notifier);
  return AuthRepositoryImpl(remote, tokenService);
}
