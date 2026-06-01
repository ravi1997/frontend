import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_client_wrapper.dart';
import '../../domain/entities/user.dart';

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
      // Backend LoginSchema uses `identifier` (accepts username or email).
      data: {'identifier': email, 'password': password},
    );
    return _responseMap(response);
  }

  @override
  Future<Map<String, dynamic>> loginWithOtp(String mobile, String otp) async {
    final response = await _apiClient.post(
      ApiEndpoints.loginWithOtp,
      data: {'mobile': mobile, 'otp': otp},
    );
    return _responseMap(response);
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
      final mapData = _responseMap(response);
      final userData = _extractUserMap(mapData);
      if (userData != null) {
        return User.fromJson(userData);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return null;
      }
      debugPrint('Error in getCurrentUser: $e');
      rethrow;
    } catch (e) {
      debugPrint('Error in getCurrentUser: $e');
      rethrow;
    }
    return null;
  }

  @override
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    final response = await _apiClient.post(
      ApiEndpoints.refreshToken,
      options: Options(headers: {'Authorization': 'Bearer $refreshToken'}),
    );
    return _responseMap(response);
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
        'user_type': 'general',
        if (employeeId != null) 'employee_id': employeeId,
        if (mobile != null) 'mobile': mobile,
      },
    );
    return _responseMap(response);
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

  Map<String, dynamic> _responseMap(Response response) {
    dynamic data = response.data;

    if (data is String) {
      try {
        data = jsonDecode(data);
      } catch (_) {
        throw FormatException(
          'Expected JSON response for auth endpoint, got string payload',
        );
      }
    }

    if (data is! Map) {
      throw FormatException(
        'Expected JSON object for auth endpoint, got ${data.runtimeType}',
      );
    }

    final mapData = Map<String, dynamic>.from(data);
    final envelopeData = mapData['data'];

    if (mapData['success'] == true && envelopeData is Map) {
      return Map<String, dynamic>.from(envelopeData);
    }

    return mapData;
  }

  Map<String, dynamic>? _extractUserMap(Map<String, dynamic> data) {
    final userData = data['user'];
    if (userData is Map) {
      return Map<String, dynamic>.from(userData);
    }

    if (data.containsKey('id') && data.containsKey('username')) {
      return data;
    }

    return null;
  }
}

final authRemoteSourceProvider = Provider<AuthRemoteSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRemoteSourceImpl(apiClient);
});
