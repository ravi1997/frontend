import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/form_builder/domain/entities/form_question.dart';
import 'package:frontend/features/form_builder/domain/entities/form_style.dart';
import 'package:frontend/features/form_builder/presentation/controllers/form_builder_controller.dart';
import 'property_builder_utils.dart';

class FieldStyleSettings extends ConsumerStatefulWidget { // Changed to ConsumerStatefulWidget
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

class _FieldStyleSettingsState extends ConsumerState<FieldStyleSettings> { // Added State class
  final _formKey = GlobalKey<FormState>(); // Added GlobalKey

  void _updateStyle(WidgetRef ref, QuestionStyle newStyle) {
    if (_formKey.currentState!.validate()) { // Validate before updating
      ref
          .read(formBuilderControllerProvider(widget.formId).notifier) // Access via widget
          .updateQuestion(widget.question.copyWith(style: newStyle)); // Access via widget
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
                validator: (value) { // Added validator
                  if (value == null || value.isEmpty) return 'Color is required';
                  if (!RegExp(r'^#([0-9a-fA-F]{3}){1,2}$').hasMatch(value)) {
                    return 'Invalid hex color';
                  }
                  return null;
                },
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
  Widget build(BuildContext context) {
    return Form( // Added Form widget
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
            widget.question.style.labelFontSize, // Access via widget
            widget.question.style.labelColor, // Access via widget
            widget.question.style.labelFontWeight, // Access via widget
            (s, c, w) => _updateStyle(
              ref,
              widget.question.style.copyWith( // Access via widget
                labelFontSize: s,
                labelColor: c,
                labelFontWeight: w,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildTypographyGroup(
            'Helper Text',
            widget.question.style.helperFontSize, // Access via widget
            widget.question.style.helperColor, // Access via widget
            widget.question.style.helperFontWeight, // Access via widget
            (s, c, w) => _updateStyle(
              ref,
              widget.question.style.copyWith( // Access via widget
                helperFontSize: s,
                helperColor: c,
                helperFontWeight: w,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildTypographyGroup(
            'Input Text',
            widget.question.style.inputFontSize, // Access via widget
            widget.question.style.inputFontColor, // Access via widget
            widget.question.style.inputFontWeight, // Access via widget
            (s, c, w) => _updateStyle(
              ref,
              widget.question.style.copyWith( // Access via widget
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
            value: widget.question.style.inputStyle, // Access via widget
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
                _updateStyle(ref, widget.question.style.copyWith(inputStyle: val)); // Access via widget
              }
            },
          ),
          const SizedBox(height: 12),
          PropertyBuilderUtils.buildNumberSlider(
            label: 'Border Radius',
            value: widget.question.style.borderRadius, // Access via widget
            min: 0,
            max: 32,
            onChanged: (val) =>
                _updateStyle(ref, widget.question.style.copyWith(borderRadius: val)), // Access via widget
          ),
          const SizedBox(height: 12),
          PropertyBuilderUtils.buildColorPicker(
            label: 'Background Color',
            value: widget.question.style.backgroundColor, // Access via widget
            onChanged: (val) =>
                _updateStyle(ref, widget.question.style.copyWith(backgroundColor: val)), // Access via widget
            validator: (value) { // Added validator
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
            value: widget.question.style.borderColor, // Access via widget
            onChanged: (val) =>
                _updateStyle(ref, widget.question.style.copyWith(borderColor: val)), // Access via widget
            validator: (value) { // Added validator
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
            value: widget.question.style.borderWidth, // Access via widget
            min: 0,
            max: 10,
            onChanged: (val) =>
                _updateStyle(ref, widget.question.style.copyWith(borderWidth: val)), // Access via widget
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
                  value: widget.question.style.focusColor, // Access via widget
                  onChanged: (val) =>
                      _updateStyle(ref, widget.question.style.copyWith(focusColor: val)), // Access via widget
                  validator: (value) { // Added validator
                  if (value == null || value.isEmpty) return 'Color is required';
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
                  value: widget.question.style.errorColor, // Access via widget
                  onChanged: (val) =>
                      _updateStyle(ref, widget.question.style.copyWith(errorColor: val)), // Access via widget
                  validator: (value) { // Added validator
                  if (value == null || value.isEmpty) return 'Color is required';
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
            value: widget.question.style.hoverColor, // Access via widget
            onChanged: (val) =>
                _updateStyle(ref, widget.question.style.copyWith(hoverColor: val)), // Access via widget
            validator: (value) { // Added validator
                  if (value == null || value.isEmpty) return 'Color is required';
                  if (!RegExp(r'^#([0-9a-fA-F]{3}){1,2}$').hasMatch(value)) {
                    return 'Invalid hex color';
                  }
                  return null;
                },
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
                  controller: widget.prefixIconController, // Access via widget
                  onChanged: (val) =>
                      _updateStyle(ref, widget.question.style.copyWith(prefixIcon: val)), // Access via widget
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PropertyBuilderUtils.buildTextField(
                  label: 'Suffix Icon',
                  placeholder: 'e.g. 👁️',
                  controller: widget.suffixIconController, // Access via widget
                  onChanged: (val) =>
                      _updateStyle(ref, widget.question.style.copyWith(suffixIcon: val)), // Access via widget
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
