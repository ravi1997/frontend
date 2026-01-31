// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workflow_executor_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(workflowExecutor)
final workflowExecutorProvider = WorkflowExecutorProvider._();

final class WorkflowExecutorProvider
    extends
        $FunctionalProvider<
          WorkflowExecutor,
          WorkflowExecutor,
          WorkflowExecutor
        >
    with $Provider<WorkflowExecutor> {
  WorkflowExecutorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workflowExecutorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workflowExecutorHash();

  @$internal
  @override
  $ProviderElement<WorkflowExecutor> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WorkflowExecutor create(Ref ref) {
    return workflowExecutor(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WorkflowExecutor value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WorkflowExecutor>(value),
    );
  }
}

String _$workflowExecutorHash() => r'12b6ad4a589be6a6356f760930a2dbef877a6c09';
