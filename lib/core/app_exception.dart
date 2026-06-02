/// Base exception class for the application
sealed class AppException implements Exception {
  final String message;
  final Object? originalError;
  final StackTrace? stackTrace;

  const AppException(this.message, {this.originalError, this.stackTrace});

  /// Log/debug oriented representation.
  ///
  /// Intentionally does not include [originalError] (it may carry sensitive data)
  /// and avoids multi-line / unbounded output.
  String _debugString() {
    // Keep logs single-line and avoid very large payloads (e.g. raw HTML bodies).
    final normalized = message.replaceAll('\n', r'\n').replaceAll('\r', r'\r');
    const maxLen = 500;
    final clipped = normalized.length <= maxLen
        ? normalized
        : '${normalized.substring(0, maxLen)}...';
    return clipped.isEmpty ? '$runtimeType' : '$runtimeType: $clipped';
  }

  @override
  String toString() => _debugString();
}

/// Form-related exceptions
final class FormLoadException extends AppException {
  final String formId;

  const FormLoadException(
    this.formId, {
    Object? originalError,
    StackTrace? stackTrace,
  }) : super(
         'Failed to load form: $formId',
         originalError: originalError,
         stackTrace: stackTrace,
       );
}

final class FormSaveException extends AppException {
  final String formId;

  const FormSaveException(
    this.formId, {
    Object? originalError,
    StackTrace? stackTrace,
  }) : super(
         'Failed to save form: $formId',
         originalError: originalError,
         stackTrace: stackTrace,
       );
}

final class FormVersionException extends AppException {
  final String formId;
  final String versionId;

  const FormVersionException(
    this.formId,
    this.versionId, {
    Object? originalError,
    StackTrace? stackTrace,
  }) : super(
         'Failed to load form version: $versionId for form: $formId',
         originalError: originalError,
         stackTrace: stackTrace,
       );
}

/// Authentication-related exceptions
final class AuthException extends AppException {
  final String? code;

  const AuthException(
    super.message, {
    this.code,
    super.originalError,
    super.stackTrace,
  });
}

/// Network-related exceptions
final class NetworkException extends AppException {
  final int? statusCode;

  const NetworkException(
    super.message, {
    this.statusCode,
    super.originalError,
    super.stackTrace,
  });
}

/// Detailed API exceptions for structured error responses
final class ApiException extends AppException {
  final int? statusCode;
  final String? code;
  final dynamic details;
  final Map<String, dynamic>? fieldErrors;
  final String? requestId;
  final int? retryAfter;

  const ApiException(
    super.message, {
    this.statusCode,
    this.code,
    this.details,
    this.fieldErrors,
    this.requestId,
    this.retryAfter,
    super.originalError,
    super.stackTrace,
  });
}
