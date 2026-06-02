import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/form_models.dart' hide Form;
import 'package:frontend/features/form_builder/models/form_style.dart';
import 'package:frontend/features/form_builder/models/question_type.dart';
import 'package:frontend/features/form_builder/services/form_builder_controller.dart';
import 'property_builder_utils.dart';

class FieldStyleSettings extends ConsumerStatefulWidget {
  final String formId;
  final FormQuestion question;
  final TextEditingController prefixIconController;
  final TextEditingController suffixIconController;

  const FieldStyleSettings({
    super.key,
    required this.formId,
    required this.question,
    required this.prefixIconController,
    required this.suffixIconController,
  });

  @override
  ConsumerState<FieldStyleSettings> createState() => _FieldStyleSettingsState();
}

class _FieldStyleSettingsState extends ConsumerState<FieldStyleSettings> {
  final _formKey = GlobalKey<FormState>();

  void _updateStyle(WidgetRef ref, QuestionStyle newStyle) {
    if (_formKey.currentState!.validate()) {
      ref
          .read(formBuilderControllerProvider(widget.formId).notifier)
          .updateQuestion(
            widget.question.copyWith(
              ui: {...widget.question.ui, 'style': newStyle.toJson()},
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.question.type == QuestionType.spacer) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            'No style settings for Spacer.',
            style: TextStyle(color: AppColors.textGrey, fontSize: 13),
          ),
        ),
      );
    }

    if (widget.question.type == QuestionType.divider) {
      return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildResetButton(),
            const SizedBox(height: 16),
            const Text(
              'DIVIDER STYLE',
              style: TextStyle(
                color: AppColors.textGrey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 16),
            PropertyBuilderUtils.buildColorPicker(
              label: 'Line Color',
              value: widget.question.style.borderColor,
              onChanged: (val) => _updateStyle(
                ref,
                widget.question.style.copyWith(borderColor: val),
              ),
            ),
            const SizedBox(height: 12),
            PropertyBuilderUtils.buildNumberSlider(
              label: 'Thickness',
              value: widget.question.style.borderWidth,
              min: 1,
              max: 10,
              onChanged: (val) => _updateStyle(
                ref,
                widget.question.style.copyWith(borderWidth: val),
              ),
            ),
            const SizedBox(height: 12),
            PropertyBuilderUtils.buildDropdown<String>(
              label: 'Style',
              value: widget.question.metadata['dividerStyle'] ?? 'solid',
              items: const [
                DropdownMenuItem(value: 'solid', child: Text('Solid')),
                DropdownMenuItem(value: 'dashed', child: Text('Dashed')),
                DropdownMenuItem(value: 'dotted', child: Text('Dotted')),
              ],
              onChanged: (val) {
                if (val != null) {
                  ref
                      .read(
                        formBuilderControllerProvider(widget.formId).notifier,
                      )
                      .updateQuestionMetadata(widget.question.id, {
                        'dividerStyle': val,
                      });
                }
              },
            ),
          ],
        ),
      );
    }

    final showIcons = [
      QuestionType.shortText,
      QuestionType.number,
      QuestionType.email,
      QuestionType.url,
      QuestionType.mobile,
      QuestionType.date,
      QuestionType.time,
      QuestionType.dropdown,
    ].contains(widget.question.type);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildResetButton(),
          const SizedBox(height: 16),

          ExpansionTile(
            title: const Text(
              'Typography',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.textDark,
              ),
            ),
            initiallyExpanded: true,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    _buildTypographyGroup(
                      'Label',
                      widget.question.style.labelFontSize,
                      widget.question.style.labelColor,
                      widget.question.style.labelFontWeight,
                      (s, c, w) => _updateStyle(
                        ref,
                        widget.question.style.copyWith(
                          labelFontSize: s,
                          labelColor: c,
                          labelFontWeight: w,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTypographyGroup(
                      'Helper Text',
                      widget.question.style.helperFontSize,
                      widget.question.style.helperColor,
                      widget.question.style.helperFontWeight,
                      (s, c, w) => _updateStyle(
                        ref,
                        widget.question.style.copyWith(
                          helperFontSize: s,
                          helperColor: c,
                          helperFontWeight: w,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTypographyGroup(
                      'Input Text',
                      widget.question.style.inputFontSize,
                      widget.question.style.inputFontColor,
                      widget.question.style.inputFontWeight,
                      (s, c, w) => _updateStyle(
                        ref,
                        widget.question.style.copyWith(
                          inputFontSize: s,
                          inputFontColor: c,
                          inputFontWeight: w,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          ExpansionTile(
            title: const Text(
              'Input Decoration',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.textDark,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    PropertyBuilderUtils.buildDropdown<String>(
                      label: 'Style',
                      value: widget.question.style.inputStyle,
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
                        if (val != null) {
                          _updateStyle(
                            ref,
                            widget.question.style.copyWith(inputStyle: val),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    PropertyBuilderUtils.buildNumberSlider(
                      label: 'Border Radius',
                      value: widget.question.style.borderRadius,
                      min: 0,
                      max: 32,
                      onChanged: (val) => _updateStyle(
                        ref,
                        widget.question.style.copyWith(borderRadius: val),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Shadow Settings
                    PropertyBuilderUtils.buildNumberSlider(
                      label: 'Shadow Elevation',
                      value: (widget.question.metadata['elevation'] ?? 0)
                          .toDouble(),
                      min: 0,
                      max: 10,
                      onChanged: (val) {
                        ref
                            .read(
                              formBuilderControllerProvider(
                                widget.formId,
                              ).notifier,
                            )
                            .updateQuestionMetadata(widget.question.id, {
                              'elevation': val,
                            });
                      },
                    ),
                    const SizedBox(height: 12),
                    if ((widget.question.metadata['elevation'] ?? 0) > 0)
                      PropertyBuilderUtils.buildColorPicker(
                        label: 'Shadow Color',
                        value:
                            widget.question.metadata['shadowColor'] ??
                            '#000000',
                        onChanged: (val) {
                          ref
                              .read(
                                formBuilderControllerProvider(
                                  widget.formId,
                                ).notifier,
                              )
                              .updateQuestionMetadata(widget.question.id, {
                                'shadowColor': val,
                              });
                        },
                      ),

                    const SizedBox(height: 12),
                    PropertyBuilderUtils.buildColorPicker(
                      label: 'Background Color',
                      value: widget.question.style.backgroundColor,
                      onChanged: (val) => _updateStyle(
                        ref,
                        widget.question.style.copyWith(backgroundColor: val),
                      ),
                    ),
                    const SizedBox(height: 12),
                    PropertyBuilderUtils.buildColorPicker(
                      label: 'Border Color',
                      value: widget.question.style.borderColor,
                      onChanged: (val) => _updateStyle(
                        ref,
                        widget.question.style.copyWith(borderColor: val),
                      ),
                    ),
                    const SizedBox(height: 12),
                    PropertyBuilderUtils.buildNumberSlider(
                      label: 'Border Width',
                      value: widget.question.style.borderWidth,
                      min: 0,
                      max: 10,
                      onChanged: (val) => _updateStyle(
                        ref,
                        widget.question.style.copyWith(borderWidth: val),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          ExpansionTile(
            title: const Text(
              'State Colors',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.textDark,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: PropertyBuilderUtils.buildColorPicker(
                        label: 'Focus',
                        value: widget.question.style.focusColor,
                        onChanged: (val) => _updateStyle(
                          ref,
                          widget.question.style.copyWith(focusColor: val),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: PropertyBuilderUtils.buildColorPicker(
                        label: 'Error',
                        value: widget.question.style.errorColor,
                        onChanged: (val) => _updateStyle(
                          ref,
                          widget.question.style.copyWith(errorColor: val),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (showIcons)
            ExpansionTile(
              title: const Text(
                'Icons',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.textDark,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildIconPicker(
                          label: 'Prefix Icon',
                          currentIcon: widget.question.style.prefixIcon,
                          onChanged: (val) => _updateStyle(
                            ref,
                            widget.question.style.copyWith(prefixIcon: val),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildIconPicker(
                          label: 'Suffix Icon',
                          currentIcon: widget.question.style.suffixIcon,
                          onChanged: (val) => _updateStyle(
                            ref,
                            widget.question.style.copyWith(suffixIcon: val),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildResetButton() {
    return TextButton.icon(
      onPressed: () {
        // Reset detailed style to default
        _updateStyle(ref, const QuestionStyle());
      },
      icon: const Icon(Icons.refresh, size: 16),
      label: const Text('Reset to Global Theme'),
    );
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PropertyBuilderUtils.buildNumberSlider(
              label: 'Size',
              value: fontSize,
              min: 10,
              max: 32,
              onChanged: (val) => onChanged(val, color, fontWeight),
            ),
            const SizedBox(height: 12),
            PropertyBuilderUtils.buildColorPicker(
              label: 'Color',
              value: color,
              onChanged: (val) => onChanged(fontSize, val, fontWeight),
            ),
          ],
        ),
        const SizedBox(height: 8),
        PropertyBuilderUtils.buildDropdown<String>(
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

  Widget _buildIconPicker({
    required String label,
    required String? currentIcon,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: AppColors.textDark),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showIconPickerDialog(onChanged),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderLight),
              borderRadius: BorderRadius.circular(8),
              color: AppColors.builderElement,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (currentIcon != null && currentIcon.isNotEmpty)
                  Text(currentIcon, style: const TextStyle(fontSize: 24))
                else
                  const Text(
                    'Select',
                    style: TextStyle(color: AppColors.textGrey),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showIconPickerDialog(Function(String) onSelected) {
    final Map<String, IconData> icons = {
      'email': Icons.email,
      'person': Icons.person,
      'phone': Icons.phone,
      'lock': Icons.lock,
      'calendar_today': Icons.calendar_today,
      'access_time': Icons.access_time,
      'visibility': Icons.visibility,
      'attach_file': Icons.attach_file,
      'search': Icons.search,
      'home': Icons.home,
      'work': Icons.work,
      'info': Icons.info,
      'check': Icons.check,
      'close': Icons.close,
    };

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Icon'),
        content: SizedBox(
          width: double.maxFinite,
          child: GridView.count(
            crossAxisCount: 5,
            shrinkWrap: true,
            children: icons.entries
                .map(
                  (e) => IconButton(
                    icon: Icon(e.value),
                    onPressed: () {
                      onSelected(e.key);
                      Navigator.pop(context);
                    },
                  ),
                )
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
