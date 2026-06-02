import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:frontend/features/form_builder/services/git_controller.dart';

class GitMergeDialog extends ConsumerStatefulWidget {
  final String controllerKey;
  final String projectId;
  final String formId;
  final String theirsCommitId;
  final String mineCommitId;

  const GitMergeDialog({
    super.key,
    required this.controllerKey,
    required this.projectId,
    required this.formId,
    required this.theirsCommitId,
    required this.mineCommitId,
  });

  @override
  ConsumerState<GitMergeDialog> createState() => _GitMergeDialogState();
}

class _GitMergeDialogState extends ConsumerState<GitMergeDialog> {
  final Map<String, String> _resolutions = {}; // path -> 'mine' or 'theirs'

  @override
  Widget build(BuildContext context) {
    final gitState = ref.watch(gitControllerProvider(widget.controllerKey));
    final conflicts = gitState.conflicts;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      child: Dialog(
        backgroundColor: Colors.white.withValues(alpha: 0.88),
        elevation: 24,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  const Icon(FontAwesomeIcons.codeMerge, color: AppColors.primary, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    'Visual 3-Way Conflict Resolver',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Concurrent changes occurred on the server while you were working. Resolve conflicts to finalize the merge.',
                style: TextStyle(color: AppColors.textGrey, fontSize: 14),
              ),
              const SizedBox(height: 20),

              // Conflict List
              Expanded(
                child: conflicts.isEmpty
                    ? const Center(
                        child: Text(
                          'No active conflicts remaining.',
                          style: TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      )
                    : ListView.builder(
                        itemCount: conflicts.length,
                        itemBuilder: (context, index) {
                          final conflict = conflicts[index];
                          final path = conflict.path;
                          final mineVal = conflict.mine?.toString() ?? '(Deleted)';
                          final theirsVal = conflict.theirs?.toString() ?? '(Deleted)';
                          final resolution = _resolutions[path] ?? 'mine';

                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Path label
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          'Path: $path',
                                          style: const TextStyle(
                                            fontFamily: 'monospace',
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textDark,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),

                                  // Split comparison panes
                                  Row(
                                    children: [
                                      // Mine Column
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              _resolutions[path] = 'mine';
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: resolution == 'mine'
                                                  ? AppColors.primary.withValues(alpha: 0.08)
                                                  : Colors.transparent,
                                              border: Border.all(
                                                color: resolution == 'mine'
                                                    ? AppColors.primary
                                                    : Colors.grey.shade300,
                                                width: 1.5,
                                              ),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Your Draft changes (Workspace)',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.primary,
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  mineVal,
                                                  style: const TextStyle(color: AppColors.textDark),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),

                                      // Theirs Column
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              _resolutions[path] = 'theirs';
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: resolution == 'theirs'
                                                  ? Colors.amber.withValues(alpha: 0.08)
                                                  : Colors.transparent,
                                              border: Border.all(
                                                color: resolution == 'theirs'
                                                    ? Colors.amber.shade700
                                                    : Colors.grey.shade300,
                                                width: 1.5,
                                              ),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Server main changes',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.amber.shade700,
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  theirsVal,
                                                  style: const TextStyle(color: AppColors.textDark),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 16),

              // Action buttons footer
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(FontAwesomeIcons.circleCheck, size: 16),
                    label: const Text(
                      'Resolve & Complete Merge',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    onPressed: () async {
                      // Call resolution API using resolved values
                      final notifier = ref.read(gitControllerProvider(widget.controllerKey).notifier);
                      
                      final success = await notifier.mergeBranches(
                        widget.projectId,
                        widget.formId,
                        widget.theirsCommitId,
                        widget.mineCommitId,
                      );

                      if (context.mounted) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              success
                                  ? 'Workspace merged and published successfully!'
                                  : 'Failed to resolve all conflicts. Re-check options.',
                            ),
                            backgroundColor: success ? Colors.green : Colors.red,
                          ),
                        );
                      }
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
