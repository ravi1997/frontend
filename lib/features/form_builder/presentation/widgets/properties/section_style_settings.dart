import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/form_builder/domain/entities/form_section.dart';
import 'package:frontend/features/form_builder/domain/entities/form_style.dart';
import 'package:frontend/features/form_builder/presentation/controllers/form_builder_controller.dart';
import 'property_builder_utils.dart';

class SectionStyleSettings extends ConsumerWidget {
  final String formId;
  final FormSection section;

  const SectionStyleSettings({
    super.key,
    required this.formId,
    required this.section,
  });

  void _updateStyle(WidgetRef ref, SectionStyle newStyle) {
    ref
        .read(formBuilderControllerProvider(formId).notifier)
        .updateSection(section.copyWith(style: newStyle));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'APPEARANCE',
          style: TextStyle(
            color: AppColors.textGrey,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 16),
        PropertyBuilderUtils.buildColorPicker(
          label: 'Background Color',
          value: section.style.backgroundColor,
          onChanged: (val) =>
              _updateStyle(ref, section.style.copyWith(backgroundColor: val)),
        ),
        const SizedBox(height: 12),
        PropertyBuilderUtils.buildNumberSlider(
          label: 'Border Radius',
          value: section.style.borderRadius,
          min: 0,
          max: 40,
          onChanged: (val) =>
              _updateStyle(ref, section.style.copyWith(borderRadius: val)),
        ),
        const SizedBox(height: 12),
        PropertyBuilderUtils.buildNumberSlider(
          label: 'Elevation',
          value: section.style.elevation,
          min: 0,
          max: 12,
          onChanged: (val) =>
              _updateStyle(ref, section.style.copyWith(elevation: val)),
        ),
        const SizedBox(height: 24),
        const Text(
          'HEADER',
          style: TextStyle(
            color: AppColors.textGrey,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 16),
        PropertyBuilderUtils.buildSwitch(
          label: 'Show Header',
          value: section.style.showHeader,
          onChanged: (val) =>
              _updateStyle(ref, section.style.copyWith(showHeader: val)),
        ),
        const SizedBox(height: 12),
        PropertyBuilderUtils.buildColorPicker(
          label: 'Header Color',
          value: section.style.headerBackgroundColor,
          onChanged: (val) => _updateStyle(
            ref,
            section.style.copyWith(headerBackgroundColor: val),
          ),
        ),
      ],
    );
  }
}
