// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_repository_impl.dart';

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
    r'3326a84652e5b36d184511b7549831629732d73d';
