import 'package:dio/dio.dart';
import '../exceptions/app_exception.dart';
import '../widgets/snackbar_service.dart';

class ErrorInterceptor extends Interceptor {
  final SnackbarService _snackbarService;

  ErrorInterceptor(this._snackbarService);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 401 errors are handled by AuthInterceptor (token refresh or redirect to login)
    if (err.response?.statusCode == 401) {
      return handler.next(err);
    }

    // ApiException is already handled by calling code via ErrorHandler
    if (err.error is ApiException) {
      return handler.next(err);
    }

    // Only show snackbar for truly unhandled network-level errors
    String? message;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'Connection timed out. Please check your internet.';
        break;
      case DioExceptionType.connectionError:
        message = 'Connection blocked or unavailable. This may be due to a security policy or CORS mismatch.';
        break;
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        if (statusCode == 500) {
          message = 'Server error, please try again later.';
        } else if (statusCode == 502 ||
            statusCode == 503 ||
            statusCode == 504) {
          message = 'Service temporarily unavailable. Please try again.';
        }
        // 4xx errors (except 500) are handled by calling code
        break;
      case DioExceptionType.cancel:
        break;
      case DioExceptionType.unknown:
        if (err.error.toString().contains('SocketException')) {
          message = 'No internet connection.';
        }
        break;
      default:
        break;
    }

    if (message != null) {
      _snackbarService.showError(message);
    }

    handler.next(err);
  }
}
