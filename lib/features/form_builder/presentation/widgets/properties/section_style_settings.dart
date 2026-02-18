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
                    onChanged: (val) => _updateStyle(
                      ref,
                      section.style.copyWith(backgroundColor: val),
                    ),
                  ),
                  const SizedBox(height: 12),
                  PropertyBuilderUtils.buildNumberSlider(
                    label: 'Border Radius',
                    value: section.style.borderRadius,
                    min: 0,
                    max: 40,
                    onChanged: (val) => _updateStyle(
                      ref,
                      section.style.copyWith(borderRadius: val),
                    ),
                  ),
                  const SizedBox(height: 12),
                  PropertyBuilderUtils.buildNumberSlider(
                    label: 'Elevation',
                    value: section.style.elevation,
                    min: 0,
                    max: 12,
                    onChanged: (val) => _updateStyle(
                      ref,
                      section.style.copyWith(elevation: val),
                    ),
                  ),
                  if (section.style.elevation > 0)
                    PropertyBuilderUtils.buildColorPicker(
                      label: 'Shadow Color',
                      value: metadata['shadowColor'] ?? '#000000',
                      onChanged: (val) =>
                          _updateMetadata(ref, 'shadowColor', val),
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
                    onChanged: (val) => _updateStyle(
                      ref,
                      section.style.copyWith(showHeader: val),
                    ),
                  ),
                  if (section.style.showHeader) ...[
                    const SizedBox(height: 12),
                    PropertyBuilderUtils.buildColorPicker(
                      label: 'Header Background',
                      value: section.style.headerBackgroundColor,
                      onChanged: (val) => _updateStyle(
                        ref,
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
                    onChanged: (val) =>
                        _updateMetadata(ref, 'borderColor', val),
                  ),
                  const SizedBox(height: 12),
                  PropertyBuilderUtils.buildNumberSlider(
                    label: 'Border Width',
                    value: (metadata['borderWidth'] ?? 1.0).toDouble(),
                    min: 0,
                    max: 10,
                    onChanged: (val) =>
                        _updateMetadata(ref, 'borderWidth', val),
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
                    onChanged: (val) =>
                        _updateMetadata(ref, 'borderStyle', val),
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
                onChanged: (val) =>
                    _updateMetadata(ref, '${keyPrefix}Size', val),
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
                onChanged: (val) =>
                    _updateMetadata(ref, '${keyPrefix}Color', val),
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
          onChanged: (val) => _updateMetadata(ref, '${keyPrefix}Weight', val),
        ),
      ],
    );
  }
}
