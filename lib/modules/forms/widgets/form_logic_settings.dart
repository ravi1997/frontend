import 'package:flutter/material.dart';
import 'package:frontend/app/theme/tokens.dart';

class FormLogicSettings extends StatelessWidget {
  final Map<String, dynamic> form;
  final Function(Map<String, dynamic>) onChanged;

  const FormLogicSettings({
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
          'Logic Settings',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: DesignTokens.spaceM),
        const Text('Form logic rules will be configured here.'),
      ],
    );
  }
}
