import 'package:flutter/material.dart';

class FormBuilderCopilot extends StatelessWidget {
  final dynamic currentForm;
  final void Function(Map<String, dynamic>) onFormUpdated;

  const FormBuilderCopilot({
    super.key,
    this.currentForm,
    required this.onFormUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
