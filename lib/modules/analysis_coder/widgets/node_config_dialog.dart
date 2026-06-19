"""
lib/modules/analysis_coder/widgets/node_config_dialog.dart
Dialog for configuring node properties.
"""

import 'package:flutter/material.dart';

import '../models/analysis_models.dart';
import '../theme/analysis_theme.dart';

class NodeConfigDialog extends StatefulWidget {
  final AnalysisNode node;
  final Function(AnalysisNode) onConfigChanged;

  const NodeConfigDialog({
    super.key,
    required this.node,
    required this.onConfigChanged,
  });

  @override
  State<NodeConfigDialog> createState() => _NodeConfigDialogState();
}

class _NodeConfigDialogState extends State<NodeConfigDialog> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late Map<String, dynamic> _config;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.node.name);
    _descriptionController = TextEditingController(text: widget.node.description);
    _config = Map<String, dynamic>.from(widget.node.config);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSave() {
    final updatedNode = widget.node.copyWith(
      name: _nameController.text,
      description: _descriptionController.text,
      config: _config,
    );
    widget.onConfigChanged(updatedNode);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AnalysisTheme.of(context);
    final nodeDefinition = _getNodeDefinition(widget.node.nodeType);

    return Dialog(
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  nodeDefinition.icon,
                  size: 24,
                  color: theme.primaryColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Configure ${nodeDefinition.name}',
                    style: theme.dialogTitleStyle,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Basic configuration
            _buildBasicConfigSection(theme),
            const SizedBox(height: 24),
            // Node-specific configuration
            if (nodeDefinition.properties.isNotEmpty)
              _buildNodeConfigSection(nodeDefinition, theme),
            const SizedBox(height: 24),
            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _handleSave,
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicConfigSection(AnalysisThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Basic Configuration',
          style: theme.sectionTitleStyle,
        ),
        const SizedBox(height: 16),
        // Name
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Description
        TextField(
          controller: _descriptionController,
          decoration: InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildNodeConfigSection(
    NodeDefinition nodeDefinition,
    AnalysisThemeData theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Node Configuration',
          style: theme.sectionTitleStyle,
        ),
        const SizedBox(height: 16),
        ...nodeDefinition.properties.map((property) {
          return _buildPropertyField(property, theme);
        }),
      ],
    );
  }

  Widget _buildPropertyField(NodeProperty property, AnalysisThemeData theme) {
    final value = _config[property.key] ?? property.default;

    switch (property.type) {
      case 'string':
        return _buildStringField(property, value);
      case 'number':
        return _buildNumberField(property, value);
      case 'boolean':
        return _buildBooleanField(property, value);
      case 'enum':
        return _buildEnumField(property, value);
      case 'color':
        return _buildColorField(property, value);
      case 'object':
        return _buildObjectField(property, value);
      case 'array':
        return _buildArrayField(property, value);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildStringField(NodeProperty property, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        decoration: InputDecoration(
          labelText: property.label,
          hintText: property.description,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        controller: TextEditingController(text: value?.toString() ?? ''),
        onChanged: (newValue) {
          _config[property.key] = newValue;
        },
      ),
    );
  }

  Widget _buildNumberField(NodeProperty property, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        decoration: InputDecoration(
          labelText: property.label,
          hintText: property.description,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        keyboardType: TextInputType.number,
        controller: TextEditingController(text: value?.toString() ?? ''),
        onChanged: (newValue) {
          _config[property.key] = double.tryParse(newValue) ?? 0;
        },
      ),
    );
  }

  Widget _buildBooleanField(NodeProperty property, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SwitchListTile(
        title: Text(property.label),
        subtitle: property.description.isNotEmpty
            ? Text(property.description)
            : null,
        value: value ?? false,
        onChanged: (newValue) {
          setState(() {
            _config[property.key] = newValue;
          });
        },
      ),
    );
  }

  Widget _buildEnumField(NodeProperty property, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: property.label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        value: value?.toString(),
        items: (property.options as List<dynamic>)
            .map<DropdownMenuItem<String>>((option) {
          return DropdownMenuItem<String>(
            value: option.toString(),
            child: Text(option.toString()),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            _config[property.key] = newValue;
          });
        },
      ),
    );
  }

  Widget _buildColorField(NodeProperty property, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                labelText: property.label,
                hintText: property.description,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              controller: TextEditingController(text: value?.toString() ?? '#000000'),
              onChanged: (newValue) {
                _config[property.key] = newValue;
              },
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _parseColor(value?.toString() ?? '#000000'),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildObjectField(NodeProperty property, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        decoration: InputDecoration(
          labelText: property.label,
          hintText: property.description,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        controller: TextEditingController(
          text: value != null ? value.toString() : '{}',
        ),
        maxLines: 5,
        onChanged: (newValue) {
          // Simple JSON parsing for object fields
          try {
            _config[property.key] = newValue.isEmpty ? {} : newValue;
          } catch (e) {
            // Keep as string if not valid JSON
            _config[property.key] = newValue;
          }
        },
      ),
    );
  }

  Widget _buildArrayField(NodeProperty property, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        decoration: InputDecoration(
          labelText: property.label,
          hintText: property.description,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
        ),
        ),
        controller: TextEditingController(
          text: value != null ? value.toString() : '[]',
        ),
        maxLines: 3,
        onChanged: (newValue) {
          // Simple parsing for array fields
          try {
            _config[property.key] = newValue.isEmpty ? [] : newValue;
          } catch (e) {
            // Keep as string if not valid array
            _config[property.key] = newValue;
          }
        },
      ),
    );
  }

  Color _parseColor(String colorString) {
    // Simple color parsing - in a real app, use a proper color parser
    if (colorString.startsWith('#')) {
      final hex = colorString.substring(1);
      if (hex.length == 6) {
        final r = int.parse(hex.substring(0, 2), radix: 16);
        final g = int.parse(hex.substring(2, 4), radix: 16);
        final b = int.parse(hex.substring(4, 6), radix: 16);
        return Color.fromRGBO(r, g, b, 1);
      }
    }
    return Colors.black;
  }

  NodeDefinition _getNodeDefinition(String nodeType) {
    // This should be replaced with a proper registry
    // For now, return a default definition
    return NodeDefinition(
      type: nodeType,
      name: nodeType,
      description: '',
      category: NodeCategory.transform,
      icon: Icons.code,
      inputPorts: const [],
      outputPorts: const [],
      defaultConfig: const {},
      properties: const [],
    );
  }
}