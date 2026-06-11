import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/app/theme/app_colors.dart';
import 'package:frontend/app/theme/tokens.dart';
import 'package:frontend/shared/models/form_models.dart' hide Form;
import 'package:frontend/modules/forms/models/form_style.dart';
import 'package:frontend/modules/forms/models/question_type.dart';
import 'package:frontend/modules/forms/services/form_builder_controller.dart';
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
  static const Map<String, IconData> _iconOptions = {
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

  FormBuilderController _controller() {
    return ref.read(formBuilderControllerProvider(widget.formId).notifier);
  }

  void _updateStyle(WidgetRef ref, QuestionStyle newStyle) {
    if (_formKey.currentState!.validate()) {
      _controller().updateQuestion(
            widget.question.copyWith(
              ui: {...widget.question.ui, 'style': newStyle.toJson()},
            ),
          );
    }
  }

  void _updateMetadata(WidgetRef ref, String key, dynamic value) {
    _controller().updateQuestionMetadata(widget.question.id, {key: value});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.question.type == QuestionType.spacer) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(DesignTokens.spaceL),
          child: Text(
            'No style settings for Spacer.',
            style: TextStyle(
              color: AppColors.textGrey,
              fontSize: DesignTokens.fontS,
            ),
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
            const SizedBox(height: DesignTokens.spaceM),
            const Text(
              'DIVIDER STYLE',
              style: TextStyle(
                color: AppColors.textGrey,
                fontSize: DesignTokens.fontS,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: DesignTokens.spaceM),
            const Text('Quick Palette', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 4),
            _buildColorSwatches(
              value: widget.question.styleObject.borderColor,
              onChanged: (val) => _updateStyle(
                ref,
                widget.question.styleObject.copyWith(borderColor: val),
              ),
            ),
            const SizedBox(height: 4),
            PropertyBuilderUtils.buildColorPicker(
              label: 'Line Color',
              value: widget.question.styleObject.borderColor,
              onChanged: (val) => _updateStyle(
                ref,
                widget.question.styleObject.copyWith(borderColor: val),
              ),
            ),
            const SizedBox(height: DesignTokens.spaceS + 4),
            PropertyBuilderUtils.buildNumberSlider(
              label: 'Thickness',
              value: widget.question.styleObject.borderWidth,
              min: 1,
              max: 10,
              onChanged: (val) => _updateStyle(
                ref,
                widget.question.styleObject.copyWith(borderWidth: val),
              ),
            ),
            const SizedBox(height: DesignTokens.spaceS + 4),
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
          const SizedBox(height: DesignTokens.spaceM),

          ExpansionTile(
            title: const Text(
              'Typography',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: DesignTokens.fontM,
                color: AppColors.textDark,
              ),
            ),
            initiallyExpanded: true,
            children: [
              Padding(
                padding: const EdgeInsets.all(DesignTokens.spaceS),
                child: Column(
                  children: [
                    _buildTypographyGroup(
                      'Label',
                      widget.question.styleObject.labelFontSize,
                      widget.question.styleObject.labelColor,
                      widget.question.styleObject.labelFontWeight,
                      (s, c, w) => _updateStyle(
                        ref,
                        widget.question.styleObject.copyWith(
                          labelFontSize: s,
                          labelColor: c,
                          labelFontWeight: w,
                        ),
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spaceM),
                    _buildTypographyGroup(
                      'Helper Text',
                      widget.question.styleObject.helperFontSize,
                      widget.question.styleObject.helperColor,
                      widget.question.styleObject.helperFontWeight,
                      (s, c, w) => _updateStyle(
                        ref,
                        widget.question.styleObject.copyWith(
                          helperFontSize: s,
                          helperColor: c,
                          helperFontWeight: w,
                        ),
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spaceM),
                    _buildTypographyGroup(
                      'Input Text',
                      widget.question.styleObject.inputFontSize,
                      widget.question.styleObject.inputFontColor,
                      widget.question.styleObject.inputFontWeight,
                      (s, c, w) => _updateStyle(
                        ref,
                        widget.question.styleObject.copyWith(
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
                fontSize: DesignTokens.fontM,
                color: AppColors.textDark,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(DesignTokens.spaceS),
                child: Column(
                  children: [
                    PropertyBuilderUtils.buildDropdown<String>(
                      label: 'Style',
                      value: widget.question.styleObject.inputStyle,
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
                            widget.question.styleObject.copyWith(inputStyle: val),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: DesignTokens.spaceS + 4),
                    PropertyBuilderUtils.buildNumberSlider(
                      label: 'Border Radius',
                      value: widget.question.styleObject.borderRadius,
                      min: 0,
                      max: 32,
                      onChanged: (val) => _updateStyle(
                        ref,
                        widget.question.styleObject.copyWith(borderRadius: val),
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spaceS + 4),

                    // Shadow Settings
                    PropertyBuilderUtils.buildNumberSlider(
                      label: 'Shadow Elevation',
                      value: (widget.question.metadata['elevation'] ?? 0)
                          .toDouble(),
                      min: 0,
                      max: 10,
                      onChanged: (val) => _updateMetadata(
                        ref,
                        'elevation',
                        val,
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spaceS + 4),
                    if ((widget.question.metadata['elevation'] ?? 0) > 0) ...[
                      const Text('Quick Palette', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                      const SizedBox(height: 4),
                      _buildColorSwatches(
                        value: widget.question.metadata['shadowColor'] ?? '#000000',
                        onChanged: (val) => _updateMetadata(ref, 'shadowColor', val),
                      ),
                      const SizedBox(height: 4),
                      PropertyBuilderUtils.buildColorPicker(
                        label: 'Shadow Color',
                        value:
                        widget.question.metadata['shadowColor'] ??
                            '#000000',
                        onChanged: (val) => _updateMetadata(
                          ref,
                          'shadowColor',
                          val,
                        ),
                      ),
                    ],

                    const SizedBox(height: DesignTokens.spaceS + 4),
                    const Text('Background Quick Palette', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                    const SizedBox(height: 4),
                    _buildColorSwatches(
                      value: widget.question.styleObject.backgroundColor,
                      onChanged: (val) => _updateStyle(
                        ref,
                        widget.question.styleObject.copyWith(backgroundColor: val),
                      ),
                    ),
                    const SizedBox(height: 4),
                    PropertyBuilderUtils.buildColorPicker(
                      label: 'Background Color',
                      value: widget.question.styleObject.backgroundColor,
                      onChanged: (val) => _updateStyle(
                        ref,
                        widget.question.styleObject.copyWith(backgroundColor: val),
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spaceS + 4),
                    const Text('Border Quick Palette', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                    const SizedBox(height: 4),
                    _buildColorSwatches(
                      value: widget.question.styleObject.borderColor,
                      onChanged: (val) => _updateStyle(
                        ref,
                        widget.question.styleObject.copyWith(borderColor: val),
                      ),
                    ),
                    const SizedBox(height: 4),
                    PropertyBuilderUtils.buildColorPicker(
                      label: 'Border Color',
                      value: widget.question.styleObject.borderColor,
                      onChanged: (val) => _updateStyle(
                        ref,
                        widget.question.styleObject.copyWith(borderColor: val),
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spaceS + 4),
                    PropertyBuilderUtils.buildNumberSlider(
                      label: 'Border Width',
                      value: widget.question.styleObject.borderWidth,
                      min: 0,
                      max: 10,
                      onChanged: (val) => _updateStyle(
                        ref,
                        widget.question.styleObject.copyWith(borderWidth: val),
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
                fontSize: DesignTokens.fontM,
                color: AppColors.textDark,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(DesignTokens.spaceS),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Quick Palette', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                          const SizedBox(height: 4),
                          _buildColorSwatches(
                            value: widget.question.styleObject.focusColor,
                            onChanged: (val) => _updateStyle(
                              ref,
                              widget.question.styleObject.copyWith(focusColor: val),
                            ),
                          ),
                          const SizedBox(height: 4),
                          PropertyBuilderUtils.buildColorPicker(
                            label: 'Focus',
                            value: widget.question.styleObject.focusColor,
                            onChanged: (val) => _updateStyle(
                              ref,
                              widget.question.styleObject.copyWith(focusColor: val),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: DesignTokens.spaceS),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Quick Palette', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                          const SizedBox(height: 4),
                          _buildColorSwatches(
                            value: widget.question.styleObject.errorColor,
                            onChanged: (val) => _updateStyle(
                              ref,
                              widget.question.styleObject.copyWith(errorColor: val),
                            ),
                          ),
                          const SizedBox(height: 4),
                          PropertyBuilderUtils.buildColorPicker(
                            label: 'Error',
                            value: widget.question.styleObject.errorColor,
                            onChanged: (val) => _updateStyle(
                              ref,
                              widget.question.styleObject.copyWith(errorColor: val),
                            ),
                          ),
                        ],
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
                fontSize: DesignTokens.fontM,
                  color: AppColors.textDark,
                ),
              ),
              children: [
                Padding(
                padding: const EdgeInsets.all(DesignTokens.spaceS),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildIconPicker(
                          label: 'Prefix Icon',
                          currentIcon: widget.question.styleObject.prefixIcon,
                          onChanged: (val) => _updateStyle(
                            ref,
                            widget.question.styleObject.copyWith(prefixIcon: val),
                          ),
                        ),
                      ),
                      const SizedBox(width: DesignTokens.spaceS + 4),
                      Expanded(
                        child: _buildIconPicker(
                          label: 'Suffix Icon',
                          currentIcon: widget.question.styleObject.suffixIcon,
                          onChanged: (val) => _updateStyle(
                            ref,
                            widget.question.styleObject.copyWith(suffixIcon: val),
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
            fontSize: DesignTokens.fontS,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: DesignTokens.spaceS),
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
            const SizedBox(height: DesignTokens.spaceS + 4),
            const Text('Quick Palette', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 4),
            _buildColorSwatches(
              value: color,
              onChanged: (val) => onChanged(fontSize, val, fontWeight),
            ),
            const SizedBox(height: 4),
            PropertyBuilderUtils.buildColorPicker(
              label: 'Color',
              value: color,
              onChanged: (val) => onChanged(fontSize, val, fontWeight),
            ),
          ],
        ),
        const SizedBox(height: DesignTokens.spaceS),
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
          style: const TextStyle(fontSize: DesignTokens.fontS, color: AppColors.textDark),
        ),
        const SizedBox(height: DesignTokens.spaceS),
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
                  Text(
                    currentIcon,
                    style: const TextStyle(fontSize: DesignTokens.fontL),
                  )
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Icon'),
        content: SizedBox(
          width: double.maxFinite,
          child: GridView.count(
            crossAxisCount: 5,
            shrinkWrap: true,
            children: _iconOptions.entries
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

  Widget _buildColorSwatches({
    required String value,
    required ValueChanged<String> onChanged,
  }) {
    final colors = ['#FFFFFF', '#F5F5F5', '#E0E0E0', '#2196F3', '#4CAF50', '#FFC107', '#F44336', '#9C27B0'];
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
                      color: col.toLowerCase() == '#ffffff' ? Colors.black : Colors.white,
                    )
                  : null,
            ),
          );
        }).toList(),
      ),
    );
  }
}
