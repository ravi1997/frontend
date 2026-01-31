import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/api_client.dart';
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
  final Dio _dio;
  AuthRemoteSourceImpl(this._dio);

  @override
  Future<Map<String, dynamic>> login(String identifier, String password) async {
    final response = await _dio.post(
      '/auth/login',
      data: {'identifier': identifier, 'password': password},
    );
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> loginWithOtp(String mobile, String otp) async {
    final response = await _dio.post(
      '/auth/login',
      data: {'mobile': mobile, 'otp': otp},
    );
    return response.data;
  }

  @override
  Future<void> generateOtp(String mobile) async {
    await _dio.post('/auth/generate-otp', data: {'mobile': mobile});
  }

  @override
  Future<void> logout() async {
    await _dio.post('/auth/logout');
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final response = await _dio.get('/user/status');
      if (response.data != null && response.data['user'] != null) {
        return User.fromJson(response.data['user']);
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  @override
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    final response = await _dio.post(
      '/auth/refresh',
      data: {'refresh_token': refreshToken},
    );
    return response.data;
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
    final response = await _dio.post(
      '/auth/register',
      data: {
        'username': username,
        'email': email,
        'password': password,
        'user_type': userType,
        'employee_id': employeeId,
        'mobile': mobile,
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
    return response.data;
  }

  @override
  Future<void> requestPasswordReset(String email) async {
    await _dio.post('/auth/request-password-reset', data: {'email': email});
  }
}

@riverpod
AuthRemoteSource authRemoteSource(Ref ref) {
  final dioClient = ref.watch(dioProvider);
  return AuthRemoteSourceImpl(dioClient);
}
