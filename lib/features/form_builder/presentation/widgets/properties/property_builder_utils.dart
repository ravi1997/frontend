import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';

class PropertyBuilderUtils {
  static Widget buildTextField({
    required String label,
    String? placeholder,
    required TextEditingController controller,
    required Function(String) onChanged,
    TextInputType? keyboardType,
    String? Function(String?)? validator, // Added validator
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
        TextFormField(
          // Changed from TextField
          controller: controller,
          keyboardType: keyboardType,
          validator: validator, // Passed validator
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

  static Widget buildSwitch({
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

  static Widget buildNumberSlider({
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

  static Widget buildColorPicker({
    required String label,
    required String value,
    required Function(String) onChanged,
    String? Function(String?)? validator,
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
              child: TextFormField(
                key: ValueKey(
                  label,
                ), // Use label as key to avoid losing state but allow updates? No, Key(label) is fine.
                controller: TextEditingController(text: value)
                  ..selection = TextSelection.fromPosition(
                    TextPosition(offset: value.length),
                  ),
                onChanged: onChanged,
                validator: validator,
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

  static Widget buildDropdown<T>({
    required String label,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required Function(T?) onChanged,
    String? hint,
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
              hint: hint != null ? Text(hint) : null,
            ),
          ),
        ),
      ],
    );
  }
}
