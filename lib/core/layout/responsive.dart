import 'package:flutter/material.dart';
import '../design_system/tokens.dart';

/// Screen size enum for the four supported breakpoints.
enum ScreenSize { mobile, tablet, laptop, desktop }

/// Responsive layout utilities.
/// Always use these instead of raw [MediaQuery] size checks so breakpoints
/// stay centralised and consistent across every page.
///
/// Usage:
/// ```dart
/// final size = Responsive.of(context);
/// if (Responsive.isMobile(context)) { ... }
/// padding: Responsive.pagePadding(context),
/// ```
abstract class Responsive {
  // ─── Breakpoint resolution ─────────────────────────────────────────────────

  static ScreenSize of(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w < DesignTokens.kMobile) return ScreenSize.mobile;
    if (w < DesignTokens.kTablet) return ScreenSize.tablet;
    if (w < DesignTokens.kLaptop) return ScreenSize.laptop;
    return ScreenSize.desktop;
  }

  static bool isMobile(BuildContext context) =>
      of(context) == ScreenSize.mobile;

  static bool isTablet(BuildContext context) =>
      of(context) == ScreenSize.tablet;

  static bool isLaptop(BuildContext context) =>
      of(context) == ScreenSize.laptop;

  static bool isDesktop(BuildContext context) =>
      of(context) == ScreenSize.desktop;

  /// True when the sidebar should be fully hidden (mobile only uses bottom bar).
  static bool hideSidebar(BuildContext context) => isMobile(context);

  /// True when the sidebar should collapse to icon-only mode.
  static bool collapseSidebar(BuildContext context) => isTablet(context);

  // ─── Layout helpers ────────────────────────────────────────────────────────

  /// Horizontal page padding that adapts to screen size.
  static EdgeInsets pagePadding(BuildContext context) {
    return switch (of(context)) {
      ScreenSize.mobile  => const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      ScreenSize.tablet  => const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      ScreenSize.laptop  => const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      ScreenSize.desktop => const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
    };
  }

  /// Horizontal padding value only (for use in SliverPadding etc.)
  static double pageHPad(BuildContext context) {
    return switch (of(context)) {
      ScreenSize.mobile  => 12,
      ScreenSize.tablet  => 20,
      ScreenSize.laptop  => 24,
      ScreenSize.desktop => 32,
    };
  }

  /// Max content width for centred layouts.
  static double maxContentWidth(BuildContext context) =>
      DesignTokens.maxContentWidth;

  /// Number of grid columns for card grids at current breakpoint.
  static int cardColumns(BuildContext context) {
    return switch (of(context)) {
      ScreenSize.mobile  => 1,
      ScreenSize.tablet  => 2,
      ScreenSize.laptop  => 3,
      ScreenSize.desktop => 4,
    };
  }

  /// Number of stat-card columns (summary row at top of pages).
  static int statColumns(BuildContext context) {
    return switch (of(context)) {
      ScreenSize.mobile  => 2,
      ScreenSize.tablet  => 2,
      ScreenSize.laptop  => 4,
      ScreenSize.desktop => 4,
    };
  }

  /// Width to use for the sidebar (may be 0 on mobile).
  static double sidebarWidth(BuildContext context) {
    if (isMobile(context)) return 0;
    if (isTablet(context)) return DesignTokens.sidebarCollapsed;
    return DesignTokens.sidebarExpanded;
  }
}
