import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/modules/dashboard_builder/repositories/dashboard_builder_repository.dart';

class SharingDialog extends ConsumerStatefulWidget {
  final String dashboardId;
  final bool initialIsPublic;
  final String? initialToken;

  const SharingDialog({
    super.key,
    required this.dashboardId,
    required this.initialIsPublic,
    this.initialToken,
  });

  @override
  ConsumerState<SharingDialog> createState() => _SharingDialogState();
}

class _SharingDialogState extends ConsumerState<SharingDialog> {
  late bool _isPublic;
  String? _publicToken;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isPublic = widget.initialIsPublic;
    _publicToken = widget.initialToken;
  }

  Future<void> _toggleSharing(bool value) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final repo = ref.read(dashboardBuilderRepositoryProvider);
      if (value) {
        final token = await repo.share(widget.dashboardId);
        setState(() {
          _isPublic = true;
          _publicToken = token;
        });
      } else {
        await repo.unshare(widget.dashboardId);
        setState(() {
          _isPublic = false;
          _publicToken = null;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update sharing: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final publicUrl = _publicToken != null
        ? '${Uri.base.scheme}://${Uri.base.host}${Uri.base.port != 80 && Uri.base.port != 443 ? ":${Uri.base.port}" : ""}/public/dashboard/$_publicToken'
        : '';

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        width: 480,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Share Dashboard',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Make this dashboard public to share it with anyone, even without a login.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Public access',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _isPublic ? 'Anyone with link can view' : 'Only members can view',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                _isLoading
                    ? const CircularProgressIndicator()
                    : Switch(
                        value: _isPublic,
                        onChanged: _toggleSharing,
                      ),
              ],
            ),
            if (_isPublic && _publicToken != null) ...[
              const SizedBox(height: 24),
              Text(
                'Public Link',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: theme.colorScheme.outlineVariant,
                        ),
                      ),
                      child: Text(
                        publicUrl,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontFamily: 'monospace',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filledTonal(
                    icon: const Icon(Icons.copy),
                    tooltip: 'Copy Link',
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: publicUrl));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Link copied to clipboard'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
