import 'package:flutter/material.dart';
import 'package:frontend/modules/forms/widgets/property_builder_utils.dart';

class SectionStyleSettings extends StatefulWidget {
  final Map<String, dynamic> section;
  final Function(Map<String, dynamic>) onChanged;

  const SectionStyleSettings({
    super.key,
    required this.section,
    required this.onChanged,
  });

  @override
  State<SectionStyleSettings> createState() => _SectionStyleSettingsState();
}

class _SectionStyleSettingsState extends State<SectionStyleSettings> {
  void _updateStyle(String key, dynamic value) {
    final style = Map<String, dynamic>.from(widget.section['style'] ?? const {});
    style[key] = value;
    widget.onChanged({
      ...widget.section,
      'style': style,
    });
  }

  void _updateMetadata(String key, dynamic value) {
    final metadata = Map<String, dynamic>.from(widget.section['metadata'] ?? const {});
    metadata[key] = value;
    widget.onChanged({
      ...widget.section,
      'metadata': metadata,
    });
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

  @override
  Widget build(BuildContext context) {
    final style = Map<String, dynamic>.from(widget.section['style'] ?? const {});
    final metadata = Map<String, dynamic>.from(widget.section['metadata'] ?? const {});

    final backgroundColor = style['backgroundColor']?.toString() ?? '#FFFFFF';
    final borderRadius = (style['borderRadius'] as num?)?.toDouble() ?? 16.0;
    final padding = (style['padding'] as num?)?.toDouble() ?? 24.0;
    final elevation = (style['elevation'] as num?)?.toDouble() ?? 0.0;
    final showHeader = style['showHeader'] as bool? ?? true;
    final headerBackgroundColor = style['headerBackgroundColor']?.toString() ?? '#F5F5F5';

    final borderColor = style['borderColor']?.toString() ?? '#D8D2C8';
    final borderWidth = (style['borderWidth'] as num?)?.toDouble() ?? 1.0;
    final borderStyle = metadata['borderStyle']?.toString() ?? 'solid';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Style Settings',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        ExpansionTile(
          title: const Text(
            'Appearance',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          initiallyExpanded: true,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Quick Palette', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 6),
                  _buildColorSwatches(
                    value: backgroundColor,
                    onChanged: (val) => _updateStyle('backgroundColor', val),
                  ),
                  const SizedBox(height: 8),
                  PropertyBuilderUtils.buildColorPicker(
                    label: 'Background color',
                    value: backgroundColor,
                    onChanged: (val) => _updateStyle('backgroundColor', val),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Corner radius', style: Theme.of(context).textTheme.titleSmall),
                      Text('${borderRadius.round()} px'),
                    ],
                  ),
                  Slider(
                    value: borderRadius,
                    min: 0,
                    max: 48,
                    divisions: 48,
                    onChanged: (val) => _updateStyle('borderRadius', val.round()),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Section padding', style: Theme.of(context).textTheme.titleSmall),
                      Text('${padding.round()} px'),
                    ],
                  ),
                  Slider(
                    value: padding,
                    min: 0,
                    max: 64,
                    divisions: 64,
                    onChanged: (val) => _updateStyle('padding', val.round()),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Elevation', style: Theme.of(context).textTheme.titleSmall),
                      Text('${elevation.round()}'),
                    ],
                  ),
                  Slider(
                    value: elevation,
                    min: 0,
                    max: 12,
                    divisions: 12,
                    onChanged: (val) => _updateStyle('elevation', val.round()),
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
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
              child: Column(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Show section header'),
                      subtitle: const Text(
                        'Display title and description above the section content.',
                      ),
                      value: showHeader,
                      onChanged: (val) => _updateStyle('showHeader', val),
                    ),
                  ),
                  if (showHeader) ...[
                    const SizedBox(height: 16),
                    PropertyBuilderUtils.buildColorPicker(
                      label: 'Header Background',
                      value: headerBackgroundColor,
                      onChanged: (val) => _updateStyle('headerBackgroundColor', val),
                    ),
                    const SizedBox(height: 20),
                    _buildTypographyGroup(
                      label: 'Title Typography',
                      keyPrefix: 'title',
                      metadata: metadata,
                      fallbackSize: 18.0,
                    ),
                    const SizedBox(height: 20),
                    _buildTypographyGroup(
                      label: 'Description Typography',
                      keyPrefix: 'desc',
                      metadata: metadata,
                      fallbackSize: 14.0,
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
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Quick Palette', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 6),
                  _buildColorSwatches(
                    value: borderColor,
                    onChanged: (val) => _updateStyle('borderColor', val),
                  ),
                  const SizedBox(height: 8),
                  PropertyBuilderUtils.buildColorPicker(
                    label: 'Border Color',
                    value: borderColor,
                    onChanged: (val) => _updateStyle('borderColor', val),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Border Width', style: Theme.of(context).textTheme.titleSmall),
                      Text('${borderWidth.round()} px'),
                    ],
                  ),
                  Slider(
                    value: borderWidth,
                    min: 0,
                    max: 10,
                    divisions: 10,
                    onChanged: (val) => _updateStyle('borderWidth', val.round()),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: borderStyle,
                    decoration: InputDecoration(
                      labelText: 'Border Style',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'solid', child: Text('Solid')),
                      DropdownMenuItem(value: 'dashed', child: Text('Dashed')),
                      DropdownMenuItem(value: 'dotted', child: Text('Dotted')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        _updateMetadata('borderStyle', val);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTypographyGroup({
    required String label,
    required String keyPrefix,
    required Map<String, dynamic> metadata,
    required double fallbackSize,
  }) {
    final size = (metadata['${keyPrefix}Size'] as num?)?.toDouble() ?? fallbackSize;
    final color = metadata['${keyPrefix}Color']?.toString() ?? '#212121';
    final weight = metadata['${keyPrefix}Weight']?.toString() ?? 'normal';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Font Size', style: Theme.of(context).textTheme.titleSmall),
            Text('${size.round()} px'),
          ],
        ),
        Slider(
          value: size,
          min: 10,
          max: 48,
          divisions: 38,
          onChanged: (val) => _updateMetadata('${keyPrefix}Size', val.round()),
        ),
        const SizedBox(height: 12),
        const Text('Quick Palette', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 6),
        _buildColorSwatches(
          value: color,
          onChanged: (val) => _updateMetadata('${keyPrefix}Color', val),
        ),
        const SizedBox(height: 8),
        PropertyBuilderUtils.buildColorPicker(
          label: 'Font Color',
          value: color,
          onChanged: (val) => _updateMetadata('${keyPrefix}Color', val),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          initialValue: weight,
          decoration: InputDecoration(
            labelText: 'Font Weight',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          items: const [
            DropdownMenuItem(value: 'normal', child: Text('Normal')),
            DropdownMenuItem(value: 'medium', child: Text('Medium')),
            DropdownMenuItem(value: 'bold', child: Text('Bold')),
          ],
          onChanged: (val) {
            if (val != null) {
              _updateMetadata('${keyPrefix}Weight', val);
            }
          },
        ),
      ],
    );
  }
}
