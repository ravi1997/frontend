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
    final refreshToken = response['refresh_token'] as String?;
    final userData = response['user'] as Map<String, dynamic>?;
    final organizationId = userData?['organization_id'] as String?;

    await _tokenService.setTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      organizationId: organizationId,
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
    final refreshToken = response['refresh_token'] as String?;
    final userData = response['user'] as Map<String, dynamic>?;
    final organizationId = userData?['organization_id'] as String?;

    await _tokenService.setTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      organizationId: organizationId,
    );

    final user = await getCurrentUser();
    if (user == null) {
      throw Exception('Failed to retrieve user info after login');
    }
    return user;
  }

  @override
  Future<void> requestOtp(String mobile) async {
    await _remoteSource.requestOtp(mobile);
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
    final user = await _remoteSource.getCurrentUser();
    // After getting user, update organizationId if available
    if (user?.organizationId != null) {
      await _tokenService.setOrganizationId(user!.organizationId!);
    }
    return user;
  }

  @override
  Future<void> register({
    required String username,
    required String email,
    required String password,
    String? employeeId,
    String? mobile,
  }) async {
    await _remoteSource.register(
      username: username,
      email: email,
      password: password,
      employeeId: employeeId,
      mobile: mobile,
    );
  }

  @override
  Future<void> requestPasswordReset(String email) async {
    await _remoteSource.requestPasswordReset(email);
  }

  @override
  Future<String> refreshToken(String refreshToken) async {
    final response = await _remoteSource.refreshToken(refreshToken);
    final newAccessToken = response['access_token'] as String;
    final newRefreshToken = response['refresh_token'] as String?;
    final userData = response['user'] as Map<String, dynamic>?;
    final organizationId = userData?['organization_id'] as String?;

    await _tokenService.setTokens(
      accessToken: newAccessToken,
      refreshToken: newRefreshToken,
      organizationId: organizationId,
    );

    return newAccessToken;
  }

  @override
  Future<void> revokeAll() async {
    await _remoteSource.revokeAll();
  }

  @override
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    await _remoteSource.changePassword(currentPassword, newPassword);
  }
}

@riverpod
AuthRepository authRepositoryImpl(Ref ref) {
  final remote = ref.watch(authRemoteSourceProvider);
  final tokenService = ref.watch(tokenServiceProvider.notifier);
  return AuthRepositoryImpl(remote, tokenService);
}
