import 'package:frontend/features/form_builder/domain/entities/form_question.dart';
import 'package:frontend/features/form_builder/domain/entities/question_type.dart';

/// Comprehensive input validation utility for security
class InputValidator {
  /// Validates email format
  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;

    // Basic email regex pattern
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    return emailRegex.hasMatch(email);
  }

  /// Validates mobile number format
  static bool isValidMobile(String mobile) {
    if (mobile.isEmpty) return false;

    // Remove any non-digit characters
    final digitsOnly = mobile.replaceAll(RegExp(r'[^\d]'), '');

    // Check if it's a valid mobile number (10-15 digits)
    return digitsOnly.length >= 10 && digitsOnly.length <= 15;
  }

  /// Validates password strength
  static PasswordStrength validatePassword(String password) {
    if (password.isEmpty) {
      return PasswordStrength.empty;
    }

    int score = 0;

    // Length check
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;

    // Complexity checks
    if (password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*()_+=\[\]{};:|<>?,./-]'))) score++;

    // Determine strength
    if (score <= 2) return PasswordStrength.weak;
    if (score <= 3) return PasswordStrength.medium;
    return PasswordStrength.strong;
  }

  /// Sanitizes text input to prevent XSS
  static String sanitizeText(String input) {
    if (input.isEmpty) return input;

    // Remove potentially dangerous HTML/JS characters
    String sanitized = input
        .replaceAll(RegExp(r'<[^>]*>'), '') // Remove HTML tags
        .replaceAll(RegExp(r'javascript:'), '') // Remove javascript: protocol
        .replaceAll(RegExp(r'on\w+\s*='), '') // Remove event handlers
        .replaceAll(RegExp(r'&[a-z]+;'), '&'); // Escape HTML entities

    return sanitized.trim();
  }

  /// Validates URL format
  static bool isValidUrl(String url) {
    if (url.isEmpty) return false;

    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  /// Validates numeric input within range
  static bool isValidNumber(
    String input, {
    int? min,
    int? max,
    bool allowDecimal = false,
  }) {
    if (input.isEmpty) return false;

    final numberRegex = allowDecimal
        ? RegExp(r'^-?\d*\.?\d+$')
        : RegExp(r'^-?\d+$');

    if (!numberRegex.hasMatch(input)) return false;

    final value = double.tryParse(input);
    if (value == null) return false;

    if (min != null && value < min) return false;
    if (max != null && value > max) return false;

    return true;
  }

  /// Validates date format (YYYY-MM-DD)
  static bool isValidDate(String input) {
    if (input.isEmpty) return false;

    final dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!dateRegex.hasMatch(input)) return false;

    try {
      final parts = input.split('-');
      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final day = int.parse(parts[2]);

      // Basic validation
      if (year < 1900 || year > 2100) return false;
      if (month < 1 || month > 12) return false;
      if (day < 1 || day > 31) return false;

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Validates form field based on its type and constraints
  static ValidationResult validateField(FormQuestion field, String value) {
    // Check required fields
    if (field.isRequired && value.trim().isEmpty) {
      return ValidationResult(
        isValid: false,
        errorMessage: '${field.label} is required',
      );
    }

    // Skip validation if not required and empty
    if (!field.isRequired && value.trim().isEmpty) {
      return ValidationResult(isValid: true);
    }

    // Type-specific validation
    switch (field.type) {
      case QuestionType.email:
        if (!isValidEmail(value)) {
          return ValidationResult(
            isValid: false,
            errorMessage: 'Please enter a valid email address',
          );
        }
        break;

      case QuestionType.mobile:
        if (!isValidMobile(value)) {
          return ValidationResult(
            isValid: false,
            errorMessage: 'Please enter a valid mobile number',
          );
        }
        break;

      case QuestionType.number:
        final min = field.minValue?.toInt();
        final max = field.maxValue?.toInt();
        if (!isValidNumber(value, min: min, max: max)) {
          return ValidationResult(
            isValid: false,
            errorMessage:
                'Please enter a valid number${min != null ? ' (min: $min)' : ''}${max != null ? ' (max: $max)' : ''}',
          );
        }
        break;

      case QuestionType.url:
        if (!isValidUrl(value)) {
          return ValidationResult(
            isValid: false,
            errorMessage: 'Please enter a valid URL',
          );
        }
        break;

      case QuestionType.date:
        if (!isValidDate(value)) {
          return ValidationResult(
            isValid: false,
            errorMessage: 'Please enter a valid date (YYYY-MM-DD)',
          );
        }
        break;

      default:
        // For text fields, apply sanitization
        final sanitized = sanitizeText(value);
        if (sanitized != value) {
          return ValidationResult(
            isValid: true,
            warning: 'Special characters were removed for security',
          );
        }
        break;
    }

    // Length validation
    if (field.minLength != null && value.length < field.minLength!) {
      return ValidationResult(
        isValid: false,
        errorMessage: 'Minimum length is ${field.minLength} characters',
      );
    }

    if (field.maxLength != null && value.length > field.maxLength!) {
      return ValidationResult(
        isValid: false,
        errorMessage: 'Maximum length is ${field.maxLength} characters',
      );
    }

    // Regex validation
    if (field.validationRegex != null && field.validationRegex!.isNotEmpty) {
      try {
        final regex = RegExp(field.validationRegex!);
        if (!regex.hasMatch(value)) {
          return ValidationResult(
            isValid: false,
            errorMessage: field.customErrorMessage ?? 'Invalid format',
          );
        }
      } catch (e) {
        // Invalid regex pattern, skip validation
      }
    }

    return ValidationResult(isValid: true);
  }

  /// Validates multiple fields at once
  static Map<String, ValidationResult> validateForm(
    List<FormQuestion> fields,
    Map<String, dynamic> values,
  ) {
    final results = <String, ValidationResult>{};

    for (final field in fields) {
      final value = values[field.id]?.toString() ?? '';
      results[field.id] = validateField(field, value);
    }

    return results;
  }

  /// Checks if all validations passed
  static bool allValid(Map<String, ValidationResult> results) {
    return results.values.every((result) => result.isValid);
  }

  /// Gets first error message from validation results
  static String? getFirstError(Map<String, ValidationResult> results) {
    for (final result in results.values) {
      if (!result.isValid) {
        return result.errorMessage;
      }
    }
    return null;
  }

  /// Gets all error messages from validation results
  static List<String> getAllErrors(Map<String, ValidationResult> results) {
    return results.values
        .where((result) => !result.isValid)
        .map((result) => result.errorMessage!)
        .toList();
  }
}

/// Password strength enum
enum PasswordStrength { empty, weak, medium, strong }

/// Validation result class
class ValidationResult {
  final bool isValid;
  final String? errorMessage;
  final String? warning;

  ValidationResult({required this.isValid, this.errorMessage, this.warning});

  @override
  String toString() {
    if (isValid) {
      return warning != null ? 'Valid (Warning: $warning)' : 'Valid';
    }
    return errorMessage ?? 'Invalid';
  }
}
