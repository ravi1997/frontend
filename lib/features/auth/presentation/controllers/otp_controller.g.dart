// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(OtpController)
final otpControllerProvider = OtpControllerProvider._();

final class OtpControllerProvider
    extends $NotifierProvider<OtpController, int> {
  OtpControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'otpControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$otpControllerHash();

  @$internal
  @override
  OtpController create() => OtpController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$otpControllerHash() => r'23ae9515dabf18c9d591250dbf284ecc4b23fe44';

abstract class _$OtpController extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
