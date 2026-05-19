import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/form_builder/domain/entities/form_section.dart';
import 'package:frontend/features/form_builder/domain/entities/section_layout_type.dart';
import 'property_builder_utils.dart';

class SectionLayoutSettings extends ConsumerWidget {
  final String projectId;
  final String formId;
  final FormSection section;
  final ValueChanged<FormSection> onSectionChanged;

  const SectionLayoutSettings({
    super.key,
    required this.projectId,
    required this.formId,
    required this.section,
    required this.onSectionChanged,
  });

  void _updateSection(FormSection updatedSection) {
    onSectionChanged(updatedSection);
  }

  void _updateMetadata(String key, dynamic value) {
    onSectionChanged(
      section.copyWith(metaData: {...section.metaData, key: value}),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metadata = section.metaData;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 360;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Section Layout',
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<SectionLayoutType>(
              initialValue: section.layout,
              isExpanded: true,
              itemHeight: null,
              menuMaxHeight: 380,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.builderElement,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
              ),
              dropdownColor: Colors.white,
              iconEnabledColor: AppColors.textDark,
              style: const TextStyle(color: AppColors.textDark),
              items: SectionLayoutType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(
                    type.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.textDark),
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  _updateSection(section.copyWith(layout: val));
                }
              },
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.06),
                    AppColors.builderElement.withValues(alpha: 0.5),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
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
                    maxLines: isCompact ? 2 : 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Best for: ${section.layout.bestFor}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),
            if (section.layout == SectionLayoutType.grid ||
                section.layout == SectionLayoutType.threeColumns) ...[
              const SizedBox(height: 24),
              PropertyBuilderUtils.buildNumberSlider(
                label: 'Grid Columns',
                value: (section.layout == SectionLayoutType.threeColumns
                        ? 3
                        : section.gridColumns)
                    .toDouble(),
                min: 2,
                max: 4,
                onChanged: (val) {
                  _updateSection(section.copyWith(gridColumns: val.toInt()));
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
              onChanged: (val) => _updateMetadata('fieldGap', val),
            ),
            const SizedBox(height: 12),

            PropertyBuilderUtils.buildNumberSlider(
              label: 'Vertical Padding',
              value: (metadata['verticalPadding'] ?? section.style.padding)
                  .toDouble(),
              min: 0,
              max: 64,
              onChanged: (val) => _updateMetadata('verticalPadding', val),
            ),
            const SizedBox(height: 12),

            PropertyBuilderUtils.buildNumberSlider(
              label: 'Horizontal Padding',
              value: (metadata['horizontalPadding'] ?? section.style.padding)
                  .toDouble(),
              min: 0,
              max: 64,
              onChanged: (val) => _updateMetadata('horizontalPadding', val),
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
              onChanged: (val) => _updateMetadata('alignment', val),
            ),

            const SizedBox(height: 24),
            PropertyBuilderUtils.buildNumberSlider(
              label: 'Max Width (px)',
              value: (metadata['maxWidth'] ?? 1200.0).toDouble(),
              min: 400,
              max: 2000,
              onChanged: (val) => _updateMetadata('maxWidth', val),
            ),
          ],
        );
      },
    );
  }
}
