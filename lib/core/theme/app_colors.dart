import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds
  static const Color backgroundDark = Color(0xFF050510);
  static const Color backgroundLight = Color(
    0xFFFFFFFF,
  ); // Placeholder for light mode if needed

  // Surfaces
  static const Color surfaceDark = Color(0xFF0F121E);
  static const Color surface = surfaceDark;
  static const Color glassBorder = Color(0xFFFFFFFF); // usually with opacity

  // Builder Specific Colors (Light Mode)
  static const Color builderSidebar = Color(0xFFFFFFFF); // White
  static const Color builderElement = Color(0xFFF1F5F9); // Slate 100
  static const Color builderCanvas = Color(0xFFF8FAFC); // Slate 50

  static const Color background = backgroundDark;

  // Accents
  static const Color primary = Color(0xFF00FFC2); // Vibrant Cyan
  static const Color secondary = Color(0xFF9D00FF); // Deep Purple
  static const Color accent = Color(
    0xFFFF0055,
  ); // Pink/Red for alerts or highlights

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xB3FFFFFF); // 70% opacity
  static const Color textTertiary = Color(0x80FFFFFF); // 50% opacity
  static const Color textDark = Color(0xFF1F2937);
  static const Color textGrey = Color(0xFF6B7280);

  // Brand Colors from Design
  static const Color brandBlue = Color(0xFF2563EB);
  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color fieldBackground = Color(0xFFF9FAFB);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const RadialGradient backgroundGradient = RadialGradient(
    center: Alignment.topLeft,
    radius: 1.5,
    colors: [Color(0xFF1A1F35), backgroundDark],
  );
}
