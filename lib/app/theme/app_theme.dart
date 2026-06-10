import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tokens.dart';

class AppTheme {
  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color scaffoldBackgroundColor,
    required Color surfaceColor,
    required Color surfaceVariantColor,
    required Color outlineColor,
    required Color textPrimary,
    required Color textSecondary,
    required Color textMuted,
    required Color onPrimary,
  }) {
    final base = brightness == Brightness.dark
        ? ThemeData.dark(useMaterial3: true)
        : ThemeData.light(useMaterial3: true);

    final scheme = brightness == Brightness.dark
        ? ColorScheme.dark(
            primary: DesignTokens.primary,
            onPrimary: onPrimary,
            secondary: DesignTokens.secondary,
            surface: surfaceColor,
            onSurface: textPrimary,
            error: DesignTokens.error,
            outline: outlineColor,
          )
        : ColorScheme.light(
            primary: DesignTokens.primary,
            onPrimary: onPrimary,
            secondary: DesignTokens.secondary,
            surface: surfaceColor,
            onSurface: textPrimary,
            error: DesignTokens.error,
            outline: outlineColor,
          );

    return base.copyWith(
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      colorScheme: scheme,
      textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.inter(
          fontSize: DesignTokens.fontXXL,
          fontWeight: FontWeight.w800,
          color: textPrimary,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: DesignTokens.fontL,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: DesignTokens.fontM,
          color: textSecondary,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: DesignTokens.fontS,
          color: textMuted,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusL),
          side: BorderSide(color: outlineColor),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceColor,
        foregroundColor: textPrimary,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.inter(
          fontSize: DesignTokens.fontBase,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: outlineColor,
        thickness: 1,
        space: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceVariantColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spaceM,
          vertical: DesignTokens.spaceS + 4,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusS),
          borderSide: BorderSide(color: outlineColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusS),
          borderSide: BorderSide(color: outlineColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusS),
          borderSide: const BorderSide(
            color: DesignTokens.primary,
            width: 2,
          ),
        ),
        hintStyle: GoogleFonts.inter(
          color: textMuted,
          fontSize: DesignTokens.fontM,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: DesignTokens.primary,
          foregroundColor: onPrimary,
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
          foregroundColor: onPrimary,
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
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          side: BorderSide(color: outlineColor),
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

  static ThemeData get lightTheme => _buildTheme(
    brightness: Brightness.light,
    scaffoldBackgroundColor: DesignTokens.lightBackground,
    surfaceColor: DesignTokens.lightSurface,
    surfaceVariantColor: DesignTokens.lightSurface2,
    outlineColor: DesignTokens.lightBorder,
    textPrimary: DesignTokens.lightTextPrimary,
    textSecondary: DesignTokens.lightTextSecondary,
    textMuted: DesignTokens.lightTextMuted,
    onPrimary: Colors.white,
  );

  static ThemeData get darkTheme => _buildTheme(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: DesignTokens.darkBackground,
    surfaceColor: DesignTokens.darkSurface,
    surfaceVariantColor: DesignTokens.darkSurface2,
    outlineColor: DesignTokens.darkBorder,
    textPrimary: DesignTokens.darkTextPrimary,
    textSecondary: DesignTokens.darkTextSecondary,
    textMuted: DesignTokens.darkTextMuted,
    onPrimary: Colors.white,
  );
}
