import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/models/form_models.dart';
import 'package:frontend/features/form_builder/domain/entities/form_style.dart';
import 'property_builder_utils.dart';

class SectionStyleSettings extends ConsumerWidget {
  final String projectId;
  final String formId;
  final FormSection section;
  final ValueChanged<FormSection> onSectionChanged;

  const SectionStyleSettings({
    super.key,
    required this.projectId,
    required this.formId,
    required this.section,
    required this.onSectionChanged,
  });

  void _updateStyle(SectionStyle newStyle) {
    onSectionChanged(
      section.copyWith(
        ui: {...section.ui, 'style': newStyle.toJson()},
      ),
    );
  }

  void _updateMetadata(String key, dynamic value) {
    onSectionChanged(
      section.copyWith(metadata: {...section.metaData, key: value}),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metadata = section.metaData;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExpansionTile(
          title: const Text(
            'Appearance',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppColors.textDark,
            ),
          ),
          initiallyExpanded: true,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  PropertyBuilderUtils.buildColorPicker(
                    label: 'Background Color',
                    value: section.style.backgroundColor,
                    showHexInput: false,
                    onChanged: (val) =>
                        _updateStyle(section.style.copyWith(backgroundColor: val)),
                  ),
                  const SizedBox(height: 12),
                  PropertyBuilderUtils.buildSwitch(
                    label: 'Show Card Background',
                    description: 'Wraps the section in a distinctive card container with shadows.',
                    value: metadata['isCardLayout'] as bool? ?? false,
                    onChanged: (val) => _updateMetadata('isCardLayout', val),
                  ),
                  const SizedBox(height: 12),
                  PropertyBuilderUtils.buildNumberSlider(
                    label: 'Border Radius',
                    value: section.style.borderRadius,
                    min: 0,
                    max: 40,
                    onChanged: (val) =>
                        _updateStyle(section.style.copyWith(borderRadius: val)),
                  ),
                  const SizedBox(height: 12),
                  PropertyBuilderUtils.buildNumberSlider(
                    label: 'Elevation',
                    value: section.style.elevation,
                    min: 0,
                    max: 12,
                    onChanged: (val) =>
                        _updateStyle(section.style.copyWith(elevation: val)),
                  ),
                  if (section.style.elevation > 0)
                    PropertyBuilderUtils.buildColorPicker(
                      label: 'Shadow Color',
                      value: metadata['shadowColor'] ?? '#000000',
                      showHexInput: false,
                      onChanged: (val) => _updateMetadata('shadowColor', val),
                    ),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: const Text(
            'Header & Typography',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppColors.textDark,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  PropertyBuilderUtils.buildSwitch(
                    label: 'Show Header',
                    value: section.style.showHeader,
                    onChanged: (val) =>
                        _updateStyle(section.style.copyWith(showHeader: val)),
                  ),
                  if (section.style.showHeader) ...[
                    const SizedBox(height: 12),
                    PropertyBuilderUtils.buildColorPicker(
                      label: 'Header Background',
                      value: section.style.headerBackgroundColor,
                      showHexInput: false,
                      onChanged: (val) => _updateStyle(
                        section.style.copyWith(headerBackgroundColor: val),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTypographyGroup(
                      ref,
                      'Title Typography',
                      'title',
                      metadata,
                    ),
                    const SizedBox(height: 16),
                    _buildTypographyGroup(
                      ref,
                      'Description Typography',
                      'desc',
                      metadata,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: const Text(
            'Borders',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppColors.textDark,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  PropertyBuilderUtils.buildColorPicker(
                    label: 'Border Color',
                    value: metadata['borderColor'] ?? '#E0E0E0',
                    showHexInput: false,
                    onChanged: (val) => _updateMetadata('borderColor', val),
                  ),
                  const SizedBox(height: 12),
                  PropertyBuilderUtils.buildNumberSlider(
                    label: 'Border Width',
                    value: (metadata['borderWidth'] ?? 1.0).toDouble(),
                    min: 0,
                    max: 10,
                    onChanged: (val) => _updateMetadata('borderWidth', val),
                  ),
                  const SizedBox(height: 12),
                  PropertyBuilderUtils.buildDropdown<String>(
                    label: 'Border Style',
                    value: metadata['borderStyle'] ?? 'solid',
                    items: const [
                      DropdownMenuItem(value: 'solid', child: Text('Solid')),
                      DropdownMenuItem(value: 'dashed', child: Text('Dashed')),
                      DropdownMenuItem(value: 'dotted', child: Text('Dotted')),
                    ],
                    onChanged: (val) => _updateMetadata('borderStyle', val),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTypographyGroup(
    WidgetRef ref,
    String label,
    String keyPrefix,
    Map<String, dynamic> metadata,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.textGrey,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: PropertyBuilderUtils.buildNumberSlider(
                label: 'Size',
                value: (metadata['${keyPrefix}Size'] ?? 16.0).toDouble(),
                min: 10,
                max: 48,
                onChanged: (val) => _updateMetadata('${keyPrefix}Size', val),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: PropertyBuilderUtils.buildColorPicker(
                label: 'Color',
                value: metadata['${keyPrefix}Color'] ?? '#212121',
                showHexInput: false,
                onChanged: (val) => _updateMetadata('${keyPrefix}Color', val),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        PropertyBuilderUtils.buildDropdown<String>(
          label: 'Weight',
          value: metadata['${keyPrefix}Weight'] ?? 'normal',
          items: const [
            DropdownMenuItem(value: 'normal', child: Text('Normal')),
            DropdownMenuItem(value: 'medium', child: Text('Medium')),
            DropdownMenuItem(value: 'bold', child: Text('Bold')),
          ],
          onChanged: (val) => _updateMetadata('${keyPrefix}Weight', val),
        ),
      ],
    );
  }
}
