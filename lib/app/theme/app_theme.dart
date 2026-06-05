import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../design_system/tokens.dart';

class AppTheme {
  // ─── Light Theme ──────────────────────────────────────────────────────────
  static ThemeData get lightTheme {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: DesignTokens.lightBackground,
      colorScheme: const ColorScheme.light(
        primary: DesignTokens.primary,
        onPrimary: Colors.black,
        secondary: DesignTokens.secondary,
        onSecondary: Colors.black,
        surface: DesignTokens.lightSurface,
        onSurface: DesignTokens.lightTextPrimary,
        error: DesignTokens.error,
        outline: DesignTokens.lightBorder,
      ),
      textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.inter(
          fontSize: DesignTokens.fontXXL,
          fontWeight: FontWeight.w800,
          color: DesignTokens.lightTextPrimary,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: DesignTokens.fontL,
          fontWeight: FontWeight.w700,
          color: DesignTokens.lightTextPrimary,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: DesignTokens.fontM,
          color: DesignTokens.lightTextSecondary,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: DesignTokens.fontS,
          color: DesignTokens.lightTextMuted,
        ),
      ),
      cardTheme: CardThemeData(
        color: DesignTokens.lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusL),
          side: const BorderSide(color: DesignTokens.lightBorder),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: DesignTokens.lightSurface,
        foregroundColor: DesignTokens.lightTextPrimary,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.inter(
          fontSize: DesignTokens.fontBase,
          fontWeight: FontWeight.w600,
          color: DesignTokens.lightTextPrimary,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: DesignTokens.lightBorder,
        thickness: 1,
        space: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: DesignTokens.lightSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spaceM,
          vertical: DesignTokens.spaceS + 4,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusS),
          borderSide: const BorderSide(color: DesignTokens.lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusS),
          borderSide: const BorderSide(color: DesignTokens.lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusS),
          borderSide: const BorderSide(
            color: DesignTokens.primary,
            width: 2,
          ),
        ),
        hintStyle: GoogleFonts.inter(
          color: DesignTokens.lightTextMuted,
          fontSize: DesignTokens.fontM,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: DesignTokens.primary,
          foregroundColor: Colors.black,
          minimumSize: const Size(88, 44),
          padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.spaceL,
            vertical: DesignTokens.spaceS + 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusS),
          ),
          elevation: 0,
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: DesignTokens.fontM,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: DesignTokens.primary,
          foregroundColor: Colors.black,
          minimumSize: const Size(88, 44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusS),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: DesignTokens.fontM,
          ),
        ),
      ),
    );
  }

  // ─── Dark Theme ───────────────────────────────────────────────────────────
  static ThemeData get darkTheme {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: DesignTokens.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: DesignTokens.primary,
        onPrimary: Colors.black,
        secondary: DesignTokens.secondary,
        onSecondary: Colors.black,
        surface: DesignTokens.darkSurface,
        onSurface: DesignTokens.darkTextPrimary,
        error: DesignTokens.error,
        outline: DesignTokens.darkBorder,
      ),
      textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.inter(
          fontSize: DesignTokens.fontXXL,
          fontWeight: FontWeight.w800,
          color: DesignTokens.darkTextPrimary,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: DesignTokens.fontL,
          fontWeight: FontWeight.w700,
          color: DesignTokens.darkTextPrimary,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: DesignTokens.fontM,
          color: DesignTokens.darkTextSecondary,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: DesignTokens.fontS,
          color: DesignTokens.darkTextMuted,
        ),
      ),
      cardTheme: CardThemeData(
        color: DesignTokens.darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusL),
          side: const BorderSide(color: DesignTokens.darkBorder),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: DesignTokens.darkSurface,
        foregroundColor: DesignTokens.darkTextPrimary,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.inter(
          fontSize: DesignTokens.fontBase,
          fontWeight: FontWeight.w600,
          color: DesignTokens.darkTextPrimary,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: DesignTokens.darkBorder,
        thickness: 1,
        space: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: DesignTokens.darkSurface2,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spaceM,
          vertical: DesignTokens.spaceS + 4,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusS),
          borderSide: const BorderSide(color: DesignTokens.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusS),
          borderSide: const BorderSide(color: DesignTokens.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusS),
          borderSide: const BorderSide(
            color: DesignTokens.primary,
            width: 2,
          ),
        ),
        hintStyle: GoogleFonts.inter(
          color: DesignTokens.darkTextMuted,
          fontSize: DesignTokens.fontM,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: DesignTokens.primary,
          foregroundColor: Colors.black,
          minimumSize: const Size(88, 44),
          padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.spaceL,
            vertical: DesignTokens.spaceS + 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusS),
          ),
          elevation: 0,
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: DesignTokens.fontM,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: DesignTokens.primary,
          foregroundColor: Colors.black,
          minimumSize: const Size(88, 44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusS),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: DesignTokens.fontM,
          ),
        ),
      ),
    );
  }
}
