import 'package:flutter/material.dart';

class SectionStyleSettings extends StatelessWidget {
  final Map<String, dynamic> section;
  final Function(Map<String, dynamic>) onChanged;

  const SectionStyleSettings({
    super.key,
    required this.section,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Style Settings',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: section['backgroundColor'] ?? '#FFFFFF',
          decoration: const InputDecoration(
            labelText: 'Background Color',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            onChanged({...section, 'backgroundColor': value});
          },
        ),
      ],
    );
  }
}