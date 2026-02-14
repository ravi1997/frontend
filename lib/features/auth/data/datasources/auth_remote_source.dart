import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_client_wrapper.dart';
import '../../domain/entities/user.dart';

part 'auth_remote_source.g.dart';

abstract class AuthRemoteSource {
  Future<Map<String, dynamic>> login(String identifier, String password);
  Future<Map<String, dynamic>> loginWithOtp(String mobile, String otp);
  Future<void> generateOtp(String mobile);
  Future<void> logout();
  Future<User?> getCurrentUser();
  Future<Map<String, dynamic>> refreshToken(String refreshToken);
  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    required String userType,
    String? employeeId,
    String? mobile,
  });
  Future<void> requestPasswordReset(String email);
}

class AuthRemoteSourceImpl implements AuthRemoteSource {
  final ApiClient _apiClient;
  AuthRemoteSourceImpl(this._apiClient);

  @override
  Future<Map<String, dynamic>> login(String identifier, String password) async {
    final response = await _apiClient.post(
      ApiEndpoints.login,
      data: {'identifier': identifier, 'password': password},
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> loginWithOtp(String mobile, String otp) async {
    final response = await _apiClient.post(
      ApiEndpoints.loginWithOtp,
      data: {'mobile': mobile, 'otp': otp},
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<void> generateOtp(String mobile) async {
    await _apiClient.post(ApiEndpoints.generateOtp, data: {'mobile': mobile});
  }

  @override
  Future<void> logout() async {
    await _apiClient.post(ApiEndpoints.logout);
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.userStatus);
      if (response.data != null && response.data['user'] != null) {
        return User.fromJson(response.data['user'] as Map<String, dynamic>);
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  @override
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    final response = await _apiClient.post(
      ApiEndpoints.refreshToken,
      data: {'refresh_token': refreshToken},
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    required String userType,
    String? employeeId,
    String? mobile,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.register,
      data: {
        'username': username,
        'email': email,
        'password': password,
        'user_type': userType,
        'employee_id': employeeId,
        'mobile': mobile ?? '',
        'roles': [
          'user',
          'creator',
          'editor',
          'publisher',
          'deo',
          'manager',
          'general',
        ],
      },
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<void> requestPasswordReset(String email) async {
    await _apiClient.post(
      ApiEndpoints.requestPasswordReset,
      data: {'email': email},
    );
  }
}

@riverpod
AuthRemoteSource authRemoteSource(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRemoteSourceImpl(apiClient);
}
