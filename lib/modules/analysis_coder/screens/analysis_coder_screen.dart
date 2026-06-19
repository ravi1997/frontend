import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnalysisCoderScreen extends ConsumerStatefulWidget {
  final String projectId;
  final String? analysisId;

  const AnalysisCoderScreen({
    super.key,
    required this.projectId,
    this.analysisId,
  });

  @override
  ConsumerState<AnalysisCoderScreen> createState() => _AnalysisCoderScreenState();
}

class _AnalysisCoderScreenState extends ConsumerState<AnalysisCoderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analysis Coder')),
      body: Center(
        child: Text('Project ${widget.projectId}'),
      ),
    );
  }
}
