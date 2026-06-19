"""
lib/modules/admin/pages/llm_provider_config_page.dart
LLM Provider Configuration page for managing AI models and settings.
"""

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/llm_config_models.dart';
import '../../providers/llm_config_provider.dart';

class LLMProviderConfigPage extends ConsumerStatefulWidget {
  const LLMProviderConfigPage({super.key});

  @override
  ConsumerState<LLMProviderConfigPage> createState() => _LLMProviderConfigPageState();
}

class _LLMProviderConfigPageState extends ConsumerState<LLMProviderConfigPage> {
  @override
  Widget build(BuildContext context) {
    final configState = ref.watch(llmConfigProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('LLM Provider Configuration'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddProviderDialog(),
            tooltip: 'Add Provider',
          ),
        ],
      ),
      body: configState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error loading LLM configuration',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(error.toString()),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(llmConfigProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (config) => _buildConfigContent(config),
      ),
    );
  }

  Widget _buildConfigContent(LLMConfiguration config) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Usage Statistics
          _buildUsageStats(config.usage),
          const SizedBox(height: 24),

          // Providers
          _buildProvidersSection(config.providers),
          const SizedBox(height: 24),

          // Models
          _buildModelsSection(config.models),
          const SizedBox(height: 24),

          // Settings
          _buildSettingsSection(config.settings),
        ],
      ),
    );
  }

  Widget _buildUsageStats(LLMUsageStats usage) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Usage Statistics',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total Tokens',
                    '${usage.totalTokens}',
                    Icons.token,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'Total Cost',
                    '\$${usage.totalCost.toStringAsFixed(2)}',
                    Icons.attach_money,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'Requests Today',
                    '${usage.requestsToday}',
                    Icons.today,
                    Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: usage.quotaUsagePercentage,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                usage.quotaUsagePercentage > 0.8 ? Colors.red : Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Quota Usage: ${(usage.quotaUsagePercentage * 100).toStringAsFixed(1)}%',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProvidersSection(List<LLMProvider> providers) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Providers',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        ...providers.map((provider) => _buildProviderCard(provider)),
      ],
    );
  }

  Widget _buildProviderCard(LLMProvider provider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _getProviderColor(provider.type).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getProviderIcon(provider.type),
            color: _getProviderColor(provider.type),
          ),
        ),
        title: Text(provider.name),
        subtitle: Text(provider.type),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              provider.isEnabled ? Icons.check_circle : Icons.cancel,
              color: provider.isEnabled ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    _showEditProviderDialog(provider);
                    break;
                  case 'delete':
                    _showDeleteProviderDialog(provider);
                    break;
                  case 'toggle':
                    _toggleProviderEnabled(provider);
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'toggle',
                  child: Row(
                    children: [
                      Icon(provider.isEnabled ? Icons.disable : Icons.enable),
                      SizedBox(width: 8),
                      Text(provider.isEnabled ? 'Disable' : 'Enable'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete),
                      SizedBox(width: 8),
                      Text('Delete'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () => _showEditProviderDialog(provider),
      ),
    );
  }

  Widget _buildModelsSection(List<LLMModel> models) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Models',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add Model'),
              onPressed: () => _showAddModelDialog(),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...models.map((model) => _buildModelCard(model)),
      ],
    );
  }

  Widget _buildModelCard(LLMModel model) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    model.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getProviderColor(model.provider).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    model.provider,
                    style: TextStyle(
                      fontSize: 12,
                      color: _getProviderColor(model.provider),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('ID: ${model.id}'),
            const SizedBox(height: 4),
            Text('Max Tokens: ${model.maxTokens}'),
            const SizedBox(height: 4),
            Text('Cost: \$${model.costPer1kTokens}/1K tokens'),
            const SizedBox(height: 8),
            Row(
              children: [
                if (model.supportsStreaming)
                  const Chip(
                    label: Text('Streaming'),
                    backgroundColor: Colors.green,
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                if (model.isEnabled)
                  const Chip(
                    label: Text('Enabled'),
                    backgroundColor: Colors.blue,
                    labelStyle: TextStyle(color: Colors.white),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(LLMGlobalSettings settings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Global Settings',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildSettingRow(
                  'Default Provider',
                  settings.defaultProvider,
                  Icons.settings,
                ),
                const Divider(),
                _buildSettingRow(
                  'Default Model',
                  settings.defaultModel,
                  Icons.psychology,
                ),
                const Divider(),
                _buildSettingRow(
                  'Max Tokens Per Request',
                  '${settings.maxTokensPerRequest}',
                  Icons.token,
                ),
                const Divider(),
                _buildSettingRow(
                  'Temperature Default',
                  '${settings.defaultTemperature}',
                  Icons.thermostat,
                ),
                const Divider(),
                _buildSettingRow(
                  'Cost Alert Threshold',
                  '\$${settings.costAlertThreshold}',
                  Icons.warning,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Color _getProviderColor(String providerType) {
    switch (providerType.toLowerCase()) {
      case 'openai':
        return Colors.green;
      case 'anthropic':
        return Colors.purple;
      case 'ollama':
        return Colors.orange;
      case 'google':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getProviderIcon(String providerType) {
    switch (providerType.toLowerCase()) {
      case 'openai':
        return Icons.smart_toy;
      case 'anthropic':
        return Icons.psychology;
      case 'ollama':
        return Icons.computer;
      case 'google':
        return Icons.cloud;
      default:
        return Icons.settings;
    }
  }

  void _showAddProviderDialog() {
    showDialog(
      context: context,
      builder: (context) => _LLMProviderDialog(
        onSaved: (provider) {
          ref.read(llmConfigProvider.notifier).addProvider(provider);
        },
      ),
    );
  }

  void _showEditProviderDialog(LLMProvider provider) {
    showDialog(
      context: context,
      builder: (context) => _LLMProviderDialog(
        provider: provider,
        onSaved: (updatedProvider) {
          ref.read(llmConfigProvider.notifier).updateProvider(updatedProvider);
        },
      ),
    );
  }

  void _showDeleteProviderDialog(LLMProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Provider'),
        content: Text('Are you sure you want to delete "${provider.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(llmConfigProvider.notifier).deleteProvider(provider.id);
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _toggleProviderEnabled(LLMProvider provider) {
    final updatedProvider = provider.copyWith(isEnabled: !provider.isEnabled);
    ref.read(llmConfigProvider.notifier).updateProvider(updatedProvider);
  }

  void _showAddModelDialog() {
    showDialog(
      context: context,
      builder: (context) => _LLMModelDialog(
        onSaved: (model) {
          ref.read(llmConfigProvider.notifier).addModel(model);
        },
      ),
    );
  }
}

class _LLMProviderDialog extends StatefulWidget {
  final LLMProvider? provider;
  final Function(LLMProvider) onSaved;

  const _LLMProviderDialog({
    this.provider,
    required this.onSaved,
  });

  @override
  State<_LLMProviderDialog> createState() => _LLMProviderDialogState();
}

class _LLMProviderDialogState extends State<_LLMProviderDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _apiKeyController = TextEditingController();
  final _baseUrlController = TextEditingController();
  String _selectedType = 'openai';
  bool _isEnabled = true;

  @override
  void initState() {
    super.initState();
    if (widget.provider != null) {
      _nameController.text = widget.provider!.name;
      _apiKeyController.text = widget.provider!.apiKey ?? '';
      _baseUrlController.text = widget.provider!.baseUrl ?? '';
      _selectedType = widget.provider!.type;
      _isEnabled = widget.provider!.isEnabled;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _apiKeyController.dispose();
    _baseUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.provider == null ? 'Add Provider' : 'Edit Provider'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Provider Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a provider name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'Provider Type',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'openai', child: Text('OpenAI')),
                  DropdownMenuItem(value: 'anthropic', child: Text('Anthropic')),
                  DropdownMenuItem(value: 'ollama', child: Text('Ollama')),
                  DropdownMenuItem(value: 'google', child: Text('Google')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedType = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _apiKeyController,
                decoration: const InputDecoration(
                  labelText: 'API Key',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _baseUrlController,
                decoration: const InputDecoration(
                  labelText: 'Base URL (Optional)',
                  border: OutlineInputBorder(),
                  hintText: 'https://api.example.com',
                ),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Enabled'),
                value: _isEnabled,
                onChanged: (value) {
                  setState(() {
                    _isEnabled = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final provider = LLMProvider(
                id: widget.provider?.id ?? DateTime.now().toString(),
                name: _nameController.text.trim(),
                type: _selectedType,
                apiKey: _apiKeyController.text.trim().isEmpty ? null : _apiKeyController.text.trim(),
                baseUrl: _baseUrlController.text.trim().isEmpty ? null : _baseUrlController.text.trim(),
                isEnabled: _isEnabled,
              );
              widget.onSaved(provider);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _LLMModelDialog extends StatefulWidget {
  final Function(LLMModel) onSaved;

  const _LLMModelDialog({required this.onSaved});

  @override
  State<_LLMModelDialog> createState() => _LLMModelDialogState();
}

class _LLMModelDialogState extends State<_LLMModelDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _maxTokensController = TextEditingController();
  final _costController = TextEditingController();
  String _selectedProvider = 'openai';
  bool _supportsStreaming = true;
  bool _isEnabled = true;

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _maxTokensController.dispose();
    _costController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Model'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Model Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a model name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _idController,
                decoration: const InputDecoration(
                  labelText: 'Model ID',
                  border: OutlineInputBorder(),
                  hintText: 'gpt-4, claude-3-opus, etc.',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a model ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedProvider,
                decoration: const InputDecoration(
                  labelText: 'Provider',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'openai', child: Text('OpenAI')),
                  DropdownMenuItem(value: 'anthropic', child: Text('Anthropic')),
                  DropdownMenuItem(value: 'ollama', child: Text('Ollama')),
                  DropdownMenuItem(value: 'google', child: Text('Google')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedProvider = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _maxTokensController,
                decoration: const InputDecoration(
                  labelText: 'Max Tokens',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter max tokens';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _costController,
                decoration: const InputDecoration(
                  labelText: 'Cost per 1K Tokens (USD)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter cost';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Supports Streaming'),
                value: _supportsStreaming,
                onChanged: (value) {
                  setState(() {
                    _supportsStreaming = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Enabled'),
                value: _isEnabled,
                onChanged: (value) {
                  setState(() {
                    _isEnabled = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final model = LLMModel(
                id: _idController.text.trim(),
                name: _nameController.text.trim(),
                provider: _selectedProvider,
                maxTokens: int.parse(_maxTokensController.text),
                supportsStreaming: _supportsStreaming,
                costPer1kTokens: double.parse(_costController.text),
                isEnabled: _isEnabled,
              );
              widget.onSaved(model);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}