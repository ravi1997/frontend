import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/api_client.dart';
import 'workflow_executor.dart';

part 'workflow_executor_provider.g.dart';

@riverpod
WorkflowExecutor workflowExecutor(Ref ref) {
  final dio = ref.read(dioProvider);
  return WorkflowExecutorImpl(dio);
}
