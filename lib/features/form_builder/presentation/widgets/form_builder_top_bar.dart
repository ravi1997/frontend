import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/localization/locale_controller.dart';
import '../controllers/form_builder_controller.dart';
import 'ai_assistant_dialog.dart';

import 'workflow_configuration_dialog.dart';
import 'publish_success_dialog.dart';

class FormBuilderTopBar extends ConsumerWidget {
  final String controllerKey;
  final String? projectId;
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
      height: 64,
      decoration: const BoxDecoration(
        color: AppColors.builderSidebar,
        border: Border(
          bottom: BorderSide(color: AppColors.builderBorder, width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
          const SizedBox(width: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  InkWell(
                    onTap: () => ref
                        .read(formBuilderControllerProvider(controllerKey).notifier)
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
                  const SizedBox(width: 12),
                  _VersionBadge(version: formVersion),
                  const SizedBox(width: 8),
                  const _EditingBadge(),
                  const SizedBox(width: 8),
                  _EditingLocaleSwitcher(
                    controllerKey: controllerKey,
                    formId: formId,
                    currentLocale: editingLocale,
                  ),
                ],
              ),
            ),
          ),
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
          const SizedBox(width: 8),
          _TopBarActionButton(
            icon: FontAwesomeIcons.users,
            label: 'Access',
            onTap: () {
              context.push('/forms/$formId/access');
            },
          ),
          const SizedBox(width: 8),
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
          const SizedBox(width: 8),
          _TopBarActionButton(
            icon: FontAwesomeIcons.chartLine,
            label: 'Analytics',
            onTap: () {
              context.push('/forms/$formId/analysis-builder');
            },
          ),
          const SizedBox(width: 8),
          _TopBarActionButton(
            icon: FontAwesomeIcons.clockRotateLeft,
            label: 'History',
            onTap: () async {
              await context.push(
                '/forms/$formId/versions?title=${formTitle.translate('en')}${projectId != null ? '&projectId=$projectId' : ''}',
              );
              ref.invalidate(formBuilderControllerProvider(controllerKey));
            },
          ),
          const SizedBox(width: 8),
          _TopBarActionButton(
            icon: Icons.translate,
            label: 'Translate',
            onTap: () {
              context.push('/forms/$formId/translate');
            },
          ),
          const SizedBox(width: 8),
          _TopBarActionButton(
            icon: FontAwesomeIcons.shareNodes,
            label: 'Workflows',
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => WorkflowConfigurationDialog(
                  initialWorkflows: workflows,
                  sections: sections,
                  locale: editingLocale,
                  onSave: (config) {
                    ref
                        .read(formBuilderControllerProvider(controllerKey).notifier)
                        .updateWorkflows(config);
                  },
                ),
              );
            },
          ),
          const SizedBox(width: 16),
          _SaveButton(
            controllerKey: controllerKey,
            formId: formId,
            isSaving: isSaving,
          ),
          const SizedBox(width: 12),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        'v$version',
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 12,
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        'Editing',
        style: TextStyle(
          color: Colors.green,
          fontSize: 12,
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
            fontSize: 12,
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
  final IconData icon;
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
      icon: Icon(icon, size: 14, color: AppColors.textGrey),
      label: Text(
        label,
        style: const TextStyle(color: AppColors.textGrey, fontSize: 13),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Form saved successfully (${type == 'patch'
                ? 'Patch'
                : type == 'minor'
                ? 'Minor'
                : 'Major'} Version)',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      final error = ref
          .read(formBuilderControllerProvider(controllerKey))
          .value
          ?.error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save form: ${error ?? "Unknown error"}'),
          backgroundColor: Colors.red,
        ),
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
                child: Icon(
                  Icons.arrow_drop_down,
                  color: isSaving ? AppColors.textGrey : AppColors.primary,
                  size: 20,
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Failed to publish form: ${error ?? "Unknown error"}',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      child: Text(
        mode != null && mode != 'form' ? 'Publish Template' : 'Publish',
      ),
    );
  }
}
