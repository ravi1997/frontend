import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:frontend/core/services/snackbar_service.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/localization/locale_controller.dart';
import 'package:frontend/shared/models/form_models.dart';
import 'package:frontend/modules/forms/services/form_builder_controller.dart';
import 'ai_assistant_dialog.dart';
import 'package:frontend/modules/forms/services/git_controller.dart';
import 'git_commit_dialog.dart';
import 'git_merge_dialog.dart';
import 'package:frontend/app/theme/tokens.dart';
import 'package:frontend/core/widgets/responsive.dart';

import 'workflow_configuration_dialog.dart';
import 'publish_success_dialog.dart';

class FormBuilderTopBar extends ConsumerWidget {
  final String controllerKey;
  final String projectId;
  final String formId;
  final String? mode;

  const FormBuilderTopBar({
    super.key,
    required this.controllerKey,
    required this.projectId,
    required this.formId,
    this.mode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = Responsive.of(context);
    final isCompact = screenSize == ScreenSize.mobile || screenSize == ScreenSize.tablet;
    // Select specific parts of the state to minimize rebuilds
    final formTitle = ref.watch(
      formBuilderControllerProvider(
        controllerKey,
      ).select((state) => state.value?.form.title),
    );
    final formVersion = ref.watch(
      formBuilderControllerProvider(
        controllerKey,
      ).select((state) => state.value?.form.version ?? '1.0'),
    );
    final isSaving = ref.watch(
      formBuilderControllerProvider(
        controllerKey,
      ).select((state) => state.value?.isSaving ?? false),
    );
    final isDirty = ref.watch(
      formBuilderControllerProvider(
        controllerKey,
      ).select((state) => state.value?.isDirty ?? false),
    );
    final canUndo = ref.watch(
      formBuilderControllerProvider(
        controllerKey,
      ).select((state) => state.value?.canUndo ?? false),
    );
    final canRedo = ref.watch(
      formBuilderControllerProvider(
        controllerKey,
      ).select((state) => state.value?.canRedo ?? false),
    );
    final editingLocale = ref.watch(
      formBuilderControllerProvider(
        controllerKey,
      ).select((state) => state.value?.editingLocale ?? 'en'),
    );
    // Needed for workflow dialog
    final workflows = ref.watch(
      formBuilderControllerProvider(
        controllerKey,
      ).select((state) => state.value?.form.workflows ?? {}),
    );
    final sections = ref.watch(
      formBuilderControllerProvider(
        controllerKey,
      ).select((state) => state.value?.form.sections ?? []),
    );

    return Container(
      constraints: BoxConstraints(minHeight: isCompact ? 72 : 64),
      decoration: const BoxDecoration(
        color: AppColors.builderSidebar,
        border: Border(
          bottom: BorderSide(color: AppColors.builderBorder, width: 1),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? DesignTokens.spaceM : DesignTokens.spaceL,
        vertical: DesignTokens.spaceS,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textGrey),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/');
              }
            },
          ),
          const SizedBox(width: DesignTokens.spaceS),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  InkWell(
                    onTap: () => ref
                        .read(
                          formBuilderControllerProvider(controllerKey).notifier,
                        )
                        .selectForm(),
                    child: Text(
                      formTitle.translate(editingLocale),
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: DesignTokens.spaceM),
                  _VersionBadge(version: formVersion),
                  const SizedBox(width: DesignTokens.spaceS),
                  const _EditingBadge(),
                  const SizedBox(width: DesignTokens.spaceS),
                  _EditingLocaleSwitcher(
                    controllerKey: controllerKey,
                    formId: formId,
                    currentLocale: editingLocale,
                  ),
                  _GitBranchSelector(
                    controllerKey: controllerKey,
                    projectId: projectId,
                    formId: formId,
                  ),
                ],
              ),
            ),
          ),
          _TopBarActionButton(
            icon: FontAwesomeIcons.codeBranch,
            label: 'Merge & Sync',
            onTap: () async {
              final gitNotifier = ref.read(gitControllerProvider(controllerKey).notifier);
              final success = await gitNotifier.mergeBranches(
                projectId,
                formId,
                'a8a8a8a8-b9b9-c0c0-d1d1-e2e2e2e2e2e2',
                'f3f3f3f3-a4a4-b5b5-c6c6-d7d7d7d7d7d7',
              );

              if (!success && context.mounted) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => GitMergeDialog(
                    controllerKey: controllerKey,
                    projectId: projectId,
                    formId: formId,
                    theirsCommitId: 'a8a8a8a8-b9b9-c0c0-d1d1-e2e2e2e2e2e2',
                    mineCommitId: 'f3f3f3f3-a4a4-b5b5-c6c6-d7d7d7d7d7d7',
                  ),
                );
              }
            },
          ),
          const SizedBox(width: DesignTokens.spaceS),
          _TopBarActionButton(
            icon: FontAwesomeIcons.codeFork,
            label: 'Commit',
            onTap: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => GitCommitDialog(
                  controllerKey: controllerKey,
                  projectId: projectId,
                  formId: formId,
                ),
              );
            },
          ),
          const SizedBox(width: DesignTokens.spaceS),
          _TopBarActionButton(
            icon: FontAwesomeIcons.clockRotateLeft,
            label: 'History',
            onTap: () {
              context.push(
                '/projects/$projectId/forms/$formId/versions?title=${Uri.encodeComponent(formTitle.translate(editingLocale))}',
              );
            },
          ),
          const SizedBox(width: DesignTokens.spaceS),
          _TopBarActionButton(
            icon: FontAwesomeIcons.wandMagicSparkles,
            label: 'AI Assistant',
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AiAssistantDialog(formId: formId),
              );
            },
          ),
          const SizedBox(width: DesignTokens.spaceS),
          _TopBarActionButton(
            icon: FontAwesomeIcons.eye,
            label: 'Preview',
            onTap: () {
              // We need the full form for preview.
              // It's acceptable to read the current state here as it's an action.
              final form = ref
                  .read(formBuilderControllerProvider(controllerKey))
                  .value
                  ?.form;
              if (form != null) {
                context.push('/form-preview', extra: form);
              }
            },
          ),
          const SizedBox(width: DesignTokens.spaceS),
          _TopBarOverflowMenu(
            projectId: projectId,
            formId: formId,
            controllerKey: controllerKey,
            formTitle: formTitle.translate('en'),
            workflows: workflows,
            sections: sections,
            editingLocale: editingLocale,
          ),
          const SizedBox(width: DesignTokens.spaceM),
          if (isDirty) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
                border: Border.all(
                  color: Colors.orange.withValues(alpha: 0.35),
                ),
              ),
              child: const Text(
                'Unsaved changes',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: DesignTokens.fontS,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: DesignTokens.spaceS),
            TextButton.icon(
              onPressed: canUndo
                  ? () => ref
                      .read(
                        formBuilderControllerProvider(controllerKey).notifier,
                      )
                      .undo()
                  : null,
              icon: const Icon(Icons.undo, size: 18),
              label: const Text('Undo'),
            ),
            const SizedBox(width: DesignTokens.spaceXS),
            TextButton.icon(
              onPressed: canRedo
                  ? () => ref
                      .read(
                        formBuilderControllerProvider(controllerKey).notifier,
                      )
                      .redo()
                  : null,
              icon: const Icon(Icons.redo, size: 18),
              label: const Text('Redo'),
            ),
            const SizedBox(width: DesignTokens.spaceS),
          ],
          _SaveButton(
            controllerKey: controllerKey,
            formId: formId,
            isSaving: isSaving,
          ),
          const SizedBox(width: DesignTokens.spaceM),
          _PublishButton(
            controllerKey: controllerKey,
            formId: formId,
            mode: mode,
          ),
        ],
      ),
    );
  }
}

class _VersionBadge extends StatelessWidget {
  final String version;
  const _VersionBadge({required this.version});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spaceS,
        vertical: DesignTokens.spaceXS,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(DesignTokens.radiusXS),
      ),
      child: Text(
        'v$version',
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: DesignTokens.fontS,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _EditingBadge extends StatelessWidget {
  const _EditingBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spaceS,
        vertical: DesignTokens.spaceXS,
      ),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(DesignTokens.radiusXS),
      ),
      child: const Text(
        'Editing',
        style: TextStyle(
          color: Colors.green,
          fontSize: DesignTokens.fontS,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _EditingLocaleSwitcher extends ConsumerWidget {
  final String controllerKey;
  final String formId;
  final String currentLocale;

  const _EditingLocaleSwitcher({
    required this.controllerKey,
    required this.formId,
    required this.currentLocale,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentLocale,
          isDense: true,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: DesignTokens.fontS,
            fontWeight: FontWeight.bold,
          ),
          icon: const Icon(
            Icons.arrow_drop_down,
            size: 16,
            color: AppColors.primary,
          ),
          items: const [
            DropdownMenuItem(value: 'en', child: Text('EN')),
            DropdownMenuItem(value: 'es', child: Text('ES')),
            DropdownMenuItem(value: 'fr', child: Text('FR')),
            DropdownMenuItem(value: 'hi', child: Text('HI')),
          ],
          onChanged: (val) {
            if (val != null) {
              ref
                  .read(formBuilderControllerProvider(controllerKey).notifier)
                  .setEditingLocale(val);
            }
          },
        ),
      ),
    );
  }
}

class _TopBarActionButton extends StatelessWidget {
  final FaIconData icon;
  final String label;
  final VoidCallback onTap;

  const _TopBarActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onTap,
      icon: FaIcon(icon, size: 14, color: AppColors.textGrey),
      label: Text(
        label,
        style: const TextStyle(
          color: AppColors.textGrey,
          fontSize: DesignTokens.fontS,
        ),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }
}

class _TopBarOverflowMenu extends ConsumerWidget {
  final String projectId;
  final String formId;
  final String controllerKey;
  final String formTitle;
  final Map<String, dynamic> workflows;
  final List<FormSection> sections;
  final String editingLocale;

  const _TopBarOverflowMenu({
    required this.projectId,
    required this.formId,
    required this.controllerKey,
    required this.formTitle,
    required this.workflows,
    required this.sections,
    required this.editingLocale,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      tooltip: 'More actions',
      icon: const Icon(Icons.more_horiz, color: AppColors.textGrey),
      onSelected: (value) {
        switch (value) {
          case 'access':
            context.push('/projects/$projectId/forms/$formId/access');
            break;
          case 'analytics':
            context.push('/projects/$projectId/forms/$formId/analysis-builder');
            break;
          case 'history':
            context.push(
              '/projects/$projectId/forms/$formId/versions?title=${Uri.encodeComponent(formTitle)}&projectId=$projectId',
            );
            break;
          case 'translate':
            context.push('/projects/$projectId/forms/$formId/translate');
            break;
          case 'workflows':
            showDialog(
              context: context,
              builder: (context) => WorkflowConfigurationDialog(
                initialWorkflows: workflows,
                sections: sections,
                locale: editingLocale,
                onSave: (config) {
                  ref
                      .read(
                        formBuilderControllerProvider(controllerKey).notifier,
                      )
                      .updateWorkflows(config);
                },
              ),
            );
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'access',
          child: Row(
            children: [
              FaIcon(FontAwesomeIcons.users, size: 16),
              SizedBox(width: 10),
              Text('Access'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'analytics',
          child: Row(
            children: [
              FaIcon(FontAwesomeIcons.chartLine, size: 16),
              SizedBox(width: 10),
              Text('Analytics'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'history',
          child: Row(
            children: [
              FaIcon(FontAwesomeIcons.clockRotateLeft, size: 16),
              SizedBox(width: 10),
              Text('History'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'translate',
          child: Row(
            children: [
              Icon(Icons.translate, size: 16),
              SizedBox(width: 10),
              Text('Translate'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'workflows',
          child: Row(
            children: [
              FaIcon(FontAwesomeIcons.shareNodes, size: 16),
              SizedBox(width: 10),
              Text('Workflows'),
            ],
          ),
        ),
      ],
    );
  }
}

class _SaveButton extends ConsumerWidget {
  final String controllerKey;
  final String formId;
  final bool isSaving;

  const _SaveButton({
    required this.controllerKey,
    required this.formId,
    required this.isSaving,
  });

  Future<void> _handleSave(
    BuildContext context,
    WidgetRef ref, {
    String type = 'patch',
  }) async {
    final wasNew = formId == 'new';

    Logger().i('controllerKey: $controllerKey');

    final success = await ref
        .read(formBuilderControllerProvider(controllerKey).notifier)
        .saveForm(versionType: type);

    if (!context.mounted) return;

    if (success) {
      // If this was a new form, navigate to the actual form URL using the
      // real ID returned by the API so the controller and URL stay in sync.
      if (wasNew) {
        final savedFormId = ref
            .read(formBuilderControllerProvider(controllerKey))
            .value
            ?.form
            .id;
        if (savedFormId != null &&
            savedFormId.isNotEmpty &&
            savedFormId != 'new') {
          context.pushReplacement('/builder/$savedFormId');
          // Skip the snackbar — the page rebuild handles the transition.
          return;
        }
      }

      ref.read(snackbarServiceProvider).showSuccess(
        'Form saved successfully (${type == 'patch'
            ? 'Patch'
            : type == 'minor'
            ? 'Minor'
            : 'Major'} Version)',
      );
    } else {
      final error = ref
          .read(formBuilderControllerProvider(controllerKey))
          .value
          ?.error;
      ref.read(snackbarServiceProvider).showError(
        'Failed to save form: ${error ?? "Unknown error"}',
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        border: Border.all(
          color: isSaving ? AppColors.textGrey : AppColors.primary,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton.icon(
              onPressed: isSaving
                  ? null
                  : () => _handleSave(context, ref, type: 'patch'),
              icon: isSaving
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(
                      Icons.save_outlined,
                      size: 16,
                      color: AppColors.primary,
                    ),
              label: Text(
                'Save',
                style: TextStyle(
                  color: isSaving ? AppColors.textGrey : AppColors.primary,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(7),
                  ),
                ),
              ),
            ),
            VerticalDivider(
              width: 1,
              color: isSaving ? AppColors.textGrey : AppColors.primary,
            ),
            PopupMenuButton<String>(
              tooltip: 'Save Options',
              enabled: !isSaving,
              onSelected: (type) => _handleSave(context, ref, type: type),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'patch',
                  child: Text('Save Patch (x.y.z+1)'),
                ),
                const PopupMenuItem(
                  value: 'minor',
                  child: Text('Save Minor (x.y+1.0)'),
                ),
                const PopupMenuItem(
                  value: 'major',
                  child: Text('Save Major (x+1.0.0)'),
                ),
              ],
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Tooltip(
                  message: 'Save options',
                  child: Icon(
                    Icons.arrow_drop_down,
                    color: isSaving ? AppColors.textGrey : AppColors.primary,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PublishButton extends ConsumerWidget {
  final String controllerKey;
  final String formId;
  final String? mode;

  const _PublishButton({
    required this.controllerKey,
    required this.formId,
    this.mode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        final success = await ref
            .read(formBuilderControllerProvider(controllerKey).notifier)
            .publishForm();

        if (success && context.mounted) {
          showDialog(
            context: context,
            builder: (_) => PublishSuccessDialog(formId: formId),
          );
        } else if (!success && context.mounted) {
          final error = ref
              .read(formBuilderControllerProvider(controllerKey))
              .value
              ?.error;
          ref.read(snackbarServiceProvider).showError(
            'Failed to publish form: ${error ?? "Unknown error"}',
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusS),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spaceL - 4,
          vertical: DesignTokens.spaceM,
        ),
      ),
      child: Text(
        mode != null && mode != 'form' ? 'Publish Template' : 'Publish',
      ),
    );
  }
}

class _GitBranchSelector extends ConsumerWidget {
  final String controllerKey;
  final String projectId;
  final String formId;

  const _GitBranchSelector({
    required this.controllerKey,
    required this.projectId,
    required this.formId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gitState = ref.watch(gitControllerProvider(controllerKey));
    final gitNotifier = ref.read(gitControllerProvider(controllerKey).notifier);

    return Container(
      margin: const EdgeInsets.only(left: DesignTokens.spaceS + 4),
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spaceS,
        vertical: DesignTokens.spaceXS,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(DesignTokens.radiusS),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: gitState.activeBranch,
          icon: const FaIcon(
            FontAwesomeIcons.codeBranch,
            size: 14,
            color: AppColors.primary,
          ),
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
            fontSize: DesignTokens.fontS,
          ),
          onChanged: (String? newValue) {
            if (newValue != null) {
              gitNotifier.switchBranch(newValue);
              ref.read(snackbarServiceProvider).showInfo(
                'Switched to branch: $newValue',
              );
            }
          },
          items: gitState.branches.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Text(value),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
