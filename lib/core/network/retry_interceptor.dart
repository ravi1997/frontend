import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

/// Interceptor that automatically retries failed requests.
///
/// This interceptor handles transient network failures by automatically
/// retrying requests with exponential backoff. It's smart enough to:
/// - Only retry on network/timeout errors (not auth or validation errors)
/// - Use configurable retry delays with exponential backoff
/// - Respect the maximum retry limit
/// - Log retry attempts for debugging
/// - Preserve request options including headers and data
///
/// Retry-able error types:
/// - Connection timeout
/// - Send timeout
/// - Receive timeout
/// - Connection errors (no internet)
/// - 5xx server errors (502, 503, 504)
class RetryInterceptor extends Interceptor {
  final Dio _dio;
  final Logger _logger;
  final int maxRetries;
  final List<Duration> retryDelays;

  RetryInterceptor({
    required Dio dio,
    required Logger logger,
    this.maxRetries = 3,
    this.retryDelays = const [
      Duration(seconds: 1),
      Duration(seconds: 2),
      Duration(seconds: 4),
    ],
  })  : _dio = dio,
        _logger = logger;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Check if this request should be retried
    if (!_shouldRetry(err)) {
      return handler.next(err);
    }

    // Get current retry count
    final retryCount = err.requestOptions.extra['_retryCount'] as int? ?? 0;

    // Check if we've exceeded max retries
    if (retryCount >= maxRetries) {
      _logger.w(
        'Max retries ($maxRetries) exceeded for ${err.requestOptions.path}',
      );
      return handler.next(err);
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
      extra: {
        ...err.requestOptions.extra,
        '_retryCount': retryCount + 1,
      },
    );

    try {
      // Retry the request
      final response = await _dio.request(
        err.requestOptions.path,
        data: err.requestOptions.data,
        queryParameters: err.requestOptions.queryParameters,
        options: options,
      );

      _logger.i(
        'Retry successful for ${err.requestOptions.path}',
      );

      return handler.resolve(response);
    } catch (e) {
      _logger.w(
        'Retry failed for ${err.requestOptions.path}: ${e.toString()}',
      );

      // If the retry also fails, pass the error to the next interceptor
      if (e is DioException) {
        return handler.next(e);
      } else {
        return handler.next(
          DioException(
            requestOptions: err.requestOptions,
            error: e,
            type: DioExceptionType.unknown,
          ),
        );
      }
    }
  }

  /// Determine if the request should be retried based on error type
  bool _shouldRetry(DioException err) {
    // Don't retry if already marked as retried by AuthInterceptor
    if (err.requestOptions.extra['_retried'] == true) {
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
}
