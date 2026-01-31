import 'dart:io';
import 'package:dio/dio.dart';

class AppError implements Exception {
  final String message;
  final String? code;

  AppError(this.message, {this.code});

  @override
  String toString() => message;
}

class ErrorHandler {
  static AppError handle(dynamic error) {
    if (error is DioException) {
      return _handleDioError(error);
    } else if (error is SocketException) {
      return AppError('No internet connection. Please check your network.');
    } else if (error is AppError) {
      return error;
    } else {
      return AppError('An unexpected error occurred. Please try again.');
    }
  }

  static AppError _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AppError('Connection timed out. Please try again.');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;
        if (data is Map && data.containsKey('message')) {
          return AppError(data['message']);
        }
        if (statusCode == 401) {
          return AppError('Session expired. Please login again.');
        } else if (statusCode == 403) {
          return AppError('You do not have permission to perform this action.');
        } else if (statusCode == 404) {
          return AppError('The requested resource was not found.');
        } else if (statusCode != null && statusCode >= 500) {
          return AppError('Server error. Please try again later.');
        }
        return AppError('Something went wrong. Status: $statusCode');
      case DioExceptionType.cancel:
        return AppError('Request was cancelled.');
      case DioExceptionType.connectionError:
        return AppError('Failed to connect to the server.');
      default:
        return AppError(
          'A network error occurred. Please check your connection.',
        );
    }
  }
}
