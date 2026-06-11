import 'package:flutter/material.dart';
import 'package:frontend/app/theme/tokens.dart';

class FormAccessSettings extends StatelessWidget {
  final Map<String, dynamic> form;
  final Function(Map<String, dynamic>) onChanged;

  const FormAccessSettings({
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
          'Access Settings',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: DesignTokens.spaceM),
        SwitchListTile(
          title: const Text('Public Form'),
          value: form['isPublic'] ?? false,
          onChanged: (value) {
            onChanged({...form, 'isPublic': value});
          },
        ),
      ],
    );
  }
}
