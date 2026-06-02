import 'package:flutter/material.dart';

class SectionLogicSettings extends StatelessWidget {
  final Map<String, dynamic> section;
  final Function(Map<String, dynamic>) onChanged;

  const SectionLogicSettings({
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
          'Logic Settings',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        const Text('Section logic rules will be configured here.'),
      ],
    );
  }
}