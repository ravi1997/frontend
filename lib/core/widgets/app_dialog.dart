import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:frontend/app/theme/tokens.dart';

/// Reusable Glassmorphic Dialog container enforcing visual parity across the app.
class AppDialog extends StatelessWidget {
  final String title;
  final Widget child;
  final List<Widget>? actions;
  final double maxWidth;

  const AppDialog({
    super.key,
    required this.title,
    required this.child,
    this.actions,
    this.maxWidth = 550,
  });

  @override
  Widget build(BuildContext buildContext) {
    final screenSize = MediaQuery.sizeOf(buildContext);

    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: maxWidth,
              maxHeight: screenSize.height * 0.85,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Material(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Close dialog',
                          icon: const Icon(Icons.close, color: Colors.white60),
                          onPressed: () => Navigator.of(buildContext).pop(),
                        ),
                      ],
                    ),
                    const Divider(color: Colors.white10),
                    const SizedBox(height: AppSpacing.md),

                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: screenSize.height * 0.6,
                      ),
                      child: SingleChildScrollView(child: child),
                    ),

                    if (actions != null && actions!.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.lg),
                      Wrap(
                        alignment: WrapAlignment.end,
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: actions!.map((action) {
                          return action;
                        }).toList(),
                      ),
                    ],
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
