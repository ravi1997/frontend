import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/core/services/snackbar_service.dart';
import '../../../../app/theme/app_colors.dart';
import 'package:frontend/modules/forms/services/git_controller.dart';

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
    final allResolved = conflicts.every((c) => _resolutions.containsKey(c.path));

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      child: Dialog(
        backgroundColor: Colors.white.withValues(alpha: 0.94),
        elevation: 24,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.92,
          height: MediaQuery.of(context).size.height * 0.85,
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  const FaIcon(FontAwesomeIcons.codeMerge, color: AppColors.primary, size: 28),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Visual Three-Way Conflict Resolver',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppColors.textDark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Select the value to keep for each conflicting schema property.',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ),
              const Divider(height: 32),

              // Conflict List
              Expanded(
                child: conflicts.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle_outline, color: Colors.green, size: 64),
                            SizedBox(height: 16),
                            Text(
                              'No active conflicts remaining.',
                              style: TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: conflicts.length,
                        itemBuilder: (context, index) {
                          final conflict = conflicts[index];
                          final path = conflict.path;
                          final baseVal = conflict.base?.toString() ?? '(Empty/Unchanged)';
                          final mineVal = conflict.mine?.toString() ?? '(Deleted)';
                          final theirsVal = conflict.theirs?.toString() ?? '(Deleted)';
                          final resolution = _resolutions[path];

                          return Card(
                            margin: const EdgeInsets.only(bottom: 24),
                            elevation: 4,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Path label
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.folder_open_outlined, size: 16, color: Colors.grey),
                                            const SizedBox(width: 6),
                                            Text(
                                              path,
                                              style: const TextStyle(
                                                fontFamily: 'monospace',
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.textDark,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Spacer(),
                                      if (resolution != null)
                                        Chip(
                                          label: Text(
                                            'Resolved using: ${resolution == 'mine' ? 'Mine' : 'Theirs'}',
                                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                                          ),
                                          backgroundColor: resolution == 'mine' ? AppColors.primary : Colors.amber.shade700,
                                          padding: EdgeInsets.zero,
                                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),

                                  // Three columns comparison pane
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Base Column (Context)
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(14),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade50,
                                            border: Border.all(color: Colors.grey.shade300, width: 1.5),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(Icons.history, color: Colors.grey.shade600, size: 16),
                                                  const SizedBox(width: 6),
                                                  Text(
                                                    'Base Version (Ancestor)',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.grey.shade700,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                baseVal,
                                                style: TextStyle(color: Colors.grey.shade800, fontSize: 13),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),

                                      // Mine Column (Selectable)
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              _resolutions[path] = 'mine';
                                            });
                                          },
                                          borderRadius: BorderRadius.circular(12),
                                          child: Container(
                                            padding: const EdgeInsets.all(14),
                                            decoration: BoxDecoration(
                                              color: resolution == 'mine'
                                                  ? AppColors.primary.withValues(alpha: 0.08)
                                                  : Colors.transparent,
                                              border: Border.all(
                                                color: resolution == 'mine'
                                                    ? AppColors.primary
                                                    : Colors.grey.shade300,
                                                width: resolution == 'mine' ? 2.5 : 1.5,
                                              ),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      resolution == 'mine' ? Icons.check_circle : Icons.radio_button_off,
                                                      color: AppColors.primary,
                                                      size: 18,
                                                    ),
                                                    const SizedBox(width: 6),
                                                    const Text(
                                                      'Mine (Merge Branch)',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: AppColors.primary,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  mineVal,
                                                  style: const TextStyle(color: AppColors.textDark, fontSize: 13),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),

                                      // Theirs Column (Selectable)
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              _resolutions[path] = 'theirs';
                                            });
                                          },
                                          borderRadius: BorderRadius.circular(12),
                                          child: Container(
                                            padding: const EdgeInsets.all(14),
                                            decoration: BoxDecoration(
                                              color: resolution == 'theirs'
                                                  ? Colors.amber.withValues(alpha: 0.08)
                                                  : Colors.transparent,
                                              border: Border.all(
                                                color: resolution == 'theirs'
                                                    ? Colors.amber.shade700
                                                    : Colors.grey.shade300,
                                                width: resolution == 'theirs' ? 2.5 : 1.5,
                                              ),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      resolution == 'theirs' ? Icons.check_circle : Icons.radio_button_off,
                                                      color: Colors.amber.shade700,
                                                      size: 18,
                                                    ),
                                                    const SizedBox(width: 6),
                                                    Text(
                                                      'Theirs (Target Branch)',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.amber.shade700,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  theirsVal,
                                                  style: const TextStyle(color: AppColors.textDark, fontSize: 13),
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
              const SizedBox(height: 20),

              // Action buttons footer
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (!allResolved && conflicts.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            'Please resolve all ${conflicts.length} conflicts to complete merge.',
                            style: TextStyle(color: Colors.red.shade700, fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: allResolved ? AppColors.primary : Colors.grey.shade400,
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: allResolved ? 4 : 0,
                    ),
                    icon: const FaIcon(FontAwesomeIcons.circleCheck, size: 16, color: Colors.white),
                    label: const Text(
                      'Resolve & Complete Merge',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
                    ),
                    onPressed: allResolved
                        ? () async {
                            final notifier = ref.read(gitControllerProvider(widget.controllerKey).notifier);
                            
                            final success = await notifier.mergeBranches(
                              widget.projectId,
                              widget.formId,
                              widget.theirsCommitId,
                              widget.mineCommitId,
                              resolutions: _resolutions,
                            );

                            if (context.mounted) {
                              Navigator.of(context).pop();
                              if (success) {
                                ref
                                    .read(snackbarServiceProvider)
                                    .showSuccess('Workspace merged and published successfully!');
                              } else {
                                ref
                                    .read(snackbarServiceProvider)
                                    .showError('Failed to resolve all conflicts. Re-check options.');
                              }
                            }
                          }
                        : null,
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
