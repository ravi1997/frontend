import 'package:flutter/material.dart';
import 'tokens.dart';

/// Compatibility color aliases for existing UI code.
///
/// New UI should prefer [DesignTokens] directly.
/// This class remains to reduce churn while the codebase is migrated.
class AppColors {
  // Backgrounds
  static const Color backgroundDark = DesignTokens.darkBackground;
  static const Color backgroundLight = DesignTokens.lightBackground;
  static const Color background = backgroundDark;

  // Surfaces
  static const Color surfaceDark = DesignTokens.darkSurface;
  static const Color surface = surfaceDark;
  static const Color fieldBackground = DesignTokens.lightSurface;
  static const Color builderSidebar = DesignTokens.lightSurface;
  static const Color builderElement = DesignTokens.lightSurface2;
  static const Color builderCanvas = DesignTokens.lightBackground;
  static const Color builderBackground = DesignTokens.lightBackground;
  static const Color builderBorder = DesignTokens.lightBorder;
  static const Color borderLight = DesignTokens.lightBorder;
  static const Color glassBorder = Color(0x33FFFFFF);

  // Accents
  static const Color primary = DesignTokens.primary;
  static const Color primaryDark = DesignTokens.primaryDark;
  static const Color primarySoft = DesignTokens.primarySoft;
  static const Color secondary = DesignTokens.secondary;
  static const Color accent = DesignTokens.accent;
  static const Color brandBlue = DesignTokens.primary;

  // Text
  static const Color textPrimary = DesignTokens.darkTextPrimary;
  static const Color textSecondary = DesignTokens.darkTextSecondary;
  static const Color textTertiary = Color(0x80FFFFFF);
  static const Color textDark = DesignTokens.lightTextPrimary;
  static const Color textGrey = DesignTokens.lightTextMuted;

  // Semantic/field colors
  static const Color fieldText = DesignTokens.info;
  static const Color fieldChoice = DesignTokens.accent;
  static const Color fieldDate = DesignTokens.warning;
  static const Color fieldMedia = Color(0xFFDB2777);
  static const Color fieldAdvanced = DesignTokens.success;

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [DesignTokens.primary, DesignTokens.secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const RadialGradient backgroundGradient = RadialGradient(
    center: Alignment.topLeft,
    radius: 1.5,
    colors: [DesignTokens.darkSurface, DesignTokens.darkBackground],
  );
}
