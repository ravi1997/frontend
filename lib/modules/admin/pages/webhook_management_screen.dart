import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/snackbar_service.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/error_widget.dart';

class WebhookManagementScreen extends ConsumerStatefulWidget {
  const WebhookManagementScreen({super.key});

  @override
  ConsumerState<WebhookManagementScreen> createState() => _WebhookManagementScreenState();
}

class _WebhookManagementScreenState extends ConsumerState<WebhookManagementScreen> {
  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>> _webhooks = [];

  @override
  void initState() {
    super.initState();
    _loadWebhooks();
  }

  Future<void> _loadWebhooks() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await ref.read(apiServiceProvider).get('/webhooks');
      if (response.success) {
        setState(() {
          _webhooks = List<Map<String, dynamic>>.from(response.data['webhooks']);
        });
      } else {
        setState(() {
          _error = response.message;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _createWebhook(Map<String, dynamic> webhookData) async {
    try {
      final response = await ref.read(apiServiceProvider).post('/webhooks', data: webhookData);
      if (response.success) {
        ref.read(snackbarServiceProvider).showSuccess('Webhook created successfully');
        await _loadWebhooks(); // Refresh list
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      ref.read(snackbarServiceProvider).showError('Error creating webhook: $e');
    }
  }

  Future<void> _updateWebhook(String webhookId, Map<String, dynamic> webhookData) async {
    try {
      final response = await ref.read(apiServiceProvider).put('/webhooks/$webhookId', data: webhookData);
      if (response.success) {
        ref.read(snackbarServiceProvider).showSuccess('Webhook updated successfully');
        await _loadWebhooks(); // Refresh list
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      ref.read(snackbarServiceProvider).showError('Error updating webhook: $e');
    }
  }

  Future<void> _deleteWebhook(String webhookId) async {
    try {
      final response = await ref.read(apiServiceProvider).delete('/webhooks/$webhookId');
      if (response.success) {
        ref.read(snackbarServiceProvider).showSuccess('Webhook deleted successfully');
        await _loadWebhooks(); // Refresh list
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      ref.read(snackbarServiceProvider).showError('Error deleting webhook: $e');
    }
  }

  void _showWebhookDialog({Map<String, dynamic>? webhook}) {
    final isEditing = webhook != null;
    final urlController = TextEditingController(text: webhook?['url'] ?? '');
    final secretController = TextEditingController(text: webhook?['secret'] ?? '');
    final eventsController = TextEditingController(
      text: webhook?['events']?.join(', ') ?? 'response.submitted,form.published',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Edit Webhook' : 'Create Webhook'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: urlController,
                decoration: const InputDecoration(
                  labelText: 'URL',
                  border: OutlineInputBorder(),
                  hintText: 'https://example.com/webhook',
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: secretController,
                decoration: const InputDecoration(
                  labelText: 'Secret (Optional)',
                  border: OutlineInputBorder(),
                  hintText: 'Your webhook secret for signature verification',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: eventsController,
                decoration: const InputDecoration(
                  labelText: 'Events',
                  border: OutlineInputBorder(),
                  hintText: 'response.submitted,form.published',
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Comma-separated list of events to trigger this webhook',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (urlController.text.isEmpty) {
                ref.read(snackbarServiceProvider).showError('URL is required');
                return;
              }

              final events = eventsController.text
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList();

              final webhookData = {
                'url': urlController.text,
                'secret': secretController.text,
                'events': events,
              };

              Navigator.of(context).pop();

              if (isEditing) {
                _updateWebhook(webhook['id'], webhookData);
              } else {
                _createWebhook(webhookData);
              }
            },
            child: Text(isEditing ? 'Update' : 'Create'),
          ),
        ],
      ),
    );
  }

  void _showTestWebhookDialog(Map<String, dynamic> webhook) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Test Webhook'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Send a test payload to ${webhook['url']}?'),
            const SizedBox(height: 16.0),
            Text(
              'This will send a sample payload with test data.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                final response = await ref.read(apiServiceProvider).post('/webhooks/${webhook['id']}/test');
                if (response.success) {
                  ref.read(snackbarServiceProvider).showSuccess('Test webhook sent successfully');
                } else {
                  throw Exception(response.message);
                }
              } catch (e) {
                ref.read(snackbarServiceProvider).showError('Error testing webhook: $e');
              }
            },
            child: const Text('Send Test'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Webhook Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadWebhooks,
          ),
        ],
      ),
      body: _isLoading
          ? const LoadingWidget()
          : _error != null
              ? AppErrorWidget(
                  error: _error!,
                  onRetry: _loadWebhooks,
                )
              : _buildContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showWebhookDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildContent() {
    if (_webhooks.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.webhook, size: 64, color: Colors.grey),
            SizedBox(height: 16.0),
            Text(
              'No webhooks configured',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8.0),
            Text(
              'Add a webhook to receive real-time notifications',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _webhooks.length,
      itemBuilder: (context, index) {
        final webhook = _webhooks[index];
        return _buildWebhookCard(webhook);
      },
    );
  }

  Widget _buildWebhookCard(Map<String, dynamic> webhook) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    webhook['name'] ?? 'Unnamed Webhook',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Icon(
                  webhook['is_active'] ? Icons.check_circle : Icons.cancel,
                  color: webhook['is_active'] ? Colors.green : Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              webhook['url'],
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8.0),
            Wrap(
              spacing: 8.0,
              children: (webhook['events'] as List<dynamic>)
                  .map((event) => Chip(
                        label: Text(event),
                        backgroundColor: Theme.of(context).primaryColorLight,
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                  onPressed: () => _showWebhookDialog(webhook: webhook),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.send),
                  label: const Text('Test'),
                  onPressed: () => _showTestWebhookDialog(webhook),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text('Delete', style: TextStyle(color: Colors.red)),
                  onPressed: () => _deleteWebhook(webhook['id']),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
