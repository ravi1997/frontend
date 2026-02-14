// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translation_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for TranslationRepository

@ProviderFor(translationRepository)
final translationRepositoryProvider = TranslationRepositoryProvider._();

/// Provider for TranslationRepository

final class TranslationRepositoryProvider
    extends
        $FunctionalProvider<
          TranslationRepository,
          TranslationRepository,
          TranslationRepository
        >
    with $Provider<TranslationRepository> {
  /// Provider for TranslationRepository
  TranslationRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'translationRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$translationRepositoryHash();

  @$internal
  @override
  $ProviderElement<TranslationRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TranslationRepository create(Ref ref) {
    return translationRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TranslationRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TranslationRepository>(value),
    );
  }
}

String _$translationRepositoryHash() =>
    r'd32fc3aeebea3bf35a272af053c62da7ef3537ab';

/// Controller for managing bulk translation operations.

@ProviderFor(TranslationController)
final translationControllerProvider = TranslationControllerProvider._();

/// Controller for managing bulk translation operations.
final class TranslationControllerProvider
    extends $NotifierProvider<TranslationController, List<TranslationJob>> {
  /// Controller for managing bulk translation operations.
  TranslationControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'translationControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$translationControllerHash();

  @$internal
  @override
  TranslationController create() => TranslationController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<TranslationJob> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<TranslationJob>>(value),
    );
  }
}

String _$translationControllerHash() =>
    r'5f3e4bf7592105471dc33028bcb314dc739fa283';

/// Controller for managing bulk translation operations.

abstract class _$TranslationController extends $Notifier<List<TranslationJob>> {
  List<TranslationJob> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<TranslationJob>, List<TranslationJob>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<TranslationJob>, List<TranslationJob>>,
              List<TranslationJob>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
