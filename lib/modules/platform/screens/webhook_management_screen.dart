import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/theme/tokens.dart';
import '../../../core/services/snackbar_service.dart';
import '../../../core/widgets/responsive.dart';
import '../webhook_management_repository.dart';

class WebhookManagementScreen extends ConsumerStatefulWidget {
  const WebhookManagementScreen({super.key});

  @override
  ConsumerState<WebhookManagementScreen> createState() =>
      _WebhookManagementScreenState();
}

class _WebhookManagementScreenState extends ConsumerState<WebhookManagementScreen> {
  final _formIdController = TextEditingController();
  final _urlController = TextEditingController();
  final _statusController = TextEditingController();
  final _limitController = TextEditingController(text: '50');
  final _payloadController = TextEditingController(
    text: jsonEncode(<String, dynamic>{
      'event_type': 'webhook.test',
      'message': 'Test delivery from the admin webhook console',
    }),
  );
  final _newWebhookNameController = TextEditingController();
  final _newWebhookUrlController = TextEditingController();
  final _newWebhookEventController = TextEditingController(text: 'on_submit');
  final _newWebhookDescriptionController = TextEditingController();

  bool _loading = false;
  String? _error;
  List<Map<String, dynamic>> _webhooks = const [];
  List<Map<String, dynamic>> _logs = const [];
  String? _selectedWebhookId;

  @override
  void dispose() {
    _formIdController.dispose();
    _urlController.dispose();
    _statusController.dispose();
    _limitController.dispose();
    _payloadController.dispose();
    _newWebhookNameController.dispose();
    _newWebhookUrlController.dispose();
    _newWebhookEventController.dispose();
    _newWebhookDescriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadWebhooks() async {
    final formId = _formIdController.text.trim();
    if (formId.isEmpty) {
      ref.read(snackbarServiceProvider).showError('Form ID is required');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final repo = ref.read(webhookManagementRepositoryProvider);
      final webhooks = await repo.listWebhooks(formId: formId);
      setState(() {
        _webhooks = webhooks;
        _loading = false;
      });
      if (webhooks.isNotEmpty) {
        await _loadLogsFor(webhooks.first['id']?.toString() ?? '');
      } else {
        setState(() {
          _selectedWebhookId = null;
          _logs = const [];
        });
      }
    } catch (e) {
      setState(() {
        _loading = false;
        _error = 'Failed to load webhooks: $e';
      });
    }
  }

  Future<void> _loadLogs() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final repo = ref.read(webhookManagementRepositoryProvider);
      final logs = await repo.listWebhookLogs(
        url: _urlController.text.trim(),
        status: _statusController.text.trim(),
        limit: int.tryParse(_limitController.text.trim()) ?? 50,
      );
      setState(() {
        _logs = logs;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = 'Failed to load webhook logs: $e';
      });
    }
  }

  Future<void> _loadLogsFor(String webhookId) async {
    if (webhookId.isEmpty) return;
    setState(() {
      _loading = true;
      _error = null;
      _selectedWebhookId = webhookId;
    });
    try {
      final repo = ref.read(webhookManagementRepositoryProvider);
      final logs = await repo.listWebhookLogs(
        webhookId: webhookId,
        limit: int.tryParse(_limitController.text.trim()) ?? 50,
      );
      setState(() {
        _logs = logs;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = 'Failed to load webhook logs: $e';
      });
    }
  }

  Future<void> _triggerTest() async {
    final url = _urlController.text.trim();
    if (url.isEmpty) {
      ref.read(snackbarServiceProvider).showError('Webhook URL is required');
      return;
    }

    Map<String, dynamic> payload;
    try {
      final decoded = jsonDecode(_payloadController.text.trim());
      if (decoded is! Map) {
        throw const FormatException('payload must be a JSON object');
      }
      payload = Map<String, dynamic>.from(decoded);
    } catch (_) {
      ref.read(snackbarServiceProvider).showError('Payload must be valid JSON');
      return;
    }

    setState(() => _loading = true);
    try {
      final repo = ref.read(webhookManagementRepositoryProvider);
      await repo.testWebhook(url: url, payload: payload);
      ref.read(snackbarServiceProvider).showSuccess('Webhook test sent');
      await _loadLogs();
    } catch (e) {
      setState(() => _loading = false);
      ref.read(snackbarServiceProvider).showError('Webhook test failed: $e');
    }
  }

  Future<void> _showCreateDialog() async {
    final formId = _formIdController.text.trim();
    if (formId.isEmpty) {
      ref.read(snackbarServiceProvider).showError('Form ID is required');
      return;
    }

    final formKey = GlobalKey<FormState>();
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Create Webhook',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold),
          ),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _newWebhookNameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) =>
                        value == null || value.trim().isEmpty ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: _newWebhookUrlController,
                    decoration: const InputDecoration(labelText: 'Delivery URL'),
                    validator: (value) =>
                        value == null || value.trim().isEmpty ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: _newWebhookEventController,
                    decoration: const InputDecoration(labelText: 'Event type'),
                  ),
                  TextFormField(
                    controller: _newWebhookDescriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                Navigator.pop(context);
                try {
                  final repo = ref.read(webhookManagementRepositoryProvider);
                  await repo.createWebhook(
                    formId: formId,
                    name: _newWebhookNameController.text.trim(),
                    url: _newWebhookUrlController.text.trim(),
                    eventType: _newWebhookEventController.text.trim(),
                    description: _newWebhookDescriptionController.text.trim(),
                  );
                  ref.read(snackbarServiceProvider).showSuccess('Webhook created');
                  _newWebhookNameController.clear();
                  _newWebhookUrlController.clear();
                  _newWebhookEventController.text = 'on_submit';
                  _newWebhookDescriptionController.clear();
                  await _loadWebhooks();
                } catch (e) {
                  ref.read(snackbarServiceProvider).showError('Failed to create webhook: $e');
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteWebhook(Map<String, dynamic> webhook) async {
    final webhookId = webhook['id']?.toString() ?? '';
    if (webhookId.isEmpty) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete webhook?'),
        content: Text(
          'This will permanently remove "${webhook['name'] ?? webhookId}".',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      final repo = ref.read(webhookManagementRepositoryProvider);
      await repo.deleteWebhook(webhookId);
      ref.read(snackbarServiceProvider).showSuccess('Webhook deleted');
      await _loadWebhooks();
    } catch (e) {
      ref.read(snackbarServiceProvider).showError('Failed to delete webhook: $e');
    }
  }

  Future<void> _testWebhookById(Map<String, dynamic> webhook) async {
    final webhookId = webhook['id']?.toString() ?? '';
    if (webhookId.isEmpty) return;

    try {
      final repo = ref.read(webhookManagementRepositoryProvider);
      await repo.testWebhook(webhookId: webhookId);
      ref.read(snackbarServiceProvider).showSuccess('Webhook test sent');
      await _loadLogsFor(webhookId);
    } catch (e) {
      ref.read(snackbarServiceProvider).showError('Webhook test failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final compact = Responsive.of(context) == ScreenSize.mobile;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Webhook Management',
          style: GoogleFonts.inter(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _formIdController.text.trim().isEmpty
                ? _loadLogs
                : _loadWebhooks,
          ),
          TextButton.icon(
            onPressed: _showCreateDialog,
            icon: const Icon(Icons.add),
            label: const Text('New Webhook'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(DesignTokens.spaceL),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFormSelectorCard(compact),
                      const SizedBox(height: DesignTokens.spaceL),
                      _buildWebhookListCard(),
                      const SizedBox(height: DesignTokens.spaceL),
                      _buildManualTestCard(compact),
                      const SizedBox(height: DesignTokens.spaceL),
                      _buildLogsCard(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildFormSelectorCard(bool compact) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spaceL),
        child: compact
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Form Scope',
                    style: GoogleFonts.inter(
                      fontSize: DesignTokens.fontM,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: DesignTokens.spaceM),
                  TextField(
                    controller: _formIdController,
                    decoration: const InputDecoration(
                      labelText: 'Form ID',
                      hintText: 'form-123',
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: _loadWebhooks,
                    child: const Text('Load Webhooks'),
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _formIdController,
                      decoration: const InputDecoration(
                        labelText: 'Form ID',
                        hintText: 'form-123',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: _loadWebhooks,
                    child: const Text('Load Webhooks'),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildWebhookListCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spaceL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Configured Webhooks',
                    style: GoogleFonts.inter(
                      fontSize: DesignTokens.fontM,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if (_selectedWebhookId != null)
                  Text(
                    'Selected: $_selectedWebhookId',
                    style: GoogleFonts.inter(
                      fontSize: DesignTokens.fontS,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: DesignTokens.spaceM),
            if (_webhooks.isEmpty)
              const Text('No webhooks found for the selected form.')
            else
              ..._webhooks.map(
                (webhook) => Card(
                  child: ListTile(
                    title: Text(webhook['name']?.toString() ?? 'Untitled webhook'),
                    subtitle: Text(
                      [
                        if (webhook['event_type'] != null) webhook['event_type'],
                        if (webhook['action_config'] is Map)
                          (webhook['action_config'] as Map)['url'],
                      ].whereType<String>().join(' • '),
                    ),
                    trailing: Wrap(
                      spacing: 8,
                      children: [
                        TextButton(
                          onPressed: () => _testWebhookById(webhook),
                          child: const Text('Test'),
                        ),
                        TextButton(
                          onPressed: () => _loadLogsFor(webhook['id']?.toString() ?? ''),
                          child: const Text('Logs'),
                        ),
                        TextButton(
                          onPressed: () => _deleteWebhook(webhook),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildManualTestCard(bool compact) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spaceL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Test Delivery',
              style: GoogleFonts.inter(
                fontSize: DesignTokens.fontM,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: DesignTokens.spaceM),
            if (compact)
              Column(
                children: [
                  _buildField(_urlController, 'Webhook URL'),
                  const SizedBox(height: 12),
                  _buildField(_statusController, 'Status filter', hint: 'optional'),
                  const SizedBox(height: 12),
                  _buildField(
                    _limitController,
                    'Limit',
                    keyboardType: TextInputType.number,
                  ),
                ],
              )
            else
              Row(
                children: [
                  Expanded(child: _buildField(_urlController, 'Webhook URL')),
                  const SizedBox(width: 12),
                  Expanded(child: _buildField(_statusController, 'Status filter', hint: 'optional')),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 120,
                    child: _buildField(
                      _limitController,
                      'Limit',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 12),
            TextField(
              controller: _payloadController,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: 'JSON Payload',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: _triggerTest,
                icon: const Icon(Icons.send),
                label: const Text('Send Test'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String label, {
    String? hint,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
      ),
    );
  }

  Widget _buildLogsCard() {
    if (_error != null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.spaceL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: _formIdController.text.trim().isEmpty
                    ? _loadLogs
                    : _loadWebhooks,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spaceL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Logs',
              style: GoogleFonts.inter(
                fontSize: DesignTokens.fontM,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: DesignTokens.spaceM),
            if (_logs.isEmpty)
              const Text('No webhook logs found.')
            else
              ..._logs.take(20).map(
                    (log) => ListTile(
                      leading: const Icon(Icons.receipt_long),
                      title: Text(
                        '${log['event_type'] ?? 'webhook'} • ${log['status'] ?? 'unknown'}',
                      ),
                      subtitle: Text(
                        [
                          if (log['url'] != null) log['url'],
                          if (log['timestamp'] != null) log['timestamp'],
                        ].whereType<String>().join(' • '),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
