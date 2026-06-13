import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/modules/forms/widgets/property_builder_utils.dart';

class FormDataExportSettings extends StatefulWidget {
  final Map<String, dynamic> form;
  final ValueChanged<Map<String, dynamic>> onChanged;

  const FormDataExportSettings({
    super.key,
    required this.form,
    required this.onChanged,
  });

  @override
  State<FormDataExportSettings> createState() => _FormDataExportSettingsState();
}

class _FormDataExportSettingsState extends State<FormDataExportSettings> {
  TextEditingController? _delimiterController;
  TextEditingController? _emptyFieldController;
  TextEditingController? _dateFormatController;
  TextEditingController? _timezoneController;
  TextEditingController? _encodingController;
  TextEditingController? _retentionController;
  final Map<String, TextEditingController> _mappingControllers = {};
  final Map<String, bool> _anonymizeFlags = {};
  String _headerMode = 'labels';
  String _anonymizationMode = 'none';
  bool _seededDefaults = false;
  bool _includeAttachments = false;

  TextEditingController get _delimiterControllerValue => _delimiterController!;
  TextEditingController get _emptyFieldControllerValue =>
      _emptyFieldController!;
  TextEditingController get _dateFormatControllerValue =>
      _dateFormatController!;
  TextEditingController get _timezoneControllerValue => _timezoneController!;
  TextEditingController get _encodingControllerValue => _encodingController!;
  TextEditingController get _retentionControllerValue => _retentionController!;

  Map<String, dynamic> get _dataExportSettings => Map<String, dynamic>.from(
    widget.form['dataExportSettings'] ??
        widget.form['data_export_settings'] ??
        _legacyAdvancedSettings['dataExport'] ??
        _legacyAdvancedSettings['data_export'] ??
        const {},
  );

  Map<String, dynamic> get _legacyAdvancedSettings => Map<String, dynamic>.from(
    widget.form['advancedSettings'] ??
        widget.form['advanced_settings'] ??
        const {},
  );

  Map<String, dynamic> get _csvSettings => Map<String, dynamic>.from(
    _dataExportSettings['csv_defaults'] ??
        _dataExportSettings['csvDefaults'] ??
        _dataExportSettings['csv'] ??
        _dataExportSettings['csvSettings'] ??
        const {},
  );

  Map<String, dynamic> get _anonymization => Map<String, dynamic>.from(
    _dataExportSettings['anonymization'] ??
        _dataExportSettings['anonymisation'] ??
        const {},
  );

  Map<String, String> get _fieldMappings => _normalizeFieldMapping(
    _dataExportSettings['field_mapping'] ??
        _dataExportSettings['fieldMapping'] ??
        const {},
  );

  List<_ExportField> get _fields =>
      _flattenFields(widget.form['sections'] as List? ?? const []);

  @override
  void initState() {
    super.initState();
    _seedFromSettings();
  }

  @override
  void didUpdateWidget(covariant FormDataExportSettings oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!mapEquals(oldWidget.form, widget.form)) {
      _seedFromSettings();
    }
  }

  void _seedFromSettings() {
    final csvSettings = _csvSettings;
    _headerMode =
        csvSettings['header_mode']?.toString() ??
        csvSettings['headerMode']?.toString() ??
        'labels';
    _anonymizationMode =
        _anonymization['mode']?.toString() ??
        _anonymization['type']?.toString() ??
        'none';
    _includeAttachments =
        csvSettings['include_attachments'] as bool? ??
        csvSettings['includeAttachments'] as bool? ??
        false;

    _delimiterController = _seedController(
      _delimiterController,
      csvSettings['delimiter']?.toString() ?? ',',
    );
    _emptyFieldController = _seedController(
      _emptyFieldController,
      csvSettings['empty_field_value']?.toString() ??
          csvSettings['emptyFieldValue']?.toString() ??
          '',
    );
    _dateFormatController = _seedController(
      _dateFormatController,
      csvSettings['date_format']?.toString() ??
          csvSettings['dateFormat']?.toString() ??
          'iso8601',
    );
    _timezoneController = _seedController(
      _timezoneController,
      csvSettings['timezone']?.toString() ?? 'UTC',
    );
    _encodingController = _seedController(
      _encodingController,
      csvSettings['encoding']?.toString() ?? 'utf-8',
    );
    _retentionController = _seedController(
      _retentionController,
      (_dataExportSettings['retention_days'] ??
              _dataExportSettings['retentionDays'] ??
              '')
          .toString(),
    );

    _syncMappingControllers(_fields);
    _scheduleDefaultSeed();
  }

  TextEditingController _seedController(
    TextEditingController? controller,
    String value,
  ) {
    final next = controller ?? TextEditingController(text: value);
    if (next.text != value) {
      next.value = next.value.copyWith(
        text: value,
        selection: TextSelection.collapsed(offset: value.length),
      );
    }
    return next;
  }

  void _syncMappingControllers(List<_ExportField> fields) {
    final knownIds = fields.map((field) => field.id).toSet();
    final mapping = _fieldMappings;
    final anonymized = _anonymizedFields;

    for (final field in fields) {
      final nextText = mapping[field.id] ?? field.defaultExportLabel;
      final controller = _mappingControllers.putIfAbsent(
        field.id,
        () => TextEditingController(text: nextText),
      );
      if (controller.text != nextText) {
        controller.value = controller.value.copyWith(
          text: nextText,
          selection: TextSelection.collapsed(offset: nextText.length),
        );
      }
      _anonymizeFlags[field.id] =
          anonymized.contains(field.id) || _looksSensitive(field);
    }

    final staleIds = _mappingControllers.keys
        .where((id) => !knownIds.contains(id))
        .toList();
    for (final id in staleIds) {
      _mappingControllers.remove(id)?.dispose();
      _anonymizeFlags.remove(id);
    }
  }

  Set<String> get _anonymizedFields {
    final raw = _anonymization['fields'];
    if (raw is! List) return <String>{};
    return raw.map((e) => e.toString()).where((e) => e.isNotEmpty).toSet();
  }

  @override
  void dispose() {
    _delimiterController?.dispose();
    _emptyFieldController?.dispose();
    _dateFormatController?.dispose();
    _timezoneController?.dispose();
    _encodingController?.dispose();
    _retentionController?.dispose();
    for (final controller in _mappingControllers.values) {
      controller.dispose();
    }
    _mappingControllers.clear();
    _anonymizeFlags.clear();
    super.dispose();
  }

  Map<String, String> _normalizeFieldMapping(dynamic raw) {
    if (raw is Map) {
      final result = <String, String>{};
      raw.forEach((key, value) {
        final fieldKey = key.toString().trim();
        if (fieldKey.isEmpty) return;
        if (value is Map) {
          final mapValue = Map<String, dynamic>.from(value);
          final label =
              mapValue['label']?.toString() ??
              mapValue['alias']?.toString() ??
              mapValue['header_label']?.toString() ??
              mapValue['exportLabel']?.toString() ??
              mapValue['export_label']?.toString();
          if (label != null && label.trim().isNotEmpty) {
            result[fieldKey] = label.trim();
          }
          return;
        }
        final label = value.toString().trim();
        if (label.isNotEmpty) {
          result[fieldKey] = label;
        }
      });
      return result;
    }

    if (raw is List) {
      final result = <String, String>{};
      for (final item in raw) {
        if (item is! Map) continue;
        final mapping = Map<String, dynamic>.from(item);
        final fieldKey =
            mapping['fieldId']?.toString() ?? mapping['field_id']?.toString();
        final label =
            mapping['exportLabel']?.toString() ??
            mapping['export_label']?.toString() ??
            mapping['label']?.toString() ??
            mapping['alias']?.toString() ??
            mapping['header_label']?.toString();
        if (fieldKey == null ||
            fieldKey.trim().isEmpty ||
            label == null ||
            label.trim().isEmpty) {
          continue;
        }
        result[fieldKey.trim()] = label.trim();
      }
      return result;
    }

    return const <String, String>{};
  }

  List<_ExportField> _flattenFields(List<dynamic> sections) {
    final fields = <_ExportField>[];

    void walkSections(List<dynamic> nodes) {
      for (final node in nodes) {
        if (node is! Map) continue;
        final section = Map<String, dynamic>.from(node);
        final questions = section['questions'] as List? ?? const [];
        for (final rawQuestion in questions) {
          if (rawQuestion is! Map) continue;
          final question = Map<String, dynamic>.from(rawQuestion);
          final fieldId = question['id']?.toString() ?? '';
          if (fieldId.isEmpty) continue;
          fields.add(
            _ExportField(
              id: fieldId,
              label:
                  question['label']?.toString() ??
                  question['question_text']?.toString() ??
                  'Untitled field',
              fieldType:
                  question['fieldType']?.toString() ??
                  question['field_type']?.toString() ??
                  question['type']?.toString() ??
                  'input',
              defaultExportLabel:
                  question['variableName']?.toString() ??
                  question['variable_name']?.toString() ??
                  question['label']?.toString() ??
                  fieldId,
            ),
          );
        }

        final nestedSections = section['sections'] as List? ?? const [];
        if (nestedSections.isNotEmpty) {
          walkSections(nestedSections);
        }
      }
    }

    walkSections(sections);
    return fields;
  }

  bool _looksSensitive(_ExportField field) {
    final label = field.label.toLowerCase();
    const sensitiveTokens = [
      'name',
      'email',
      'phone',
      'mobile',
      'address',
      'ssn',
      'social',
      'user',
      'patient',
    ];
    return sensitiveTokens.any(label.contains);
  }

  Map<String, dynamic> _normalizedExportSettings() {
    final fieldMapping = <String, String>{};
    final anonymizedFields = <String>[];
    final usedLabels = <String>{};

    for (final field in _fields) {
      final controller = _mappingControllers[field.id];
      final exportLabel = controller?.text.trim().isNotEmpty == true
          ? controller!.text.trim()
          : field.defaultExportLabel;
      final uniqueLabel = _uniqueExportLabel(exportLabel, usedLabels);
      usedLabels.add(uniqueLabel);
      fieldMapping[field.id] = uniqueLabel;

      final anonymize = _anonymizeFlags[field.id] ?? _looksSensitive(field);
      if (anonymize) {
        anonymizedFields.add(field.id);
      }
    }

    return {
      'csv_defaults': {
        'delimiter': _delimiterControllerValue.text.trim().isEmpty
            ? ','
            : _delimiterControllerValue.text.trim(),
        'header_mode': _headerMode,
        'empty_field_value': _emptyFieldControllerValue.text,
        'date_format': _dateFormatControllerValue.text.trim().isEmpty
            ? 'iso8601'
            : _dateFormatControllerValue.text.trim(),
        'timezone': _timezoneControllerValue.text.trim().isEmpty
            ? 'UTC'
            : _timezoneControllerValue.text.trim(),
        'encoding': _encodingControllerValue.text.trim().isEmpty
            ? 'utf-8'
            : _encodingControllerValue.text.trim(),
        'include_attachments': _includeAttachments,
      },
      'retention_days': int.tryParse(_retentionControllerValue.text.trim()),
      'field_mapping': fieldMapping,
      'anonymization': {'mode': _anonymizationMode, 'fields': anonymizedFields},
    };
  }

  String _uniqueExportLabel(String desired, Set<String> usedLabels) {
    final base = desired.trim().isEmpty ? 'field' : desired.trim();
    var next = base;
    var suffix = 2;
    while (usedLabels.contains(next)) {
      next = '$base ($suffix)';
      suffix += 1;
    }
    return next;
  }

  void _emitCurrent() {
    final exportSettings = _normalizedExportSettings();
    widget.onChanged({
      ...widget.form,
      'dataExportSettings': exportSettings,
      'data_export_settings': exportSettings,
      'advancedSettings': {
        ..._legacyAdvancedSettings,
        'dataExport': exportSettings,
        'data_export': exportSettings,
      },
      'advanced_settings': {
        ..._legacyAdvancedSettings,
        'dataExport': exportSettings,
        'data_export': exportSettings,
      },
    });
  }

  void _scheduleDefaultSeed() {
    if (_seededDefaults) return;
    _seededDefaults = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final normalized = _normalizedExportSettings();
      if (!mapEquals(normalized, _dataExportSettings)) {
        _emitCurrent();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final fields = _fields;
    final anonymizationMode = _anonymizationMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Data / Export', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          'Set CSV defaults, retention, field mapping, and anonymization before responses leave the builder.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 16),
        const Text(
          'Export format',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        PropertyBuilderUtils.buildDropdown<String>(
          label: 'Header mode',
          value: _headerMode,
          items: const [
            DropdownMenuItem(value: 'labels', child: Text('Field labels')),
            DropdownMenuItem(value: 'keys', child: Text('Field keys')),
          ],
          onChanged: (value) {
            if (value == null) return;
            setState(() => _headerMode = value);
            _emitCurrent();
          },
        ),
        const SizedBox(height: 12),
        _buildLabeledField(
          key: const Key('data-export-delimiter'),
          label: 'CSV delimiter',
          controller: _delimiterControllerValue,
          onChanged: (_) => _emitCurrent(),
        ),
        const SizedBox(height: 12),
        _buildLabeledField(
          key: const Key('data-export-empty-field'),
          label: 'Empty field value',
          controller: _emptyFieldControllerValue,
          onChanged: (_) => _emitCurrent(),
        ),
        const SizedBox(height: 12),
        _buildLabeledField(
          key: const Key('data-export-date-format'),
          label: 'Date format',
          controller: _dateFormatControllerValue,
          onChanged: (_) => _emitCurrent(),
        ),
        const SizedBox(height: 12),
        _buildLabeledField(
          key: const Key('data-export-timezone'),
          label: 'Timezone',
          controller: _timezoneControllerValue,
          onChanged: (_) => _emitCurrent(),
        ),
        const SizedBox(height: 12),
        _buildLabeledField(
          key: const Key('data-export-encoding'),
          label: 'Encoding',
          controller: _encodingControllerValue,
          onChanged: (_) => _emitCurrent(),
        ),
        const SizedBox(height: 12),
        PropertyBuilderUtils.buildSwitch(
          label: 'Include attachments',
          value: _includeAttachments,
          onChanged: (value) {
            setState(() => _includeAttachments = value);
            _emitCurrent();
          },
        ),
        const SizedBox(height: 16),
        const Text(
          'Retention policy',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        _buildLabeledField(
          key: const Key('data-export-retention-days'),
          label: 'Retention period (days)',
          controller: _retentionControllerValue,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (_) => _emitCurrent(),
        ),
        const SizedBox(height: 16),
        const Text(
          'Field mapping',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Text(
          'Rename the CSV columns and choose which fields should be anonymized in exports.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 12),
        if (fields.isEmpty)
          const Text('Add at least one question to configure field mapping.')
        else
          Column(
            children: [
              for (final field in fields) ...[
                _FieldMappingRow(
                  field: field,
                  controller: _mappingControllers[field.id]!,
                  initialAnonymize:
                      _anonymizeFlags[field.id] ?? _looksSensitive(field),
                  onChanged: (exportLabel, anonymize) {
                    _mappingControllers[field.id]?.text = exportLabel;
                    setState(() => _anonymizeFlags[field.id] = anonymize);
                    _emitCurrent();
                  },
                ),
                const SizedBox(height: 12),
              ],
            ],
          ),
        const SizedBox(height: 16),
        const Text(
          'Privacy / anonymization',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        PropertyBuilderUtils.buildDropdown<String>(
          label: 'Anonymization mode',
          value: anonymizationMode,
          items: const [
            DropdownMenuItem(value: 'none', child: Text('None')),
            DropdownMenuItem(value: 'redact', child: Text('Redact')),
            DropdownMenuItem(value: 'mask', child: Text('Mask')),
            DropdownMenuItem(value: 'hash', child: Text('Hash')),
            DropdownMenuItem(value: 'remove', child: Text('Remove')),
          ],
          onChanged: (value) {
            if (value == null) return;
            setState(() => _anonymizationMode = value);
            _emitCurrent();
          },
        ),
        const SizedBox(height: 8),
        Text(
          'Fields marked in the mapping list are included in the anonymization field set.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildLabeledField({
    required Key key,
    required String label,
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          key: key,
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          decoration: const InputDecoration(border: OutlineInputBorder()),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _FieldMappingRow extends StatefulWidget {
  final _ExportField field;
  final TextEditingController controller;
  final bool initialAnonymize;
  final void Function(String exportLabel, bool anonymize) onChanged;

  const _FieldMappingRow({
    required this.field,
    required this.controller,
    required this.initialAnonymize,
    required this.onChanged,
  });

  @override
  State<_FieldMappingRow> createState() => _FieldMappingRowState();
}

class _FieldMappingRowState extends State<_FieldMappingRow> {
  late bool _anonymize;

  @override
  void initState() {
    super.initState();
    _anonymize = widget.initialAnonymize;
  }

  @override
  void didUpdateWidget(covariant _FieldMappingRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialAnonymize != widget.initialAnonymize) {
      _anonymize = widget.initialAnonymize;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.field.label,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            widget.field.fieldType,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          TextFormField(
            key: Key('data-export-field-${widget.field.id}'),
            controller: widget.controller,
            decoration: const InputDecoration(
              labelText: 'CSV column header',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              widget.onChanged(value, _anonymize);
            },
          ),
          const SizedBox(height: 8),
          PropertyBuilderUtils.buildSwitch(
            label: 'Anonymize this field',
            value: _anonymize,
            onChanged: (value) {
              setState(() => _anonymize = value);
              widget.onChanged(widget.controller.text, value);
            },
          ),
        ],
      ),
    );
  }
}

class _ExportField {
  final String id;
  final String label;
  final String fieldType;
  final String defaultExportLabel;

  const _ExportField({
    required this.id,
    required this.label,
    required this.fieldType,
    required this.defaultExportLabel,
  });
}
