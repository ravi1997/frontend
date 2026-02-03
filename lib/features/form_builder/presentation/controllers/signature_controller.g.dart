// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signature_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Controller for managing signature requests.

@ProviderFor(SignatureController)
final signatureControllerProvider = SignatureControllerProvider._();

/// Controller for managing signature requests.
final class SignatureControllerProvider
    extends $NotifierProvider<SignatureController, List<SignatureRequest>> {
  /// Controller for managing signature requests.
  SignatureControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signatureControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signatureControllerHash();

  @$internal
  @override
  SignatureController create() => SignatureController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<SignatureRequest> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<SignatureRequest>>(value),
    );
  }
}

String _$signatureControllerHash() =>
    r'16b20a9d1be31fa3ff460ebf24e29e58201f48b2';

/// Controller for managing signature requests.

abstract class _$SignatureController extends $Notifier<List<SignatureRequest>> {
  List<SignatureRequest> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<List<SignatureRequest>, List<SignatureRequest>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<SignatureRequest>, List<SignatureRequest>>,
              List<SignatureRequest>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
