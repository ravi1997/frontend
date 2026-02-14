// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workflow_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for WorkflowRepository

@ProviderFor(workflowRepository)
final workflowRepositoryProvider = WorkflowRepositoryProvider._();

/// Provider for WorkflowRepository

final class WorkflowRepositoryProvider
    extends
        $FunctionalProvider<
          WorkflowRepository,
          WorkflowRepository,
          WorkflowRepository
        >
    with $Provider<WorkflowRepository> {
  /// Provider for WorkflowRepository
  WorkflowRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workflowRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workflowRepositoryHash();

  @$internal
  @override
  $ProviderElement<WorkflowRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WorkflowRepository create(Ref ref) {
    return workflowRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WorkflowRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WorkflowRepository>(value),
    );
  }
}

String _$workflowRepositoryHash() =>
    r'df28363c273e374eb670e84dcc8a9cb7df08bf24';

/// Controller for managing workflow builder state.

@ProviderFor(WorkflowController)
final workflowControllerProvider = WorkflowControllerProvider._();

/// Controller for managing workflow builder state.
final class WorkflowControllerProvider
    extends $NotifierProvider<WorkflowController, List<Workflow>> {
  /// Controller for managing workflow builder state.
  WorkflowControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workflowControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workflowControllerHash();

  @$internal
  @override
  WorkflowController create() => WorkflowController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Workflow> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Workflow>>(value),
    );
  }
}

String _$workflowControllerHash() =>
    r'2af9bf7328ec173108e908525086e76f96bc4d37';

/// Controller for managing workflow builder state.

abstract class _$WorkflowController extends $Notifier<List<Workflow>> {
  List<Workflow> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<Workflow>, List<Workflow>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<Workflow>, List<Workflow>>,
              List<Workflow>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
