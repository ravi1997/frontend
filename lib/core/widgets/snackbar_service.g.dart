// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'snackbar_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SnackbarService)
final snackbarServiceProvider = SnackbarServiceProvider._();

final class SnackbarServiceProvider
    extends $NotifierProvider<SnackbarService, void> {
  SnackbarServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'snackbarServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$snackbarServiceHash();

  @$internal
  @override
  SnackbarService create() => SnackbarService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$snackbarServiceHash() => r'07e0fec600a1451efd58d9aadf9684bbfd8bb7a5';

abstract class _$SnackbarService extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
