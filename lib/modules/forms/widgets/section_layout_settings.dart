import 'package:flutter/material.dart';

class SectionLayoutSettings extends StatelessWidget {
  final Map<String, dynamic> section;
  final Function(Map<String, dynamic>) onChanged;

  const SectionLayoutSettings({
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
          'Layout Settings',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: section['title'] ?? '',
          decoration: const InputDecoration(
            labelText: 'Section Title',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            onChanged({...section, 'title': value});
          },
        ),
      ],
    );
  }
}