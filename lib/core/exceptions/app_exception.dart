/// Base exception class for the application
sealed class AppException implements Exception {
  final String message;
  final Object? originalError;
  final StackTrace? stackTrace;

  const AppException(this.message, {this.originalError, this.stackTrace});

  @override
  String toString() => message;
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
