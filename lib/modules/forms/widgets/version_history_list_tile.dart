import 'package:flutter/material.dart';
import 'package:frontend/app/theme/app_colors.dart';
import 'package:frontend/modules/forms/models/form_version_history.dart';

class VersionHistoryListTile extends StatelessWidget {
  final FormVersionHistory version;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onView;
  final VoidCallback onRestore;

  const VersionHistoryListTile({
    super.key,
    required this.version,
    required this.isSelected,
    required this.onTap,
    required this.onView,
    required this.onRestore,
  });

  Future<void> _confirmRestore(BuildContext context) async {
    final shouldRestore = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restore version?'),
        content: Text(
          'This will replace the current form with version ${version.version}. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (shouldRestore == true) {
      onRestore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final createdAt = MaterialLocalizations.of(context).formatFullDate(
      version.created_at.toLocal(),
    );
    final author = version.authorId?.trim();

    return Card(
      elevation: isSelected ? 4 : 1,
      color: isSelected ? AppColors.primary.withValues(alpha: 0.08) : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: isSelected ? AppColors.primary : Colors.transparent,
          width: 1.2,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Version ${version.version}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        'Selected',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                createdAt,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textGrey,
                ),
              ),
              if (author != null && author.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  'Author: $author',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textGrey,
                  ),
                ),
              ],
              if ((version.changeLog ?? '').trim().isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  version.changeLog!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textDark,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  TextButton(
                    onPressed: onView,
                    child: const Text('View'),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: () => _confirmRestore(context),
                    child: const Text('Restore'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
