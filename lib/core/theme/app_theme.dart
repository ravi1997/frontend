import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: AppColors.backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surfaceDark,
        onSurface: AppColors.textPrimary,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme)
          .copyWith(
            displayLarge: GoogleFonts.orbitron(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: AppColors.textPrimary,
            ),
            bodyMedium: GoogleFonts.inter(color: AppColors.textSecondary),
          ),
      // Add other theme customizations here (InputDecoration, Buttons, etc.)
    );
  }
}
