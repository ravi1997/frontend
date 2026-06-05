import 'package:dio/dio.dart';

class ErrorHandler {
  static String handle(Object error) {
    if (error is DioException) {
      final response = error.response;
      if (response?.data is Map<String, dynamic>) {
        final data = response!.data as Map<String, dynamic>;
        return data['message']?.toString() ?? error.message ?? 'Request failed';
      }
      return error.message ?? 'Request failed';
    }
    return error.toString();
  }
}
