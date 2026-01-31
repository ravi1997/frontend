// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mock_response_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(responseRepository)
final responseRepositoryProvider = ResponseRepositoryProvider._();

final class ResponseRepositoryProvider
    extends
        $FunctionalProvider<
          ResponseRepository,
          ResponseRepository,
          ResponseRepository
        >
    with $Provider<ResponseRepository> {
  ResponseRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'responseRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$responseRepositoryHash();

  @$internal
  @override
  $ProviderElement<ResponseRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ResponseRepository create(Ref ref) {
    return responseRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ResponseRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ResponseRepository>(value),
    );
  }
}

String _$responseRepositoryHash() =>
    r'3694d2f7f2a0663331c9717999578a751e0f77f0';
