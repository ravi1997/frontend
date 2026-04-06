// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_submission_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FormSubmissionController)
final formSubmissionControllerProvider = FormSubmissionControllerProvider._();

final class FormSubmissionControllerProvider
    extends $NotifierProvider<FormSubmissionController, AsyncValue<void>> {
  FormSubmissionControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'formSubmissionControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$formSubmissionControllerHash();

  @$internal
  @override
  FormSubmissionController create() => FormSubmissionController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$formSubmissionControllerHash() =>
    r'46133cf73c3a7b48789aa02322aef3110c92ae74';

abstract class _$FormSubmissionController extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
