import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/app/theme/app_colors.dart';
import 'package:frontend/core/services/snackbar_service.dart';
import 'package:frontend/modules/forms/services/form_builder_controller.dart';
import 'package:frontend/modules/forms/services/git_controller.dart';

class GitCommitDialog extends ConsumerStatefulWidget {
  final String controllerKey;
  final String projectId;
  final String formId;

  const GitCommitDialog({
    super.key,
    required this.controllerKey,
    required this.projectId,
    required this.formId,
  });

  @override
  ConsumerState<GitCommitDialog> createState() => _GitCommitDialogState();
}

class _GitCommitDialogState extends ConsumerState<GitCommitDialog> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _handleCommit() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) {
      ref.read(snackbarServiceProvider).showError('Commit message is required');
      return;
    }

    final gitState = ref.read(gitControllerProvider(widget.controllerKey));
    final form = ref
        .read(formBuilderControllerProvider(widget.controllerKey))
        .value
        ?.form;
    if (form == null) {
      ref.read(snackbarServiceProvider).showError('Current form is not available');
      return;
    }

    final controller = ref.read(gitControllerProvider(widget.controllerKey).notifier);
    final commitId = await controller.createCommit(
      widget.projectId,
      widget.formId,
      message,
      form.toJson(),
    );

    if (!mounted) return;
    if (commitId != null) {
      Navigator.of(context).pop();
      ref.read(snackbarServiceProvider).showSuccess('Commit created');
    } else {
      ref.read(snackbarServiceProvider).showError(
        'Commit failed: ${gitState.error ?? 'Unknown error'}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final gitState = ref.watch(gitControllerProvider(widget.controllerKey));

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: Row(
        children: [
          const FaIcon(FontAwesomeIcons.codeFork, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Text(
            'Create Commit',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
          ),
        ],
      ),
      content: SizedBox(
        width: 520,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _messageController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Commit message',
                hintText: 'Describe the snapshot you are saving',
              ),
            ),
            const SizedBox(height: 16),
            if (gitState.error != null)
              Text(
                gitState.error!,
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: gitState.isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: gitState.isLoading ? null : _handleCommit,
          child: gitState.isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Commit'),
        ),
      ],
    );
  }
}
