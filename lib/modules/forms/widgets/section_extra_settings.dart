import 'package:flutter/material.dart';

class SectionExtraField {
  final String keyName;
  final String label;
  final bool isToggle;
  final bool isChips;
  final bool isNumeric;
  final bool isDropdown;
  final bool fallback;
  final int lines;
  final String? hintText;
  final double min;
  final double max;
  final double defaultValue;
  final List<String> options;

  const SectionExtraField.toggle(
    this.keyName,
    this.label, {
    this.fallback = false,
  }) : isToggle = true,
       isChips = false,
       isNumeric = false,
       isDropdown = false,
       lines = 1,
       hintText = null,
       min = 0,
       max = 0,
       defaultValue = 0,
       options = const [];

  const SectionExtraField.text(
    this.keyName,
    this.label, {
    this.hintText,
    this.lines = 1,
    this.fallback = false,
  }) : isToggle = false,
       isChips = false,
       isNumeric = false,
       isDropdown = false,
       min = 0,
       max = 0,
       defaultValue = 0,
       options = const [];

  const SectionExtraField.chips(this.keyName, this.label, {this.hintText})
    : isToggle = false,
      isChips = true,
      isNumeric = false,
      isDropdown = false,
      lines = 1,
      fallback = false,
      min = 0,
      max = 0,
      defaultValue = 0,
      options = const [];

  const SectionExtraField.numeric(
    this.keyName,
    this.label, {
    this.min = 0.0,
    this.max = 400.0,
    this.defaultValue = 0.0,
  }) : isToggle = false,
       isChips = false,
       isNumeric = true,
       isDropdown = false,
       lines = 1,
       hintText = null,
       fallback = false,
       options = const [];

  const SectionExtraField.dropdown(this.keyName, this.label, this.options)
    : isToggle = false,
      isChips = false,
      isNumeric = false,
      isDropdown = true,
      lines = 1,
      hintText = null,
      fallback = false,
      min = 0,
      max = 0,
      defaultValue = 0;
}

class SectionExtraSettings extends StatelessWidget {
  final String title;
  final Map<String, dynamic> section;
  final List<SectionExtraField> fields;
  final Function(Map<String, dynamic>) onChanged;

  const SectionExtraSettings({
    super.key,
    required this.title,
    required this.section,
    required this.fields,
    required this.onChanged,
  });

  Map<String, dynamic> _metadata() =>
      Map<String, dynamic>.from(section['metadata'] ?? const {});

  @override
  Widget build(BuildContext context) {
    final metadata = _metadata();
    final intro = switch (title) {
      'Behavior' =>
        'Behavior settings control how the section behaves at runtime and during navigation.',
      'A11y' =>
        'Accessibility metadata helps assistive technologies describe this section correctly.',
      'Analytics' =>
        'Analytics settings determine what section events are tracked.',
      'Advanced' =>
        'Advanced settings store implementation details and power-user overrides.',
      _ => 'Section metadata settings.',
    };

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        Text(
          intro,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade700),
        ),
        const SizedBox(height: 16),
        ...fields.map((field) {
          final current = metadata[field.keyName];

          if (field.isChips) {
            final chips = (metadata[field.keyName] is List)
                ? (metadata[field.keyName] as List)
                      .map((e) => e.toString())
                      .where((e) => e.isNotEmpty)
                      .toList()
                : (metadata[field.keyName] is String &&
                      (metadata[field.keyName] as String).isNotEmpty)
                ? (metadata[field.keyName] as String)
                      .split(',')
                      .map((s) => s.trim())
                      .where((s) => s.isNotEmpty)
                      .toList()
                : <String>[];

            void removeChip(String chip) {
              final updated = List<String>.from(chips)..remove(chip);
              onChanged({
                ...section,
                'metadata': {...metadata, field.keyName: updated},
              });
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (chips.isNotEmpty) ...[
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: chips
                          .map(
                            (chip) => Chip(
                              label: Text(chip),
                              deleteIcon: const Icon(Icons.close, size: 14),
                              onDeleted: () => removeChip(chip),
                              visualDensity: VisualDensity.compact,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 8),
                  ],
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: field.label,
                      hintText: field.hintText ?? 'Type and press Enter',
                      border: const OutlineInputBorder(),
                    ),
                    onFieldSubmitted: (value) {
                      final incoming = value
                          .split(',')
                          .map((s) => s.trim())
                          .where((s) => s.isNotEmpty && !chips.contains(s))
                          .toList();
                      if (incoming.isEmpty) return;
                      final updated = [...chips, ...incoming];
                      onChanged({
                        ...section,
                        'metadata': {...metadata, field.keyName: updated},
                      });
                    },
                  ),
                ],
              ),
            );
          }

          if (field.isNumeric) {
            final raw = metadata[field.keyName];
            final currentValue =
                (raw is num
                    ? raw.toDouble()
                    : double.tryParse(raw?.toString() ?? '')) ??
                field.defaultValue;
            final clamped = currentValue.clamp(field.min, field.max).toDouble();
            final divisions = (field.max - field.min).round();

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(field.label),
                      Text('${clamped.round()} px'),
                    ],
                  ),
                  Slider(
                    value: clamped,
                    min: field.min,
                    max: field.max,
                    divisions: divisions == 0 ? null : divisions,
                    onChanged: (val) {
                      onChanged({
                        ...section,
                        'metadata': {...metadata, field.keyName: val.round()},
                      });
                    },
                  ),
                ],
              ),
            );
          }

          if (field.isDropdown) {
            final currentValue = field.options.contains(current?.toString())
                ? current.toString()
                : (field.options.isNotEmpty ? field.options.first : '');
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: DropdownButtonFormField<String>(
                initialValue: currentValue,
                decoration: InputDecoration(
                  labelText: field.label,
                  border: const OutlineInputBorder(),
                ),
                items: field.options
                    .map(
                      (opt) => DropdownMenuItem<String>(
                        value: opt,
                        child: Text(opt),
                      ),
                    )
                    .toList(),
                onChanged: (val) {
                  if (val == null) return;
                  onChanged({
                    ...section,
                    'metadata': {...metadata, field.keyName: val},
                  });
                },
              ),
            );
          }

          if (field.isToggle) {
            final value = current is bool ? current : field.fallback;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Material(
                color: Colors.transparent,
                child: SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: Text(field.label),
                  value: value,
                  onChanged: (next) {
                    onChanged({
                      ...section,
                      'metadata': {...metadata, field.keyName: next},
                    });
                  },
                ),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: TextFormField(
              initialValue: current?.toString() ?? '',
              decoration: InputDecoration(
                labelText: field.label,
                hintText: field.hintText,
                border: const OutlineInputBorder(),
              ),
              maxLines: field.lines,
              onChanged: (value) {
                onChanged({
                  ...section,
                  'metadata': {...metadata, field.keyName: value},
                });
              },
            ),
          );
        }),
      ],
    );
  }
}
