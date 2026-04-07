import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_client_wrapper.dart';
import '../../domain/entities/user.dart';

part 'auth_remote_source.g.dart';

abstract class AuthRemoteSource {
  Future<Map<String, dynamic>> login(String email, String password);
  Future<Map<String, dynamic>> loginWithOtp(String mobile, String otp);
  Future<void> requestOtp(String mobile);
  Future<void> logout();
  Future<User?> getCurrentUser();
  Future<Map<String, dynamic>> refreshToken(String refreshToken);
  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    String? employeeId,
    String? mobile,
  });
  Future<void> requestPasswordReset(String email);
  Future<void> revokeAll();
  Future<void> changePassword(String currentPassword, String newPassword);
}

class AuthRemoteSourceImpl implements AuthRemoteSource {
  final ApiClient _apiClient;
  AuthRemoteSourceImpl(this._apiClient);

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _apiClient.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
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
  Future<void> requestOtp(String mobile) async {
    await _apiClient.post(ApiEndpoints.requestOtp, data: {'mobile': mobile});
  }

  @override
  Future<void> logout() async {
    await _apiClient.post(ApiEndpoints.logout);
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.userStatus);
      dynamic data = response.data;

      // Unpack string manually if DIO doesn't map it to JSON due to content-type issues
      if (data is String) {
        try {
          data = jsonDecode(data);
        } catch (_) {}
      }

      if (data is Map) {
        final mapData = Map<String, dynamic>.from(data);
        if (mapData.containsKey('user')) {
          return User.fromJson(mapData['user'] as Map<String, dynamic>);
        }
        // If the entire data object is the user
        if (mapData.containsKey('id') && mapData.containsKey('username')) {
          return User.fromJson(mapData);
        }
      }
    } catch (e, st) {
      print('Error in getCurrentUser: \$e\\n\$st');
      return null;
    }
    return null;
  }

  @override
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    final response = await _apiClient.post(
      ApiEndpoints.refreshToken,
      options: Options(
        headers: {'Authorization': 'Bearer $refreshToken'},
      ),
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    String? employeeId,
    String? mobile,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.register,
      data: {
        'username': username,
        'email': email,
        'password': password,
        if (employeeId != null) 'employee_id': employeeId,
        if (mobile != null) 'mobile': mobile,
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

  @override
  Future<void> revokeAll() async {
    await _apiClient.post(ApiEndpoints.revokeAll);
  }

  @override
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    await _apiClient.post(
      ApiEndpoints.changePassword,
      data: {'current_password': currentPassword, 'new_password': newPassword},
    );
  }
}

@riverpod
AuthRemoteSource authRemoteSource(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRemoteSourceImpl(apiClient);
}
