import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/networking/api_client.dart';
import 'workflow_executor.dart';

final workflowExecutorProvider = Provider<WorkflowExecutor>((ref) {
  final dio = ref.read(dioProvider);
  return WorkflowExecutorImpl(dio);
});
