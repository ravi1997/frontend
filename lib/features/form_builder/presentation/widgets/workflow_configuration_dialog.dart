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
        if (_emailEnabled) 'recipient': _emailController.text,
      },
      'webhook': {
        'enabled': _webhookEnabled,
        if (_webhookEnabled) 'url': _webhookController.text,
      },
      'slack_notification': {'enabled': _slackEnabled},
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
                    ? AppColors.primary.withOpacity(0.1)
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
              activeColor: AppColors.primary,
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
      ],
    );
  }
}
