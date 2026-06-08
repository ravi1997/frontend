import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/networking/dio_provider.dart';
import 'workflow_executor.dart';

final workflowExecutorProvider = Provider<WorkflowExecutor>((ref) {
  final dio = ref.read(dioProvider);
  return WorkflowExecutorImpl(dio);
});
