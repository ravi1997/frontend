import 'package:dio/dio.dart';
import 'package:frontend/core/networking/api_client.dart';
import 'package:frontend/core/networking/api_requests.dart';
import 'package:frontend/core/networking/token_service.dart';
import 'package:frontend/modules/auth/auth_models.dart';

class AuthService {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  AuthService(this._apiClient, this._tokenService);

  Future<UserModel> login(String identifier, String password) async {
    final data = _authData(
      await _apiClient.login(
        LoginRequest(identifier: identifier, password: password),
      ),
    );
    return _completeLogin(data, fallbackUserKey: 'user');
  }

  Future<UserModel> loginWithOtp(String mobile, String otp) async {
    final data = _authData(
      await _apiClient.loginWithOtp(OtpLoginRequest(mobile: mobile, otp: otp)),
    );
    return _completeLogin(data, fallbackUserKey: 'user');
  }

  Future<void> requestOtp(String mobile) async {
    await _apiClient.requestOtp(OtpRequest(mobile: mobile));
  }

  Future<void> logout() async {
    try {
      await _apiClient.logout();
    } finally {
      await _tokenService.clearTokens();
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      return await _fetchCurrentUserOrNull();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        return null;
      }
      rethrow;
    }
  }

  Future<UserModel?> _fetchCurrentUserOrNull() async {
    try {
      final data = _authData(await _apiClient.currentUser());
      return _userFromData(data?['user'] ?? data);
    } on DioException {
      return null;
    }
  }

  Future<void> register({
    required String username,
    required String email,
    required String password,
    String? employeeId,
    String? mobile,
  }) async {
    await _apiClient.register(
      RegisterRequest(
        username: username,
        email: email,
        password: password,
        employeeId: employeeId,
        mobile: mobile,
      ),
    );
  }

  Future<void> requestPasswordReset(String email) async {
    await _apiClient.requestPasswordReset(PasswordResetRequest(email: email));
  }

  Future<String> refreshToken(String refreshToken) async {
    final data = _authData(await _apiClient.refreshToken(refreshToken));
    final accessToken = _tokenFromData(data, 'access_token');
    if (accessToken == null) {
      throw Exception('Refresh response missing access token');
    }

    await _handleAuthResponse(
      accessToken,
      _tokenFromData(data, 'refresh_token'),
      null,
    );
    final organizationId = _tokenService.organizationId;
    if (organizationId != null) {
      await _tokenService.setOrganizationId(organizationId);
    }
    return accessToken;
  }

  Future<void> revokeAll() async {
    await _apiClient.revokeAll();
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    await _apiClient.changePassword(
      ChangePasswordRequest(
        currentPassword: currentPassword,
        newPassword: newPassword,
      ),
    );
  }

  Future<UserModel> verifyOidcCallback(String code, String state) async {
    final data = _authData(await _apiClient.oidcCallback(code, state));
    if (data == null) {
      throw Exception('OIDC Callback response missing data');
    }

    await _handleAuthResponse(
      _tokenFromData(data, 'access_token'),
      _tokenFromData(data, 'refresh_token'),
      _userFromData(data['user']),
    );
    final user = _userFromData(data['user']);
    if (user != null) return user;

    final currentUser = await _fetchCurrentUserOrNull();
    if (currentUser != null) {
      await _tokenService.setOrganizationId(currentUser.organizationId.toString());
      return currentUser;
    }

    throw Exception('Failed to retrieve user info after OIDC login');
  }

  Future<UserModel> _completeLogin(
    Map<String, dynamic>? data, {
    required String fallbackUserKey,
  }) async {
    if (data == null) {
      throw Exception('Login response missing data');
    }

    await _handleAuthResponse(
      _tokenFromData(data, 'access_token'),
      _tokenFromData(data, 'refresh_token'),
      _userFromData(data['user'] ?? data['user_data'] ?? data['profile']),
    );
    final user =
        _userFromData(data['user'] ?? data['user_data'] ?? data['profile']);
    if (user != null) return user;

    final currentUser = await _fetchCurrentUserOrNull();
    if (currentUser != null) {
      await _tokenService.setOrganizationId(
        currentUser.organizationId.toString(),
      );
      return currentUser;
    }

    throw Exception('Failed to retrieve user info after login');
  }

  Future<void> _handleAuthResponse(
    String? accessToken,
    String? refreshToken,
    UserModel? user,
  ) async {
    if (accessToken == null) {
      throw Exception('Auth response missing access token');
    }

    await _tokenService.setTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      organizationId: user?.organizationId?.toString(),
    );
  }

  Map<String, dynamic>? _authData(dynamic raw) {
    if (raw is Map<String, dynamic>) {
      final data = raw['data'];
      if (data is Map<String, dynamic>) return data;
      if (data is Map) return Map<String, dynamic>.from(data);
      if (raw['user'] is Map<String, dynamic>) return raw;
      if (raw['user'] is Map) return Map<String, dynamic>.from(raw);
      return raw;
    }
    if (raw is Map) return Map<String, dynamic>.from(raw);
    return null;
  }

  String? _tokenFromData(Map<String, dynamic>? data, String key) {
    switch (key) {
      case 'access_token':
        return data?['access_token']?.toString() ??
            data?['accessToken']?.toString();
      case 'refresh_token':
        return data?['refresh_token']?.toString() ??
            data?['refreshToken']?.toString();
      default:
        return data?[key]?.toString();
    }
  }

  UserModel? _userFromData(dynamic raw) {
    if (raw == null) return null;
    if (raw is UserModel) return raw;
    if (raw is Map<String, dynamic> && raw.containsKey('user')) {
      return _userFromData(raw['user']);
    }
    try {
      if (raw is Map<String, dynamic>) {
        return UserModel.fromJson(raw);
      }
      if (raw is Map) {
        return UserModel.fromJson(Map<String, dynamic>.from(raw));
      }
    } catch (_) {
      return null;
    }
    return null;
  }
}
