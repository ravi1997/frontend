import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/theme/app_colors.dart';

class WorkflowConfigurationDialog extends StatefulWidget {
  final Map<String, dynamic> initialWorkflows;
  final Function(Map<String, dynamic>) onSave;

  const WorkflowConfigurationDialog({
    super.key,
    required this.initialWorkflows,
    required this.onSave,
  });

  @override
  State<WorkflowConfigurationDialog> createState() =>
      _WorkflowConfigurationDialogState();
}

class _WorkflowConfigurationDialogState
    extends State<WorkflowConfigurationDialog> {
  // Integation States
  late bool _emailEnabled;
  late bool _webhookEnabled;
  late bool _slackEnabled;

  // Configuration Controllers
  late TextEditingController _emailController;
  late TextEditingController _webhookController;

  // Condition States
  late Map<String, Map<String, dynamic>> _conditions;

  @override
  void initState() {
    super.initState();
    final workflows = widget.initialWorkflows;

    _emailEnabled = workflows['email_notification']?['enabled'] ?? false;
    _webhookEnabled = workflows['webhook']?['enabled'] ?? false;
    _slackEnabled = workflows['slack_notification']?['enabled'] ?? false;

    _emailController = TextEditingController(
      text: workflows['email_notification']?['recipient'] ?? '',
    );
    _webhookController = TextEditingController(
      text: workflows['webhook']?['url'] ?? '',
    );

    _conditions = {
      'email_notification': workflows['email_notification']?['condition'] ?? {},
      'webhook': workflows['webhook']?['condition'] ?? {},
      'slack_notification': workflows['slack_notification']?['condition'] ?? {},
    };
  }

  @override
  void dispose() {
    _emailController.dispose();
    _webhookController.dispose();
    super.dispose();
  }

  void _saveLogic() {
    final config = {
      'email_notification': {
        'enabled': _emailEnabled,
        'recipient': _emailController.text,
        'condition': _conditions['email_notification'],
      },
      'webhook': {
        'enabled': _webhookEnabled,
        'url': _webhookController.text,
        'condition': _conditions['webhook'],
      },
      'slack_notification': {
        'enabled': _slackEnabled,
        'condition': _conditions['slack_notification'],
      },
    };

    widget.onSave(config);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Form Workflows',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textGrey),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Configure automated actions when a form is submitted.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textGrey),
            ),
            const SizedBox(height: 24),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildIntegrationItem(
                      icon: Icons.email_outlined,
                      title: 'Email Notification',
                      description: 'Send an email when a response is received',
                      isEnabled: _emailEnabled,
                      id: 'email_notification',
                      onToggle: (val) => setState(() => _emailEnabled = val),
                      child: TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Recipient Email',
                          border: OutlineInputBorder(),
                          hintText: 'user@example.com',
                          isDense: true,
                        ),
                      ),
                    ),
                    const Divider(height: 32),
                    _buildIntegrationItem(
                      icon: Icons.webhook,
                      title: 'Webhook',
                      description: 'POST submission data to an external URL',
                      isEnabled: _webhookEnabled,
                      id: 'webhook',
                      onToggle: (val) => setState(() => _webhookEnabled = val),
                      child: TextField(
                        controller: _webhookController,
                        decoration: const InputDecoration(
                          labelText: 'Webhook URL',
                          border: OutlineInputBorder(),
                          hintText: 'https://api.example.com/hooks',
                          isDense: true,
                        ),
                      ),
                    ),
                    const Divider(height: 32),
                    _buildIntegrationItem(
                      icon: FontAwesomeIcons.slack,
                      title: 'Slack Notification',
                      description: 'Send a message to a Slack channel',
                      isEnabled: _slackEnabled,
                      id: 'slack_notification',
                      onToggle: (val) => setState(() => _slackEnabled = val),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _saveLogic,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Save Logic'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntegrationItem({
    required IconData icon,
    required String title,
    required String description,
    required bool isEnabled,
    required String id,
    required ValueChanged<bool> onToggle,
    Widget? child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isEnabled
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isEnabled ? AppColors.primary : Colors.grey,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    description,
                    style: const TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: isEnabled,
              onChanged: onToggle,
              activeTrackColor: AppColors.primary,
            ),
          ],
        ),
        if (isEnabled && child != null) ...[
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 44), // Align with text
            child: child,
          ),
        ],
        if (isEnabled) ...[
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 44),
            child: _buildConditionBuilder(id),
          ),
        ],
      ],
    );
  }

  Widget _buildConditionBuilder(String integrationId) {
    final condition = _conditions[integrationId]!;
    final isConditional = condition['enabled'] ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.filter_list, size: 14, color: AppColors.textGrey),
            const SizedBox(width: 8),
            Text(
              'Workflow Logic',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isConditional ? AppColors.primary : AppColors.textGrey,
              ),
            ),
            const Spacer(),
            Text(
              isConditional ? 'Conditional' : 'Run Always',
              style: const TextStyle(fontSize: 11, color: AppColors.textGrey),
            ),
            Switch(
              value: isConditional,
              onChanged: (val) {
                setState(() {
                  _conditions[integrationId]!['enabled'] = val;
                });
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
        if (isConditional) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text('IF field', style: TextStyle(fontSize: 12)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        initialValue: condition['field'] ?? '',
                        onChanged: (val) =>
                            _conditions[integrationId]!['field'] = val,
                        decoration: _conditionInputDecoration('score'),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<String>(
                        initialValue: condition['operator'] ?? 'equals',
                        items: const [
                          DropdownMenuItem(
                            value: 'equals',
                            child: Text('Equals'),
                          ),
                          DropdownMenuItem(
                            value: 'not_equals',
                            child: Text('Not Equals'),
                          ),
                          DropdownMenuItem(
                            value: 'contains',
                            child: Text('Contains'),
                          ),
                          DropdownMenuItem(
                            value: 'is_empty',
                            child: Text('Is Empty'),
                          ),
                        ],
                        onChanged: (val) => setState(
                          () => _conditions[integrationId]!['operator'] = val,
                        ),
                        decoration: _conditionInputDecoration('operator'),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        initialValue: condition['value'] ?? '',
                        onChanged: (val) =>
                            _conditions[integrationId]!['value'] = val,
                        decoration: _conditionInputDecoration('value'),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  InputDecoration _conditionInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
    );
  }
}
