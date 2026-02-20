import 'package:flutter/material.dart';

/// Auth-page background scaffold with soft decorative gradient orbs.
class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: Stack(
        children: [
          // ── Top-right large orb ──────────────────────────────────────────
          Positioned(
            top: -200,
            right: -180,
            child: _GradientOrb(
              size: 550,
              colors: const [Color(0xFF4F46E5), Color(0xFF7C3AED)],
              opacity: 0.055,
            ),
          ),

          // ── Bottom-left large orb ────────────────────────────────────────
          Positioned(
            bottom: -160,
            left: -140,
            child: _GradientOrb(
              size: 440,
              colors: const [Color(0xFF7C3AED), Color(0xFFEC4899)],
              opacity: 0.045,
            ),
          ),

          // ── Mid-left accent orb ──────────────────────────────────────────
          Positioned(
            top: 200,
            left: -80,
            child: _GradientOrb(
              size: 260,
              colors: const [Color(0xFF6366F1), Color(0xFF4F46E5)],
              opacity: 0.03,
            ),
          ),

          // ── Subtle dot-grid overlay ──────────────────────────────────────
          Positioned.fill(
            child: Opacity(
              opacity: 0.35,
              child: CustomPaint(painter: _DotGridPainter()),
            ),
          ),

          SafeArea(child: child),
        ],
      ),
    );
  }
}

class _GradientOrb extends StatelessWidget {
  final double size;
  final List<Color> colors;
  final double opacity;

  const _GradientOrb({
    required this.size,
    required this.colors,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            colors[0].withValues(alpha: opacity),
            colors[1].withValues(alpha: 0),
          ],
        ),
      ),
    );
  }
}

/// Paints a subtle background dot-grid pattern.
class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const spacing = 28.0;
    final paint = Paint()
      ..color = const Color(0xFF4F46E5).withValues(alpha: 0.06)
      ..style = PaintingStyle.fill;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
