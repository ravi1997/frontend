import 'package:frontend/core/network/token_service.dart';
import 'package:frontend/features/auth/data/datasources/auth_remote_source.dart';
import 'package:frontend/features/auth/domain/entities/user.dart';

/// Lean replacement for the repository chain.
///
/// For now this composes the existing remote source + token store logic.
/// Next steps will inline the remote calls and delete the old layers.
class AuthService {
  AuthService(this._remoteSource, this._tokenService);

  final AuthRemoteSource _remoteSource;
  final TokenService _tokenService;

  Future<User> login(String identifier, String password) async {
    final response = await _remoteSource.login(identifier, password);
    await _handleAuthResponse(response);
    final user = await getCurrentUser();
    if (user == null) {
      await _tokenService.clearTokens();
      throw Exception('Failed to retrieve user info after login');
    }
    return user;
  }

  Future<User> loginWithOtp(String mobile, String otp) async {
    final response = await _remoteSource.loginWithOtp(mobile, otp);
    await _handleAuthResponse(response);
    final user = await getCurrentUser();
    if (user == null) {
      await _tokenService.clearTokens();
      throw Exception('Failed to retrieve user info after login');
    }
    return user;
  }

  Future<void> requestOtp(String mobile) => _remoteSource.requestOtp(mobile);

  Future<void> logout() async {
    try {
      await _remoteSource.logout();
    } finally {
      await _tokenService.clearTokens();
    }
  }

  Future<User?> getCurrentUser() => _remoteSource.getCurrentUser();

  Future<void> register({
    required String username,
    required String email,
    required String password,
    String? employeeId,
    String? mobile,
  }) => _remoteSource.register(
    username: username,
    email: email,
    password: password,
    employeeId: employeeId,
    mobile: mobile,
  );

  Future<void> requestPasswordReset(String email) =>
      _remoteSource.requestPasswordReset(email);

  Future<String> refreshToken(String refreshToken) async {
    final response = await _remoteSource.refreshToken(refreshToken);
    await _handleAuthResponse(response);
    return response['access_token'] as String;
  }

  Future<void> revokeAll() => _remoteSource.revokeAll();

  Future<void> changePassword(String currentPassword, String newPassword) =>
      _remoteSource.changePassword(currentPassword, newPassword);

  Future<void> _handleAuthResponse(Map<String, dynamic> response) async {
    final accessToken = response['access_token'] as String;
    final refreshToken = response['refresh_token'] as String?;
    final userData = response['user'] as Map<String, dynamic>?;
    final organizationId = userData?['organization_id'] as String?;

    await _tokenService.setTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      organizationId: organizationId,
    );
  }
}
