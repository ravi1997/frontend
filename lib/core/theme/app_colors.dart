import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds
  static const Color backgroundDark = Color(0xFF050510);
  static const Color backgroundLight = Color(0xFFFFFFFF);

  // Surfaces
  static const Color surfaceDark = Color(0xFF0F121E);
  static const Color surface = surfaceDark;
  static const Color glassBorder = Color(0xFFFFFFFF); // usually with opacity

  // Builder Specific Colors (Modern & Elegant)
  static const Color builderSidebar = Color(0xFFFFFFFF);
  static const Color builderElement = Color(0xFFF8FAFC); // Slate 50
  static const Color builderCanvas = Color(0xFFF1F5F9); // Slate 100
  static const Color builderBackground = Color(
    0xFFF1F5F9,
  ); // Matches canvas for uniformity
  static const Color builderBorder = Color(
    0xFFE2E8F0,
  ); // Slate 200 - softer border

  static const Color background = backgroundDark;

  // Accents - Updated for Elegance
  static const Color primary = Color(
    0xFF6366F1,
  ); // Indigo 500 - Professional & Modern
  static const Color secondary = Color(0xFF8B5CF6); // Violet 500
  static const Color accent = Color(0xFFEC4899); // Pink 500

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xB3FFFFFF);
  static const Color textTertiary = Color(0x80FFFFFF);
  static const Color textDark = Color(
    0xFF1E293B,
  ); // Slate 800 - Softer than pure black
  static const Color textGrey = Color(0xFF64748B); // Slate 500

  // Brand Colors
  static const Color brandBlue = Color(0xFF3B82F6);
  static const Color borderLight = Color(
    0xFFE2E8F0,
  ); // Unified with builderBorder
  static const Color fieldBackground = Color(0xFFFFFFFF);

  // Semantic Field Colors - Refined
  static const Color fieldText = Color(0xFF3B82F6); // Blue 500
  static const Color fieldChoice = Color(0xFF8B5CF6); // Violet 500
  static const Color fieldDate = Color(0xFFF59E0B); // Amber 500
  static const Color fieldMedia = Color(0xFFEC4899); // Pink 500
  static const Color fieldAdvanced = Color(0xFF10B981); // Emerald 500

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const RadialGradient backgroundGradient = RadialGradient(
    center: Alignment.topLeft,
    radius: 1.5,
    colors: [Color(0xFF1E1B4B), backgroundDark], // Indigo 950 base
  );
}
