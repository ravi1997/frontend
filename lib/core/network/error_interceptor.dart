import 'package:dio/dio.dart';
import '../widgets/snackbar_service.dart';

class ErrorInterceptor extends Interceptor {
  final SnackbarService _snackbarService;

  ErrorInterceptor(this._snackbarService);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Handled by AuthInterceptor
      return handler.next(err);
    }

    String? message;

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
          message = 'Server is busy, please try again.';
        } else if (statusCode == 404) {
          message = 'Resource not found (404).';
        } else if (statusCode == 403) {
          message = 'You do not have permission to perform this action.';
        } else {
          // Optionally parse backend error message here
          message = 'An error occurred (${statusCode}).';
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

    if (message != null) {
      _snackbarService.showError(message);
    }

    handler.next(err);
  }
}
