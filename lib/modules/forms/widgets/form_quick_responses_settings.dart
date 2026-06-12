import 'dart:convert';

import 'package:flutter/material.dart';

class FormQuickResponsesSettings extends StatefulWidget {
  final Map<String, dynamic> form;
  final ValueChanged<Map<String, dynamic>> onChanged;

  const FormQuickResponsesSettings({
    super.key,
    required this.form,
    required this.onChanged,
  });

  @override
  State<FormQuickResponsesSettings> createState() =>
      _FormQuickResponsesSettingsState();
}

class _FormQuickResponsesSettingsState
    extends State<FormQuickResponsesSettings> {
  List<Map<String, dynamic>> get _responses {
    final raw = widget.form['quickResponses'] ?? widget.form['quick_responses'];
    if (raw is! List) return const [];
    return raw.whereType<Map>().map((item) => Map<String, dynamic>.from(item)).toList();
  }

  void _emit(List<Map<String, dynamic>> responses) {
    widget.onChanged({
      ...widget.form,
      'quickResponses': responses,
      'quick_responses': responses,
    });
  }

  String _summary(Map<String, dynamic> response) {
    final name = response['name']?.toString().trim() ?? '';
    final description = response['description']?.toString().trim() ?? '';
    final values = response['field_values'] ?? response['fieldValues'] ?? const {};
    final tagCount = (response['tags'] as List? ?? const []).length;

    if (name.isEmpty) {
      return 'Untitled quick response';
    }

    final details = <String>[];
    if (description.isNotEmpty) details.add(description);
    if (values is Map && values.isNotEmpty) {
      details.add('${values.length} mapped field${values.length == 1 ? '' : 's'}');
    }
    if (tagCount > 0) details.add('$tagCount tag${tagCount == 1 ? '' : 's'}');
    return details.isEmpty ? name : '$name • ${details.join(' • ')}';
  }

  Future<Map<String, dynamic>?> _showEditorDialog({
    Map<String, dynamic>? initial,
  }) async {
    final response = Map<String, dynamic>.from(initial ?? const {});
    final nameController = TextEditingController(
      text: response['name']?.toString() ?? '',
    );
    final descriptionController = TextEditingController(
      text: response['description']?.toString() ?? '',
    );
    final tagsController = TextEditingController(
      text: (response['tags'] as List? ?? const []).join(', '),
    );
    final ownerController = TextEditingController(
      text: response['owner_id']?.toString() ??
          response['ownerId']?.toString() ??
          '',
    );
    final fieldValuesController = TextEditingController(
      text: const JsonEncoder.withIndent('  ').convert(
        response['field_values'] ?? response['fieldValues'] ?? const {},
      ),
    );
    String visibility = response['visibility']?.toString() ?? 'personal';
    bool isArchived = response['is_archived'] as bool? ??
        response['isArchived'] as bool? ??
        false;
    String? errorText;

    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                initial == null ? 'Add quick response' : 'Edit quick response',
              ),
              content: SizedBox(
                width: 560,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          hintText: 'Follow-up intake',
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                        ),
                        minLines: 2,
                        maxLines: 4,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: tagsController,
                        decoration: const InputDecoration(
                          labelText: 'Tags',
                          hintText: 'patient, follow-up, intake',
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: visibility,
                        decoration: const InputDecoration(labelText: 'Visibility'),
                        items: const [
                          DropdownMenuItem(
                            value: 'personal',
                            child: Text('Personal'),
                          ),
                          DropdownMenuItem(
                            value: 'project',
                            child: Text('Project'),
                          ),
                          DropdownMenuItem(
                            value: 'org',
                            child: Text('Organization'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() => visibility = value);
                        },
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: ownerController,
                        decoration: const InputDecoration(
                          labelText: 'Owner ID',
                          hintText: 'Optional',
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: fieldValuesController,
                        decoration: InputDecoration(
                          labelText: 'Field values (JSON)',
                          helperText:
                              'Example: {"patient_id":"12345","email":"ada@example.com"}',
                          errorText: errorText,
                        ),
                        minLines: 6,
                        maxLines: 10,
                        style: const TextStyle(fontFamily: 'monospace'),
                      ),
                      const SizedBox(height: 12),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Archived'),
                        value: isArchived,
                        onChanged: (value) => setState(() => isArchived = value),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    if (name.isEmpty) {
                      setState(() => errorText = 'Name is required.');
                      return;
                    }

                    Map<String, dynamic> fieldValues;
                    try {
                      final decoded = jsonDecode(fieldValuesController.text.trim());
                      if (decoded is! Map) {
                        throw const FormatException(
                          'Field values must be a JSON object.',
                        );
                      }
                      fieldValues = Map<String, dynamic>.from(decoded);
                    } catch (_) {
                      setState(
                        () => errorText =
                            'Field values must be valid JSON object syntax.',
                      );
                      return;
                    }

                    final tags = tagsController.text
                        .split(',')
                        .map((tag) => tag.trim())
                        .where((tag) => tag.isNotEmpty)
                        .toSet()
                        .toList();

                    Navigator.of(dialogContext).pop({
                      'name': name,
                      'description': descriptionController.text.trim().isEmpty
                          ? null
                          : descriptionController.text.trim(),
                      'tags': tags,
                      'visibility': visibility,
                      'owner_id': ownerController.text.trim().isEmpty
                          ? null
                          : ownerController.text.trim(),
                      'field_values': fieldValues,
                      'is_archived': isArchived,
                    });
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final responses = _responses;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Responses', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          'Quick responses appear on the submit page and can be applied to draft answers.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            FilledButton.icon(
              onPressed: () async {
                final created = await _showEditorDialog();
                if (created == null) return;
                _emit([...responses, created]);
              },
              icon: const Icon(Icons.add),
              label: const Text('Add quick response'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (responses.isEmpty)
          const Text('No quick responses have been added yet.')
        else
          ...responses.asMap().entries.map((entry) {
            final index = entry.key;
            final response = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                child: ListTile(
                  title: Text(response['name']?.toString() ?? 'Untitled quick response'),
                  subtitle: Text(_summary(response)),
                  isThreeLine: false,
                  trailing: Wrap(
                    spacing: 4,
                    children: [
                      IconButton(
                        tooltip: 'Edit',
                        onPressed: () async {
                          final updated = await _showEditorDialog(
                            initial: response,
                          );
                          if (updated == null) return;
                          final next = List<Map<String, dynamic>>.from(responses);
                          next[index] = updated;
                          _emit(next);
                        },
                        icon: const Icon(Icons.edit_outlined),
                      ),
                      IconButton(
                        tooltip: 'Delete',
                        onPressed: () {
                          final next = List<Map<String, dynamic>>.from(responses)
                            ..removeAt(index);
                          _emit(next);
                        },
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
      ],
    );
  }
}
