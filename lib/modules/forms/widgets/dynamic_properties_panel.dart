import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/app/theme/app_colors.dart';
import 'package:frontend/app/theme/tokens.dart';
import 'package:frontend/shared/models/form_models.dart';
import 'package:frontend/core/widgets/app_shimmer.dart';
import 'package:frontend/modules/forms/services/form_builder_repository.dart';
import 'property_builder_utils.dart';

/// Dynamic, schema-driven properties panel rendering inputs on the fly
/// based on backend `/builder-metadata` API schema.
class DynamicPropertiesPanel extends ConsumerStatefulWidget {
  final Question question;
  final Function(Question) onQuestionChanged;

  const DynamicPropertiesPanel({
    super.key,
    required this.question,
    required this.onQuestionChanged,
  });

  @override
  ConsumerState<DynamicPropertiesPanel> createState() => _DynamicPropertiesPanelState();
}

class _DynamicPropertiesPanelState extends ConsumerState<DynamicPropertiesPanel> {
  Future<Map<String, dynamic>>? _metadataFuture;

  @override
  void initState() {
    super.initState();
    _metadataFuture = ref.read(formBuilderRepositoryProvider).getBuilderMetadata();
  }

  void _updateQuestionValue(String target, String key, dynamic value) {
    Question updatedQuestion = widget.question;

    if (target == 'validation') {
      final newValidation = Map<String, dynamic>.from(widget.question.validation);
      if (value == null || value.toString().isEmpty) {
        newValidation.remove(key);
      } else {
        newValidation[key] = value;
      }
      updatedQuestion = widget.question.copyWith(validation: newValidation);
    } else if (target == 'ui') {
      final newUi = Map<String, dynamic>.from(widget.question.ui);
      if (value == null || value.toString().isEmpty) {
        newUi.remove(key);
      } else {
        newUi[key] = value;
      }
      updatedQuestion = widget.question.copyWith(ui: newUi);
    } else if (target == 'logic') {
      final newLogic = Map<String, dynamic>.from(widget.question.logic ?? {});
      if (value == null || value.toString().isEmpty) {
        newLogic.remove(key);
      } else {
        newLogic[key] = value;
      }
      updatedQuestion = widget.question.copyWith(logic: newLogic);
    }

    widget.onQuestionChanged(updatedQuestion);
  }

  Widget _buildRegexPresetField(String key) {
    final current = widget.question.validation[key]?.toString() ?? '';
    final controller = TextEditingController(text: current);
    final presets = <String, String>{
      'Email': r'^[\w\.-]+@[\w\.-]+\.\w+$',
      'URL': r'^(https?:\/\/)?([\w\-]+\.)+[\w\-]{2,}(\/\S*)?$',
      'Integer': r'^-?\d+$',
      'Decimal': r'^-?\d+(\.\d+)?$',
      'Alphanumeric': r'^[a-zA-Z0-9]+$',
      'Phone': r'^\+?[0-9\s\-\(\)]{7,}$',
    };

    return Column(
      children: [
        PropertyBuilderUtils.buildDropdown<String>(
          label: 'Regex preset',
          value: presets.values.contains(current)
              ? presets.entries.firstWhere((e) => e.value == current).key
              : 'Custom',
          items: [
            ...presets.keys
                .map((preset) => DropdownMenuItem(value: preset, child: Text(preset))),
            const DropdownMenuItem(value: 'Custom', child: Text('Custom')),
          ],
          onChanged: (val) {
            if (val == null || val == 'Custom') return;
            final preset = presets[val]!;
            controller.text = preset;
            _updateQuestionValue('validation', key, preset);
            setState(() {});
          },
        ),
        const SizedBox(height: DesignTokens.spaceM),
        PropertyBuilderUtils.buildTextField(
          label: key.replaceAll('_', ' ').toUpperCase(),
          placeholder: 'Enter regex pattern',
          controller: controller,
          onChanged: (val) => _updateQuestionValue('validation', key, val),
          keyboardType: TextInputType.text,
        ),
      ],
    );
  }

  Widget _buildDateField(String key) {
    final current = widget.question.validation[key]?.toString() ?? '';
    final controller = TextEditingController(text: current);
    return Column(
      children: [
        PropertyBuilderUtils.buildTextField(
          label: key.replaceAll('_', ' ').toUpperCase(),
          placeholder: 'YYYY-MM-DD',
          controller: controller,
          readOnly: true,
          onChanged: (val) {},
        ),
        const SizedBox(height: DesignTokens.spaceS),
        Align(
          alignment: Alignment.centerLeft,
          child: OutlinedButton.icon(
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.tryParse(current) ?? DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
              );
              if (picked == null) return;
              final next = picked.toIso8601String().split('T').first;
              controller.text = next;
              _updateQuestionValue('validation', key, next);
              setState(() {});
            },
            icon: const Icon(Icons.calendar_month, size: 18),
            label: const Text('Pick date'),
          ),
        ),
      ],
    );
  }

  Widget _buildNumericSlider(String key) {
    final current = widget.question.validation[key];
    final value = current is num ? current.toDouble() : double.tryParse(current?.toString() ?? '') ?? 0;
    final min = key.contains('max') ? 0.0 : 0.0;
    final max = key.contains('size') ? 1000000.0 : 100.0;
    final label = key.replaceAll('_', ' ').toUpperCase();
    return PropertyBuilderUtils.buildNumberSlider(
      label: label,
      value: value.clamp(min, max),
      min: min,
      max: max,
      onChanged: (val) => _updateQuestionValue('validation', key, val.round()),
    );
  }

  Widget _buildFileExtensionsField(String key) {
    final current = widget.question.validation[key];
    final chips = current is List
        ? current.map((e) => e.toString()).toList()
        : current is String && current.isNotEmpty
            ? current.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList()
            : <String>[];
    const options = ['pdf', 'png', 'jpg', 'jpeg', 'docx', 'doc', 'xlsx', 'csv'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          key.replaceAll('_', ' ').toUpperCase(),
          style: const TextStyle(
            color: AppColors.textDark,
            fontSize: DesignTokens.fontS,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: DesignTokens.spaceS),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options
              .map(
                (ext) => FilterChip(
                  label: Text(ext.toUpperCase()),
                  selected: chips.contains(ext),
                  onSelected: (selected) {
                    final next = List<String>.from(chips);
                    if (selected) {
                      if (!next.contains(ext)) next.add(ext);
                    } else {
                      next.remove(ext);
                    }
                    _updateQuestionValue('validation', key, next);
                    setState(() {});
                  },
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _metadataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.all(DesignTokens.spaceL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppShimmer(width: 150, height: 20),
                const SizedBox(height: DesignTokens.spaceM - 1),
                AppShimmer(width: double.infinity, height: 48),
                const SizedBox(height: DesignTokens.spaceL + 1),
                AppShimmer(width: 100, height: 20),
                const SizedBox(height: DesignTokens.spaceM - 1),
                AppShimmer(width: double.infinity, height: 48),
              ],
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(DesignTokens.spaceL),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.cloud_off, size: 48, color: AppColors.textGrey),
                  const SizedBox(height: DesignTokens.spaceM),
                  const Text(
                    'Failed to load properties schema',
                    style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark),
                  ),
                  const SizedBox(height: DesignTokens.spaceS),
                  const Text(
                    'Ensure backend service is running and retry.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textGrey,
                      fontSize: DesignTokens.fontS,
                    ),
                  ),
                  const SizedBox(height: DesignTokens.spaceM),
                  ElevatedButton(
                    onPressed: () {
                    setState(() {
                        _metadataFuture = ref.read(formBuilderRepositoryProvider).getBuilderMetadata();
                      });
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.brandBlue),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        final schema = snapshot.data!;
        final validationSchema = schema['validation'] as Map<String, dynamic>? ?? {};

        // Find relevant validation keys for current field type group
        final List<String> fieldValidationKeys = [];
        final fieldType = widget.question.fieldType;

        if (fieldType == 'input' || fieldType == 'textarea') {
          fieldValidationKeys.addAll(List<String>.from(validationSchema['text'] ?? []));
        } else if (fieldType == 'number') {
          fieldValidationKeys.addAll(List<String>.from(validationSchema['number'] ?? []));
        } else if (fieldType == 'date') {
          fieldValidationKeys.addAll(List<String>.from(validationSchema['date'] ?? []));
        } else if (fieldType == 'file') {
          fieldValidationKeys.addAll(List<String>.from(validationSchema['file'] ?? []));
        } else if (fieldType == 'dropdown' || fieldType == 'checkboxes' || fieldType == 'multipleChoice') {
          fieldValidationKeys.addAll(List<String>.from(validationSchema['selection'] ?? []));
        }

        return Padding(
          padding: const EdgeInsets.all(DesignTokens.spaceL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PropertyBuilderUtils.buildSectionHeader(title: 'VALIDATION SETTINGS'),
              const SizedBox(height: DesignTokens.spaceM),
              ...fieldValidationKeys.map((key) {
                final label = key.replaceAll('_', ' ').toUpperCase();
                
                // Handle booleans (e.g. is_required)
                if (key == 'is_required' || key.startsWith('disable_')) {
                  final bool currentValue = widget.question.validation[key] == true;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: DesignTokens.spaceM),
                    child: PropertyBuilderUtils.buildSwitch(
                      label: label,
                      value: currentValue,
                      onChanged: (val) => _updateQuestionValue('validation', key, val),
                    ),
                  );
                }

                if (key.contains('regex') || key.contains('pattern')) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: DesignTokens.spaceM),
                    child: _buildRegexPresetField(key),
                  );
                }

                if (key.contains('date')) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: DesignTokens.spaceM),
                    child: _buildDateField(key),
                  );
                }

                // Handle numbers (e.g. min_length, max_length, repeat_min, repeat_max)
                if (key.contains('length') || key.contains('count') || key.contains('value') || key.contains('files') || key.contains('size') || key.contains('min') || key.contains('max') || key.contains('repeat_')) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: DesignTokens.spaceM),
                    child: _buildNumericSlider(key),
                  );
                }

                if (key.contains('extension') || key.contains('file_type') || key.contains('allowed')) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: DesignTokens.spaceM),
                    child: _buildFileExtensionsField(key),
                  );
                }

                final isNumeric = key.contains('length') || key.contains('count') || key.contains('value') || key.contains('files') || key.contains('size');
                final currentValue = widget.question.validation[key]?.toString() ?? '';
                final controller = TextEditingController(text: currentValue);

                return Padding(
                  padding: const EdgeInsets.only(bottom: DesignTokens.spaceM),
                  child: PropertyBuilderUtils.buildTextField(
                    label: label,
                    placeholder: 'Enter ${label.toLowerCase()}',
                    controller: controller,
                    keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
                    onChanged: (val) {
                      final dynamic value = isNumeric ? int.tryParse(val) : val;
                      _updateQuestionValue('validation', key, value);
                    },
                  ),
                );
              }),
              const SizedBox(height: DesignTokens.spaceM),
              PropertyBuilderUtils.buildSectionHeader(title: 'AESTHETIC CUSTOMIZATION'),
              const SizedBox(height: DesignTokens.spaceM),
              PropertyBuilderUtils.buildSwitch(
                label: 'SENSITIVE DATA (FLE/PII)',
                value: widget.question.isReadOnly,
                onChanged: (val) => _updateQuestionValue('ui', 'sensitive', val),
              ),
            ],
          ),
        );
      },
    );
  }
}
