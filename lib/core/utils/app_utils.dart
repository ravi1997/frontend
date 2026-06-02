import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

/// Core utilities for the application
class AppUtils {
  // Date Utilities
  static final DateFormat _rfc1123 = DateFormat(
    "EEE, dd MMM yyyy HH:mm:ss 'GMT'",
    'en_US',
  );

  /// Parse a date string, trying RFC 1123 first then ISO 8601.
  /// Returns null if the input is null or cannot be parsed.
  static DateTime? parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) {
      if (value.isEmpty) return null;
      // Try RFC 1123 first. This format uses English day/month names and is in GMT/UTC.
      try {
        return _rfc1123.parseUtc(value);
      } catch (_) {
        // Fall back to ISO 8601
        return DateTime.tryParse(value);
      }
    }
    return null;
  }

  /// Format a DateTime to RFC 1123 string for API requests.
  static String? toRfc1123(DateTime? date) {
    if (date == null) return null;
    return _rfc1123.format(date.toUtc());
  }

  /// Format a DateTime to ISO 8601 string.
  static String? toIso8601(DateTime? date) {
    if (date == null) return null;
    return date.toIso8601String();
  }

  // Preview/Style Utilities
  static Color parseColor(String? hex, Color fallback) {
    if (hex == null || hex.isEmpty) return fallback;
    try {
      return Color(int.parse(hex.replaceAll('#', '0xFF')));
    } catch (_) {
      return fallback;
    }
  }

  static FontWeight parseFontWeight(String? weight) {
    switch (weight) {
      case 'bold':
        return FontWeight.bold;
      case 'medium':
        return FontWeight.w500;
      default:
        return FontWeight.normal;
    }
  }

  /// Validate a field value with various validation rules
  static String? validateField(
    String? value, {
    bool isRequired = false,
    String? regex,
    int? minLength,
    int? maxLength,
    double? minValue,
    double? maxValue,
    String? customError,
  }) {
    if (isRequired && (value == null || value.trim().isEmpty)) {
      return customError ?? 'This field is required';
    }

    if (value != null && value.isNotEmpty) {
      if (minLength != null && value.length < minLength) {
        return 'Minimum $minLength characters required';
      }
      if (maxLength != null && value.length > maxLength) {
        return 'Maximum $maxLength characters allowed';
      }
      if (regex != null && regex.isNotEmpty) {
        if (!RegExp(regex).hasMatch(value)) {
          return customError ?? 'Invalid format';
        }
      }

      final numValue = double.tryParse(value);
      if (numValue != null) {
        if (minValue != null && numValue < minValue) {
          return 'Value must be at least $minValue';
        }
        if (maxValue != null && numValue > maxValue) {
          return 'Value must be at most $maxValue';
        }
      }
    }

    return null;
  }
}

/// Backward compatibility aliases
class AppDateUtils {
  static DateTime? parse(dynamic value) => AppUtils.parseDate(value);
  static String? toRfc1123(DateTime? date) => AppUtils.toRfc1123(date);
  static String? toIso8601(DateTime? date) => AppUtils.toIso8601(date);
}

class PreviewUtils {
  static Color parseColor(String? hex, Color fallback) => AppUtils.parseColor(hex, fallback);
  static FontWeight parseFontWeight(String? weight) => AppUtils.parseFontWeight(weight);
  static String? validateField(
    String? value, {
    bool isRequired = false,
    String? regex,
    int? minLength,
    int? maxLength,
    double? minValue,
    double? maxValue,
    String? customError,
  }) => AppUtils.validateField(
    value,
    isRequired: isRequired,
    regex: regex,
    minLength: minLength,
    maxLength: maxLength,
    minValue: minValue,
    maxValue: maxValue,
    customError: customError,
  );
}