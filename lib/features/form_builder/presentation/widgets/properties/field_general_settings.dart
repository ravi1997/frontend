import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/form_builder/domain/entities/form_question.dart';
import 'package:frontend/features/form_builder/domain/entities/form_question_option.dart';
import 'package:frontend/features/form_builder/domain/entities/question_type.dart';
import 'package:frontend/features/form_builder/presentation/controllers/form_builder_controller.dart';
import 'package:uuid/uuid.dart';
import 'property_builder_utils.dart';

class FieldGeneralSettings extends ConsumerStatefulWidget {
  final String projectId;
  final String formId;
  final FormQuestion question;
  final TextEditingController labelController;
  final TextEditingController variableNameController;
  final TextEditingController helperTextController;
  final TextEditingController placeholderController;

  const FieldGeneralSettings({
    super.key,
    required this.projectId,
    required this.formId,
    required this.question,
    required this.labelController,
    required this.variableNameController,
    required this.helperTextController,
    required this.placeholderController,
  });

  @override
  ConsumerState<FieldGeneralSettings> createState() =>
      _FieldGeneralSettingsState();
}

class _FieldGeneralSettingsState extends ConsumerState<FieldGeneralSettings> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _defaultValueController;
  late TextEditingController _dividerTextController;

  @override
  void initState() {
    super.initState();
    _defaultValueController = TextEditingController(
      text: widget.question.metadata?['defaultValue']?.toString() ?? '',
    );
    _dividerTextController = TextEditingController(
      text: widget.question.metadata?['dividerText']?.toString() ?? '',
    );
  }

  @override
  void didUpdateWidget(covariant FieldGeneralSettings oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.question.metadata?['defaultValue']?.toString() !=
        _defaultValueController.text) {
      if (!FocusScope.of(context).hasFocus) {
        _defaultValueController.text =
            widget.question.metadata?['defaultValue']?.toString() ?? '';
      }
    }
    if (widget.question.metadata?['dividerText']?.toString() !=
        _dividerTextController.text) {
      if (!FocusScope.of(context).hasFocus) {
        _dividerTextController.text =
            widget.question.metadata?['dividerText']?.toString() ?? '';
      }
    }
  }

  @override
  void dispose() {
    _defaultValueController.dispose();
    _dividerTextController.dispose();
    super.dispose();
  }

  bool get _showLabel =>
      widget.question.type != QuestionType.divider &&
      widget.question.type != QuestionType.spacer;

  bool get _showHelperText =>
      widget.question.type != QuestionType.divider &&
      widget.question.type != QuestionType.spacer;

  bool get _showPlaceholder => ![
    QuestionType.dropdown,
    QuestionType.checkboxes,
    QuestionType.multipleChoice,
    QuestionType.rating,
    QuestionType.matrixChoice,
    QuestionType.slider,
    QuestionType.fileUpload,
    QuestionType.image,
    QuestionType.signature,
    QuestionType.divider,
    QuestionType.spacer,
    QuestionType.date,
    QuestionType.time,
  ].contains(widget.question.type);

  bool get _showDefaultValue => [
    QuestionType.shortText,
    QuestionType.paragraph,
    QuestionType.number,
    QuestionType.date,
    QuestionType.time,
    QuestionType.dropdown,
    QuestionType.multipleChoice,
  ].contains(widget.question.type);

  bool get _showContentFormat =>
      [QuestionType.shortText].contains(widget.question.type);

  bool get _showDividerText => widget.question.type == QuestionType.divider;

  bool get _showOptions => [
    QuestionType.dropdown,
    QuestionType.checkboxes,
    QuestionType.multipleChoice,
  ].contains(widget.question.type);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Field Type
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Field Type',
                style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.builderElement.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Text(
                  widget.question.type.label,
                  style: const TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Label
          if (_showLabel) ...[
            PropertyBuilderUtils.buildTextField(
              label: 'Field Label',
              controller: widget.labelController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Field label cannot be empty';
                }
                return null;
              },
              onChanged: (val) {
                if (_formKey.currentState!.validate()) {
                  ref
                      .read(
                        formBuilderControllerProvider(widget.formId).notifier,
                      )
                      .updateQuestionLabel(widget.question.id, val);
                }
              },
            ),
            const SizedBox(height: 20),
            PropertyBuilderUtils.buildTextField(
              label: 'Field Variable Name (API Key/ID)',
              controller: widget.variableNameController,
              placeholder: 'my_custom_field',
              onChanged: (val) {
                ref
                    .read(formBuilderControllerProvider(widget.formId).notifier)
                    .updateQuestion(
                      widget.question.copyWith(variableName: val),
                    );
              },
            ),
            const SizedBox(height: 20),
          ],

          // Divider Text
          if (_showDividerText) ...[
            PropertyBuilderUtils.buildTextField(
              label: 'Divider Text',
              placeholder: 'Section Break',
              controller: _dividerTextController,
              onChanged: (val) {
                ref
                    .read(formBuilderControllerProvider(widget.formId).notifier)
                    .updateQuestionMetadata(widget.question.id, {
                      'dividerText': val,
                    });
              },
            ),
            const SizedBox(height: 20),
          ],

          // Helper Text
          if (_showHelperText) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PropertyBuilderUtils.buildTextField(
                  label: 'Helper Text',
                  placeholder: 'e.g. Please enter your full name',
                  controller: widget.helperTextController,
                  onChanged: (val) {
                    ref
                        .read(
                          formBuilderControllerProvider(widget.formId).notifier,
                        )
                        .updateQuestionHelperText(widget.question.id, val);
                  },
                ),
                const SizedBox(height: 4),
                const Text(
                  'Supports Markdown',
                  style: TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],

          // Content Format (Phone, Credit Card, Currency)
          if (_showContentFormat) ...[
            _buildContentFormat(),
            const SizedBox(height: 20),
          ],

          // Placeholder
          if (_showPlaceholder) ...[
            PropertyBuilderUtils.buildTextField(
              label: 'Placeholder',
              placeholder: 'Input placeholder...',
              controller: widget.placeholderController,
              onChanged: (val) {
                ref
                    .read(formBuilderControllerProvider(widget.formId).notifier)
                    .updateQuestionPlaceholder(widget.question.id, val);
              },
            ),
            const SizedBox(height: 20),
          ],

          // Default Value
          if (_showDefaultValue) ...[
            _buildDefaultValuePicker(),
            const SizedBox(height: 20),
          ],

          // Behavior
          const Text(
            'BEHAVIOR',
            style: TextStyle(
              color: AppColors.textGrey,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          PropertyBuilderUtils.buildSwitch(
            label: 'Hidden Field',
            value: widget.question.isHidden,
            onChanged: (val) {
              ref
                  .read(
                    formBuilderControllerProvider(
                      '${widget.projectId}::${widget.formId}',
                    ).notifier,
                  )
                  .updateQuestion(widget.question.copyWith(isHidden: val));
            },
          ),
          const SizedBox(height: 20),

          // Options Editor
          if (_showOptions) ...[
            const SizedBox(height: 4),
            _buildOptionsEditor(ref, widget.question),
          ],

          const SizedBox(height: 32),

          // Field Actions
          _buildFieldActions(ref),
        ],
      ),
    );
  }

  Widget _buildFieldActions(WidgetRef ref) {
    final actionConfig = widget.question.actionConfig ?? {};
    final hasButton = actionConfig['hasButton'] ?? false;
    final buttonLabel = actionConfig['buttonLabel'] ?? 'Search';
    final webhookUrl = actionConfig['webhookUrl'] ?? '';
    final webhookMethod = actionConfig['webhookMethod'] ?? 'GET';
    final mappings = List<Map<String, dynamic>>.from(
      actionConfig['mappings'] ?? [],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'INTERACTIVE FIELD ACTIONS',
          style: TextStyle(
            color: AppColors.textGrey,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.brandBlue.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.brandBlue.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            children: [
              PropertyBuilderUtils.buildSwitch(
                label: 'Show Action Button',
                value: hasButton,
                onChanged: (val) {
                  final newConfig = Map<String, dynamic>.from(actionConfig);
                  newConfig['hasButton'] = val;
                  ref
                      .read(
                        formBuilderControllerProvider(widget.formId).notifier,
                      )
                      .updateQuestion(
                        widget.question.copyWith(actionConfig: newConfig),
                      );
                },
              ),
              if (hasButton) ...[
                const SizedBox(height: 16),
                PropertyBuilderUtils.buildTextField(
                  label: 'Button Label',
                  controller: TextEditingController(text: buttonLabel),
                  onChanged: (val) {
                    final newConfig = Map<String, dynamic>.from(actionConfig);
                    newConfig['buttonLabel'] = val;
                    ref
                        .read(
                          formBuilderControllerProvider(widget.formId).notifier,
                        )
                        .updateQuestion(
                          widget.question.copyWith(actionConfig: newConfig),
                        );
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<String>(
                        initialValue: webhookMethod,
                        decoration: const InputDecoration(
                          labelText: 'Method',
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'GET', child: Text('GET')),
                          DropdownMenuItem(value: 'POST', child: Text('POST')),
                        ],
                        onChanged: (v) {
                          final newConfig = Map<String, dynamic>.from(
                            actionConfig,
                          );
                          newConfig['webhookMethod'] = v;
                          ref
                              .read(
                                formBuilderControllerProvider(
                                  widget.formId,
                                ).notifier,
                              )
                              .updateQuestion(
                                widget.question.copyWith(
                                  actionConfig: newConfig,
                                ),
                              );
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 5,
                      child: TextFormField(
                        initialValue: webhookUrl,
                        decoration: const InputDecoration(
                          labelText: 'Webhook URL',
                          hintText: 'https://api.example.com/search',
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (val) {
                          final newConfig = Map<String, dynamic>.from(
                            actionConfig,
                          );
                          newConfig['webhookUrl'] = val;
                          ref
                              .read(
                                formBuilderControllerProvider(
                                  widget.formId,
                                ).notifier,
                              )
                              .updateQuestion(
                                widget.question.copyWith(
                                  actionConfig: newConfig,
                                ),
                              );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'RESPONSE MAPPING',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                ...mappings.asMap().entries.map((e) {
                  final i = e.key;
                  final m = e.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: m['responseKey'],
                            onChanged: (v) {
                              mappings[i]['responseKey'] = v;
                              final newConfig = Map<String, dynamic>.from(
                                actionConfig,
                              );
                              newConfig['mappings'] = mappings;
                              ref
                                  .read(
                                    formBuilderControllerProvider(
                                      widget.formId,
                                    ).notifier,
                                  )
                                  .updateQuestion(
                                    widget.question.copyWith(
                                      actionConfig: newConfig,
                                    ),
                                  );
                            },
                            decoration: const InputDecoration(
                              hintText: 'JSON Key',
                              isDense: true,
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const Icon(Icons.arrow_forward, size: 14),
                        Expanded(
                          child: _buildFieldTargetDropdown(m['targetFieldId'], (
                            v,
                          ) {
                            mappings[i]['targetFieldId'] = v;
                            final newConfig = Map<String, dynamic>.from(
                              actionConfig,
                            );
                            newConfig['mappings'] = mappings;
                            ref
                                .read(
                                  formBuilderControllerProvider(
                                    widget.formId,
                                  ).notifier,
                                )
                                .updateQuestion(
                                  widget.question.copyWith(
                                    actionConfig: newConfig,
                                  ),
                                );
                          }),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            size: 18,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            final newConfig = Map<String, dynamic>.from(
                              actionConfig,
                            );
                            final newList = List<Map<String, dynamic>>.from(
                              mappings,
                            )..removeAt(i);
                            newConfig['mappings'] = newList;
                            ref
                                .read(
                                  formBuilderControllerProvider(
                                    widget.formId,
                                  ).notifier,
                                )
                                .updateQuestion(
                                  widget.question.copyWith(
                                    actionConfig: newConfig,
                                  ),
                                );
                          },
                        ),
                      ],
                    ),
                  );
                }),
                TextButton.icon(
                  onPressed: () {
                    final newConfig = Map<String, dynamic>.from(actionConfig);
                    final newList = List<Map<String, dynamic>>.from(mappings)
                      ..add({'responseKey': '', 'targetFieldId': null});
                    newConfig['mappings'] = newList;
                    ref
                        .read(
                          formBuilderControllerProvider(widget.formId).notifier,
                        )
                        .updateQuestion(
                          widget.question.copyWith(actionConfig: newConfig),
                        );
                  },
                  icon: const Icon(Icons.add, size: 14),
                  label: const Text(
                    'Add Mapping',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFieldTargetDropdown(String? value, Function(String?) onChanged) {
    final state = ref.read(formBuilderControllerProvider(widget.formId)).value;
    if (state == null) return const SizedBox();

    final allQuestions = state.form.sections
        .expand((s) => s.questions)
        .where((q) => q.id != widget.question.id)
        .toList();

    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      decoration: const InputDecoration(
        hintText: 'Target Field',
        isDense: true,
        border: OutlineInputBorder(),
      ),
      items: allQuestions.map((q) {
        return DropdownMenuItem(
          value: q.id,
          child: Text(
            '${q.label is String ? q.label as String : (q.label as Map?)?['en'] ?? 'Untitled'} (${q.variableName?.isNotEmpty == true ? q.variableName : q.id})',
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildContentFormat() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Content Format',
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.borderLight),
            ),
            filled: true,
            fillColor: AppColors.builderElement,
          ),
          initialValue: null,
          items: const [
            DropdownMenuItem(value: null, child: Text('None')),
            DropdownMenuItem(value: 'phone', child: Text('Phone Number')),
            DropdownMenuItem(value: 'email', child: Text('Email')),
            DropdownMenuItem(value: 'currency', child: Text('Currency')),
            DropdownMenuItem(value: 'credit_card', child: Text('Credit Card')),
          ],
          onChanged: (value) {
            String? mask;
            String? regex;

            if (value == 'phone') {
              mask = '(###) ###-####';
              regex = r'^\(\d{3}\) \d{3}-\d{4}$';
            } else if (value == 'email') {
              regex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
            } else if (value == 'currency') {
              mask = '\$###,###.##';
              regex = r'^\$?\d+(,\d{3})*(\.\d{1,2})?$';
            } else if (value == 'credit_card') {
              mask = '#### #### #### ####';
              regex = r'^\d{4} \d{4} \d{4} \d{4}$';
            }

            final notifier = ref.read(
              formBuilderControllerProvider(widget.formId).notifier,
            );

            var q = widget.question;
            if (mask != null) q = q.copyWith(inputMask: mask);
            if (regex != null) q = q.copyWith(validationRegex: regex);

            notifier.updateQuestion(q);
          },
        ),
      ],
    );
  }

  Widget _buildDefaultValuePicker() {
    if (widget.question.type == QuestionType.date) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Default Date',
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                ref
                    .read(formBuilderControllerProvider(widget.formId).notifier)
                    .updateQuestionDefaultValue(
                      widget.question.id,
                      picked.toIso8601String().split('T').first,
                    );
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.borderLight),
                borderRadius: BorderRadius.circular(8),
                color: AppColors.builderElement,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.question.defaultValue != null
                        ? widget.question.defaultValue.toString()
                        : 'Select Date',
                    style: TextStyle(
                      color: widget.question.defaultValue != null
                          ? AppColors.textDark
                          : AppColors.textGrey,
                    ),
                  ),
                  const Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: AppColors.textGrey,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    if (widget.question.type == QuestionType.time) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Default Time',
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () async {
              final TimeOfDay? picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (picked != null) {
                final formatted =
                    '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                ref
                    .read(formBuilderControllerProvider(widget.formId).notifier)
                    .updateQuestionDefaultValue(widget.question.id, formatted);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.borderLight),
                borderRadius: BorderRadius.circular(8),
                color: AppColors.builderElement,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.question.defaultValue?.toString() ?? 'Select Time',
                    style: TextStyle(
                      color: widget.question.defaultValue != null
                          ? AppColors.textDark
                          : AppColors.textGrey,
                    ),
                  ),
                  const Icon(
                    Icons.access_time,
                    size: 16,
                    color: AppColors.textGrey,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    if (widget.question.type == QuestionType.dropdown ||
        widget.question.type == QuestionType.multipleChoice) {
      final options = widget.question.options ?? [];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Default Selection',
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: widget.question.defaultValue?.toString(),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.borderLight),
              ),
              filled: true,
              fillColor: AppColors.builderElement,
            ),
            items: [
              const DropdownMenuItem(value: null, child: Text('None')),
              ...{for (var opt in options) opt.value: opt}.values.map(
                (opt) =>
                    DropdownMenuItem(value: opt.value, child: Text(opt.label)),
              ),
            ],
            onChanged: (val) {
              ref
                  .read(formBuilderControllerProvider(widget.formId).notifier)
                  .updateQuestionDefaultValue(widget.question.id, val);
            },
          ),
        ],
      );
    }

    return PropertyBuilderUtils.buildTextField(
      label: 'Default Value',
      placeholder: 'Initial value',
      controller: _defaultValueController,
      onChanged: (val) {
        ref
            .read(formBuilderControllerProvider(widget.formId).notifier)
            .updateQuestionDefaultValue(widget.question.id, val);
      },
    );
  }

  Widget _buildOptionsEditor(WidgetRef ref, FormQuestion question) {
    final options = question.options ?? [];
    final hasOtherOption = question.metadata?['hasOtherOption'] == true;

    final optionValues = options
        .map((e) => e.value.trim().toLowerCase())
        .toList();
    final duplicateValues = optionValues
        .where((e) => optionValues.indexOf(e) != optionValues.lastIndexOf(e))
        .toSet();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'OPTIONS',
              style: TextStyle(
                color: AppColors.textGrey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            TextButton(
              onPressed: () => _showBulkAddDialog(options),
              child: const Text('Bulk Add', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: options.length,
          onReorder: (oldIndex, newIndex) {
            if (oldIndex < newIndex) newIndex -= 1;
            final newOptions = List<FormQuestionOption>.from(options);
            final item = newOptions.removeAt(oldIndex);
            newOptions.insert(newIndex, item);

            // Re-assign order
            final orderedOptions = newOptions.asMap().entries.map((e) {
              return e.value.copyWith(order: e.key);
            }).toList();

            ref
                .read(formBuilderControllerProvider(widget.formId).notifier)
                .updateQuestion(question.copyWith(options: orderedOptions));
          },
          itemBuilder: (context, index) {
            final option = options[index];
            final isDuplicate = duplicateValues.contains(
              option.value.trim().toLowerCase(),
            );

            return _OptionRow(
              key: ValueKey(option.id),
              initialValue: option.label,
              errorText: isDuplicate ? 'Duplicate option value' : null,
              onChanged: (newValue) {
                final newOptions = List<FormQuestionOption>.from(options);
                newOptions[index] = option.copyWith(
                  label: newValue,
                  value: newValue,
                );
                ref
                    .read(formBuilderControllerProvider(widget.formId).notifier)
                    .updateQuestion(question.copyWith(options: newOptions));
              },
              onDelete: () {
                final newOptions = List<FormQuestionOption>.from(options);
                newOptions.removeAt(index);
                ref
                    .read(formBuilderControllerProvider(widget.formId).notifier)
                    .updateQuestion(question.copyWith(options: newOptions));
              },
            );
          },
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () {
            final newOptions = List<FormQuestionOption>.from(options);
            newOptions.add(
              FormQuestionOption(
                id: const Uuid().v4(),
                label: 'Option ${newOptions.length + 1}',
                value: 'Option ${newOptions.length + 1}',
                order: newOptions.length,
              ),
            );
            ref
                .read(formBuilderControllerProvider(widget.formId).notifier)
                .updateQuestion(question.copyWith(options: newOptions));
          },
          icon: const Icon(Icons.add, size: 16),
          label: const Text('Add Option'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 44),
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
          ),
        ),
        const SizedBox(height: 12),

        PropertyBuilderUtils.buildSwitch(
          label: "Include 'Other' Option",
          value: hasOtherOption,
          onChanged: (val) {
            ref
                .read(formBuilderControllerProvider(widget.formId).notifier)
                .updateQuestionMetadata(widget.question.id, {
                  'hasOtherOption': val,
                });
          },
        ),
      ],
    );
  }

  void _showBulkAddDialog(List<FormQuestionOption> currentOptions) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bulk Add Options'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter one option per line:',
              style: TextStyle(fontSize: 13, color: AppColors.textGrey),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              maxLines: 8,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Option 1\nOption 2\nOption 3',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final lines = controller.text
                  .split('\n')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList();

              if (lines.isNotEmpty) {
                final newOptions = List<FormQuestionOption>.from(
                  currentOptions,
                );
                for (var line in lines) {
                  newOptions.add(
                    FormQuestionOption(
                      id: const Uuid().v4(),
                      label: line,
                      value: line,
                      order: newOptions.length,
                    ),
                  );
                }
                ref
                    .read(formBuilderControllerProvider(widget.formId).notifier)
                    .updateQuestion(
                      widget.question.copyWith(options: newOptions),
                    );
              }
              Navigator.pop(context);
            },
            child: const Text('Add Options'),
          ),
        ],
      ),
    );
  }
}

class _OptionRow extends StatefulWidget {
  final String initialValue;
  final Function(String) onChanged;
  final VoidCallback onDelete;
  final String? errorText;

  const _OptionRow({
    super.key,
    required this.initialValue,
    required this.onChanged,
    required this.onDelete,
    this.errorText,
  });

  @override
  State<_OptionRow> createState() => _OptionRowState();
}

class _OptionRowState extends State<_OptionRow> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(_OptionRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue &&
        _controller.text != widget.initialValue) {
      if (!FocusScope.of(context).hasFocus) {
        _controller.text = widget.initialValue;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.drag_indicator,
                color: AppColors.textGrey,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    fillColor: AppColors.builderElement,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: widget.errorText != null
                          ? const BorderSide(color: Colors.red, width: 1)
                          : BorderSide.none,
                    ),
                    errorStyle: const TextStyle(
                      height: 0,
                      color: Colors.transparent,
                    ),
                  ),
                  style: const TextStyle(fontSize: 14),
                  onChanged: widget.onChanged,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(
                  Icons.close,
                  size: 18,
                  color: AppColors.textGrey,
                ),
                onPressed: widget.onDelete,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          if (widget.errorText != null)
            Padding(
              padding: const EdgeInsets.only(left: 28, top: 4),
              child: Text(
                widget.errorText!,
                style: const TextStyle(color: Colors.red, fontSize: 11),
              ),
            ),
        ],
      ),
    );
  }
}
