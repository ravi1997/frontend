import 'package:flutter/material.dart';

class ResponseDetailPage extends StatelessWidget {
  final String projectId;
  final String formId;
  final String responseId;

  const ResponseDetailPage({
    super.key,
    required this.projectId,
    required this.formId,
    required this.responseId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Response Details')),
      body: Center(
        child: Text(
          'Response details for: $responseId in form: $formId - Coming Soon',
        ),
      ),
    );
  }
}
