import 'package:flutter/material.dart';

class FormGeneralSettings extends StatelessWidget {
  final Map<String, dynamic> form;
  final Function(Map<String, dynamic>) onChanged;

  const FormGeneralSettings({
    super.key,
    required this.form,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'General Settings',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: form['title'] ?? '',
          decoration: const InputDecoration(
            labelText: 'Form Title',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            onChanged({...form, 'title': value});
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: form['description'] ?? '',
          decoration: const InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          onChanged: (value) {
            onChanged({...form, 'description': value});
          },
        ),
      ],
    );
  }
}

class SectionGeneralSettings extends StatelessWidget {
  final Map<String, dynamic> section;
  final Function(Map<String, dynamic>) onChanged;

  const SectionGeneralSettings({
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
          'General Settings',
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
        const SizedBox(height: 16),
        TextFormField(
          initialValue: section['description'] ?? '',
          decoration: const InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          onChanged: (value) {
            onChanged({...section, 'description': value});
          },
        ),
      ],
    );
  }
}
