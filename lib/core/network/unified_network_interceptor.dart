import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../exceptions/app_exception.dart';
import '../widgets/snackbar_service.dart';

/// Unified network interceptor that combines error handling, retry logic, and envelope parsing.
///
/// This interceptor provides:
/// - Automatic retry for transient network failures (5xx, timeouts, connection errors)
/// - User-friendly error messages via Snackbar
/// - Envelope/response parsing for API responses
/// - Exponential backoff for retries
class UnifiedNetworkInterceptor extends Interceptor {
  final Logger _logger;
  final SnackbarService _snackbarService;
  final int maxRetries;
  final List<Duration> retryDelays;

  UnifiedNetworkInterceptor({
    required Logger logger,
    required SnackbarService snackbarService,
    this.maxRetries = 3,
    this.retryDelays = const [
      Duration(seconds: 1),
      Duration(seconds: 2),
      Duration(seconds: 4),
    ],
  }) : _logger = logger,
       _snackbarService = snackbarService;

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _parseEnvelope(response);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Check if this is an envelope error
    if (_isEnvelopeError(err)) {
      _handleEnvelopeError(err, handler);
      return;
    }

    // Check if this should be retried
    if (_shouldRetry(err)) {
      await _retryRequest(err, handler);
      return;
    }

    // Show user-friendly error message
    _showErrorMessage(err);

    handler.next(err);
  }

  /// Parse envelope-style API responses.
  void _parseEnvelope(Response response) {
    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      if (data.containsKey('success')) {
        final bool success = data['success'] ?? false;
        if (success) {
          if (data.containsKey('data')) {
            response.data = data['data'];
          }
        } else {
          final errorStr =
              (data['error'] ?? data['msg'] ?? data['message'])?.toString() ??
              'Unknown API error';
          final details = data['details'];

          throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            error: ApiException(
              errorStr,
              details: details,
              statusCode: response.statusCode,
            ),
            type: DioExceptionType.badResponse,
          );
        }
      }
    }
  }

  /// Check if error is from envelope parsing.
  bool _isEnvelopeError(DioException err) {
    return err.error is ApiException;
  }

  /// Handle envelope-specific errors.
  void _handleEnvelopeError(DioException err, ErrorInterceptorHandler handler) {
    // 401 errors should still go through (handled by auth interceptor)
    if (err.response?.statusCode == 401) {
      return handler.next(err);
    }

    // Don't show snackbar for envelope errors (already handled by caller)
    handler.next(err);
  }

  /// Determine if the request should be retried based on error type.
  bool _shouldRetry(DioException err) {
    // Don't retry login requests
    if (err.requestOptions.path.contains('/login')) {
      return false;
    }

    // Don't retry if already marked as retried by AuthInterceptor
    if (err.requestOptions.extra['_retried'] == true) {
      return false;
    }

    // Don't retry if error is from envelope parsing
    if (err.error is ApiException) {
      return false;
    }

    // Retry on timeout errors
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      return true;
    }

    // Retry on connection errors (no internet)
    if (err.type == DioExceptionType.connectionError) {
      return true;
    }

    // Retry on specific HTTP status codes
    final statusCode = err.response?.statusCode;
    if (statusCode != null) {
      // Retry on server errors (502 Bad Gateway, 503 Service Unavailable, 504 Gateway Timeout)
      if (statusCode == 502 || statusCode == 503 || statusCode == 504) {
        return true;
      }

      // Don't retry on client errors (4xx) or auth errors (401, 403)
      if (statusCode >= 400 && statusCode < 500) {
        return false;
      }
    }

    // Retry on unknown errors that might be network-related
    if (err.type == DioExceptionType.unknown) {
      final errorMessage = err.error.toString().toLowerCase();
      if (errorMessage.contains('socket') ||
          errorMessage.contains('network') ||
          errorMessage.contains('connection')) {
        return true;
      }
    }

    return false;
  }

  /// Retry a failed request with exponential backoff.
  Future<void> _retryRequest(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final retryCount = err.requestOptions.extra['_retryCount'] as int? ?? 0;

    // Check if we've exceeded max retries
    if (retryCount >= maxRetries) {
      _logger.w(
        'Max retries ($maxRetries) exceeded for ${err.requestOptions.path}',
      );
      handler.next(err);
      return;
    }

    // Calculate delay for this retry
    final delayIndex = retryCount < retryDelays.length
        ? retryCount
        : retryDelays.length - 1;
    final delay = retryDelays[delayIndex];

    _logger.i(
      'Retrying request (${retryCount + 1}/$maxRetries) after ${delay.inSeconds}s: '
      '${err.requestOptions.method} ${err.requestOptions.path}',
    );

    // Wait before retrying
    await Future.delayed(delay);

    // Create new options with incremented retry count
    final options = Options(
      method: err.requestOptions.method,
      headers: err.requestOptions.headers,
      extra: {...err.requestOptions.extra, '_retryCount': retryCount + 1},
    );

    try {
      final Dio dio = err.requestOptions.extra['_dio'] as Dio;
      final response = await dio.request(
        err.requestOptions.path,
        data: err.requestOptions.data,
        queryParameters: err.requestOptions.queryParameters,
        options: options,
      );

      _logger.i('Retry successful for ${err.requestOptions.path}');
      handler.resolve(response);
    } catch (e) {
      _logger.w('Retry failed for ${err.requestOptions.path}: ${e.toString()}');

      // If the retry also fails, pass the error to the next interceptor
      if (e is DioException) {
        handler.next(e);
      } else {
        handler.next(
          DioException(
            requestOptions: err.requestOptions,
            error: e,
            type: DioExceptionType.unknown,
          ),
        );
      }
    }
  }

  /// Show user-friendly error message for network errors.
  void _showErrorMessage(DioException err) {
    // Don't show message for 401 errors (handled by auth interceptor)
    if (err.response?.statusCode == 401) {
      return;
    }

    // Don't show message for envelope errors (already handled by caller)
    if (err.error is ApiException) {
      return;
    }

    // Don't show message for cancelled requests
    if (err.type == DioExceptionType.cancel) {
      return;
    }

    String? message;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'Connection timed out. Please check your internet.';
        break;
      case DioExceptionType.connectionError:
        message =
            'Connection blocked or unavailable. This may be due to a security policy or CORS mismatch.';
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
  }
}
