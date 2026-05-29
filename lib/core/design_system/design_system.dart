import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tokens.dart';

class AppDesignSystem {
  static ThemeData get enterpriseDarkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: DesignTokens.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF6366F1),
        onPrimary: Color(0xFFFFFFFF),
        secondary: Color(0xFF8B5CF6),
        surface: Color(0xFF1E293B),
        onSurface: Color(0xFFFFFFFF),
        error: Color(0xFFEF4444),
      ),
      
      // Typography
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.orbitron(
          fontSize: DesignTokens.fontXXL,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
          color: DesignTokens.darkTextPrimary,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: DesignTokens.fontM,
          color: DesignTokens.darkTextSecondary,
        ),
      ),
      
      // Components
      cardTheme: CardThemeData(
        color: DesignTokens.darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusL),
          side: BorderSide(color: DesignTokens.glassBorder),
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: DesignTokens.darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusM),
          borderSide: BorderSide(color: DesignTokens.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusM),
          borderSide: BorderSide(color: DesignTokens.darkBorder.withAlpha(128)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusM),
          borderSide: BorderSide(color: DesignTokens.primary, width: 2),
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: DesignTokens.primary,
          foregroundColor: DesignTokens.darkTextPrimary,
          minimumSize: const Size(88, 48),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusM),
          ),
        ),
      ),
    );
  }
}
