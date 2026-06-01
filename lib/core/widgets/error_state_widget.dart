import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Semantics(
                        label: 'Error',
                        child: Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 48,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    if (trimmedError?.isNotEmpty == true) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: SelectableText(
                          trimmedError!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.firaCode(
                            fontSize: 12,
                            color: const Color(0xFFef4444),
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
