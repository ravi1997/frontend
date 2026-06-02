import 'package:flutter/material.dart';

class FormLayoutSettings extends StatelessWidget {
  final Map<String, dynamic> form;
  final Function(Map<String, dynamic>) onChanged;

  const FormLayoutSettings({
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
          'Layout Settings',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          initialValue: form['layout'] ?? 'singleColumn',
          decoration: const InputDecoration(
            labelText: 'Layout Type',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'singleColumn', child: Text('Single Column')),
            DropdownMenuItem(value: 'twoColumns', child: Text('Two Columns')),
            DropdownMenuItem(value: 'threeColumns', child: Text('Three Columns')),
          ],
          onChanged: (value) {
            if (value != null) {
              onChanged({...form, 'layout': value});
            }
          },
        ),
      ],
    );
  }
}
