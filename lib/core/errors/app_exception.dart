class ApiException implements Exception {
  final int statusCode;
  final String message;
  final String? code;
  final dynamic details;
  final Map<String, dynamic>? fieldErrors;
  final String? requestId;

  ApiException(
    this.statusCode,
    this.message, {
    this.code,
    this.details,
    this.fieldErrors,
    this.requestId,
  });

  @override
  String toString() {
    return 'ApiException($statusCode): $message (code: $code, requestId: $requestId)';
  }
}

class AuthException implements Exception {
  final String message;
  final dynamic originalError;

  AuthException(this.message, [this.originalError]);

  @override
  String toString() {
    return 'AuthException: $message${originalError != null ? ' (Original: $originalError)' : ''}';
  }
}

class NetworkException implements Exception {
  final String message;
  final dynamic originalError;

  NetworkException(this.message, [this.originalError]);

  @override
  String toString() {
    return 'NetworkException: $message${originalError != null ? ' (Original: $originalError)' : ''}';
  }
}

class AppException implements Exception {
  final String message;
  final dynamic originalError;

  AppException(this.message, [this.originalError]);

  @override
  String toString() {
    return 'AppException: $message${originalError != null ? ' (Original: $originalError)' : ''}';
  }
}