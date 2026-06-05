// lib/features/auth/auth_service.dart

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend/core/networking/api_client.dart';
import 'package:frontend/core/networking/api_endpoints.dart';
import 'package:frontend/core/networking/token_service.dart';
import 'package:frontend/modules/auth/auth_models.dart';

class AuthService {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  AuthService(this._apiClient, this._tokenService);

  Future<UserModel> login(String identifier, String password) async {
    final response = await _apiClient.post(
      ApiEndpoints.login,
      data: {'identifier': identifier, 'password': password},
    );
    final mapData = _responseMap(response);
    await _handleAuthResponse(mapData);
    final responseUser = _extractUserMap(mapData);
    if (responseUser != null) {
      return UserModel.fromJson(responseUser);
    }
    final user = await getCurrentUser();
    if (user == null) {
      await _tokenService.clearTokens();
      throw Exception('Failed to retrieve user info after login');
    }
    return user;
  }

  Future<UserModel> loginWithOtp(String mobile, String otp) async {
    final response = await _apiClient.post(
      ApiEndpoints.loginWithOtp,
      data: {'mobile': mobile, 'otp': otp},
    );
    final mapData = _responseMap(response);
    await _handleAuthResponse(mapData);
    final responseUser = _extractUserMap(mapData);
    if (responseUser != null) {
      return UserModel.fromJson(responseUser);
    }
    final user = await getCurrentUser();
    if (user == null) {
      await _tokenService.clearTokens();
      throw Exception('Failed to retrieve user info after login');
    }
    return user;
  }

  Future<void> requestOtp(String mobile) async {
    await _apiClient.post(ApiEndpoints.requestOtp, data: {'mobile': mobile});
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
      final response = await _apiClient.get(ApiEndpoints.userStatus);
      final mapData = _responseMap(response);
      final userData = _extractUserMap(mapData);
      if (userData != null) {
        return UserModel.fromJson(userData);
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
    final mapData = _responseMap(response);
    await _handleAuthResponse(mapData);
    return mapData['access_token'] as String;
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

  Map<String, dynamic> _responseMap(Response response) {
    dynamic data = response.data;

    if (data is String) {
      try {
        data = jsonDecode(data);
      } catch (_) {
        throw const FormatException(
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
