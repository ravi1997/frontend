import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../networking/dio_provider.dart';

class ApiService {
  ApiService(this._dio);

  final Dio _dio;

  Future<ApiResponse<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _wrap(_dio.get(path, queryParameters: queryParameters));
  }

  Future<ApiResponse<dynamic>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _wrap(_dio.post(path, data: data, queryParameters: queryParameters));
  }

  Future<ApiResponse<dynamic>> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _wrap(_dio.put(path, data: data, queryParameters: queryParameters));
  }

  Future<ApiResponse<dynamic>> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _wrap(_dio.delete(path, data: data, queryParameters: queryParameters));
  }

  Future<ApiResponse<dynamic>> _wrap(Future<Response<dynamic>> future) async {
    final response = await future;
    return ApiResponse<dynamic>(
      data: response.data,
      statusCode: response.statusCode,
      message: response.statusMessage,
      success: (response.statusCode ?? 0) >= 200 && (response.statusCode ?? 0) < 300,
    );
  }
}

class ApiResponse<T> {
  final T data;
  final int? statusCode;
  final String? message;
  final bool success;

  const ApiResponse({
    required this.data,
    required this.statusCode,
    required this.message,
    required this.success,
  });
}

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService(ref.read(dioProvider));
});
