import 'package:flutter/material.dart';

class FormStyleSettings extends StatelessWidget {
  final Map<String, dynamic> form;
  final Function(Map<String, dynamic>) onChanged;

  const FormStyleSettings({
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
          'Style Settings',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: form['backgroundColor'] ?? '#FFFFFF',
          decoration: const InputDecoration(
            labelText: 'Background Color',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            onChanged({...form, 'backgroundColor': value});
          },
        ),
      ],
    );
  }
}