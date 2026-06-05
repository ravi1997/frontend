import 'package:flutter/material.dart';

class PreviewUtils {
  static Color parseColor(String? value, Color fallback) {
    if (value == null || value.isEmpty) return fallback;
    final normalized = value.trim().replaceFirst('#', '');
    final hex = normalized.length == 6 ? 'FF$normalized' : normalized;
    final parsed = int.tryParse(hex, radix: 16);
    if (parsed == null) return fallback;
    return Color(parsed);
  }

  static FontWeight parseFontWeight(String? value) {
    switch (value?.toLowerCase()) {
      case 'w100':
      case '100':
        return FontWeight.w100;
      case 'w200':
      case '200':
        return FontWeight.w200;
      case 'w300':
      case '300':
        return FontWeight.w300;
      case 'w400':
      case '400':
      case null:
        return FontWeight.w400;
      case 'w500':
      case '500':
        return FontWeight.w500;
      case 'w600':
      case '600':
        return FontWeight.w600;
      case 'w700':
      case '700':
        return FontWeight.w700;
      case 'w800':
      case '800':
        return FontWeight.w800;
      case 'w900':
      case '900':
        return FontWeight.w900;
      default:
        return FontWeight.w400;
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
