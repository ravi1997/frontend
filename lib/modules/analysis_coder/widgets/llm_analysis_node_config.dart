"""
lib/modules/analysis_coder/widgets/llm_analysis_node_config.dart
Configuration widget for LLM analysis nodes.
"""

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/analysis_models.dart';
import '../providers/analysis_provider.dart';
import '../theme/analysis_theme.dart';

class LLMAnalysisNodeConfig extends ConsumerStatefulWidget {
  final AnalysisNode node;
  final Function(AnalysisNode) onNodeUpdated;

  const LLMAnalysisNodeConfig({
    super.key,
    required this.node,
    required this.onNodeUpdated,
  });

  @override
  ConsumerState<LLMAnalysisNodeConfig> createState() => _LLMAnalysisNodeConfigState();
}

class _LLMAnalysisNodeConfigState extends ConsumerState<LLMAnalysisNodeConfig> {
  late TextEditingController _promptController;
  late TextEditingController _temperatureController;
  late TextEditingController _maxTokensController;
  late String _selectedProvider;
  late String _selectedModel;
  late String _outputFormat;

  List<LLMModel> _availableModels = [];

  @override
  void initState() {
    super.initState();
    _loadAvailableModels();
    _initializeControllers();
  }

  void _initializeControllers() {
    _promptController = TextEditingController(
      text: widget.node.config['prompt'] ?? 'Analyze the following data and provide insights:',
    );
    _temperatureController = TextEditingController(
      text: widget.node.config['temperature']?.toString() ?? '0.7',
    );
    _maxTokensController = TextEditingController(
      text: widget.node.config['max_tokens']?.toString() ?? '1000',
    );
    _selectedProvider = widget.node.config['provider'] ?? 'openai';
    _selectedModel = widget.node.config['model_id'] ?? 'gpt-4';
    _outputFormat = widget.node.config['output_format'] ?? 'json';
  }

  Future<void> _loadAvailableModels() async {
    try {
      final models = await ref.read(llmModelProvider.future);
      setState(() {
        _availableModels = models;
      });
    } catch (e) {
      // Handle error
      debugPrint('Error loading LLM models: $e');
    }
  }

  @override
  void dispose() {
    _promptController.dispose();
    _temperatureController.dispose();
    _maxTokensController.dispose();
    super.dispose();
  }

  void _updateNode() {
    final updatedConfig = Map<String, dynamic>.from(widget.node.config);
    updatedConfig['prompt'] = _promptController.text;
    updatedConfig['temperature'] = double.tryParse(_temperatureController.text) ?? 0.7;
    updatedConfig['max_tokens'] = int.tryParse(_maxTokensController.text) ?? 1000;
    updatedConfig['provider'] = _selectedProvider;
    updatedConfig['model_id'] = _selectedModel;
    updatedConfig['output_format'] = _outputFormat;

    final updatedNode = widget.node.copyWith(config: updatedConfig);
    widget.onNodeUpdated(updatedNode);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AnalysisTheme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: theme.dialogBorderRadius,
      ),
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.psychology,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LLM Analysis Configuration',
                        style: theme.dialogTitleStyle,
                      ),
                      Text(
                        widget.node.name,
                        style: theme.dialogSubtitleStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Configuration form
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Provider selection
                    _buildSectionTitle('LLM Provider'),
                    _buildProviderSelector(),
                    const SizedBox(height: 16),

                    // Model selection
                    _buildSectionTitle('Model'),
                    _buildModelSelector(),
                    const SizedBox(height: 16),

                    // Output format
                    _buildSectionTitle('Output Format'),
                    _buildOutputFormatSelector(),
                    const SizedBox(height: 16),

                    // Prompt
                    _buildSectionTitle('Prompt'),
                    _buildPromptField(),
                    const SizedBox(height: 16),

                    // Temperature
                    _buildSectionTitle('Temperature'),
                    _buildTemperatureField(),
                    const SizedBox(height: 16),

                    // Max tokens
                    _buildSectionTitle('Max Tokens'),
                    _buildMaxTokensField(),
                  ],
                ),
              ),
            ),

            // Actions
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    _updateNode();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    final theme = AnalysisTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: theme.sectionTitleStyle,
      ),
    );
  }

  Widget _buildProviderSelector() {
    final providers = _availableModels
        .map((model) => model.provider)
        .toSet()
        .toList();

    return DropdownButtonFormField<String>(
      value: _selectedProvider,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: providers.map((provider) {
        return DropdownMenuItem<String>(
          value: provider,
          child: Text(_capitalizeFirst(provider)),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedProvider = value;
            // Update selected model to first available for this provider
            final firstModel = _availableModels
                .where((m) => m.provider == value)
                .firstOrNull;
            if (firstModel != null) {
              _selectedModel = firstModel.id;
            }
          });
        }
      },
    );
  }

  Widget _buildModelSelector() {
    final providerModels = _availableModels
        .where((model) => model.provider == _selectedProvider)
        .toList();

    return DropdownButtonFormField<String>(
      value: _selectedModel,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: providerModels.map((model) {
        return DropdownMenuItem<String>(
          value: model.id,
          child: Text(model.name),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedModel = value;
          });
        }
      },
    );
  }

  Widget _buildOutputFormatSelector() {
    final formats = ['json', 'text', 'table'];

    return DropdownButtonFormField<String>(
      value: _outputFormat,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: formats.map((format) {
        return DropdownMenuItem<String>(
          value: format,
          child: Text(_capitalizeFirst(format)),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _outputFormat = value;
          });
        }
      },
    );
  }

  Widget _buildPromptField() {
    return TextField(
      controller: _promptController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Enter your analysis prompt...',
        helperText: 'Use {data} to reference the input data',
      ),
      maxLines: 4,
      onChanged: (_) => _updateNode(),
    );
  }

  Widget _buildTemperatureField() {
    return TextField(
      controller: _temperatureController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: '0.7',
        helperText: 'Controls randomness (0.0 = deterministic, 1.0 = creative)',
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      onChanged: (_) => _updateNode(),
    );
  }

  Widget _buildMaxTokensField() {
    return TextField(
      controller: _maxTokensController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: '1000',
        helperText: 'Maximum number of tokens in the response',
      ),
      keyboardType: TextInputType.number,
      onChanged: (_) => _updateNode(),
    );
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}

// LLM Model class (should be moved to models)
class LLMModel {
  final String id;
  final String name;
  final String provider;
  final int maxTokens;
  final bool supportsStreaming;
  final double costPer1kTokens;

  LLMModel({
    required this.id,
    required this.name,
    required this.provider,
    required this.maxTokens,
    required this.supportsStreaming,
    required this.costPer1kTokens,
  });
}

// Provider for LLM models
final llmModelProvider = FutureProvider<List<LLMModel>>((ref) async {
  // This should fetch from the backend
  return [
    LLMModel(
      id: 'gpt-4',
      name: 'GPT-4',
      provider: 'openai',
      maxTokens: 8192,
      supportsStreaming: true,
      costPer1kTokens: 0.03,
    ),
    LLMModel(
      id: 'gpt-3.5-turbo',
      name: 'GPT-3.5 Turbo',
      provider: 'openai',
      maxTokens: 4096,
      supportsStreaming: true,
      costPer1kTokens: 0.0015,
    ),
    LLMModel(
      id: 'claude-3-opus',
      name: 'Claude 3 Opus',
      provider: 'anthropic',
      maxTokens: 100000,
      supportsStreaming: true,
      costPer1kTokens: 0.015,
    ),
    LLMModel(
      id: 'claude-3-sonnet',
      name: 'Claude 3 Sonnet',
      provider: 'anthropic',
      maxTokens: 100000,
      supportsStreaming: true,
      costPer1kTokens: 0.003,
    ),
    LLMModel(
      id: 'llama2-70b',
      name: 'Llama 2 70B',
      provider: 'ollama',
      maxTokens: 4096,
      supportsStreaming: false,
      costPer1kTokens: 0.0,
    ),
  ];
});