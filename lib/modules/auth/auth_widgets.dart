import 'package:flutter/material.dart';
import 'package:frontend/app/theme/tokens.dart';
import 'package:frontend/core/widgets/responsive.dart';

/// Auth-page background scaffold with soft decorative gradient orbs.
class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final secondary = theme.colorScheme.secondary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // ── Top-right large orb ──────────────────────────────────────────
          Positioned(
            top: -200,
            right: -180,
            child: _GradientOrb(
              size: 550,
              colors: [primary, secondary],
              opacity: 0.055,
            ),
          ),

          // ── Bottom-left large orb ────────────────────────────────────────
          Positioned(
            bottom: -160,
            left: -140,
            child: _GradientOrb(
              size: 440,
              colors: [secondary, primary],
              opacity: 0.045,
            ),
          ),

          // ── Mid-left accent orb ──────────────────────────────────────────
          Positioned(
            top: 200,
            left: -80,
            child: _GradientOrb(
              size: 260,
              colors: [primary, secondary],
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
      ..color = DesignTokens.primary.withValues(alpha: 0.06)
      ..style = PaintingStyle.fill;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Reusable form card scaffolding for all authentication views.
class AuthCardScaffold extends StatelessWidget {
  final Widget child;
  final IconData headerIcon;
  final String title;
  final String subtitle;

  const AuthCardScaffold({
    super.key,
    required this.child,
    required this.headerIcon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final screenSize = Responsive.of(context);
    final horizontalPadding = switch (screenSize) {
      ScreenSize.mobile => DesignTokens.spaceM,
      ScreenSize.tablet => DesignTokens.spaceL,
      ScreenSize.laptop => DesignTokens.spaceL,
      ScreenSize.desktop => DesignTokens.spaceXL,
      ScreenSize.wide => DesignTokens.spaceXL,
    };
    final verticalPadding = switch (screenSize) {
      ScreenSize.mobile => DesignTokens.spaceL,
      _ => DesignTokens.spaceXXL,
    };

    return AuthBackground(
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenSize == ScreenSize.desktop || screenSize == ScreenSize.wide
                  ? 520
                  : 460,
            ),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(DesignTokens.radiusL),
                border: Border.all(color: theme.colorScheme.outline),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize == ScreenSize.mobile
                      ? DesignTokens.spaceL
                      : DesignTokens.spaceXL,
                  vertical: screenSize == ScreenSize.mobile
                      ? DesignTokens.spaceXL
                      : DesignTokens.spaceXXL,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        headerIcon,
                        size: 32,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spaceL),
                    Text(
                      title,
                      style: textTheme.titleLarge?.copyWith(
                        fontSize: DesignTokens.fontXXL,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: DesignTokens.spaceS + 4),
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spaceXL),
                    child,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Standardized text input field for all auth forms.
class AuthTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String placeholder;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final IconData? prefixIcon;
  final TextInputAction? textInputAction;
  final String? helperText;

  const AuthTextFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.placeholder,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.textInputAction,
    this.helperText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: DesignTokens.spaceS),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          obscureText: obscureText,
          textInputAction: textInputAction,
          style: textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
            ),
            prefixIcon: prefixIcon != null
                ? Icon(
                    prefixIcon,
                    color: theme.colorScheme.primary.withValues(alpha: 0.72),
                    size: 18,
                  )
                : null,
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.spaceM,
              vertical: DesignTokens.spaceS + 4,
            ),
          ).applyDefaults(theme.inputDecorationTheme).copyWith(
                prefixIconColor: theme.colorScheme.primary.withValues(alpha: 0.72),
                suffixIconColor: theme.colorScheme.onSurface.withValues(
                  alpha: 0.72,
                ),
              ),
        ),
        if (helperText != null) ...[
          const SizedBox(height: 6),
          Text(
            helperText!,
            style: textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ],
    );
  }
}
