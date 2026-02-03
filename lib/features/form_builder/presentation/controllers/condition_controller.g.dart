// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'condition_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Controller for managing conditional logic rules.

@ProviderFor(ConditionController)
final conditionControllerProvider = ConditionControllerProvider._();

/// Controller for managing conditional logic rules.
final class ConditionControllerProvider
    extends $NotifierProvider<ConditionController, List<ConditionalRule>> {
  /// Controller for managing conditional logic rules.
  ConditionControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'conditionControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$conditionControllerHash();

  @$internal
  @override
  ConditionController create() => ConditionController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<ConditionalRule> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<ConditionalRule>>(value),
    );
  }
}

String _$conditionControllerHash() =>
    r'e231dcf6da157ef37e3d1bf38bab3d6d99464952';

/// Controller for managing conditional logic rules.

abstract class _$ConditionController extends $Notifier<List<ConditionalRule>> {
  List<ConditionalRule> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<ConditionalRule>, List<ConditionalRule>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<ConditionalRule>, List<ConditionalRule>>,
              List<ConditionalRule>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
