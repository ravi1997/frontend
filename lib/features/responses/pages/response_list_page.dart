import 'package:flutter/material.dart';

class ResponseListPage extends StatelessWidget {
  final String projectId;
  final String formId;

  const ResponseListPage({
    super.key,
    required this.projectId,
    required this.formId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Responses')),
      body: Center(
        child: Text(
          'Responses for form: $formId in project: $projectId - Coming Soon',
        ),
      ),
    );
  }
}
