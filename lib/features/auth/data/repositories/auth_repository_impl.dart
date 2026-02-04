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
    final accessToken = response['access_token'] as String;
    // Backend doesn't return refresh_token, tokens are managed via HTTP-only cookies
    final refreshToken = response['refresh_token'] as String?;
    await _tokenService.setTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );

    final user = await getCurrentUser();
    if (user == null) {
      throw Exception('Failed to retrieve user info after login');
    }
    return user;
  }

  @override
  Future<User> loginWithOtp(String mobile, String otp) async {
    final response = await _remoteSource.loginWithOtp(mobile, otp);
    final accessToken = response['access_token'] as String;
    // Backend doesn't return refresh_token
    final refreshToken = response['refresh_token'] as String?;
    await _tokenService.setTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );

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
      await _tokenService.clearTokens();
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

  Future<String> refreshToken(String refreshToken) async {
    // Note: Backend uses HTTP-only cookies for token management
    // This method is kept for compatibility but tokens are managed by the browser
    throw UnimplementedError(
      'Token refresh is handled via HTTP-only cookies on the backend. '
      'Please re-authenticate if your session expires.',
    );
    // Alternative: If backend adds refresh endpoint, use:
    // final response = await _remoteSource.refreshToken(refreshToken);
    // final newAccessToken = response['access_token'] as String;
    // final newRefreshToken = response['refresh_token'] as String?;
    // await _tokenService.setTokens(
    //   accessToken: newAccessToken,
    //   refreshToken: newRefreshToken,
    // );
    // return newAccessToken;
  }
}

@riverpod
AuthRepository authRepositoryImpl(Ref ref) {
  final remote = ref.watch(authRemoteSourceProvider);
  final tokenService = ref.watch(tokenServiceProvider.notifier);
  return AuthRepositoryImpl(remote, tokenService);
}
