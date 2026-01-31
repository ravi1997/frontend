import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/form_builder/domain/entities/form_section.dart';
import 'package:frontend/features/form_builder/domain/entities/section_layout_type.dart';
import 'package:frontend/features/form_builder/presentation/controllers/form_builder_controller.dart';
import 'property_builder_utils.dart';

class SectionLayoutSettings extends ConsumerWidget {
  final String formId;
  final FormSection section;

  const SectionLayoutSettings({
    super.key,
    required this.formId,
    required this.section,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PropertyBuilderUtils.buildDropdown<SectionLayoutType>(
          label: 'Section Layout',
          value: section.layout,
          items: SectionLayoutType.values.map((type) {
            return DropdownMenuItem(value: type, child: Text(type.label));
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              ref
                  .read(formBuilderControllerProvider(formId).notifier)
                  .updateSection(section.copyWith(layout: val));
            }
          },
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.builderElement.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Description",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textGrey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                section.layout.description,
                style: const TextStyle(fontSize: 13, color: AppColors.textDark),
              ),
            ],
          ),
        ),
        if (section.layout == SectionLayoutType.grid) ...[
          const SizedBox(height: 24),
          PropertyBuilderUtils.buildNumberSlider(
            label: 'Grid Columns',
            value: section.gridColumns.toDouble(),
            min: 2,
            max: 4,
            onChanged: (val) {
              ref
                  .read(formBuilderControllerProvider(formId).notifier)
                  .updateSection(section.copyWith(gridColumns: val.toInt()));
            },
          ),
        ],
        const SizedBox(height: 24),
        const Text(
          'SPACING',
          style: TextStyle(
            color: AppColors.textGrey,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 16),
        PropertyBuilderUtils.buildNumberSlider(
          label: 'Inner Padding',
          value: section.style.padding,
          min: 0,
          max: 64,
          onChanged: (val) {
            ref
                .read(formBuilderControllerProvider(formId).notifier)
                .updateSection(
                  section.copyWith(style: section.style.copyWith(padding: val)),
                );
          },
        ),
      ],
    );
  }
}
