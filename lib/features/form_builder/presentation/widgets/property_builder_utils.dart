import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
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
    TextStyle? textStyle,
    TextStyle? labelStyle,
    TextStyle? hintStyle,
    Color? fillColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: labelStyle ??
              const TextStyle(
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
            hintStyle: hintStyle ?? const TextStyle(color: Colors.black26),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            filled: true,
            fillColor: fillColor ?? AppColors.builderElement,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
          style: textStyle ?? const TextStyle(color: AppColors.textDark),
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
    bool showHexInput = true,
  }) {
    return _StatefulColorPicker(
      label: label,
      value: value,
      onChanged: onChanged,
      validator: validator,
      showHexInput: showHexInput,
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
  final bool showHexInput;

  const _StatefulColorPicker({
    required this.label,
    required this.value,
    required this.onChanged,
    this.validator,
    this.showHexInput = true,
  });

  @override
  State<_StatefulColorPicker> createState() => _StatefulColorPickerState();
}

class _StatefulColorPickerState extends State<_StatefulColorPicker> {
  late TextEditingController _controller;
  late Color _pickedColor;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _pickedColor = _parseColor(widget.value);
  }

  @override
  void didUpdateWidget(covariant _StatefulColorPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _controller.text) {
      if (!FocusScope.of(context).hasFocus) {
        _controller.text = widget.value;
        _pickedColor = _parseColor(widget.value);
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
    final displayColor = _pickedColor;

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
        if (widget.showHexInput)
          Row(
            children: [
              InkWell(
                onTap: () => _showColorDialog(context),
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: displayColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.borderLight),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
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
          )
        else
          InkWell(
            onTap: () => _showColorDialog(context),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.builderElement,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: displayColor,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.value.isEmpty ? 'Choose color' : widget.value,
                      style: const TextStyle(
                        color: AppColors.textDark,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const Icon(Icons.color_lens_outlined, size: 18),
                ],
              ),
            ),
          ),
      ],
    );
  }

  void _showColorDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        var tempColor = _pickedColor;
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final compact = width < 420;

                  return StatefulBuilder(
                    builder: (context, setState) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.label,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textDark,
                                  ),
                                ),
                              ),
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: tempColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.borderLight,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: ColorPicker(
                              pickerColor: tempColor,
                              onColorChanged: (color) {
                                setState(() => tempColor = color);
                                _controller.text = _formatColor(color);
                              },
                              colorPickerWidth: width,
                              pickerAreaHeightPercent: compact ? 0.58 : 0.72,
                              displayThumbColor: true,
                              paletteType: PaletteType.hsvWithHue,
                              labelTypes: const [],
                              pickerAreaBorderRadius: const BorderRadius.all(
                                Radius.circular(16),
                              ),
                              enableAlpha: true,
                              hexInputBar: false,
                              portraitOnly: true,
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (compact)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  _formatColor(tempColor),
                                  style: const TextStyle(
                                    color: AppColors.textDark,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: FilledButton(
                                        onPressed: () {
                                          final value =
                                              _formatColor(tempColor);
                                          widget.onChanged(value);
                                          _controller.text = value;
                                          _pickedColor = tempColor;
                                          Navigator.of(dialogContext).pop();
                                        },
                                        child: const Text('Apply'),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(dialogContext).pop(),
                                      child: const Text('Close'),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          else
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _formatColor(tempColor),
                                    style: const TextStyle(
                                      color: AppColors.textDark,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                FilledButton(
                                  onPressed: () {
                                    final value = _formatColor(tempColor);
                                    widget.onChanged(value);
                                    _controller.text = value;
                                    _pickedColor = tempColor;
                                    Navigator.of(dialogContext).pop();
                                  },
                                  child: const Text('Apply'),
                                ),
                                const SizedBox(width: 8),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(dialogContext).pop(),
                                  child: const Text('Close'),
                                ),
                              ],
                            ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Color _parseColor(String value) {
    try {
      return Color(int.parse(value.replaceAll('#', '0xFF')));
    } catch (_) {
      return Colors.transparent;
    }
  }

  String _formatColor(Color color) {
    final hex = color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase();
    return '#${hex.substring(2)}';
  }
}
