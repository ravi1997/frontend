import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/form_question.dart';
import '../../domain/entities/form_style.dart';
import '../../domain/entities/form_section.dart';
import '../../domain/entities/question_type.dart';
import '../controllers/form_builder_controller.dart';

class FieldPropertiesWidget extends ConsumerStatefulWidget {
  final String formId;
  final String selectedQuestionId;

  const FieldPropertiesWidget({
    super.key,
    required this.formId,
    required this.selectedQuestionId,
  });

  @override
  ConsumerState<FieldPropertiesWidget> createState() =>
      _FieldPropertiesWidgetState();
}

class _FieldPropertiesWidgetState extends ConsumerState<FieldPropertiesWidget> {
  late TextEditingController _labelController;
  late TextEditingController _helperTextController;
  late TextEditingController _placeholderController;
  late TextEditingController _regexController;
  late TextEditingController _minLengthController;
  late TextEditingController _maxLengthController;
  late TextEditingController _minValueController;
  late TextEditingController _maxValueController;
  late TextEditingController _inputMaskController;
  late TextEditingController _customErrorController;
  late TextEditingController _prefixIconController;
  late TextEditingController _suffixIconController;

  void _updateStyle(FormQuestion question, QuestionStyle newStyle) {
    ref
        .read(formBuilderControllerProvider(widget.formId).notifier)
        .updateQuestion(question.copyWith(style: newStyle));
  }

  Widget _buildTypographyGroup(
    String title,
    double fontSize,
    String color,
    String fontWeight,
    Function(double, String, String) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: _buildNumberSlider(
                label: 'Size',
                value: fontSize,
                min: 10,
                max: 32,
                onChanged: (val) => onChanged(val, color, fontWeight),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 1,
              child: _buildColorPicker(
                label: 'Color',
                value: color,
                onChanged: (val) => onChanged(fontSize, val, fontWeight),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildDropdown<String>(
          label: 'Weight',
          value: fontWeight,
          items: const [
            DropdownMenuItem(value: 'normal', child: Text('Normal')),
            DropdownMenuItem(value: 'medium', child: Text('Medium')),
            DropdownMenuItem(value: 'bold', child: Text('Bold')),
          ],
          onChanged: (val) {
            if (val != null) onChanged(fontSize, color, val);
          },
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController();
    _helperTextController = TextEditingController();
    _placeholderController = TextEditingController();
    _regexController = TextEditingController();
    _minLengthController = TextEditingController();
    _maxLengthController = TextEditingController();
    _minValueController = TextEditingController();
    _maxValueController = TextEditingController();
    _inputMaskController = TextEditingController();
    _inputMaskController = TextEditingController();
    _customErrorController = TextEditingController();
    _prefixIconController = TextEditingController();
    _suffixIconController = TextEditingController();
  }

  @override
  void dispose() {
    _labelController.dispose();
    _helperTextController.dispose();
    _placeholderController.dispose();
    _regexController.dispose();
    _minLengthController.dispose();
    _maxLengthController.dispose();
    _minValueController.dispose();
    _maxValueController.dispose();
    _inputMaskController.dispose();
    _customErrorController.dispose();
    _prefixIconController.dispose();
    _suffixIconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final builderState = ref.watch(
      formBuilderControllerProvider(widget.formId),
    );

    return builderState.when(
      data: (state) {
        // Find the question
        FormQuestion? question;
        for (final section in state.form.sections) {
          final found = section.questions
              .where((q) => q.id == widget.selectedQuestionId)
              .firstOrNull;
          if (found != null) {
            question = found;
            break;
          }
        }

        if (question == null) return const SizedBox();

        // Sync main controllers
        if (_labelController.text != question.label) {
          _labelController.value = _labelController.value.copyWith(
            text: question.label,
            selection: TextSelection.collapsed(offset: question.label.length),
          );
        }
        if (_helperTextController.text != (question.helperText ?? '')) {
          _helperTextController.text = question.helperText ?? '';
        }
        if (_placeholderController.text != (question.placeholder ?? '')) {
          _placeholderController.text = question.placeholder ?? '';
        }
        if (_regexController.text != (question.validationRegex ?? '')) {
          _regexController.text = question.validationRegex ?? '';
        }
        if (_minLengthController.text !=
            (question.minLength?.toString() ?? '')) {
          _minLengthController.text = question.minLength?.toString() ?? '';
        }
        if (_maxLengthController.text !=
            (question.maxLength?.toString() ?? '')) {
          _maxLengthController.text = question.maxLength?.toString() ?? '';
        }
        if (_minValueController.text != (question.minValue?.toString() ?? '')) {
          _minValueController.text = question.minValue?.toString() ?? '';
        }
        if (_maxValueController.text != (question.maxValue?.toString() ?? '')) {
          _maxValueController.text = question.maxValue?.toString() ?? '';
        }
        if (_inputMaskController.text != (question.inputMask ?? '')) {
          _inputMaskController.text = question.inputMask ?? '';
        }
        if (_customErrorController.text !=
            (question.customErrorMessage ?? '')) {
          _customErrorController.text = question.customErrorMessage ?? '';
        }
        if (_prefixIconController.text != (question.style.prefixIcon ?? '')) {
          _prefixIconController.text = question.style.prefixIcon ?? '';
        }
        if (_suffixIconController.text != (question.style.suffixIcon ?? '')) {
          _suffixIconController.text = question.style.suffixIcon ?? '';
        }

        return DefaultTabController(
          length: 2,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                left: BorderSide(color: AppColors.borderLight, width: 1),
              ),
            ),
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(
                        FontAwesomeIcons.sliders,
                        size: 16,
                        color: AppColors.textGrey,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Field Properties',
                        style: TextStyle(
                          color: AppColors.textDark,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.textGrey,
                          size: 20,
                        ),
                        onPressed: () => ref
                            .read(
                              formBuilderControllerProvider(
                                widget.formId,
                              ).notifier,
                            )
                            .selectQuestion(null, null),
                      ),
                    ],
                  ),
                ),
                const Divider(color: AppColors.borderLight, height: 1),

                // Tab Bar
                Material(
                  color: Colors.white,
                  child: TabBar(
                    tabs: const [
                      Tab(text: 'General'),
                      Tab(text: 'Style'),
                    ],
                    labelColor: AppColors.brandBlue,
                    unselectedLabelColor: AppColors.textGrey,
                    indicatorColor: AppColors.brandBlue,
                    indicatorWeight: 3,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
                const Divider(color: AppColors.borderLight, height: 1),

                // Properties Content
                Expanded(
                  child: TabBarView(
                    children: [
                      // General Tab
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Label
                            _buildTextField(
                              label: 'Field Label',
                              controller: _labelController,
                              onChanged: (val) {
                                ref
                                    .read(
                                      formBuilderControllerProvider(
                                        widget.formId,
                                      ).notifier,
                                    )
                                    .updateQuestion(
                                      question!.copyWith(label: val),
                                    );
                              },
                            ),
                            const SizedBox(height: 20),

                            // Helper Text
                            _buildTextField(
                              label: 'Helper Text',
                              placeholder: 'e.g. Please enter your full name',
                              controller: _helperTextController,
                              onChanged: (val) {
                                ref
                                    .read(
                                      formBuilderControllerProvider(
                                        widget.formId,
                                      ).notifier,
                                    )
                                    .updateQuestion(
                                      question!.copyWith(helperText: val),
                                    );
                              },
                            ),
                            const SizedBox(height: 20),

                            // Placeholder
                            _buildTextField(
                              label: 'Placeholder',
                              placeholder: 'Input placeholder...',
                              controller: _placeholderController,
                              onChanged: (val) {
                                ref
                                    .read(
                                      formBuilderControllerProvider(
                                        widget.formId,
                                      ).notifier,
                                    )
                                    .updateQuestion(
                                      question!.copyWith(placeholder: val),
                                    );
                              },
                            ),

                            // Options Editor
                            if (question.type == QuestionType.dropdown ||
                                question.type == QuestionType.checkboxes ||
                                question.type ==
                                    QuestionType.multipleChoice) ...[
                              const SizedBox(height: 24),
                              _buildOptionsEditor(question),
                            ],

                            const SizedBox(height: 24),
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
                            _buildSwitch(
                              label: 'Required Field',
                              value: question.isRequired,
                              onChanged: (val) {
                                ref
                                    .read(
                                      formBuilderControllerProvider(
                                        widget.formId,
                                      ).notifier,
                                    )
                                    .updateQuestion(
                                      question!.copyWith(isRequired: val),
                                    );
                              },
                            ),
                            const SizedBox(height: 12),

                            // Min/Max Length (Text/Paragraph)
                            if (question.type == QuestionType.shortText ||
                                question.type == QuestionType.paragraph) ...[
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildTextField(
                                      label: 'Min Length',
                                      controller: _minLengthController,
                                      keyboardType: TextInputType.number,
                                      onChanged: (val) {
                                        final n = int.tryParse(val);
                                        ref
                                            .read(
                                              formBuilderControllerProvider(
                                                widget.formId,
                                              ).notifier,
                                            )
                                            .updateQuestion(
                                              question!.copyWith(minLength: n),
                                            );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildTextField(
                                      label: 'Max Length',
                                      controller: _maxLengthController,
                                      keyboardType: TextInputType.number,
                                      onChanged: (val) {
                                        final n = int.tryParse(val);
                                        ref
                                            .read(
                                              formBuilderControllerProvider(
                                                widget.formId,
                                              ).notifier,
                                            )
                                            .updateQuestion(
                                              question!.copyWith(maxLength: n),
                                            );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                            ],

                            // Min/Max Value (Number)
                            if (question.type == QuestionType.number) ...[
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildTextField(
                                      label: 'Min Value',
                                      controller: _minValueController,
                                      keyboardType: TextInputType.number,
                                      onChanged: (val) {
                                        final n = num.tryParse(val);
                                        ref
                                            .read(
                                              formBuilderControllerProvider(
                                                widget.formId,
                                              ).notifier,
                                            )
                                            .updateQuestion(
                                              question!.copyWith(minValue: n),
                                            );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildTextField(
                                      label: 'Max Value',
                                      controller: _maxValueController,
                                      keyboardType: TextInputType.number,
                                      onChanged: (val) {
                                        final n = num.tryParse(val);
                                        ref
                                            .read(
                                              formBuilderControllerProvider(
                                                widget.formId,
                                              ).notifier,
                                            )
                                            .updateQuestion(
                                              question!.copyWith(maxValue: n),
                                            );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                            ],

                            // Regex (Text types)
                            if (question.type == QuestionType.shortText ||
                                question.type == QuestionType.paragraph ||
                                question.type == QuestionType.email ||
                                question.type == QuestionType.url ||
                                question.type == QuestionType.mobile) ...[
                              _buildTextField(
                                label: 'Regex Validation',
                                placeholder: 'e.g. ^[0-9]*\$',
                                controller: _regexController,
                                onChanged: (val) {
                                  ref
                                      .read(
                                        formBuilderControllerProvider(
                                          widget.formId,
                                        ).notifier,
                                      )
                                      .updateQuestion(
                                        question!.copyWith(
                                          validationRegex: val,
                                        ),
                                      );
                                },
                              ),
                              const SizedBox(height: 12),

                              if (question.type == QuestionType.shortText ||
                                  question.type == QuestionType.mobile)
                                _buildTextField(
                                  label: 'Input Mask',
                                  placeholder: 'e.g. (###) ###-####',
                                  controller: _inputMaskController,
                                  onChanged: (val) {
                                    ref
                                        .read(
                                          formBuilderControllerProvider(
                                            widget.formId,
                                          ).notifier,
                                        )
                                        .updateQuestion(
                                          question!.copyWith(inputMask: val),
                                        );
                                  },
                                ),
                              if (question.type == QuestionType.shortText ||
                                  question.type == QuestionType.mobile)
                                const SizedBox(height: 12),

                              _buildTextField(
                                label: 'Custom Error Message',
                                placeholder:
                                    'Error to show when validation fails',
                                controller: _customErrorController,
                                onChanged: (val) {
                                  ref
                                      .read(
                                        formBuilderControllerProvider(
                                          widget.formId,
                                        ).notifier,
                                      )
                                      .updateQuestion(
                                        question!.copyWith(
                                          customErrorMessage: val,
                                        ),
                                      );
                                },
                              ),
                              const SizedBox(height: 12),
                            ],
                            const SizedBox(height: 12),

                            // Read Only Toggle
                            _buildSwitch(
                              label: 'Read Only',
                              value: question.isReadOnly,
                              onChanged: (val) {
                                ref
                                    .read(
                                      formBuilderControllerProvider(
                                        widget.formId,
                                      ).notifier,
                                    )
                                    .updateQuestion(
                                      question!.copyWith(isReadOnly: val),
                                    );
                              },
                            ),
                            const SizedBox(height: 12),

                            // Hidden Toggle
                            _buildSwitch(
                              label: 'Hidden Field',
                              value: question.isHidden,
                              onChanged: (val) {
                                ref
                                    .read(
                                      formBuilderControllerProvider(
                                        widget.formId,
                                      ).notifier,
                                    )
                                    .updateQuestion(
                                      question!.copyWith(isHidden: val),
                                    );
                              },
                            ),

                            // Conditional Logic
                            const SizedBox(height: 24),
                            const Text(
                              'CONDITIONAL LOGIC',
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
                                border: Border.all(
                                  color: AppColors.borderLight,
                                  style: BorderStyle.solid,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.builderElement,
                              ),
                              child: Column(
                                children: [
                                  _buildComplexLogicEditor(
                                    question,
                                    state.form.sections,
                                  ),
                                  const SizedBox(height: 12),
                                  OutlinedButton.icon(
                                    onPressed: () => _showRuleDialog(
                                      context,
                                      question!,
                                      state.form.sections,
                                    ),
                                    icon: const Icon(Icons.add, size: 16),
                                    label: const Text('Add Rule'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppColors.primary,
                                      side: const BorderSide(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Style Tab
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'TYPOGRAPHY',
                              style: TextStyle(
                                color: AppColors.textGrey,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildTypographyGroup(
                              'Label',
                              question.style.labelFontSize,
                              question.style.labelColor,
                              question.style.labelFontWeight,
                              (s, c, w) => _updateStyle(
                                question!,
                                question.style.copyWith(
                                  labelFontSize: s,
                                  labelColor: c,
                                  labelFontWeight: w,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildTypographyGroup(
                              'Helper Text',
                              question.style.helperFontSize,
                              question.style.helperColor,
                              question.style.helperFontWeight,
                              (s, c, w) => _updateStyle(
                                question!,
                                question.style.copyWith(
                                  helperFontSize: s,
                                  helperColor: c,
                                  helperFontWeight: w,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildTypographyGroup(
                              'Input Text',
                              question.style.inputFontSize,
                              question.style.inputFontColor,
                              question.style.inputFontWeight,
                              (s, c, w) => _updateStyle(
                                question!,
                                question.style.copyWith(
                                  inputFontSize: s,
                                  inputFontColor: c,
                                  inputFontWeight: w,
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),
                            const Text(
                              'INPUT DECORATION',
                              style: TextStyle(
                                color: AppColors.textGrey,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildDropdown<String>(
                              label: 'Style',
                              value: question.style.inputStyle,
                              items: const [
                                DropdownMenuItem(
                                  value: 'outlined',
                                  child: Text('Boxed (Outlined)'),
                                ),
                                DropdownMenuItem(
                                  value: 'rounded',
                                  child: Text('Rounded'),
                                ),
                                DropdownMenuItem(
                                  value: 'underlined',
                                  child: Text('Underlined'),
                                ),
                                DropdownMenuItem(
                                  value: 'filled',
                                  child: Text('Filled'),
                                ),
                                DropdownMenuItem(
                                  value: 'glass',
                                  child: Text('Glassmorphism'),
                                ),
                                DropdownMenuItem(
                                  value: 'minimalist',
                                  child: Text('Minimalist'),
                                ),
                              ],
                              onChanged: (val) {
                                if (val != null)
                                  _updateStyle(
                                    question!,
                                    question.style.copyWith(inputStyle: val),
                                  );
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildNumberSlider(
                              label: 'Border Radius',
                              value: question.style.borderRadius,
                              min: 0,
                              max: 32,
                              onChanged: (val) => _updateStyle(
                                question!,
                                question.style.copyWith(borderRadius: val),
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildColorPicker(
                              label: 'Background Color',
                              value: question.style.backgroundColor,
                              onChanged: (val) => _updateStyle(
                                question!,
                                question.style.copyWith(backgroundColor: val),
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildColorPicker(
                              label: 'Border Color',
                              value: question.style.borderColor,
                              onChanged: (val) => _updateStyle(
                                question!,
                                question.style.copyWith(borderColor: val),
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildNumberSlider(
                              label: 'Border Width',
                              value: question.style.borderWidth,
                              min: 0,
                              max: 10,
                              onChanged: (val) => _updateStyle(
                                question!,
                                question.style.copyWith(borderWidth: val),
                              ),
                            ),

                            const SizedBox(height: 24),
                            const Text(
                              'STATE COLORS',
                              style: TextStyle(
                                color: AppColors.textGrey,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildColorPicker(
                                    label: 'Focus',
                                    value: question.style.focusColor,
                                    onChanged: (val) => _updateStyle(
                                      question!,
                                      question.style.copyWith(focusColor: val),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _buildColorPicker(
                                    label: 'Error',
                                    value: question.style.errorColor,
                                    onChanged: (val) => _updateStyle(
                                      question!,
                                      question.style.copyWith(errorColor: val),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _buildColorPicker(
                              label: 'Hover',
                              value: question.style.hoverColor,
                              onChanged: (val) => _updateStyle(
                                question!,
                                question.style.copyWith(hoverColor: val),
                              ),
                            ),

                            const SizedBox(height: 24),
                            const Text(
                              'ICONS',
                              style: TextStyle(
                                color: AppColors.textGrey,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    label: 'Prefix Icon',
                                    placeholder: 'e.g. ✉️',
                                    controller: _prefixIconController,
                                    onChanged: (val) => _updateStyle(
                                      question!,
                                      question.style.copyWith(prefixIcon: val),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildTextField(
                                    label: 'Suffix Icon',
                                    placeholder: 'e.g. 👁️',
                                    controller: _suffixIconController,
                                    onChanged: (val) => _updateStyle(
                                      question!,
                                      question.style.copyWith(suffixIcon: val),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),
                            const Text(
                              'SPACING',
                              style: TextStyle(
                                color: AppColors.textGrey,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildNumberSlider(
                              label: 'Vertical Margin',
                              value: question.style.verticalMargin,
                              min: 0,
                              max: 64,
                              onChanged: (val) => _updateStyle(
                                question!,
                                question.style.copyWith(verticalMargin: val),
                              ),
                            ),

                            const SizedBox(height: 24),
                            const Text(
                              'FIELD LAYOUT',
                              style: TextStyle(
                                color: AppColors.textGrey,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildDropdown<int>(
                              label: 'Columns Spanned',
                              value: question.style.columnSpan,
                              items: const [
                                DropdownMenuItem(
                                  value: 1,
                                  child: Text('1 Column'),
                                ),
                                DropdownMenuItem(
                                  value: 2,
                                  child: Text('2 Columns'),
                                ),
                                DropdownMenuItem(
                                  value: 3,
                                  child: Text('3 Columns'),
                                ),
                              ],
                              onChanged: (val) {
                                if (val != null)
                                  _updateStyle(
                                    question!,
                                    question.style.copyWith(columnSpan: val),
                                  );
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildDropdown<String>(
                              label: 'Label Position',
                              value: question.style.labelPosition,
                              items: const [
                                DropdownMenuItem(
                                  value: 'top',
                                  child: Text('Top Aligned'),
                                ),
                                DropdownMenuItem(
                                  value: 'left',
                                  child: Text('Left Aligned'),
                                ),
                                DropdownMenuItem(
                                  value: 'floating',
                                  child: Text('Floating / Inline'),
                                ),
                                DropdownMenuItem(
                                  value: 'hidden',
                                  child: Text('Hidden'),
                                ),
                              ],
                              onChanged: (val) {
                                if (val != null)
                                  _updateStyle(
                                    question!,
                                    question.style.copyWith(labelPosition: val),
                                  );
                              },
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildDropdown<String>(
                                    label: 'Width Mode',
                                    value: question.style.widthMode,
                                    items: const [
                                      DropdownMenuItem(
                                        value: 'auto',
                                        child: Text('Auto (Grid)'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'fixed',
                                        child: Text('Fixed'),
                                      ),
                                    ],
                                    onChanged: (val) {
                                      if (val != null)
                                        _updateStyle(
                                          question!,
                                          question.style.copyWith(
                                            widthMode: val,
                                          ),
                                        );
                                    },
                                  ),
                                ),
                                if (question.style.widthMode == 'fixed') ...[
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildDropdown<String>(
                                      label: 'Fixed Width',
                                      value: question.style.fixedWidth,
                                      items: const [
                                        DropdownMenuItem(
                                          value: 'small',
                                          child: Text('Small'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'medium',
                                          child: Text('Medium'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'large',
                                          child: Text('Large'),
                                        ),
                                      ],
                                      onChanged: (val) {
                                        if (val != null)
                                          _updateStyle(
                                            question!,
                                            question.style.copyWith(
                                              fixedWidth: val,
                                            ),
                                          );
                                      },
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => const SizedBox(),
    );
  }

  Map<String, dynamic> _getLogicState(FormQuestion question) {
    final logic = question.conditionalLogic ?? {};
    if (logic['rules'] is List) return logic;
    if (logic['triggerId'] != null) {
      return {
        'matchType': 'and',
        'rules': [logic],
      };
    }
    return {'matchType': 'and', 'rules': []};
  }

  Widget _buildComplexLogicEditor(
    FormQuestion question,
    List<FormSection> sections,
  ) {
    final logicState = _getLogicState(question);
    final rules = (logicState['rules'] as List? ?? [])
        .cast<Map<String, dynamic>>();

    if (rules.isEmpty) {
      return Text(
        'Add logic to show/hide this field.',
        style: TextStyle(color: AppColors.textGrey, fontSize: 13),
        textAlign: TextAlign.center,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (rules.length > 1)
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              children: [
                const Text('Match: ', style: TextStyle(fontSize: 13)),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: logicState['matchType'] ?? 'and',
                  isDense: true,
                  underline: const SizedBox(),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'and',
                      child: Text('All Rules (AND)'),
                    ),
                    DropdownMenuItem(value: 'or', child: Text('Any Rule (OR)')),
                  ],
                  onChanged: (val) {
                    if (val == null) return;
                    final newLogic = Map<String, dynamic>.from(logicState);
                    newLogic['matchType'] = val;
                    ref
                        .read(
                          formBuilderControllerProvider(widget.formId).notifier,
                        )
                        .updateQuestion(
                          question.copyWith(conditionalLogic: newLogic),
                        );
                  },
                ),
              ],
            ),
          ),
        ...rules.asMap().entries.map((entry) {
          final index = entry.key;
          final rule = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: _buildSingleRuleItem(question, sections, rule, index),
          );
        }),
      ],
    );
  }

  Widget _buildSingleRuleItem(
    FormQuestion question,
    List<FormSection> sections,
    Map<String, dynamic> rule,
    int index,
  ) {
    final triggerId = rule['triggerId'] as String?;
    final condition = rule['condition'] as String?;
    final value = rule['value'] as String?;

    FormQuestion? triggerQuestion;
    for (final s in sections) {
      triggerQuestion = s.questions.where((q) => q.id == triggerId).firstOrNull;
      if (triggerQuestion != null) break;
    }

    final triggerLabel = triggerQuestion?.label ?? 'Unknown Question';
    final conditionLabel = condition == 'equals'
        ? 'Is Equal To'
        : condition == 'not_equals'
        ? 'Is Not Equal To'
        : 'Contains';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Rule ${index + 1}",
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              InkWell(
                onTap: () {
                  final logicState = _getLogicState(question);
                  final rules = (logicState['rules'] as List)
                      .cast<Map<String, dynamic>>();
                  final newRules = List<Map<String, dynamic>>.from(rules);
                  newRules.removeAt(index);

                  final newLogic = {...logicState, 'rules': newRules};

                  ref
                      .read(
                        formBuilderControllerProvider(widget.formId).notifier,
                      )
                      .updateQuestion(
                        question.copyWith(conditionalLogic: newLogic),
                      );
                },
                child: const Icon(
                  Icons.delete_outline,
                  size: 16,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            "$triggerLabel $conditionLabel \"$value\"",
            style: const TextStyle(fontSize: 13),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _showRuleDialog(
    BuildContext context,
    FormQuestion currentQuestion,
    List<FormSection> sections,
  ) {
    // Flatten logic to get eligible questions (preceding/all except current)
    // For simplicity, allowed trigger questions are those that have OPTIONS (Dropdown, Radio, Checkbox)
    // and are NOT the current question.
    final eligibleQuestions = <FormQuestion>[];
    for (final s in sections) {
      for (final q in s.questions) {
        if (q.id != currentQuestion.id &&
            (q.type == QuestionType.dropdown ||
                q.type == QuestionType.multipleChoice ||
                q.type == QuestionType.checkboxes)) {
          eligibleQuestions.add(q);
        }
      }
    }

    if (eligibleQuestions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No eligible trigger questions (Dropdown/Radio) found.',
          ),
        ),
      );
      return;
    }

    String? selectedTriggerId = eligibleQuestions.first.id;
    String selectedCondition = 'equals';
    String value = '';

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final triggerQ = eligibleQuestions.firstWhere(
              (q) => q.id == selectedTriggerId,
            );
            final triggerOptions = triggerQ.options ?? [];

            return AlertDialog(
              title: const Text('Add Logic'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Show this field when:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Trigger Question
                  const Text(
                    "Question:",
                    style: TextStyle(fontSize: 12, color: AppColors.textGrey),
                  ),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<String>(
                    initialValue: selectedTriggerId,
                    isExpanded: true,
                    items: eligibleQuestions.map((q) {
                      return DropdownMenuItem(
                        value: q.id,
                        child: Text(q.label, overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setDialogState(() {
                        selectedTriggerId = val;
                        value = ''; // Reset value on trigger change
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Condition
                  const Text(
                    "Condition:",
                    style: TextStyle(fontSize: 12, color: AppColors.textGrey),
                  ),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<String>(
                    initialValue: selectedCondition,
                    items: const [
                      DropdownMenuItem(
                        value: 'equals',
                        child: Text('Is Equal To'),
                      ),
                      DropdownMenuItem(
                        value: 'not_equals',
                        child: Text('Is Not Equal To'),
                      ),
                      // DropdownMenuItem(value: 'contains', child: Text('Contains')), // Removed for simplicity with options
                    ],
                    onChanged: (val) =>
                        setDialogState(() => selectedCondition = val!),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Value (Dropdown based on trigger options)
                  const Text(
                    "Value:",
                    style: TextStyle(fontSize: 12, color: AppColors.textGrey),
                  ),
                  const SizedBox(height: 4),
                  if (triggerOptions.isNotEmpty)
                    DropdownButtonFormField<String>(
                      initialValue:
                          value.isNotEmpty && triggerOptions.contains(value)
                          ? value
                          : null,
                      hint: const Text("Select Option"),
                      items: triggerOptions.map((opt) {
                        return DropdownMenuItem(value: opt, child: Text(opt));
                      }).toList(),
                      onChanged: (val) =>
                          setDialogState(() => value = val ?? ''),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    )
                  else
                    TextField(
                      onChanged: (val) => value = val,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter value',
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: AppColors.textGrey),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (value.isEmpty) {
                      // Show error or just return
                      return;
                    }
                    final newRule = {
                      'triggerId': selectedTriggerId,
                      'condition': selectedCondition,
                      'value': value,
                      'action': 'show',
                    };

                    final logicState = _getLogicState(currentQuestion);
                    final rules = (logicState['rules'] as List)
                        .cast<Map<String, dynamic>>();
                    final newRules = List<Map<String, dynamic>>.from(rules)
                      ..add(newRule);
                    final newLogic = {...logicState, 'rules': newRules};

                    ref
                        .read(
                          formBuilderControllerProvider(widget.formId).notifier,
                        )
                        .updateQuestion(
                          currentQuestion.copyWith(conditionalLogic: newLogic),
                        );

                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Save Rule'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildTextField({
    required String label,
    String? placeholder,
    required TextEditingController controller,
    required Function(String) onChanged,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textDark,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: const TextStyle(color: Colors.black26),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            filled: true,
            fillColor: AppColors.builderElement,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
          style: const TextStyle(color: AppColors.textDark),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildSwitch({
    required String label,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textDark,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildOptionsEditor(FormQuestion question) {
    final options = question.options ?? ['Option 1', 'Option 2', 'Option 3'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: options.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            return _OptionRow(
              key: ValueKey('${question.id}_opt_$index'),
              initialValue: options[index],
              onChanged: (newValue) {
                final newOptions = List<String>.from(options);
                newOptions[index] = newValue;
                ref
                    .read(formBuilderControllerProvider(widget.formId).notifier)
                    .updateQuestion(question.copyWith(options: newOptions));
              },
              onDelete: () {
                final newOptions = List<String>.from(options);
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
            final newOptions = List<String>.from(options);
            newOptions.add('Option ${newOptions.length + 1}');
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
      ],
    );
  }

  Widget _buildNumberSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required Function(double) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textDark,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              value.toStringAsFixed(0),
              style: const TextStyle(
                color: AppColors.brandBlue,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          onChanged: onChanged,
          activeColor: AppColors.brandBlue,
        ),
      ],
    );
  }

  Widget _buildColorPicker({
    required String label,
    required String value,
    required Function(String) onChanged,
  }) {
    Color displayColor;
    try {
      displayColor = Color(int.parse(value.replaceAll('#', '0xFF')));
    } catch (_) {
      displayColor = Colors.transparent;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textDark,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: displayColor,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppColors.borderLight),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: TextEditingController(text: value)
                  ..selection = TextSelection.fromPosition(
                    TextPosition(offset: value.length),
                  ),
                onChanged: onChanged,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  fillColor: AppColors.builderElement,
                  filled: true,
                  hintText: '#HEXCODE',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required Function(T?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textDark,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.builderElement,
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              items: items,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

class _OptionRow extends StatefulWidget {
  final String initialValue;
  final Function(String) onChanged;
  final VoidCallback onDelete;

  const _OptionRow({
    super.key,
    required this.initialValue,
    required this.onChanged,
    required this.onDelete,
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
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.drag_indicator, color: AppColors.textGrey, size: 20),
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
                borderSide: BorderSide.none,
              ),
            ),
            style: const TextStyle(fontSize: 14),
            onChanged: widget.onChanged,
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.close, size: 18, color: AppColors.textGrey),
          onPressed: widget.onDelete,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }
}
