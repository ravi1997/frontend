import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/app/theme/app_colors.dart';
import 'package:frontend/shared/models/form_models.dart' hide Form;
import 'package:frontend/modules/forms/models/question_type.dart';
import 'package:frontend/modules/forms/models/form_question_option.dart';
import 'package:frontend/modules/forms/services/field_registry.dart';
import 'package:frontend/modules/forms/services/form_builder_controller.dart';
import 'package:uuid/uuid.dart';
import 'property_builder_utils.dart';

class FieldGeneralSettings extends ConsumerStatefulWidget {
  final String controllerKey;
  final String projectId;
  final String formId;
  final FormQuestion question;
  final TextEditingController labelController;
  final TextEditingController variableNameController;
  final TextEditingController helperTextController;
  final TextEditingController placeholderController;

  const FieldGeneralSettings({
    super.key,
    required this.controllerKey,
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
  late TextEditingController _repeatMinController;
  late TextEditingController _repeatMaxController;
  late TextEditingController _buttonLabelController;
  late TextEditingController _webhookUrlController;
  bool _isSlugLocked = true;

  String _generateSlug(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\s_]'), '')
        .trim()
        .replaceAll(RegExp(r'\s+'), '_');
  }

  @override
  void initState() {
    super.initState();
    _defaultValueController = TextEditingController(
      text: widget.question.metadata['defaultValue']?.toString() ?? '',
    );
    _dividerTextController = TextEditingController(
      text: widget.question.metadata['dividerText']?.toString() ?? '',
    );
    _repeatMinController = TextEditingController(
      text: (widget.question.repeatMin ?? 1).toString(),
    );
    _repeatMaxController = TextEditingController(
      text: widget.question.repeatMax?.toString() ?? '',
    );
    final actionConfig = widget.question.actionConfig ?? {};
    _buttonLabelController = TextEditingController(
      text: actionConfig['buttonLabel'] ?? 'Search',
    );
    _webhookUrlController = TextEditingController(
      text: actionConfig['webhookUrl'] ?? '',
    );

    final labelSlug = _generateSlug(widget.labelController.text);
    if (widget.variableNameController.text.isNotEmpty &&
        widget.variableNameController.text != labelSlug) {
      _isSlugLocked = false;
    }
  }

  @override
  void didUpdateWidget(covariant FieldGeneralSettings oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.question.metadata['defaultValue']?.toString() !=
        _defaultValueController.text) {
      if (!FocusScope.of(context).hasFocus) {
        _defaultValueController.text =
            widget.question.metadata['defaultValue']?.toString() ?? '';
      }
    }
    if (widget.question.metadata['dividerText']?.toString() !=
        _dividerTextController.text) {
      if (!FocusScope.of(context).hasFocus) {
        _dividerTextController.text =
            widget.question.metadata['dividerText']?.toString() ?? '';
      }
    }
    final nextRepeatMin = (widget.question.repeatMin ?? 1).toString();
    if (_repeatMinController.text != nextRepeatMin) {
      if (!FocusScope.of(context).hasFocus) {
        _repeatMinController.text = nextRepeatMin;
      }
    }
    final nextRepeatMax = widget.question.repeatMax?.toString() ?? '';
    if (_repeatMaxController.text != nextRepeatMax) {
      if (!FocusScope.of(context).hasFocus) {
        _repeatMaxController.text = nextRepeatMax;
      }
    }
    final nextActionConfig = widget.question.actionConfig ?? {};
    final nextButtonLabel = nextActionConfig['buttonLabel'] ?? 'Search';
    if (_buttonLabelController.text != nextButtonLabel) {
      if (!FocusScope.of(context).hasFocus) {
        _buttonLabelController.text = nextButtonLabel;
      }
    }
    final nextWebhookUrl = nextActionConfig['webhookUrl'] ?? '';
    if (_webhookUrlController.text != nextWebhookUrl) {
      if (!FocusScope.of(context).hasFocus) {
        _webhookUrlController.text = nextWebhookUrl;
      }
    }
  }

  @override
  void dispose() {
    _defaultValueController.dispose();
    _dividerTextController.dispose();
    _repeatMinController.dispose();
    _repeatMaxController.dispose();
    _buttonLabelController.dispose();
    _webhookUrlController.dispose();
    super.dispose();
  }

  void _selectAll(TextEditingController controller) {
    Future.delayed(Duration.zero, () {
      if (controller.text.isNotEmpty) {
        controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: controller.text.length,
        );
      }
    });
  }

  void _updateActionConfig(
    Map<String, dynamic> actionConfig,
    void Function(Map<String, dynamic> config) update,
  ) {
    final newConfig = Map<String, dynamic>.from(actionConfig);
    update(newConfig);
    _controller().updateQuestion(
      widget.question.copyWith(
        logic: {...widget.question.logic ?? {}, 'actionConfig': newConfig},
      ),
    );
  }

  FormBuilderController _controller() {
    return ref.read(
      formBuilderControllerProvider(widget.controllerKey).notifier,
    );
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
    final compatibleTypes = FieldRegistry.getCompatibleTypes(
      widget.question.type,
    );

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
              if (compatibleTypes.length == 1)
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
                )
              else
                DropdownButtonFormField<QuestionType>(
                  initialValue: widget.question.type,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: AppColors.builderElement,
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.borderLight),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                  ),
                  dropdownColor: Colors.white,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 14,
                  ),
                  items: compatibleTypes
                      .map(
                        (type) => DropdownMenuItem<QuestionType>(
                          value: type,
                          child: Text(
                            type.label,
                            style: const TextStyle(color: AppColors.textDark),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null || value == widget.question.type) return;
                    ref
                        .read(
                          formBuilderControllerProvider(
                            widget.controllerKey,
                          ).notifier,
                        )
                        .convertQuestionType(widget.question.id, value);
                  },
                ),
              if (compatibleTypes.length > 1) ...[
                const SizedBox(height: 6),
                const Text(
                  'You can only switch to compatible types to preserve field settings.',
                  style: TextStyle(color: AppColors.textGrey, fontSize: 11),
                ),
              ],
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
                        formBuilderControllerProvider(
                          widget.controllerKey,
                        ).notifier,
                      )
                      .updateQuestionLabel(widget.question.id, val);
                  if (_isSlugLocked) {
                    final slug = _generateSlug(val);
                    widget.variableNameController.text = slug;
                    ref
                        .read(
                          formBuilderControllerProvider(
                            widget.controllerKey,
                          ).notifier,
                        )
                        .updateQuestion(
                          widget.question.copyWith(variableName: slug),
                        );
                  }
                }
              },
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Field Variable Name (API Key/ID)',
                      style: TextStyle(
                        color: AppColors.textDark,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _isSlugLocked ? Icons.lock : Icons.lock_open,
                        size: 16,
                        color: AppColors.brandBlue,
                      ),
                      onPressed: () {
                        setState(() {
                          _isSlugLocked = !_isSlugLocked;
                          if (_isSlugLocked) {
                            final slug = _generateSlug(
                              widget.labelController.text,
                            );
                            widget.variableNameController.text = slug;
                            ref
                                .read(
                                  formBuilderControllerProvider(
                                    widget.controllerKey,
                                  ).notifier,
                                )
                                .updateQuestion(
                                  widget.question.copyWith(variableName: slug),
                                );
                          }
                        });
                      },
                      tooltip: _isSlugLocked
                          ? 'Unlock to edit manually'
                          : 'Lock to auto-generate from label',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Focus(
                  onFocusChange: (hasFocus) {
                    if (hasFocus && !_isSlugLocked) {
                      _selectAll(widget.variableNameController);
                    }
                  },
                  child: TextFormField(
                    controller: widget.variableNameController,
                    readOnly: _isSlugLocked,
                    decoration: InputDecoration(
                      hintText: 'my_custom_field',
                      hintStyle: const TextStyle(color: Colors.black26),
                      filled: true,
                      fillColor: _isSlugLocked
                          ? AppColors.builderElement.withValues(alpha: 0.5)
                          : AppColors.builderElement,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                    onTap: () {
                      if (!_isSlugLocked) {
                        _selectAll(widget.variableNameController);
                      }
                    },
                    onChanged: (val) {
                      ref
                          .read(
                            formBuilderControllerProvider(
                              widget.controllerKey,
                            ).notifier,
                          )
                          .updateQuestion(
                            widget.question.copyWith(variableName: val),
                          );
                    },
                  ),
                ),
              ],
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
                    .read(
                      formBuilderControllerProvider(
                        widget.controllerKey,
                      ).notifier,
                    )
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
                          formBuilderControllerProvider(
                            widget.controllerKey,
                          ).notifier,
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
            Column(
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
                DropdownButtonFormField<String?>(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: AppColors.borderLight,
                      ),
                    ),
                    filled: true,
                    fillColor: AppColors.builderElement,
                  ),
                  initialValue: null,
                  items: const [
                    DropdownMenuItem<String?>(value: null, child: Text('None')),
                    DropdownMenuItem<String?>(
                      value: 'phone',
                      child: Text('Phone Number'),
                    ),
                    DropdownMenuItem<String?>(
                      value: 'email',
                      child: Text('Email'),
                    ),
                    DropdownMenuItem<String?>(
                      value: 'currency',
                      child: Text('Currency'),
                    ),
                    DropdownMenuItem<String?>(
                      value: 'credit_card',
                      child: Text('Credit Card'),
                    ),
                  ],
                  onChanged: (value) {
                    String? mask;
                    String? regex;

                    if (value == 'phone') {
                      mask = '(###) ###-####';
                      regex = r'^\(\d{3}\) \d{3}-\d{4}$';
                    } else if (value == 'email') {
                      regex =
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                    } else if (value == 'currency') {
                      mask = '\$###,###.##';
                      regex = r'^\$?\d+(,\d{3})*(\.\d{1,2})?$';
                    } else if (value == 'credit_card') {
                      mask = '#### #### #### ####';
                      regex = r'^\d{4} \d{4} \d{4} \d{4}$';
                    }

                    var q = widget.question;
                    if (mask != null) {
                      q = q.copyWith(
                        metadata: {...q.metadata, 'inputMask': mask},
                      );
                    }
                    if (regex != null) {
                      q = q.copyWith(
                        validation: {...q.validation, 'regex': regex},
                      );
                    }

                    _controller().updateQuestion(q);
                  },
                ),
              ],
            ),
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
                    .read(
                      formBuilderControllerProvider(
                        widget.controllerKey,
                      ).notifier,
                    )
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
                      widget.controllerKey,
                    ).notifier,
                  )
                  .updateQuestion(widget.question.copyWith(isHidden: val));
            },
          ),
          const SizedBox(height: 12),
          PropertyBuilderUtils.buildSwitch(
            label: 'Repeatable Question',
            description: 'Allow users to enter this question multiple times.',
            value: widget.question.isRepeatable,
            onChanged: (val) {
              ref
                  .read(
                    formBuilderControllerProvider(
                      widget.controllerKey,
                    ).notifier,
                  )
                  .updateQuestion(
                    widget.question.copyWith(
                      isRepeatable: val,
                      repeatMin: val ? (widget.question.repeatMin ?? 1) : null,
                      repeatMax: val ? widget.question.repeatMax : null,
                    ),
                  );
            },
          ),
          if (widget.question.isRepeatable) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Focus(
                    onFocusChange: (hasFocus) {
                      if (hasFocus) _selectAll(_repeatMinController);
                    },
                    child: TextFormField(
                      controller: _repeatMinController,
                      key: ValueKey('${widget.question.id}-repeat-min'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        labelText: 'Minimum repeats',
                        labelStyle: TextStyle(color: AppColors.textDark),
                        filled: true,
                        fillColor: AppColors.builderElement,
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.borderLight),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primary),
                        ),
                      ),
                      style: const TextStyle(color: AppColors.textDark),
                      onTap: () => _selectAll(_repeatMinController),
                      onChanged: (val) {
                        ref
                            .read(
                              formBuilderControllerProvider(
                                widget.controllerKey,
                              ).notifier,
                            )
                            .updateQuestion(
                              widget.question.copyWith(
                                repeatMin: int.tryParse(val) ?? 1,
                              ),
                            );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Focus(
                    onFocusChange: (hasFocus) {
                      if (hasFocus) _selectAll(_repeatMaxController);
                    },
                    child: TextFormField(
                      controller: _repeatMaxController,
                      key: ValueKey('${widget.question.id}-repeat-max'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        labelText: 'Maximum repeats',
                        hintText: 'Unlimited',
                        labelStyle: TextStyle(color: AppColors.textDark),
                        hintStyle: TextStyle(color: AppColors.textGrey),
                        filled: true,
                        fillColor: AppColors.builderElement,
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.borderLight),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primary),
                        ),
                      ),
                      style: const TextStyle(color: AppColors.textDark),
                      onTap: () => _selectAll(_repeatMaxController),
                      onChanged: (val) {
                        ref
                            .read(
                              formBuilderControllerProvider(
                                widget.controllerKey,
                              ).notifier,
                            )
                            .updateQuestion(
                              widget.question.copyWith(
                                repeatMax: val.trim().isEmpty
                                    ? null
                                    : int.tryParse(val),
                              ),
                            );
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            PropertyBuilderUtils.buildSwitch(
              label: 'Keep Last Value',
              description:
                  'Prefill new question copies using the previous answer.',
              value: widget.question.keepLastValue,
              onChanged: (val) {
                ref
                    .read(
                      formBuilderControllerProvider(
                        widget.controllerKey,
                      ).notifier,
                    )
                    .updateQuestion(
                      widget.question.copyWith(keepLastValue: val),
                    );
              },
            ),
          ],
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
            color: AppColors.textDark,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.brandBlue.withValues(alpha: 0.18),
            ),
          ),
          child: Column(
            children: [
              PropertyBuilderUtils.buildSwitch(
                label: 'Show Action Button',
                value: hasButton,
                onChanged: (val) {
                  _updateActionConfig(actionConfig, (config) {
                    config['hasButton'] = val;
                  });
                },
              ),
              if (hasButton) ...[
                const SizedBox(height: 16),
                PropertyBuilderUtils.buildTextField(
                  label: 'Button Label',
                  controller: _buttonLabelController,
                  onChanged: (val) {
                    _updateActionConfig(actionConfig, (config) {
                      config['buttonLabel'] = val;
                    });
                  },
                  placeholder: 'Search',
                ),
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isNarrow = constraints.maxWidth < 420;
                    final methodField = SizedBox(
                      width: isNarrow ? double.infinity : 140,
                      child: DropdownButtonFormField<String?>(
                        initialValue: webhookMethod,
                        decoration: const InputDecoration(
                          labelText: 'Method',
                          isDense: true,
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                          labelStyle: TextStyle(color: AppColors.textDark),
                        ),
                        style: const TextStyle(color: AppColors.textDark),
                        dropdownColor: Colors.white,
                        iconEnabledColor: AppColors.textDark,
                        items: const [
                          DropdownMenuItem<String?>(
                            value: 'GET',
                            child: Text(
                              'GET',
                              style: TextStyle(color: AppColors.textDark),
                            ),
                          ),
                          DropdownMenuItem<String?>(
                            value: 'POST',
                            child: Text(
                              'POST',
                              style: TextStyle(color: AppColors.textDark),
                            ),
                          ),
                        ],
                        onChanged: (v) {
                          _updateActionConfig(actionConfig, (config) {
                            config['webhookMethod'] = v;
                          });
                        },
                      ),
                    );
                    final urlField = SizedBox(
                      width: double.infinity,
                      child: PropertyBuilderUtils.buildTextField(
                        label: 'Webhook URL',
                        controller: _webhookUrlController,
                        placeholder: 'https://api.example.com/search',
                        onChanged: (val) {
                          _updateActionConfig(actionConfig, (config) {
                            config['webhookUrl'] = val;
                          });
                        },
                      ),
                    );

                    if (isNarrow) {
                      return Column(
                        children: [
                          methodField,
                          const SizedBox(height: 8),
                          urlField,
                        ],
                      );
                    }

                    return Row(
                      children: [
                        methodField,
                        const SizedBox(width: 8),
                        Expanded(child: urlField),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'RESPONSE MAPPING',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
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
                              _updateActionConfig(actionConfig, (config) {
                                config['mappings'] = mappings;
                              });
                            },
                            decoration: const InputDecoration(
                              hintText: 'JSON Key',
                              isDense: true,
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                              labelStyle: TextStyle(color: AppColors.textDark),
                              hintStyle: TextStyle(color: AppColors.textGrey),
                            ),
                            style: const TextStyle(color: AppColors.textDark),
                          ),
                        ),
                        const Icon(Icons.arrow_forward, size: 14),
                        Expanded(
                          child: Builder(
                            builder: (context) {
                              final state = ref
                                  .read(
                                    formBuilderControllerProvider(
                                      widget.controllerKey,
                                    ),
                                  )
                                  .value;
                              if (state == null) {
                                return const InputDecorator(
                                  decoration: InputDecoration(
                                    hintText: 'Target Field',
                                    isDense: true,
                                    border: OutlineInputBorder(),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                  child: Text(
                                    'Loading fields...',
                                    style: TextStyle(
                                      color: AppColors.textGrey,
                                    ),
                                  ),
                                );
                              }

                              final allQuestions = state.form.sections
                                  .expand((s) => s.questions)
                                  .where((q) => q.id != widget.question.id)
                                  .toList();

                              return DropdownButtonFormField<String?>(
                                initialValue: m['targetFieldId'],
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  hintText: 'Target Field',
                                  isDense: true,
                                  border: OutlineInputBorder(),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                style: const TextStyle(
                                  color: AppColors.textDark,
                                ),
                                dropdownColor: Colors.white,
                                iconEnabledColor: AppColors.textDark,
                                hint: const Text(
                                  'Target Field',
                                  style: TextStyle(color: AppColors.textGrey),
                                ),
                                items: allQuestions.map((q) {
                                  return DropdownMenuItem<String?>(
                                    value: q.id,
                                    child: Text(
                                      '${q.label} (${q.variableName?.isNotEmpty == true ? q.variableName : q.id})',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textDark,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (v) {
                                  mappings[i]['targetFieldId'] = v;
                                  _updateActionConfig(actionConfig, (config) {
                                    config['mappings'] = mappings;
                                  });
                                },
                              );
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            size: 18,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            final newList = List<Map<String, dynamic>>.from(
                              mappings,
                            )..removeAt(i);
                            _updateActionConfig(actionConfig, (config) {
                              config['mappings'] = newList;
                            });
                          },
                        ),
                      ],
                    ),
                  );
                }),
                TextButton.icon(
                  onPressed: () {
                    final newList = List<Map<String, dynamic>>.from(mappings)
                      ..add({'responseKey': '', 'targetFieldId': null});
                    _updateActionConfig(actionConfig, (config) {
                      config['mappings'] = newList;
                    });
                  },
                  icon: const Icon(Icons.add, size: 14),
                  label: const Text(
                    'Add Mapping',
                    style: TextStyle(fontSize: 12, color: AppColors.brandBlue),
                  ),
                ),
              ],
            ],
          ),
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
                _controller().updateQuestionDefaultValue(
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
                _controller().updateQuestionDefaultValue(
                  widget.question.id,
                  formatted,
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
      final options = widget.question.options;
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
          DropdownButtonFormField<String?>(
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
              fillColor: Colors.white,
            ),
            style: const TextStyle(color: AppColors.textDark),
            dropdownColor: Colors.white,
            iconEnabledColor: AppColors.textDark,
            items: [
              const DropdownMenuItem<String?>(
                value: null,
                child: Text(
                  'None',
                  style: TextStyle(color: AppColors.textDark),
                ),
              ),
              ...{for (var opt in options) opt.value: opt}.values.map(
                (opt) => DropdownMenuItem<String?>(
                  value: opt.value,
                  child: Text(
                    opt.label,
                    style: const TextStyle(color: AppColors.textDark),
                  ),
                ),
              ),
            ],
            onChanged: (val) {
              _controller().updateQuestionDefaultValue(widget.question.id, val);
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
        _controller().updateQuestionDefaultValue(widget.question.id, val);
      },
    );
  }

  Widget _buildOptionsEditor(WidgetRef ref, FormQuestion question) {
    final options = question.options
        .map(
          (e) => e is Map
              ? Map<String, dynamic>.from(e)
              : (e is FormQuestionOption ? e.toJson() : <String, dynamic>{}),
        )
        .toList();
    final hasOtherOption = question.metadata['hasOtherOption'] == true;

    final optionValues = options
        .map((e) => (e['option_value'] ?? '').toString().trim().toLowerCase())
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
              onPressed: () {
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
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textGrey,
                          ),
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
                            final liveState = ref
                                .read(
                                  formBuilderControllerProvider(
                                    widget.controllerKey,
                                  ),
                                )
                                .value;
                            final liveQuestion = liveState == null
                                ? widget.question
                                : liveState.form.sections
                                          .expand((s) => s.questions)
                                          .where(
                                            (q) => q.id == widget.question.id,
                                          )
                                          .firstOrNull ??
                                      widget.question;

                            final newOptions = List<Map<String, dynamic>>.from(
                              liveQuestion.options.isEmpty
                                  ? options
                                  : liveQuestion.options,
                            );
                            for (var line in lines) {
                              final exists = newOptions.any(
                                (opt) =>
                                    (opt['option_value'] ?? opt['value'] ?? '')
                                        .toString()
                                        .trim()
                                        .toLowerCase() ==
                                    line.trim().toLowerCase(),
                              );
                              if (exists) continue;
                              newOptions.add({
                                'id': const Uuid().v4(),
                                'option_label': line,
                                'option_value': line,
                                'order': newOptions.length,
                              });
                            }
                            ref
                                .read(
                                  formBuilderControllerProvider(
                                    widget.controllerKey,
                                  ).notifier,
                                )
                                .updateQuestion(
                                  liveQuestion.copyWith(options: newOptions),
                                );
                          }
                          Navigator.pop(context);
                        },
                        child: const Text('Add Options'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Bulk Add', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: options.length,
          onReorderItem: (oldIndex, newIndex) {
            if (oldIndex < newIndex) newIndex -= 1;
            final newOptions = List<Map<String, dynamic>>.from(options);
            final item = newOptions.removeAt(oldIndex);
            newOptions.insert(newIndex, item);

            // Re-assign order
            final orderedOptions = newOptions
                .asMap()
                .entries
                .map((e) {
                  return {...e.value, 'order': e.key};
                })
                .toList()
                .cast<Map<String, dynamic>>();

            _controller().updateQuestion(
              question.copyWith(options: orderedOptions),
            );
          },
          itemBuilder: (context, index) {
            final option = options[index];
            final optionValue = (option['option_value'] ?? '').toString();
            final isMultiple = question.type == QuestionType.checkboxes;

            // Handle lists or comma-separated default values
            final isDefault = isMultiple
                ? (question.defaultValue is List
                      ? (question.defaultValue as List).contains(optionValue)
                      : (question.defaultValue
                                ?.toString()
                                .split(',')
                                .contains(optionValue) ??
                            false))
                : question.defaultValue?.toString() == optionValue;

            final isDuplicate = duplicateValues.contains(
              (option['option_value'] ?? '').toString().trim().toLowerCase(),
            );

            return _OptionRow(
              key: ValueKey(option['id']?.toString() ?? index),
              initialValue: option['option_label']?.toString() ?? '',
              errorText: isDuplicate ? 'Duplicate option value' : null,
              isMultiple: isMultiple,
              isDefault: isDefault,
              onSetDefault: () {
                if (isMultiple) {
                  final currentDefaults = question.defaultValue is List
                      ? List<String>.from(question.defaultValue as List)
                      : (question.defaultValue?.toString().isNotEmpty == true
                            ? question.defaultValue!.toString().split(',')
                            : <String>[]);
                  if (currentDefaults.contains(optionValue)) {
                    currentDefaults.remove(optionValue);
                  } else {
                    currentDefaults.add(optionValue);
                  }
                  _controller().updateQuestionDefaultValue(
                    question.id,
                    currentDefaults,
                  );
                } else {
                  if (isDefault) {
                    _controller().updateQuestionDefaultValue(question.id, null);
                  } else {
                    _controller().updateQuestionDefaultValue(
                      question.id,
                      optionValue,
                    );
                  }
                }
              },
              onChanged: (newValue) {
                final newOptions = List<Map<String, dynamic>>.from(options);
                newOptions[index] = {
                  ...option,
                  'option_label': newValue,
                  'option_value': newValue,
                };
                _controller().updateQuestion(
                  question.copyWith(options: newOptions),
                );
              },
              onDelete: () {
                final newOptions = List<Map<String, dynamic>>.from(options);
                newOptions.removeAt(index);
                _controller().updateQuestion(
                  question.copyWith(options: newOptions),
                );
              },
            );
          },
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () {
            final newOptions = List<Map<String, dynamic>>.from(options);
            newOptions.add({
              'id': const Uuid().v4(),
              'option_label': 'Option ${newOptions.length + 1}',
              'option_value': 'Option ${newOptions.length + 1}',
              'order': newOptions.length,
            });
            _controller().updateQuestion(
              question.copyWith(options: newOptions),
            );
          },
          icon: const Icon(Icons.add, size: 16),
          label: const Text('Add Option'),
        ),
        const SizedBox(height: 16),
        PropertyBuilderUtils.buildSwitch(
          label: 'Allow "Other" Option',
          value: hasOtherOption,
          onChanged: (val) {
            _controller().updateQuestionMetadata(widget.question.id, {
              'hasOtherOption': val,
            });
          },
        ),
      ],
    );
  }
}

class _OptionRow extends StatefulWidget {
  final String initialValue;
  final Function(String) onChanged;
  final VoidCallback onDelete;
  final String? errorText;
  final bool isMultiple;
  final bool isDefault;
  final VoidCallback onSetDefault;

  const _OptionRow({
    super.key,
    required this.initialValue,
    required this.onChanged,
    required this.onDelete,
    required this.isMultiple,
    required this.isDefault,
    required this.onSetDefault,
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
              if (widget.isMultiple)
                Checkbox(
                  value: widget.isDefault,
                  onChanged: (val) => widget.onSetDefault(),
                  activeColor: AppColors.brandBlue,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                )
              else
                GestureDetector(
                  onTap: widget.onSetDefault,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Icon(
                      widget.isDefault
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: widget.isDefault
                          ? AppColors.brandBlue
                          : AppColors.textGrey,
                      size: 20,
                    ),
                  ),
                ),
              const SizedBox(width: 4),
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    fillColor: Colors.white,
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
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textDark,
                  ),
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
              padding: const EdgeInsets.only(left: 56, top: 4),
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
