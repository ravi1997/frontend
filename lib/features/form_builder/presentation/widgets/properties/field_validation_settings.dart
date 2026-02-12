import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/form_builder/domain/entities/form_question.dart';
import 'package:frontend/features/form_builder/domain/entities/question_type.dart';
import 'package:frontend/features/form_builder/presentation/controllers/form_builder_controller.dart';
import 'property_builder_utils.dart';

class FieldValidationSettings extends ConsumerStatefulWidget { // Changed to ConsumerStatefulWidget
  final String formId;
  final FormQuestion question;
  final TextEditingController regexController;
  final TextEditingController minLengthController;
  final TextEditingController maxLengthController;
  final TextEditingController minValueController;
  final TextEditingController maxValueController;
  final TextEditingController inputMaskController;
  final TextEditingController customErrorController;

  const FieldValidationSettings({
    super.key,
    required this.formId,
    required this.question,
    required this.regexController,
    required this.minLengthController,
    required this.maxLengthController,
    required this.minValueController,
    required this.maxValueController,
    required this.inputMaskController,
    required this.customErrorController,
  });

  @override
  ConsumerState<FieldValidationSettings> createState() => _FieldValidationSettingsState();
}

class _FieldValidationSettingsState extends ConsumerState<FieldValidationSettings> { // Added State class
  final _formKey = GlobalKey<FormState>(); // Added GlobalKey

  @override
  Widget build(BuildContext context) {
    return Form( // Added Form widget
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'VALIDATION',
            style: TextStyle(
              color: AppColors.textGrey,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),

          // Required Toggle
          PropertyBuilderUtils.buildSwitch(
            label: 'Required Field',
            value: widget.question.isRequired, // Access via widget
            onChanged: (val) {
              ref
                  .read(formBuilderControllerProvider(widget.formId).notifier) // Access via widget
                  .updateQuestion(widget.question.copyWith(isRequired: val)); // Access via widget
            },
          ),
          const SizedBox(height: 12),

          // Min/Max Length (Text/Paragraph)
          if (widget.question.type == QuestionType.shortText || // Access via widget
              widget.question.type == QuestionType.paragraph) ...[ // Access via widget
            Row(
              children: [
                Expanded(
                  child: PropertyBuilderUtils.buildTextField(
                    label: 'Min Length',
                    controller: widget.minLengthController, // Access via widget
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) return null;
                      final n = int.tryParse(value);
                      if (n == null || n < 0) return 'Invalid number';
                      final maxLength = int.tryParse(widget.maxLengthController.text);
                      if (maxLength != null && n > maxLength) return 'Min < Max';
                      return null;
                    },
                    onChanged: (val) {
                      if (_formKey.currentState!.validate()) { // Validate before updating
                        final n = int.tryParse(val);
                        ref
                            .read(formBuilderControllerProvider(widget.formId).notifier) // Access via widget
                            .updateQuestion(widget.question.copyWith(minLength: n)); // Access via widget
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PropertyBuilderUtils.buildTextField(
                    label: 'Max Length',
                    controller: widget.maxLengthController, // Access via widget
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) return null;
                      final n = int.tryParse(value);
                      if (n == null || n < 0) return 'Invalid number';
                      final minLength = int.tryParse(widget.minLengthController.text);
                      if (minLength != null && n < minLength) return 'Max > Min';
                      return null;
                    },
                    onChanged: (val) {
                      if (_formKey.currentState!.validate()) { // Validate before updating
                        final n = int.tryParse(val);
                        ref
                            .read(formBuilderControllerProvider(widget.formId).notifier) // Access via widget
                            .updateQuestion(widget.question.copyWith(maxLength: n)); // Access via widget
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],

          // Min/Max Value (Number)
          if (widget.question.type == QuestionType.number) ...[ // Access via widget
            Row(
              children: [
                Expanded(
                  child: PropertyBuilderUtils.buildTextField(
                    label: 'Min Value',
                    controller: widget.minValueController, // Access via widget
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) return null;
                      final n = num.tryParse(value);
                      if (n == null) return 'Invalid number';
                      final maxValue = num.tryParse(widget.maxValueController.text);
                      if (maxValue != null && n > maxValue) return 'Min < Max';
                      return null;
                    },
                    onChanged: (val) {
                      if (_formKey.currentState!.validate()) { // Validate before updating
                        final n = num.tryParse(val);
                        ref
                            .read(formBuilderControllerProvider(widget.formId).notifier) // Access via widget
                            .updateQuestion(widget.question.copyWith(minValue: n)); // Access via widget
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PropertyBuilderUtils.buildTextField(
                    label: 'Max Value',
                    controller: widget.maxValueController, // Access via widget
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) return null;
                      final n = num.tryParse(value);
                      if (n == null) return 'Invalid number';
                      final minValue = num.tryParse(widget.minValueController.text);
                      if (minValue != null && n < minValue) return 'Max > Min';
                      return null;
                    },
                    onChanged: (val) {
                      if (_formKey.currentState!.validate()) { // Validate before updating
                        final n = num.tryParse(val);
                        ref
                            .read(formBuilderControllerProvider(widget.formId).notifier) // Access via widget
                            .updateQuestion(widget.question.copyWith(maxValue: n)); // Access via widget
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],

          // Regex (Text types)
          if (widget.question.type == QuestionType.shortText || // Access via widget
              widget.question.type == QuestionType.paragraph || // Access via widget
              widget.question.type == QuestionType.email || // Access via widget
              widget.question.type == QuestionType.url || // Access via widget
              widget.question.type == QuestionType.mobile) ...[ // Access via widget
            PropertyBuilderUtils.buildTextField(
              label: 'Regex Validation',
              placeholder: 'e.g. ^[0-9]*\$',
              controller: widget.regexController, // Access via widget
              validator: (value) {
                if (value == null || value.isEmpty) return null;
                try {
                  RegExp(value);
                  return null;
                } catch (e) {
                  return 'Invalid regex pattern';
                }
              },
              onChanged: (val) {
                if (_formKey.currentState!.validate()) { // Validate before updating
                  ref
                      .read(formBuilderControllerProvider(widget.formId).notifier) // Access via widget
                      .updateQuestion(widget.question.copyWith(validationRegex: val)); // Access via widget
                }
              },
            ),
            const SizedBox(height: 12),

            if (widget.question.type == QuestionType.shortText || // Access via widget
                widget.question.type == QuestionType.mobile) // Access via widget
              PropertyBuilderUtils.buildTextField(
                label: 'Input Mask',
                placeholder: 'e.g. (###) ###-####',
                controller: widget.inputMaskController, // Access via widget
                onChanged: (val) {
                  ref
                      .read(formBuilderControllerProvider(widget.formId).notifier) // Access via widget
                      .updateQuestion(widget.question.copyWith(inputMask: val)); // Access via widget
                },
              ),
            if (widget.question.type == QuestionType.shortText || // Access via widget
                widget.question.type == QuestionType.mobile) // Access via widget
              const SizedBox(height: 12),

            PropertyBuilderUtils.buildTextField(
              label: 'Custom Error Message',
              placeholder: 'Error to show when validation fails',
              controller: widget.customErrorController, // Access via widget
              onChanged: (val) {
                ref
                    .read(formBuilderControllerProvider(widget.formId).notifier) // Access via widget
                    .updateQuestion(widget.question.copyWith(customErrorMessage: val)); // Access via widget
              },
            ),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 12),

          // Read Only Toggle
          PropertyBuilderUtils.buildSwitch(
            label: 'Read Only',
            value: widget.question.isReadOnly, // Access via widget
            onChanged: (val) {
              ref
                  .read(formBuilderControllerProvider(widget.formId).notifier) // Access via widget
                  .updateQuestion(widget.question.copyWith(isReadOnly: val)); // Access via widget
            },
          ),
          const SizedBox(height: 12),

          // Hidden Toggle
          PropertyBuilderUtils.buildSwitch(
            label: 'Hidden Field',
            value: widget.question.isHidden, // Access via widget
            onChanged: (val) {
              ref
                  .read(formBuilderControllerProvider(widget.formId).notifier) // Access via widget
                  .updateQuestion(widget.question.copyWith(isHidden: val)); // Access via widget
            },
          ),
        ],
      ),
    );
  }
}
