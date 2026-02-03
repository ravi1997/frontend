// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appRouter)
final appRouterProvider = AppRouterProvider._();

final class AppRouterProvider
    extends $FunctionalProvider<Raw<GoRouter>, Raw<GoRouter>, Raw<GoRouter>>
    with $Provider<Raw<GoRouter>> {
  AppRouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appRouterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appRouterHash();

  @$internal
  @override
  $ProviderElement<Raw<GoRouter>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Raw<GoRouter> create(Ref ref) {
    return appRouter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<GoRouter> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Raw<GoRouter>>(value),
    );
  }
}

String _$appRouterHash() => r'c6297eb61c398a960bd44cb47a7a3cea48c05d5e';
