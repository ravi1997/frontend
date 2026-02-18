import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/form_builder/domain/entities/form_question.dart';
import 'package:frontend/features/form_builder/domain/entities/question_type.dart';
import 'package:frontend/features/form_builder/presentation/controllers/form_builder_controller.dart';
import 'property_builder_utils.dart';

class FieldValidationSettings extends ConsumerStatefulWidget {
  // Changed to ConsumerStatefulWidget
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
  ConsumerState<FieldValidationSettings> createState() =>
      _FieldValidationSettingsState();
}

class _FieldValidationSettingsState
    extends ConsumerState<FieldValidationSettings> {
  // Added State class
  final _formKey = GlobalKey<FormState>();

  static const Map<String, String> _regexPresets = {
    'None': '',
    'Alphanumeric': r'^[a-zA-Z0-9]*$',
    'Integer': r'^-?[0-9]+$',
    'Decimal': r'^-?[0-9]+(\.[0-9]+)?$',
    'Email': r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    'URL':
        r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)',
  };

  @override
  Widget build(BuildContext context) {
    if (widget.question.type == QuestionType.divider ||
        widget.question.type == QuestionType.spacer) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            'No validation settings available for this field type.',
            style: TextStyle(color: AppColors.textGrey, fontSize: 13),
          ),
        ),
      );
    }

    return Form(
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
            value: widget.question.isRequired,
            onChanged: (val) {
              ref
                  .read(formBuilderControllerProvider(widget.formId).notifier)
                  .updateQuestion(widget.question.copyWith(isRequired: val));
            },
          ),
          const SizedBox(height: 12),

          // Min/Max Length (Text/Paragraph)
          if (widget.question.type == QuestionType.shortText ||
              widget.question.type == QuestionType.paragraph) ...[
            Row(
              children: [
                Expanded(
                  child: PropertyBuilderUtils.buildTextField(
                    label: 'Min Length',
                    controller: widget.minLengthController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) return null;
                      final n = int.tryParse(value);
                      if (n == null || n < 0) return 'Invalid number';
                      final maxLength = int.tryParse(
                        widget.maxLengthController.text,
                      );
                      if (maxLength != null && n > maxLength)
                        return 'Min < Max';
                      return null;
                    },
                    onChanged: (val) {
                      if (_formKey.currentState!.validate()) {
                        final n = int.tryParse(val);
                        ref
                            .read(
                              formBuilderControllerProvider(
                                widget.formId,
                              ).notifier,
                            )
                            .updateQuestion(
                              widget.question.copyWith(minLength: n),
                            );
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PropertyBuilderUtils.buildTextField(
                    label: 'Max Length',
                    controller: widget.maxLengthController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) return null;
                      final n = int.tryParse(value);
                      if (n == null || n < 0) return 'Invalid number';
                      final minLength = int.tryParse(
                        widget.minLengthController.text,
                      );
                      if (minLength != null && n < minLength)
                        return 'Max > Min';
                      return null;
                    },
                    onChanged: (val) {
                      if (_formKey.currentState!.validate()) {
                        final n = int.tryParse(val);
                        ref
                            .read(
                              formBuilderControllerProvider(
                                widget.formId,
                              ).notifier,
                            )
                            .updateQuestion(
                              widget.question.copyWith(maxLength: n),
                            );
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],

          // Min/Max Value (Number)
          if (widget.question.type == QuestionType.number) ...[
            Row(
              children: [
                Expanded(
                  child: PropertyBuilderUtils.buildTextField(
                    label: 'Min Value',
                    controller: widget.minValueController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) return null;
                      final n = num.tryParse(value);
                      if (n == null) return 'Invalid number';
                      final maxValue = num.tryParse(
                        widget.maxValueController.text,
                      );
                      if (maxValue != null && n > maxValue) return 'Min < Max';
                      return null;
                    },
                    onChanged: (val) {
                      if (_formKey.currentState!.validate()) {
                        final n = num.tryParse(val);
                        ref
                            .read(
                              formBuilderControllerProvider(
                                widget.formId,
                              ).notifier,
                            )
                            .updateQuestion(
                              widget.question.copyWith(minValue: n),
                            );
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PropertyBuilderUtils.buildTextField(
                    label: 'Max Value',
                    controller: widget.maxValueController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) return null;
                      final n = num.tryParse(value);
                      if (n == null) return 'Invalid number';
                      final minValue = num.tryParse(
                        widget.minValueController.text,
                      );
                      if (minValue != null && n < minValue) return 'Max > Min';
                      return null;
                    },
                    onChanged: (val) {
                      if (_formKey.currentState!.validate()) {
                        final n = num.tryParse(val);
                        ref
                            .read(
                              formBuilderControllerProvider(
                                widget.formId,
                              ).notifier,
                            )
                            .updateQuestion(
                              widget.question.copyWith(maxValue: n),
                            );
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],

          // Regex (Text types)
          if (widget.question.type == QuestionType.shortText ||
              widget.question.type == QuestionType.paragraph ||
              widget.question.type == QuestionType.email ||
              widget.question.type == QuestionType.url ||
              widget.question.type == QuestionType.mobile) ...[
            PropertyBuilderUtils.buildDropdown<String>(
              label: 'Validation Pattern',
              value: _regexPresets.containsValue(widget.regexController.text)
                  ? widget.regexController.text
                  : (widget.regexController.text.isEmpty ? '' : null),
              items: _regexPresets.entries
                  .map(
                    (e) => DropdownMenuItem(value: e.value, child: Text(e.key)),
                  )
                  .toList(),
              onChanged: (val) {
                if (val != null) {
                  widget.regexController.text = val;
                  ref
                      .read(
                        formBuilderControllerProvider(widget.formId).notifier,
                      )
                      .updateQuestion(
                        widget.question.copyWith(validationRegex: val),
                      );
                }
              },
            ),
            const SizedBox(height: 12),
            PropertyBuilderUtils.buildTextField(
              label: 'Regex Validation',
              placeholder: 'e.g. ^[0-9]*\$',
              controller: widget.regexController,
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
                if (_formKey.currentState!.validate()) {
                  ref
                      .read(
                        formBuilderControllerProvider(widget.formId).notifier,
                      )
                      .updateQuestion(
                        widget.question.copyWith(validationRegex: val),
                      );
                }
              },
            ),
            const SizedBox(height: 12),
          ],

          // Input Mask
          if (widget.question.type == QuestionType.shortText ||
              widget.question.type == QuestionType.mobile ||
              widget.question.type == QuestionType.number ||
              widget.question.type == QuestionType.date) ...[
            PropertyBuilderUtils.buildTextField(
              label: 'Input Mask',
              placeholder: 'e.g. (###) ###-####',
              controller: widget.inputMaskController,
              onChanged: (val) {
                ref
                    .read(formBuilderControllerProvider(widget.formId).notifier)
                    .updateQuestion(widget.question.copyWith(inputMask: val));
              },
            ),
            const SizedBox(height: 12),
          ],

          // Custom Error Message
          if (widget.question.type == QuestionType.shortText ||
              widget.question.type == QuestionType.paragraph ||
              widget.question.type == QuestionType.email ||
              widget.question.type == QuestionType.url ||
              widget.question.type == QuestionType.mobile ||
              widget.question.type == QuestionType.number) ...[
            PropertyBuilderUtils.buildTextField(
              label: 'Custom Error Message',
              placeholder: 'Error to show when validation fails',
              controller: widget.customErrorController,
              onChanged: (val) {
                ref
                    .read(formBuilderControllerProvider(widget.formId).notifier)
                    .updateQuestion(
                      widget.question.copyWith(customErrorMessage: val),
                    );
              },
            ),
            const SizedBox(height: 12),
          ],

          // Read Only & Hidden
          PropertyBuilderUtils.buildSwitch(
            label: 'Read Only',
            value: widget.question.isReadOnly,
            onChanged: (val) {
              ref
                  .read(formBuilderControllerProvider(widget.formId).notifier)
                  .updateQuestion(widget.question.copyWith(isReadOnly: val));
            },
          ),
          const SizedBox(height: 12),

          PropertyBuilderUtils.buildSwitch(
            label: 'Hidden Field',
            value: widget.question.isHidden,
            onChanged: (val) {
              ref
                  .read(formBuilderControllerProvider(widget.formId).notifier)
                  .updateQuestion(widget.question.copyWith(isHidden: val));
            },
          ),
          const SizedBox(height: 12),

          // Date Validation
          if (widget.question.type == QuestionType.date) ...[
            Row(
              children: [
                Expanded(
                  child: AbsorbPointer(
                    child: PropertyBuilderUtils.buildTextField(
                      label: 'Min Date',
                      placeholder: 'Tap to select',
                      controller: TextEditingController(
                        text:
                            widget.question.dateMin
                                ?.toIso8601String()
                                .split('T')
                                .first ??
                            '',
                      ),
                      onChanged: (_) {},
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _pickDate(true),
                ),
                if (widget.question.dateMin != null)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      ref
                          .read(
                            formBuilderControllerProvider(
                              widget.formId,
                            ).notifier,
                          )
                          .updateQuestion(
                            widget.question.copyWith(dateMin: null),
                          );
                    },
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AbsorbPointer(
                    child: PropertyBuilderUtils.buildTextField(
                      label: 'Max Date',
                      placeholder: 'Tap to select',
                      controller: TextEditingController(
                        text:
                            widget.question.dateMax
                                ?.toIso8601String()
                                .split('T')
                                .first ??
                            '',
                      ),
                      onChanged: (_) {},
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _pickDate(false),
                ),
                if (widget.question.dateMax != null)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      ref
                          .read(
                            formBuilderControllerProvider(
                              widget.formId,
                            ).notifier,
                          )
                          .updateQuestion(
                            widget.question.copyWith(dateMax: null),
                          );
                    },
                  ),
              ],
            ),
            const SizedBox(height: 12),
          ],

          // File Validation
          if (widget.question.type == QuestionType.fileUpload) ...[
            const Text(
              'Allowed File Types',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _buildFileTypeChip('Images', ['jpg', 'png', 'jpeg', 'webp']),
                _buildFileTypeChip('Documents', ['doc', 'docx', 'txt']),
                _buildFileTypeChip('PDF', ['pdf']),
                _buildFileTypeChip('Spreadsheets', ['xls', 'xlsx', 'csv']),
              ],
            ),
            const SizedBox(height: 16),
            PropertyBuilderUtils.buildNumberSlider(
              label: 'Min File Size (MB)',
              value: (widget.question.metadata?['minFileSize'] ?? 0).toDouble(),
              min: 0,
              max: 10,
              onChanged: (val) {
                ref
                    .read(formBuilderControllerProvider(widget.formId).notifier)
                    .updateQuestionMetadata(widget.question.id, {
                      'minFileSize': val.toInt(),
                    });
              },
            ),
            const SizedBox(height: 12),
            PropertyBuilderUtils.buildNumberSlider(
              label: 'Max File Size (MB)',
              value: (widget.question.maxFileSize ?? 5).toDouble(),
              min: 1,
              max: 50,
              onChanged: (val) {
                ref
                    .read(formBuilderControllerProvider(widget.formId).notifier)
                    .updateQuestion(
                      widget.question.copyWith(maxFileSize: val.toInt()),
                    );
              },
            ),
            const SizedBox(height: 12),
            PropertyBuilderUtils.buildNumberSlider(
              label: 'Max Files Count',
              value: (widget.question.maxFiles ?? 1).toDouble(),
              min: 1,
              max: 10,
              onChanged: (val) {
                ref
                    .read(formBuilderControllerProvider(widget.formId).notifier)
                    .updateQuestion(
                      widget.question.copyWith(maxFiles: val.toInt()),
                    );
              },
            ),
            const SizedBox(height: 12),
          ],

          if (widget.question.type == QuestionType.shortText ||
              widget.question.type == QuestionType.email ||
              widget.question.type == QuestionType.mobile) ...[
            PropertyBuilderUtils.buildSwitch(
              label: 'Enforce Uniqueness',
              value: widget.question.isUnique ?? false,
              onChanged: (val) {
                ref
                    .read(formBuilderControllerProvider(widget.formId).notifier)
                    .updateQuestion(widget.question.copyWith(isUnique: val));
              },
            ),
            const SizedBox(height: 12),
            PropertyBuilderUtils.buildSwitch(
              label: 'Require Confirmation',
              value: widget.question.requiresConfirmation ?? false,
              onChanged: (val) {
                ref
                    .read(formBuilderControllerProvider(widget.formId).notifier)
                    .updateQuestion(
                      widget.question.copyWith(requiresConfirmation: val),
                    );
              },
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }

  Future<void> _pickDate(bool isMin) async {
    final initialDate = isMin
        ? widget.question.dateMin ?? DateTime.now()
        : widget.question.dateMax ?? DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      final notifier = ref.read(
        formBuilderControllerProvider(widget.formId).notifier,
      );
      if (isMin) {
        notifier.updateQuestion(widget.question.copyWith(dateMin: picked));
      } else {
        notifier.updateQuestion(widget.question.copyWith(dateMax: picked));
      }
    }
  }

  Widget _buildFileTypeChip(String label, List<String> extensions) {
    final currentTypes = widget.question.allowedFileTypes ?? [];
    // simplistic check: if all extensions are present, it's selected
    final isSelected = extensions.every((ext) => currentTypes.contains(ext));

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        final newTypes = List<String>.from(currentTypes);
        if (selected) {
          for (var ext in extensions) {
            if (!newTypes.contains(ext)) newTypes.add(ext);
          }
        } else {
          for (var ext in extensions) {
            newTypes.remove(ext);
          }
        }
        ref
            .read(formBuilderControllerProvider(widget.formId).notifier)
            .updateQuestion(
              widget.question.copyWith(allowedFileTypes: newTypes),
            );
      },
    );
  }
}
