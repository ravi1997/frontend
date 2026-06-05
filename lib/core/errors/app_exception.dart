class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException(this.statusCode, this.message);

  @override
  String toString() {
    return 'ApiException($statusCode): $message';
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