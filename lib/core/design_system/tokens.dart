import 'package:flutter/material.dart';

/// Enterprise Design Tokens for RIDP Form Platform.
/// Single source of truth for all colours, spacing, radii, typography,
/// breakpoints, and layout dimensions across every page.
class DesignTokens {
  // ─── Breakpoints ──────────────────────────────────────────────────────────
  static const double kMobile = 600;   // < 600  → mobile
  static const double kTablet = 1024;  // 600–1024 → tablet
  static const double kLaptop = 1440;  // 1024–1440 → laptop
  // > 1440 → desktop

  // ─── Layout Dimensions ────────────────────────────────────────────────────
  static const double navbarHeight     = 56.0;
  static const double sidebarExpanded  = 240.0;
  static const double sidebarCollapsed = 72.0;
  static const double maxContentWidth  = 1280.0;

  // ─── Brand ────────────────────────────────────────────────────────────────
  static const Color primary     = Color(0xFF6366F1); // Indigo 500
  static const Color primaryDark = Color(0xFF4338CA); // Indigo 700
  static const Color secondary   = Color(0xFF8B5CF6); // Violet 500

  // ─── Semantic ─────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error   = Color(0xFFEF4444);
  static const Color info    = Color(0xFF3B82F6);

  // ─── Dark Palette ─────────────────────────────────────────────────────────
  static const Color darkBackground = Color(0xFF0F172A); // Slate 900 (softened)
  static const Color darkSurface    = Color(0xFF1E293B); // Slate 800
  static const Color darkSurface2   = Color(0xFF334155); // Slate 700
  static const Color darkBorder     = Color(0xFF334155);
  static const Color darkTextPrimary   = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFCBD5E1); // Slate 300
  static const Color darkTextMuted     = Color(0xFF94A3B8); // Slate 400

  // ─── Light Palette ────────────────────────────────────────────────────────
  static const Color lightBackground = Color(0xFFF1F5F9); // Slate 100
  static const Color lightSurface    = Color(0xFFFFFFFF);
  static const Color lightSurface2   = Color(0xFFF8FAFC); // Slate 50
  static const Color lightBorder     = Color(0xFFE2E8F0); // Slate 200
  static const Color lightTextPrimary   = Color(0xFF0F172A); // Slate 900
  static const Color lightTextSecondary = Color(0xFF334155); // Slate 700
  static const Color lightTextMuted     = Color(0xFF64748B); // Slate 500

  // ─── Shared surface alias (resolved at runtime via Responsive) ────────────
  static const Color glassBorder = Color(0x33FFFFFF);

  // ─── Spacing ──────────────────────────────────────────────────────────────
  static const double spaceXS  = 4.0;
  static const double spaceS   = 8.0;
  static const double spaceM   = 16.0;
  static const double spaceL   = 24.0;
  static const double spaceXL  = 32.0;
  static const double spaceXXL = 48.0;

  // ─── Border Radius ────────────────────────────────────────────────────────
  static const double radiusXS   = 4.0;
  static const double radiusS    = 8.0;
  static const double radiusM    = 12.0;
  static const double radiusL    = 16.0;
  static const double radiusXL   = 24.0;
  static const double radiusFull = 999.0;

  // ─── Typography ───────────────────────────────────────────────────────────
  static const double fontXS  = 11.0;
  static const double fontS   = 13.0;
  static const double fontM   = 15.0;
  static const double fontBase = 16.0;
  static const double fontL   = 20.0;
  static const double fontXL  = 24.0;
  static const double fontXXL = 32.0;
}
