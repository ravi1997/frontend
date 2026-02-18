import 'package:flutter/material.dart';

class PreviewUtils {
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
