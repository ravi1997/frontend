import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/version_history_controller.dart';
import '../../domain/entities/form_version_history.dart';

/// Page displaying version history for a form with a premium timeline UI.
class VersionHistoryPage extends ConsumerWidget {
  final String formId;
  final String? formTitle;

  const VersionHistoryPage({super.key, required this.formId, this.formTitle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final versionState = ref.watch(versionHistoryControllerProvider(formId));

    return Scaffold(
      backgroundColor: AppColors.builderBackground,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context, ref),
      body: Stack(
        children: [
          // Background decorative elements
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.05),
              ),
            ),
          ),
          _buildBody(context, ref, versionState),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Version History',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
              fontSize: 18,
            ),
          ),
          if (formTitle != null)
            Text(
              formTitle!,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textGrey,
              ),
            ),
        ],
      ),
      backgroundColor: Colors.white.withValues(alpha: 0.8),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: ClipRect(
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppColors.builderBorder.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
        onPressed: () => context.pop(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: AppColors.textGrey),
          onPressed: () => ref
              .read(versionHistoryControllerProvider(formId).notifier)
              .refresh(),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    VersionHistoryState state,
  ) {
    // Loading state
    if (state.isLoading && state.versions.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(strokeWidth: 3),
            SizedBox(height: 24),
            Text(
              'Fetching history...',
              style: TextStyle(color: AppColors.textGrey),
            ),
          ],
        ),
      );
    }

    // Error state
    if (state.error != null && state.versions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                FontAwesomeIcons.circleExclamation,
                size: 48,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 24),
              Text(
                'History Unavailable',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                state.error!,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textGrey,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => ref
                    .read(versionHistoryControllerProvider(formId).notifier)
                    .refresh(),
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Empty state
    if (state.versions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.clockRotateLeft,
              size: 64,
              color: AppColors.textGrey.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 24),
            Text(
              'No history found',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Text(
                'Major changes and published versions will automatically appear here.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textGrey,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Success state - show version timeline
    return RefreshIndicator(
      onRefresh: () =>
          ref.read(versionHistoryControllerProvider(formId).notifier).refresh(),
      displacement: 80,
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: SizedBox(height: kToolbarHeight + 40),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 48),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final version = state.versions[index];
                final isLast = index == state.versions.length - 1;
                return _VersionTimelineItem(
                  version: version,
                  state: state,
                  formId: formId,
                  isLast: isLast,
                );
              }, childCount: state.versions.length),
            ),
          ),
        ],
      ),
    );
  }
}

class _VersionTimelineItem extends ConsumerWidget {
  final FormVersionHistory version;
  final VersionHistoryState state;
  final String formId;
  final bool isLast;

  const _VersionTimelineItem({
    required this.version,
    required this.state,
    required this.formId,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = state.selectedVersion?.version == version.version;
    final isCurrentVersion =
        state.currentVersion == version.version ||
        (state.currentVersion == null &&
            state.versions.first.version == version.version);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          Column(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCurrentVersion ? Colors.green : AppColors.primary,
                  boxShadow: [
                    BoxShadow(
                      color:
                          (isCurrentVersion ? Colors.green : AppColors.primary)
                              .withValues(alpha: 0.4),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          isCurrentVersion ? Colors.green : AppColors.primary,
                          AppColors.primary.withValues(alpha: 0.2),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 24),
          // Version Card
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isSelected ? 0.1 : 0.05,
                      ),
                      blurRadius: isSelected ? 20 : 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.builderBorder.withValues(alpha: 0.5),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    ref
                        .read(versionHistoryControllerProvider(formId).notifier)
                        .selectVersion(version);
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _VersionTypeBadge(
                              version: version.version,
                              isCurrent: isCurrentVersion,
                            ),
                            const Spacer(),
                            Text(
                              _formatDate(version.created_at),
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: AppColors.textGrey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (version.changeLog != null &&
                            version.changeLog!.isNotEmpty)
                          Text(
                            version.changeLog!,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              color: AppColors.textDark,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                            ),
                          )
                        else
                          Text(
                            'No changelog provided for this version.',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.textGrey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        const SizedBox(height: 20),
                        Divider(
                          color: AppColors.builderBorder.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: AppColors.primary.withValues(
                                alpha: 0.1,
                              ),
                              child: Text(
                                (version.authorId ?? 'A')
                                    .substring(0, 1)
                                    .toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              version.authorId ?? 'Automated System',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: AppColors.textGrey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            if (isSelected)
                              _buildActionRow(
                                context,
                                ref,
                                version,
                                isCurrentVersion,
                              )
                            else
                              const Icon(
                                Icons.chevron_right,
                                color: AppColors.textGrey,
                                size: 20,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow(
    BuildContext context,
    WidgetRef ref,
    FormVersionHistory version,
    bool isCurrentVersion,
  ) {
    return Row(
      children: [
        _ModernActionButton(
          icon: Icons.visibility_outlined,
          label: 'View',
          onPressed: () => ref
              .read(versionHistoryControllerProvider(formId).notifier)
              .viewVersion(version),
        ),
        if (!isCurrentVersion) ...[
          const SizedBox(width: 8),
          _ModernActionButton(
            icon: Icons.restore_rounded,
            label: 'Restore',
            isPrimary: true,
            onPressed: () => _showRestoreDialog(context, ref, version),
          ),
        ],
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';

    return DateFormat('MMM dd, yyyy').format(date);
  }

  void _showRestoreDialog(
    BuildContext context,
    WidgetRef ref,
    FormVersionHistory version,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.restore_rounded, color: AppColors.primary),
            const SizedBox(width: 12),
            const Text('Restore Version'),
          ],
        ),
        content: Text(
          'Are you sure you want to restore version ${version.version}?\n\n'
          'This will create a new current version based on this snapshot.',
          style: const TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textGrey),
            ),
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Restore Now'),
          ),
        ],
      ),
    );
  }
}

class _VersionTypeBadge extends StatelessWidget {
  final String version;
  final bool isCurrent;

  const _VersionTypeBadge({required this.version, required this.isCurrent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isCurrent
            ? Colors.green.withValues(alpha: 0.1)
            : AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isCurrent
              ? Colors.green.withValues(alpha: 0.2)
              : AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isCurrent
                ? Icons.check_circle_outline
                : FontAwesomeIcons.codeBranch,
            size: 10,
            color: isCurrent ? Colors.green : AppColors.primary,
          ),
          const SizedBox(width: 6),
          Text(
            isCurrent ? 'ACTIVE VERSION' : 'V$version',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: isCurrent ? Colors.green : AppColors.primary,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _ModernActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;

  const _ModernActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isPrimary
          ? AppColors.primary
          : AppColors.primary.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 14,
                color: isPrimary ? Colors.white : AppColors.primary,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isPrimary ? Colors.white : AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
