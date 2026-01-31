import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/form_builder/domain/entities/form_question.dart';
import 'package:frontend/features/form_builder/domain/entities/form_style.dart';
import 'package:frontend/features/form_builder/presentation/controllers/form_builder_controller.dart';
import 'property_builder_utils.dart';

class FieldStyleSettings extends ConsumerWidget {
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

  void _updateStyle(WidgetRef ref, QuestionStyle newStyle) {
    ref
        .read(formBuilderControllerProvider(formId).notifier)
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
              child: PropertyBuilderUtils.buildNumberSlider(
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
              child: PropertyBuilderUtils.buildColorPicker(
                label: 'Color',
                value: color,
                onChanged: (val) => onChanged(fontSize, val, fontWeight),
              ),
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
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
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
            ref,
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
            ref,
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
            ref,
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
        PropertyBuilderUtils.buildDropdown<String>(
          label: 'Style',
          value: question.style.inputStyle,
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
              _updateStyle(ref, question.style.copyWith(inputStyle: val));
            }
          },
        ),
        const SizedBox(height: 12),
        PropertyBuilderUtils.buildNumberSlider(
          label: 'Border Radius',
          value: question.style.borderRadius,
          min: 0,
          max: 32,
          onChanged: (val) =>
              _updateStyle(ref, question.style.copyWith(borderRadius: val)),
        ),
        const SizedBox(height: 12),
        PropertyBuilderUtils.buildColorPicker(
          label: 'Background Color',
          value: question.style.backgroundColor,
          onChanged: (val) =>
              _updateStyle(ref, question.style.copyWith(backgroundColor: val)),
        ),
        const SizedBox(height: 12),
        PropertyBuilderUtils.buildColorPicker(
          label: 'Border Color',
          value: question.style.borderColor,
          onChanged: (val) =>
              _updateStyle(ref, question.style.copyWith(borderColor: val)),
        ),
        const SizedBox(height: 12),
        PropertyBuilderUtils.buildNumberSlider(
          label: 'Border Width',
          value: question.style.borderWidth,
          min: 0,
          max: 10,
          onChanged: (val) =>
              _updateStyle(ref, question.style.copyWith(borderWidth: val)),
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
                value: question.style.focusColor,
                onChanged: (val) =>
                    _updateStyle(ref, question.style.copyWith(focusColor: val)),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: PropertyBuilderUtils.buildColorPicker(
                label: 'Error',
                value: question.style.errorColor,
                onChanged: (val) =>
                    _updateStyle(ref, question.style.copyWith(errorColor: val)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        PropertyBuilderUtils.buildColorPicker(
          label: 'Hover',
          value: question.style.hoverColor,
          onChanged: (val) =>
              _updateStyle(ref, question.style.copyWith(hoverColor: val)),
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
              child: PropertyBuilderUtils.buildTextField(
                label: 'Prefix Icon',
                placeholder: 'e.g. ✉️',
                controller: prefixIconController,
                onChanged: (val) =>
                    _updateStyle(ref, question.style.copyWith(prefixIcon: val)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: PropertyBuilderUtils.buildTextField(
                label: 'Suffix Icon',
                placeholder: 'e.g. 👁️',
                controller: suffixIconController,
                onChanged: (val) =>
                    _updateStyle(ref, question.style.copyWith(suffixIcon: val)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
