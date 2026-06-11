import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';

class PublishSuccessDialog extends StatelessWidget {
  final String formId;

  const PublishSuccessDialog({super.key, required this.formId});

  @override
  Widget build(BuildContext context) {
    final formUrl = 'https://app.squintcam.com/forms/$formId';
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusL),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 560,
          maxHeight: MediaQuery.sizeOf(context).height * 0.85,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(DesignTokens.spaceL),
          child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Success Icon
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: DesignTokens.success.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.check,
                  color: DesignTokens.success,
                  size: 34,
                ),
              ),
            ),
            const SizedBox(height: DesignTokens.spaceL),

            // Title
            Text(
              'Your form is Live!',
              style: TextStyle(
                fontSize: DesignTokens.fontL,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),

            // Content
            Text(
              'Share this link to start collecting responses.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
                fontSize: DesignTokens.fontM,
              ),
            ),
            const SizedBox(height: DesignTokens.spaceL),

            // Link Box
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.spaceM,
                vertical: DesignTokens.spaceS + 4,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(DesignTokens.radiusS),
                border: Border.all(color: theme.colorScheme.outline),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      formUrl,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: DesignTokens.fontM,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(
                      Icons.copy,
                      size: 20,
                      color: AppColors.primary,
                    ),
                    tooltip: 'Copy Link',
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: formUrl));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Link copied to clipboard!'),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // QR Code Section
            Container(
              padding: const EdgeInsets.all(DesignTokens.spaceM),
              decoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.outline),
                borderRadius: BorderRadius.circular(DesignTokens.radiusM),
              ),
              child: Column(
                children: [
                  Text(
                    'Scan for Quick Access',
                    style: TextStyle(
                      fontSize: DesignTokens.fontM,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
                    ),
                  ),
                  const SizedBox(height: DesignTokens.spaceM),
                  QrImageView(
                    data: formUrl,
                    version: QrVersions.auto,
                    size: 160.0,
                    gapless: false,
                    eyeStyle: QrEyeStyle(color: theme.colorScheme.onSurface),
                    dataModuleStyle: QrDataModuleStyle(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: DesignTokens.spaceL),

            // Done Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: DesignTokens.spaceS + 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusS),
                  ),
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
          ),
        ),
      ),
    );
  }
}
