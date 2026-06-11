import 'package:flutter/material.dart';
import 'package:frontend/modules/forms/models/section_layout_type.dart';

class SectionLayoutSettings extends StatefulWidget {
  final Map<String, dynamic> section;
  final Function(Map<String, dynamic>) onChanged;

  const SectionLayoutSettings({
    super.key,
    required this.section,
    required this.onChanged,
  });

  @override
  State<SectionLayoutSettings> createState() => _SectionLayoutSettingsState();
}

class _SectionLayoutSettingsState extends State<SectionLayoutSettings> {
  Widget _switchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Material(
      color: Colors.transparent,
      child: SwitchListTile.adaptive(
        contentPadding: EdgeInsets.zero,
        title: Text(title),
        subtitle: Text(subtitle),
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  SectionLayoutType _parseLayout(String? raw) {
    if (raw == null || raw.isEmpty) return SectionLayoutType.standard;
    for (final v in SectionLayoutType.values) {
      if (raw == v.name) return v;
    }
    return switch (raw) {
      'flex' => SectionLayoutType.standard,
      'grid-cols-2' => SectionLayoutType.grid,
      'grid-cols-3' => SectionLayoutType.threeColumns,
      'full-width' => SectionLayoutType.fullWidth,
      _ => SectionLayoutType.standard,
    };
  }

  String _layoutToString(SectionLayoutType type) {
    return switch (type) {
      SectionLayoutType.standard => 'flex',
      SectionLayoutType.grid => 'grid-cols-2',
      SectionLayoutType.threeColumns => 'grid-cols-3',
      SectionLayoutType.fullWidth => 'full-width',
      _ => type.name,
    };
  }

  IconData _layoutIcon(SectionLayoutType type) {
    return switch (type) {
      SectionLayoutType.standard => Icons.view_agenda_outlined,
      SectionLayoutType.grid => Icons.grid_view_outlined,
      SectionLayoutType.threeColumns => Icons.grid_on_outlined,
      SectionLayoutType.fullWidth => Icons.view_headline_outlined,
      SectionLayoutType.list => Icons.format_list_bulleted,
      SectionLayoutType.sidebar => Icons.space_dashboard_outlined,
      SectionLayoutType.accordion => Icons.expand,
      SectionLayoutType.tabbed => Icons.tab,
      SectionLayoutType.wizard => Icons.linear_scale,
      SectionLayoutType.masonry => Icons.dashboard_customize_outlined,
      SectionLayoutType.dashboard => Icons.dashboard,
      SectionLayoutType.overlay => Icons.picture_in_picture_alt_outlined,
      SectionLayoutType.centered => Icons.align_horizontal_center,
      SectionLayoutType.card => Icons.amp_stories_outlined,
      _ => Icons.widgets_outlined,
    };
  }

  Widget _buildNumberCounter({
    required String label,
    required int value,
    required ValueChanged<int> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline, size: 20),
              onPressed: value > 0 ? () => onChanged(value - 1) : null,
            ),
            Container(
              alignment: Alignment.center,
              width: 50,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Text(
                '$value',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline, size: 20),
              onPressed: () => onChanged(value + 1),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final rawLayout = widget.section['layout']?.toString() ?? 'standard';
    final layout = _parseLayout(rawLayout);
    final gridColumns = (widget.section['grid_columns'] as num?)?.toInt() ?? 2;
    final isHidden = widget.section['is_hidden'] as bool? ?? false;
    final isRepeatable = widget.section['is_repeatable'] as bool? ?? false;
    final repeatMinVal = (widget.section['repeat_min'] as num?)?.toInt() ?? 1;
    final repeatMaxVal = (widget.section['repeat_max'] as num?)?.toInt() ?? 5;

    final metadata = Map<String, dynamic>.from(widget.section['metadata'] ?? const {});
    final alignment = metadata['alignment']?.toString() ?? 'center';
    final maxWidth = (metadata['maxWidth'] as num?)?.toDouble() ?? 1200.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Layout Settings',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        const Text(
          'Section layout',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Controls questions and nested sub-sections inside this section.',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<SectionLayoutType>(
          initialValue: layout,
          isExpanded: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          items: SectionLayoutType.values.where((e) => e != SectionLayoutType.custom && e != SectionLayoutType.fixed).map((type) {
            return DropdownMenuItem(
              value: type,
              child: Row(
                children: [
                  Icon(_layoutIcon(type), size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    type.label,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              widget.onChanged({...widget.section, 'layout': _layoutToString(val)});
            }
          },
        ),
        if (layout == SectionLayoutType.grid) ...[
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Grid columns', style: Theme.of(context).textTheme.titleSmall),
              Text('$gridColumns'),
            ],
          ),
          Slider(
            value: gridColumns.toDouble(),
            min: 1,
            max: 4,
            divisions: 3,
            label: '$gridColumns',
            onChanged: (val) =>
                widget.onChanged({...widget.section, 'grid_columns': val.round()}),
          ),
        ],
        const SizedBox(height: 16),
        const Text(
          'Content Alignment',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: alignment,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          items: const [
            DropdownMenuItem(value: 'left', child: Text('Left')),
            DropdownMenuItem(value: 'center', child: Text('Center')),
            DropdownMenuItem(value: 'right', child: Text('Right')),
          ],
          onChanged: (val) {
            if (val != null) {
              final newMetadata = Map<String, dynamic>.from(widget.section['metadata'] ?? const {});
              newMetadata['alignment'] = val;
              widget.onChanged({...widget.section, 'metadata': newMetadata});
            }
          },
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Max Width (px)', style: Theme.of(context).textTheme.titleSmall),
            Text('${maxWidth.round()} px'),
          ],
        ),
        Slider(
          value: maxWidth,
          min: 400,
          max: 2000,
          divisions: 32,
          onChanged: (val) {
            final newMetadata = Map<String, dynamic>.from(widget.section['metadata'] ?? const {});
            newMetadata['maxWidth'] = val.round();
            widget.onChanged({...widget.section, 'metadata': newMetadata});
          },
        ),
        const SizedBox(height: 16),
        _switchTile(
          title: 'Hidden section',
          subtitle: 'Hide this section from the normal canvas flow.',
          value: isHidden,
          onChanged: (value) {
            widget.onChanged({...widget.section, 'is_hidden': value});
          },
        ),
        _switchTile(
          title: 'Repeatable section',
          subtitle: 'Allow this section to be repeated.',
          value: isRepeatable,
          onChanged: (value) {
            widget.onChanged({...widget.section, 'is_repeatable': value});
          },
        ),
        const SizedBox(height: 8),
        if (isRepeatable)
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Row(
              key: const ValueKey('repeat_range'),
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildNumberCounter(
                  label: 'Repeat Min',
                  value: repeatMinVal,
                  onChanged: (val) {
                    widget.onChanged({
                      ...widget.section,
                      'repeat_min': val,
                    });
                  },
                ),
                const SizedBox(width: 32),
                _buildNumberCounter(
                  label: 'Repeat Max',
                  value: repeatMaxVal,
                  onChanged: (val) {
                    widget.onChanged({
                      ...widget.section,
                      'repeat_max': val,
                    });
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }
}
