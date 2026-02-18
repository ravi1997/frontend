import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/form_builder/domain/entities/form_question.dart';
import 'package:frontend/features/form_builder/domain/entities/form_style.dart';
import 'package:frontend/features/form_builder/domain/entities/question_type.dart';
import 'package:frontend/features/form_builder/presentation/controllers/form_builder_controller.dart';
import 'property_builder_utils.dart';

class FieldStyleSettings extends ConsumerStatefulWidget {
  // Changed to ConsumerStatefulWidget
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
  // Added State class
  final _formKey = GlobalKey<FormState>(); // Added GlobalKey

  void _updateStyle(WidgetRef ref, QuestionStyle newStyle) {
    if (_formKey.currentState!.validate()) {
      // Validate before updating
      ref
          .read(
            formBuilderControllerProvider(widget.formId).notifier,
          ) // Access via widget
          .updateQuestion(
            widget.question.copyWith(style: newStyle),
          ); // Access via widget
    }
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
              validator: (value) {
                // Added validator
                if (value == null || value.isEmpty) return 'Color is required';
                if (!RegExp(r'^#([0-9a-fA-F]{3}){1,2}$').hasMatch(value)) {
                  return 'Invalid hex color';
                }
                return null;
              },
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
              value: widget.question.metadata?['dividerStyle'] ?? 'solid',
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

    // Standard fields style
    final showIcons = [
      QuestionType.shortText,
      QuestionType.number,
      QuestionType.email,
      QuestionType.url,
      QuestionType.mobile,
      QuestionType.date,
      QuestionType.time,
      QuestionType
          .dropdown, // Dropdowns can technically have icons in some designs
    ].contains(widget.question.type);

    return Form(
      key: _formKey,
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
          PropertyBuilderUtils.buildDropdown<String>(
            label: 'Style',
            value: widget.question.style.inputStyle,
            items: const [
              DropdownMenuItem(
                value: 'outlined',
                child: Text('Boxed (Outlined)'),
              ),
              DropdownMenuItem(value: 'rounded', child: Text('Rounded')),
              DropdownMenuItem(value: 'underlined', child: Text('Underlined')),
              DropdownMenuItem(value: 'filled', child: Text('Filled')),
              DropdownMenuItem(value: 'glass', child: Text('Glassmorphism')),
              DropdownMenuItem(value: 'minimalist', child: Text('Minimalist')),
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
          PropertyBuilderUtils.buildColorPicker(
            label: 'Background Color',
            value: widget.question.style.backgroundColor,
            onChanged: (val) => _updateStyle(
              ref,
              widget.question.style.copyWith(backgroundColor: val),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Color is required';
              if (!RegExp(r'^#([0-9a-fA-F]{3}){1,2}$').hasMatch(value)) {
                return 'Invalid hex color';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          PropertyBuilderUtils.buildColorPicker(
            label: 'Border Color',
            value: widget.question.style.borderColor,
            onChanged: (val) => _updateStyle(
              ref,
              widget.question.style.copyWith(borderColor: val),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Color is required';
              if (!RegExp(r'^#([0-9a-fA-F]{3}){1,2}$').hasMatch(value)) {
                return 'Invalid hex color';
              }
              return null;
            },
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
                child: PropertyBuilderUtils.buildColorPicker(
                  label: 'Focus',
                  value: widget.question.style.focusColor,
                  onChanged: (val) => _updateStyle(
                    ref,
                    widget.question.style.copyWith(focusColor: val),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Color is required';
                    if (!RegExp(r'^#([0-9a-fA-F]{3}){1,2}$').hasMatch(value)) {
                      return 'Invalid hex color';
                    }
                    return null;
                  },
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
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Color is required';
                    if (!RegExp(r'^#([0-9a-fA-F]{3}){1,2}$').hasMatch(value)) {
                      return 'Invalid hex color';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          PropertyBuilderUtils.buildColorPicker(
            label: 'Hover',
            value: widget.question.style.hoverColor,
            onChanged: (val) => _updateStyle(
              ref,
              widget.question.style.copyWith(hoverColor: val),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Color is required';
              if (!RegExp(r'^#([0-9a-fA-F]{3}){1,2}$').hasMatch(value)) {
                return 'Invalid hex color';
              }
              return null;
            },
          ),

          if (showIcons) ...[
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
                  child: PropertyBuilderUtils.buildTextField(
                    label: 'Prefix Icon',
                    placeholder: 'e.g. ✉️',
                    controller: widget.prefixIconController,
                    onChanged: (val) => _updateStyle(
                      ref,
                      widget.question.style.copyWith(prefixIcon: val),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PropertyBuilderUtils.buildTextField(
                    label: 'Suffix Icon',
                    placeholder: 'e.g. 👁️',
                    controller: widget.suffixIconController,
                    onChanged: (val) => _updateStyle(
                      ref,
                      widget.question.style.copyWith(suffixIcon: val),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
