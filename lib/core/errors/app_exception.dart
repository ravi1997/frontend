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

  const AppException(this.message, [this.originalError]);

  @override
  String toString() {
    return 'AppException: $message${originalError != null ? ' (Original: $originalError)' : ''}';
  }
}

class FormLoadException extends AppException {
  final String formId;

  const FormLoadException(this.formId, {dynamic originalError})
      : super('Failed to load form: $formId', originalError);
}

class FormSaveException extends AppException {
  final String formId;

  const FormSaveException(this.formId, {dynamic originalError})
      : super('Failed to save form: $formId', originalError);
}

class FormVersionException extends AppException {
  final String formId;
  final String versionId;

  const FormVersionException(this.formId, this.versionId, {dynamic originalError})
      : super('Failed to load form version: $versionId for form: $formId', originalError);
}
