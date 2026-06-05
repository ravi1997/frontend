import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/app/theme/app_colors.dart';
import 'package:frontend/shared/models/form_models.dart';
import 'package:frontend/core/networking/api_service.dart';
import 'package:frontend/core/widgets/app_shimmer.dart';
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
    _metadataFuture = ref.read(apiServiceProvider).getBuilderMetadata();
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _metadataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppShimmer(width: 150, height: 20),
                SizedBox(height: 15),
                AppShimmer(width: double.infinity, height: 48),
                SizedBox(height: 25),
                AppShimmer(width: 100, height: 20),
                SizedBox(height: 15),
                AppShimmer(width: double.infinity, height: 48),
              ],
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.cloud_off, size: 48, color: AppColors.textGrey),
                  const SizedBox(height: 16),
                  const Text(
                    'Failed to load properties schema',
                    style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Ensure backend service is running and retry.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textGrey, fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _metadataFuture = ref.read(apiServiceProvider).getBuilderMetadata();
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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PropertyBuilderUtils.buildSectionHeader(title: 'VALIDATION SETTINGS'),
              const SizedBox(height: 12),
              ...fieldValidationKeys.map((key) {
                final label = key.replaceAll('_', ' ').toUpperCase();
                
                // Handle booleans (e.g. is_required)
                if (key == 'is_required' || key.startsWith('disable_')) {
                  final bool currentValue = widget.question.validation[key] == true;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: PropertyBuilderUtils.buildSwitch(
                      label: label,
                      value: currentValue,
                      onChanged: (val) => _updateQuestionValue('validation', key, val),
                    ),
                  );
                }

                // Handle numbers (e.g. min_length, max_length, repeat_min, repeat_max)
                final isNumeric = key.contains('length') || key.contains('count') || key.contains('value') || key.contains('files') || key.contains('size');
                final currentValue = widget.question.validation[key]?.toString() ?? '';
                final controller = TextEditingController(text: currentValue);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
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
              const SizedBox(height: 12),
              PropertyBuilderUtils.buildSectionHeader(title: 'AESTHETIC CUSTOMIZATION'),
              const SizedBox(height: 12),
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
