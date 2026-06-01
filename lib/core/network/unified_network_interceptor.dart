import 'package:dio/dio.dart';
import '../exceptions/app_exception.dart';
import 'package:frontend/shared/widgets/snackbar.dart';

/// Unified network interceptor that combines error handling and envelope parsing.
///
/// This interceptor provides:
/// - User-friendly error messages via Snackbar
/// - Envelope/response parsing for API responses
class UnifiedNetworkInterceptor extends Interceptor {
  final SnackbarService _snackbarService;

  UnifiedNetworkInterceptor({
    required SnackbarService snackbarService,
  }) : _snackbarService = snackbarService;

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _parseEnvelope(response);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final parsedEnvelopeError = _parseEnvelopeError(err);
    if (parsedEnvelopeError != null) {
      _handleEnvelopeError(parsedEnvelopeError, handler);
      return;
    }

    // Check if this is an envelope error
    if (_isEnvelopeError(err)) {
      _handleEnvelopeError(err, handler);
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
          final parsed = _parseError(data);

          throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            error: ApiException(
              parsed.message,
              code: parsed.code,
              details: parsed.details,
              fieldErrors: parsed.fieldErrors,
              requestId: parsed.requestId,
              retryAfter: parsed.retryAfter,
              statusCode: response.statusCode,
            ),
            type: DioExceptionType.badResponse,
          );
        }
      }
    }
  }

  _ParsedApiError _parseError(Map<String, dynamic> envelope) {
    final rawError = envelope['error'];
    final requestId = envelope['request_id']?.toString();

    if (rawError is Map<String, dynamic>) {
      final retryAfter = rawError['retry_after'];
      final fieldErrors = rawError['field_errors'];
      return _ParsedApiError(
        message:
            rawError['message']?.toString() ??
            envelope['message']?.toString() ??
            'Unknown API error',
        code: rawError['code']?.toString(),
        details: rawError['details'] ?? envelope['details'],
        fieldErrors: fieldErrors is Map<String, dynamic>
            ? fieldErrors
            : fieldErrors is Map
            ? Map<String, dynamic>.from(fieldErrors)
            : null,
        requestId: requestId,
        retryAfter: retryAfter is int
            ? retryAfter
            : int.tryParse(retryAfter?.toString() ?? ''),
      );
    }

    return _ParsedApiError(
      message:
          rawError?.toString() ??
          envelope['msg']?.toString() ??
          envelope['message']?.toString() ??
          'Unknown API error',
      details: envelope['details'],
      requestId: requestId,
    );
  }

  /// Convert a structured API error response into a DioException carrying ApiException.
  DioException? _parseEnvelopeError(DioException err) {
    final response = err.response;
    final data = response?.data;

    if (data is! Map<String, dynamic> || data['success'] != false) {
      return null;
    }

    final parsed = _parseError(data);

    return err.copyWith(
      error: ApiException(
        parsed.message,
        code: parsed.code,
        details: parsed.details,
        fieldErrors: parsed.fieldErrors,
        requestId: parsed.requestId,
        retryAfter: parsed.retryAfter,
        statusCode: response?.statusCode,
      ),
    );
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

class _ParsedApiError {
  final String message;
  final String? code;
  final dynamic details;
  final Map<String, dynamic>? fieldErrors;
  final String? requestId;
  final int? retryAfter;

  const _ParsedApiError({
    required this.message,
    this.code,
    this.details,
    this.fieldErrors,
    this.requestId,
    this.retryAfter,
  });
}
