import 'package:flutter/material.dart';

class FormViewerPage extends StatelessWidget {
  final String formId;
  final String formSchema;
  final String? projectId;

  const FormViewerPage({
    super.key,
    required this.formId,
    required this.formSchema,
    this.projectId,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Form Viewer')),
    );
  }
}
