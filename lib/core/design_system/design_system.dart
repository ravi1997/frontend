import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tokens.dart';

class AppDesignSystem {
  static ThemeData get enterpriseDarkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: DesignTokens.background,
      colorScheme: const ColorScheme.dark(
        primary: DesignTokens.primary,
        onPrimary: DesignTokens.textPrimary,
        secondary: DesignTokens.secondary,
        surface: DesignTokens.surface,
        onSurface: DesignTokens.textPrimary,
        error: DesignTokens.error,
      ),
      
      // Typography
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.orbitron(
          fontSize: DesignTokens.fontXXL,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
          color: DesignTokens.textPrimary,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: DesignTokens.fontM,
          color: DesignTokens.textSecondary,
        ),
      ),
      
      // Components
      cardTheme: CardThemeData(
        color: DesignTokens.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusL),
          side: const BorderSide(color: DesignTokens.glassBorder),
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: DesignTokens.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusM),
          borderSide: const BorderSide(color: DesignTokens.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusM),
          borderSide: BorderSide(color: DesignTokens.border.withAlpha(128)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusM),
          borderSide: const BorderSide(color: DesignTokens.primary, width: 2),
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: DesignTokens.primary,
          foregroundColor: DesignTokens.textPrimary,
          minimumSize: const Size(88, 48),
          padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spaceM),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusM),
          ),
        ),
      ),
    );
  }
}
