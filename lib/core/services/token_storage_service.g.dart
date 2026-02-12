// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_storage_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod provider for TokenStorageService

@ProviderFor(tokenStorageService)
final tokenStorageServiceProvider = TokenStorageServiceProvider._();

/// Riverpod provider for TokenStorageService

final class TokenStorageServiceProvider
    extends
        $FunctionalProvider<
          TokenStorageService,
          TokenStorageService,
          TokenStorageService
        >
    with $Provider<TokenStorageService> {
  /// Riverpod provider for TokenStorageService
  TokenStorageServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tokenStorageServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tokenStorageServiceHash();

  @$internal
  @override
  $ProviderElement<TokenStorageService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TokenStorageService create(Ref ref) {
    return tokenStorageService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TokenStorageService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TokenStorageService>(value),
    );
  }
}

String _$tokenStorageServiceHash() =>
    r'96a4b17af54d2467c6c0810ac9a8f8b2177b9cf1';
