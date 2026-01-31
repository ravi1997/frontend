// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TokenService)
final tokenServiceProvider = TokenServiceProvider._();

final class TokenServiceProvider
    extends $AsyncNotifierProvider<TokenService, AuthTokens> {
  TokenServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tokenServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tokenServiceHash();

  @$internal
  @override
  TokenService create() => TokenService();
}

String _$tokenServiceHash() => r'0cc9230b2ccbb864a0da1669ec12add0190a53be';

abstract class _$TokenService extends $AsyncNotifier<AuthTokens> {
  FutureOr<AuthTokens> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AuthTokens>, AuthTokens>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AuthTokens>, AuthTokens>,
              AsyncValue<AuthTokens>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
