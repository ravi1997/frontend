import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/app/theme/app_colors.dart';
import 'package:frontend/core/services/snackbar_service.dart';
import 'package:frontend/modules/forms/services/git_controller.dart';

class GitBranchManagerDialog extends ConsumerStatefulWidget {
  final String controllerKey;
  final String projectId;
  final String formId;

  const GitBranchManagerDialog({
    super.key,
    required this.controllerKey,
    required this.projectId,
    required this.formId,
  });

  @override
  ConsumerState<GitBranchManagerDialog> createState() => _GitBranchManagerDialogState();
}

class _GitBranchManagerDialogState extends ConsumerState<GitBranchManagerDialog> {
  final TextEditingController _newBranchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(gitControllerProvider(widget.controllerKey).notifier).loadBranches(
            widget.projectId,
            widget.formId,
          );
    });
  }

  @override
  void dispose() {
    _newBranchController.dispose();
    super.dispose();
  }

  Future<void> _createNewBranch() async {
    final name = _newBranchController.text.trim();
    if (name.isEmpty) {
      ref.read(snackbarServiceProvider).showError('Branch name is required');
      return;
    }

    final success = await ref
        .read(gitControllerProvider(widget.controllerKey).notifier)
        .createBranch(widget.projectId, widget.formId, name);

    if (mounted) {
      if (success) {
        _newBranchController.clear();
        ref.read(snackbarServiceProvider).showSuccess('Branch created successfully');
      } else {
        ref.read(snackbarServiceProvider).showError('Failed to create branch');
      }
    }
  }

  Future<void> _confirmDeleteBranch(String branchName) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete branch?'),
        content: Text('Are you sure you want to delete branch "$branchName"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (shouldDelete == true && mounted) {
      final success = await ref
          .read(gitControllerProvider(widget.controllerKey).notifier)
          .deleteBranch(widget.projectId, widget.formId, branchName);

      if (mounted) {
        if (success) {
          ref.read(snackbarServiceProvider).showSuccess('Branch "$branchName" deleted');
        } else {
          ref.read(snackbarServiceProvider).showError('Failed to delete branch');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final gitState = ref.watch(gitControllerProvider(widget.controllerKey));
    final branches = gitState.branches;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      elevation: 24,
      child: Container(
        width: 520,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const FaIcon(FontAwesomeIcons.codeFork, color: AppColors.primary, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Branch Manager',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppColors.textDark,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(height: 24),

            // Branch List
            const Text(
              'Active Branches',
              style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 8),
            Container(
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: branches.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final branch = branches[index];
                  final isActive = branch == gitState.activeBranch;

                  return ListTile(
                    leading: FaIcon(
                      FontAwesomeIcons.codeBranch,
                      size: 14,
                      color: isActive ? AppColors.primary : Colors.grey,
                    ),
                    title: Text(
                      branch,
                      style: TextStyle(
                        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                        color: isActive ? AppColors.primary : AppColors.textDark,
                      ),
                    ),
                    trailing: branch == 'main'
                        ? const Tooltip(
                            message: 'Default branch cannot be deleted',
                            child: Icon(Icons.lock_outline, size: 18),
                          )
                        : IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                            onPressed: () => _confirmDeleteBranch(branch),
                          ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Create Branch Field
            const Text(
              'Create New Branch',
              style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newBranchController,
                    decoration: InputDecoration(
                      hintText: 'Enter branch name (e.g. workspace/redesign)',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.add, color: Colors.white, size: 18),
                  label: const Text('Create', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  onPressed: gitState.isLoading ? null : _createNewBranch,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
