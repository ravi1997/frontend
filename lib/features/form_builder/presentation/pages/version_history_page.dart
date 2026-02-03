import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/version_history_controller.dart';
import '../../domain/entities/form_version_history.dart';

/// Page displaying version history for a form.
///
/// Allows users to view all previous versions of a form,
/// compare versions, and restore previous versions.
class VersionHistoryPage extends ConsumerWidget {
  final String formId;
  final String? formTitle;

  const VersionHistoryPage({super.key, required this.formId, this.formTitle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final versionState = ref.watch(versionHistoryControllerProvider(formId));

    return Scaffold(
      backgroundColor: AppColors.builderBackground,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Version History'),
            if (formTitle != null)
              Text(
                formTitle!,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: AppColors.textGrey,
                ),
              ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref
                .read(versionHistoryControllerProvider(formId).notifier)
                .refresh(),
          ),
        ],
      ),
      body: _buildBody(context, ref, versionState),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    VersionHistoryState state,
  ) {
    // Loading state
    if (state.isLoading && state.versions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // Error state
    if (state.error != null && state.versions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error loading version history',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.error!,
              style: GoogleFonts.inter(fontSize: 14, color: AppColors.textGrey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => ref
                  .read(versionHistoryControllerProvider(formId).notifier)
                  .refresh(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Empty state
    if (state.versions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.history_toggle_off,
              size: 48,
              color: AppColors.textGrey,
            ),
            const SizedBox(height: 16),
            Text(
              'No version history',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Version history will appear here after you make changes to the form.',
              style: GoogleFonts.inter(fontSize: 14, color: AppColors.textGrey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Success state - show version list
    return RefreshIndicator(
      onRefresh: () =>
          ref.read(versionHistoryControllerProvider(formId).notifier).refresh(),
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildHeader(state),
          const SizedBox(height: 24),
          ...state.versions.map(
            (version) => _buildVersionCard(context, ref, version, state),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(VersionHistoryState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${state.versions.length} versions',
          style: GoogleFonts.inter(fontSize: 14, color: AppColors.textGrey),
        ),
        if (state.isRefreshing)
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
      ],
    );
  }

  Widget _buildVersionCard(
    BuildContext context,
    WidgetRef ref,
    FormVersionHistory version,
    VersionHistoryState state,
  ) {
    final isSelected = state.selectedVersion?.version == version.version;
    final isCurrentVersion = state.currentVersion == version.version;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected
            ? const BorderSide(color: AppColors.primary, width: 2)
            : BorderSide(color: AppColors.borderLight.withValues(alpha: 0.5)),
      ),
      child: InkWell(
        onTap: () {
          ref
              .read(versionHistoryControllerProvider(formId).notifier)
              .selectVersion(version);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isCurrentVersion
                                ? Colors.green.withValues(alpha: 0.1)
                                : AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            isCurrentVersion ? 'Current' : version.version,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isCurrentVersion
                                  ? Colors.green
                                  : AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _formatDate(version.createdAt),
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.textGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Row(
                      children: [
                        _buildActionButton(
                          context,
                          icon: Icons.visibility,
                          label: 'View',
                          onPressed: () => ref
                              .read(
                                versionHistoryControllerProvider(
                                  formId,
                                ).notifier,
                              )
                              .viewVersion(version),
                        ),
                        if (!isCurrentVersion) const SizedBox(width: 8),
                        if (!isCurrentVersion)
                          _buildActionButton(
                            context,
                            icon: Icons.restore,
                            label: 'Restore',
                            onPressed: () => _showRestoreDialog(
                              context,
                              ref,
                              version,
                              formId,
                            ),
                          ),
                      ],
                    ),
                ],
              ),
              if (version.changeLog != null &&
                  version.changeLog!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.builderBackground,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    version.changeLog!,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
              ],
              if (version.authorId != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.person_outline,
                      size: 14,
                      color: AppColors.textGrey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'By ${version.authorId}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.textGrey,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return TextButton.icon(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      icon: Icon(icon, size: 16),
      label: Text(
        label,
        style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showRestoreDialog(
    BuildContext context,
    WidgetRef ref,
    FormVersionHistory version,
    String formId,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restore Version'),
        content: Text(
          'Are you sure you want to restore version ${version.version}?\n\n'
          'This will create a new version based on the selected version.',
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.pop();
              ref
                  .read(versionHistoryControllerProvider(formId).notifier)
                  .restoreVersion(version);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Restore'),
          ),
        ],
      ),
    );
  }
}
