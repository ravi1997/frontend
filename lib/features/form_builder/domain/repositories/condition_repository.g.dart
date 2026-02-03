// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'condition_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(conditionRepository)
final conditionRepositoryProvider = ConditionRepositoryProvider._();

final class ConditionRepositoryProvider
    extends
        $FunctionalProvider<
          ConditionRepository,
          ConditionRepository,
          ConditionRepository
        >
    with $Provider<ConditionRepository> {
  ConditionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'conditionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$conditionRepositoryHash();

  @$internal
  @override
  $ProviderElement<ConditionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ConditionRepository create(Ref ref) {
    return conditionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConditionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConditionRepository>(value),
    );
  }
}

String _$conditionRepositoryHash() =>
    r'8037ca89a8c4ab3b4858cc8754ad06df1dfd691d';
