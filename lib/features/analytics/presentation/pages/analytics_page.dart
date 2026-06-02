import 'package:flutter/material.dart';

class AnalyticsPage extends StatelessWidget {
  final String projectId;
  final String formId;

  const AnalyticsPage({
    super.key,
    required this.projectId,
    required this.formId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: const Center(
        child: Text('Analytics Dashboard - Coming Soon'),
      ),
    );
  }
}