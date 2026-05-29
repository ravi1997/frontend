import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../design_system/tokens.dart';

/// Reusable Glassmorphic Shimmer Loader with multiple named presets
/// (Card, Stats, Text, List) for platform-wide aesthetic consistency.
class AppShimmer extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final ShapeBorder? shape;
  final Widget? child;

  const AppShimmer({
    super.key,
    this.width,
    this.height,
    this.borderRadius = AppRadius.md,
    this.shape,
    this.child,
  });

  /// Factory for a Stats Card skeleton loading block
  factory AppShimmer.stats({Key? key}) {
    return AppShimmer(
      key: key,
      width: 220,
      height: 100,
      borderRadius: AppRadius.lg,
    );
  }

  /// Factory for an interactive Form Card item loading block
  factory AppShimmer.formCard({Key? key}) {
    return AppShimmer(
      key: key,
      width: double.infinity,
      height: 140,
      borderRadius: AppRadius.lg,
    );
  }

  /// Factory for a text line simulator block
  factory AppShimmer.line({Key? key, double width = 150}) {
    return AppShimmer(
      key: key,
      width: width,
      height: 16,
      borderRadius: AppRadius.sm,
    );
  }

  @override
  Widget build(BuildContext buildContext) {
    // Glassmorphic premium translucent sweep colors
    final baseColor = Colors.white.withValues(alpha: 0.08);
    final highlightColor = Colors.white.withValues(alpha: 0.18);

    if (child != null) {
      return Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: child!,
      );
    }

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: shape ?? RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
    );
  }
}

/// A simple rectangular skeleton placeholder box.
class SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final double? borderRadius;

  const SkeletonBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius ?? AppRadius.sm),
      ),
    );
  }
}

/// A simple circular skeleton placeholder box.
class SkeletonCircle extends StatelessWidget {
  final double size;

  const SkeletonCircle({
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}
