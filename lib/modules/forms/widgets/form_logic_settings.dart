import 'package:flutter/material.dart';

import 'package:frontend/app/theme/tokens.dart';
import 'package:frontend/modules/forms/widgets/workflow_configuration_dialog.dart';
import 'package:frontend/shared/models/form_models.dart' hide Form;

class FormLogicSettings extends StatelessWidget {
  final Map<String, dynamic> form;
  final Function(Map<String, dynamic>) onChanged;

  const FormLogicSettings({
    super.key,
    required this.form,
    required this.onChanged,
  });

  List<FormSection> _sections() {
    final rawSections = form['sections'] as List? ?? const [];
    return rawSections.map((section) {
      if (section is FormSection) return section;
      return FormSection.fromJson(Map<String, dynamic>.from(section as Map));
    }).toList();
  }

  Map<String, dynamic> _workflows() {
    return Map<String, dynamic>.from(form['workflows'] ?? const {});
  }

  Future<void> _openWorkflowDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return WorkflowConfigurationDialog(
          initialWorkflows: _workflows(),
          sections: _sections(),
          locale: Localizations.localeOf(context).languageCode,
          onSave: (updated) => onChanged(updated),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final workflows = _workflows();
    final emailEnabled = workflows['email_notification']?['enabled'] == true;
    final webhookEnabled = workflows['webhook']?['enabled'] == true;
    final activeCount = [
      emailEnabled,
      webhookEnabled,
    ].where((value) => value).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Logic Settings', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: DesignTokens.spaceM),
        Text(
          activeCount == 0
              ? 'No workflows configured yet. You can add email notifications or webhooks for this form.'
              : '$activeCount workflow${activeCount == 1 ? '' : 's'} configured for this form.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.72),
            height: 1.5,
          ),
        ),
        const SizedBox(height: DesignTokens.spaceM),
        Wrap(
          spacing: DesignTokens.spaceS,
          runSpacing: DesignTokens.spaceS,
          children: [
            _StatusChip(label: 'Email', enabled: emailEnabled),
            _StatusChip(label: 'Webhook', enabled: webhookEnabled),
          ],
        ),
        const SizedBox(height: DesignTokens.spaceL),
        FilledButton.icon(
          onPressed: () => _openWorkflowDialog(context),
          icon: const Icon(Icons.account_tree_outlined),
          label: Text(activeCount == 0 ? 'Add workflow' : 'Edit workflows'),
        ),
        const SizedBox(height: DesignTokens.spaceS),
        Text(
          'Configure workflow actions without leaving the form settings panel.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.58),
          ),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final bool enabled;

  const _StatusChip({required this.label, required this.enabled});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final background = enabled
        ? cs.primaryContainer
        : cs.surfaceContainerHighest;
    final foreground = enabled ? cs.onPrimaryContainer : cs.onSurfaceVariant;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spaceM,
        vertical: DesignTokens.spaceS,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
        border: Border.all(
          color: enabled
              ? cs.primary.withValues(alpha: 0.24)
              : cs.outlineVariant,
        ),
      ),
      child: Text(
        '$label: ${enabled ? 'enabled' : 'disabled'}',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: foreground,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
