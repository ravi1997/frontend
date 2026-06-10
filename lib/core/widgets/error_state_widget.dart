import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/app/theme/app_colors.dart';
import 'package:frontend/app/theme/tokens.dart';

class ErrorStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final String? error;
  final VoidCallback? onRetry;
  final VoidCallback? onBack;

  const ErrorStateWidget({
    super.key,
    this.title = 'Something went wrong',
    this.message = 'An unexpected error occurred while loading this page.',
    this.error,
    this.onRetry,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final trimmedError = error?.trim();

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(DesignTokens.spaceL),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(DesignTokens.spaceM),
                      decoration: BoxDecoration(
                        color: AppColors.fieldDate.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Semantics(
                        label: 'Error',
                        child: Icon(
                          Icons.error_outline,
                          color: AppColors.fieldDate,
                          size: 48,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: DesignTokens.fontL,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: DesignTokens.fontM,
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.72),
                      ),
                    ),
                    if (trimmedError?.isNotEmpty == true) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(DesignTokens.spaceM),
                        decoration: BoxDecoration(
                          color: AppColors.builderElement,
                          borderRadius: BorderRadius.circular(DesignTokens.radiusS),
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: SelectableText(
                          trimmedError!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.firaCode(
                            fontSize: DesignTokens.fontS,
                            color: AppColors.fieldDate,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 32),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        if (onBack != null)
                          OutlinedButton(
                            onPressed: onBack,
                            child: const Text('Go Back'),
                          ),
                        if (onRetry != null)
                          FilledButton.icon(
                            onPressed: onRetry,
                            icon: const Icon(Icons.refresh, size: 18),
                            label: const Text('Try Again'),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
