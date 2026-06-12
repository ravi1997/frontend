import 'package:flutter/material.dart';
import 'package:frontend/app/theme/tokens.dart';
import 'package:frontend/modules/forms/widgets/property_builder_utils.dart';
import 'package:frontend/modules/forms/widgets/form_branding_settings.dart';

class FormStyleSettings extends StatelessWidget {
  final Map<String, dynamic> form;
  final Function(Map<String, dynamic>) onChanged;

  const FormStyleSettings({
    super.key,
    required this.form,
    required this.onChanged,
  });

  Widget _buildColorSwatches(String value, ValueChanged<String> onChanged) {
    final colors = [
      '#FFFFFF',
      '#F5F5F5',
      '#E0E0E0',
      '#2196F3',
      '#4CAF50',
      '#FFC107',
      '#F44336',
      '#9C27B0',
    ];
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: colors.map((col) {
          final isSelected = col.toLowerCase() == value.toLowerCase();
          Color displayColor;
          try {
            displayColor = Color(int.parse(col.replaceAll('#', '0xFF')));
          } catch (_) {
            displayColor = Colors.transparent;
          }
          return GestureDetector(
            onTap: () => onChanged(col),
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: displayColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.black : Colors.grey.shade300,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      size: 14,
                      color: col.toLowerCase() == '#ffffff'
                          ? Colors.black
                          : Colors.white,
                    )
                  : null,
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = form['backgroundColor']?.toString() ?? '#FFFFFF';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Style Settings', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: DesignTokens.spaceM),
        const Text(
          'Quick Palette',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 6),
        _buildColorSwatches(
          backgroundColor,
          (val) => onChanged({...form, 'backgroundColor': val}),
        ),
        const SizedBox(height: 8),
        PropertyBuilderUtils.buildColorPicker(
          label: 'Background Color',
          value: backgroundColor,
          onChanged: (value) {
            onChanged({...form, 'backgroundColor': value});
          },
        ),
        FormBrandingSettings(form: form, onChanged: onChanged),
      ],
    );
  }
}
