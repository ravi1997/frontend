import 'package:dio/dio.dart';
import 'package:frontend/core/networking/api_endpoints.dart';
import 'package:frontend/core/networking/token_service.dart';
import 'package:frontend/modules/auth/auth_models.dart';

class AuthService {
  final Dio _apiClient;
  final TokenService _tokenService;

  AuthService(this._apiClient, this._tokenService);

  Future<UserModel> login(String identifier, String password) async {
    final response = await _apiClient.post(
      ApiEndpoints.login,
      data: {'identifier': identifier, 'password': password},
    );
    final data = _authData(response.data);
    if (data == null) {
      throw Exception('Login response missing data');
    }

    await _handleAuthResponse(
      data['access_token']?.toString() ?? data['accessToken']?.toString(),
      data['refresh_token']?.toString() ?? data['refreshToken']?.toString(),
      _userFromData(data['user']),
    );
    final user = _userFromData(data['user']);
    if (user != null) return user;

    final currentUser = await _fetchCurrentUserOrNull();
    if (currentUser != null) {
      await _tokenService.setOrganizationId(currentUser.organizationId.toString());
      return currentUser;
    }

    throw Exception('Failed to retrieve user info after login');
  }

  Future<UserModel> loginWithOtp(String mobile, String otp) async {
    final response = await _apiClient.post(
      ApiEndpoints.loginWithOtp,
      data: {'mobile': mobile, 'otp': otp},
    );
    final data = _authData(response.data);
    if (data == null) {
      throw Exception('Login response missing data');
    }

    await _handleAuthResponse(
      data['access_token']?.toString() ?? data['accessToken']?.toString(),
      data['refresh_token']?.toString() ?? data['refreshToken']?.toString(),
      _userFromData(data['user']),
    );
    final user = _userFromData(data['user']);
    if (user != null) return user;

    final currentUser = await _fetchCurrentUserOrNull();
    if (currentUser != null) {
      await _tokenService.setOrganizationId(currentUser.organizationId.toString());
      return currentUser;
    }

    throw Exception('Failed to retrieve user info after login');
  }

  Future<void> requestOtp(String mobile) async {
    await _apiClient.post(
      ApiEndpoints.requestOtp,
      data: {'mobile': mobile},
    );
  }

  Future<void> logout() async {
    try {
      await _apiClient.post(ApiEndpoints.logout);
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
      final response = await _apiClient.get(ApiEndpoints.userProfile);
      final data = _authData(response.data);
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
    await _apiClient.post(
      ApiEndpoints.register,
      data: {
        'username': username,
        'email': email,
        'password': password,
        'user_type': 'general',
        if (employeeId != null) 'employee_id': employeeId,
        if (mobile != null) 'mobile': mobile,
      },
    );
  }

  Future<void> requestPasswordReset(String email) async {
    await _apiClient.post(
      ApiEndpoints.requestPasswordReset,
      data: {'email': email},
    );
  }

  Future<String> refreshToken(String refreshToken) async {
    final response = await _apiClient.post(
      ApiEndpoints.refreshToken,
      options: Options(headers: {'Authorization': 'Bearer $refreshToken'}),
    );
    final data = _authData(response.data);
    final accessToken = data?['access_token']?.toString() ??
        data?['accessToken']?.toString();
    if (accessToken == null) {
      throw Exception('Refresh response missing access token');
    }

    await _handleAuthResponse(
      accessToken,
      data?['refresh_token']?.toString() ?? data?['refreshToken']?.toString(),
      null,
    );
    final organizationId = _tokenService.organizationId;
    if (organizationId != null) {
      await _tokenService.setOrganizationId(organizationId);
    }
    return accessToken;
  }

  Future<void> revokeAll() async {
    await _apiClient.post(ApiEndpoints.revokeAll);
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    await _apiClient.post(
      ApiEndpoints.changePassword,
      data: {'current_password': currentPassword, 'new_password': newPassword},
    );
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
      return raw;
    }
    if (raw is Map) return Map<String, dynamic>.from(raw);
    return null;
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
