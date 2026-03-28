import 'package:dio/dio.dart';
import '../exceptions/app_exception.dart';
import '../widgets/snackbar_service.dart';

class ErrorInterceptor extends Interceptor {
  final SnackbarService _snackbarService;

  ErrorInterceptor(this._snackbarService);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String? message;

    if (err.error is ApiException) {
      final apiException = err.error as ApiException;
      message = apiException.message;
      // potentially log or process details here
    } else if (err.response?.data is Map<String, dynamic>) {
      final data = err.response?.data as Map<String, dynamic>;
      message = (data['error'] ?? data['message'])?.toString();
    }

    if (message == null) {
      switch (err.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          message = 'Connection timed out. Please check your internet.';
          break;
        case DioExceptionType.connectionError:
          message = 'No internet connection available.';
          break;
        case DioExceptionType.badResponse:
          final statusCode = err.response?.statusCode;
          if (statusCode == 500) {
            message = 'Server error, please try again later.';
          } else if (statusCode == 404) {
            message = 'Resource not found.';
          } else if (statusCode == 403) {
            message = 'Permission denied.';
          } else if (statusCode == 401) {
            // Usually handled by AuthInterceptor, but if it falls through:
            message = 'Session expired. Please login again.';
          } else {
            message = 'An error occurred ($statusCode).';
          }
          break;
        case DioExceptionType.cancel:
          break;
        case DioExceptionType.unknown:
          if (err.error.toString().contains('SocketException')) {
            message = 'No internet connection.';
          } else {
            message = 'An unexpected error occurred.';
          }
          break;
        default:
          message = 'Something went wrong.';
          break;
      }
    }

    if (message != null) {
      _snackbarService.showError(message);
    }

    handler.next(err);
  }
}
