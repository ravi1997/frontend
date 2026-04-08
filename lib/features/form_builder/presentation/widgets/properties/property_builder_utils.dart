import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';

class PropertyBuilderUtils {
  static Widget buildTextField({
    required String label,
    String? placeholder,
    required TextEditingController controller,
    required Function(String) onChanged,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    bool readOnly = false,
    int maxLines = 1,
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
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          readOnly: readOnly,
          maxLines: maxLines,
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
    String? description,
  }) {
    final children = [
      Text(
        label,
        style: const TextStyle(
          color: AppColors.textDark,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      if (description != null) ...[
        const SizedBox(height: 4),
        Text(
          description,
          style: const TextStyle(color: AppColors.textGrey, fontSize: 12),
        ),
      ],
    ];

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: children,
          ),
        ),
        const SizedBox(width: 8),
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
    return _StatefulColorPicker(
      label: label,
      value: value,
      onChanged: onChanged,
      validator: validator,
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

  static Widget buildSectionHeader({required String title, Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textGrey,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }
}

class _StatefulColorPicker extends StatefulWidget {
  final String label;
  final String value;
  final Function(String) onChanged;
  final String? Function(String?)? validator;

  const _StatefulColorPicker({
    required this.label,
    required this.value,
    required this.onChanged,
    this.validator,
  });

  @override
  State<_StatefulColorPicker> createState() => _StatefulColorPickerState();
}

class _StatefulColorPickerState extends State<_StatefulColorPicker> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant _StatefulColorPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _controller.text) {
      if (!FocusScope.of(context).hasFocus) {
        _controller.text = widget.value;
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
    Color displayColor;
    try {
      displayColor = Color(int.parse(widget.value.replaceAll('#', '0xFF')));
    } catch (_) {
      displayColor = Colors.transparent;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
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
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: displayColor,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppColors.borderLight),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: _controller,
                onChanged: widget.onChanged,
                validator: widget.validator,
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
}
