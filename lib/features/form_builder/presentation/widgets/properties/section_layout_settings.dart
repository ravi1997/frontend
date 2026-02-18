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

  void _updateSection(WidgetRef ref, FormSection updatedSection) {
    ref
        .read(formBuilderControllerProvider(formId).notifier)
        .updateSection(updatedSection);
  }

  void _updateMetadata(WidgetRef ref, String key, dynamic value) {
    ref
        .read(formBuilderControllerProvider(formId).notifier)
        .updateSectionMetadata(section.id, {key: value});
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metadata = section.metadata;

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
              _updateSection(ref, section.copyWith(layout: val));
            }
          },
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.builderElement.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Description',
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
              _updateSection(ref, section.copyWith(gridColumns: val.toInt()));
            },
          ),
        ],

        const SizedBox(height: 24),
        const Text(
          'SPACING & ALIGNMENT',
          style: TextStyle(
            color: AppColors.textGrey,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 16),

        PropertyBuilderUtils.buildNumberSlider(
          label: 'Field Spacing (Gap)',
          value: (metadata['fieldGap'] ?? 16.0).toDouble(),
          min: 0,
          max: 48,
          onChanged: (val) => _updateMetadata(ref, 'fieldGap', val),
        ),
        const SizedBox(height: 12),

        PropertyBuilderUtils.buildNumberSlider(
          label: 'Vertical Padding',
          value: (metadata['verticalPadding'] ?? section.style.padding)
              .toDouble(),
          min: 0,
          max: 64,
          onChanged: (val) => _updateMetadata(ref, 'verticalPadding', val),
        ),
        const SizedBox(height: 12),

        PropertyBuilderUtils.buildNumberSlider(
          label: 'Horizontal Padding',
          value: (metadata['horizontalPadding'] ?? section.style.padding)
              .toDouble(),
          min: 0,
          max: 64,
          onChanged: (val) => _updateMetadata(ref, 'horizontalPadding', val),
        ),
        const SizedBox(height: 12),

        PropertyBuilderUtils.buildDropdown<String>(
          label: 'Content Alignment',
          value: metadata['alignment'] ?? 'center',
          items: const [
            DropdownMenuItem(value: 'left', child: Text('Left')),
            DropdownMenuItem(value: 'center', child: Text('Center')),
            DropdownMenuItem(value: 'right', child: Text('Right')),
          ],
          onChanged: (val) => _updateMetadata(ref, 'alignment', val),
        ),

        const SizedBox(height: 24),
        PropertyBuilderUtils.buildNumberSlider(
          label: 'Max Width (px)',
          value: (metadata['maxWidth'] ?? 1200.0).toDouble(),
          min: 400,
          max: 2000,
          onChanged: (val) => _updateMetadata(ref, 'maxWidth', val),
        ),
      ],
    );
  }
}
