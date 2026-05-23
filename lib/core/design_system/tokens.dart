import 'package:flutter/material.dart';

/// Enterprise Design Tokens for RIDP Form Platform.
/// These tokens provide the foundation for WCAG 2.1 AA compliance.
class DesignTokens {
  // --- Colors ---
  
  // Brand
  static const Color primary = Color(0xFF6366F1); // Indigo 500
  static const Color primaryDark = Color(0xFF4338CA); // Indigo 700
  static const Color secondary = Color(0xFF8B5CF6); // Violet 500
  
  // Neutral / Background
  static const Color background = Color(0xFF050510);
  static const Color surface = Color(0xFF0F121E);
  static const Color border = Color(0xFFE2E8F0);
  static const Color glassBorder = Color(0x33FFFFFF);
  
  // Functional / Semantic
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  
  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xB3FFFFFF);
  static const Color textInverse = Color(0xFF1E293B);
  
  // --- Spacing ---
  
  static const double spaceXS = 4.0;
  static const double spaceS = 8.0;
  static const double spaceM = 16.0;
  static const double spaceL = 24.0;
  static const double spaceXL = 32.0;
  static const double spaceXXL = 48.0;
  
  // --- Border Radius ---
  
  static const double radiusS = 4.0;
  static const double radiusM = 8.0;
  static const double radiusL = 12.0;
  static const double radiusXL = 24.0;
  static const double radiusFull = 999.0;
  
  // --- Typography ---
  
  static const double fontXS = 12.0;
  static const double fontS = 14.0;
  static const double fontM = 16.0;
  static const double fontL = 20.0;
  static const double fontXL = 24.0;
  static const double fontXXL = 32.0;
}
