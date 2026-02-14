// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(aiRepository)
final aiRepositoryProvider = AiRepositoryProvider._();

final class AiRepositoryProvider
    extends $FunctionalProvider<AIRepository, AIRepository, AIRepository>
    with $Provider<AIRepository> {
  AiRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiRepositoryHash();

  @$internal
  @override
  $ProviderElement<AIRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AIRepository create(Ref ref) {
    return aiRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AIRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AIRepository>(value),
    );
  }
}

String _$aiRepositoryHash() => r'f38ea3ef2c0ed92a1271d36f16c9b43efa391a73';
