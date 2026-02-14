// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_builder_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FormBuilderController)
final formBuilderControllerProvider = FormBuilderControllerFamily._();

final class FormBuilderControllerProvider
    extends $AsyncNotifierProvider<FormBuilderController, FormBuilderState> {
  FormBuilderControllerProvider._({
    required FormBuilderControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'formBuilderControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$formBuilderControllerHash();

  @override
  String toString() {
    return r'formBuilderControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  FormBuilderController create() => FormBuilderController();

  @override
  bool operator ==(Object other) {
    return other is FormBuilderControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$formBuilderControllerHash() =>
    r'5d3964386e02b97aaea9eb23d22c0204486f767f';

final class FormBuilderControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          FormBuilderController,
          AsyncValue<FormBuilderState>,
          FormBuilderState,
          FutureOr<FormBuilderState>,
          String
        > {
  FormBuilderControllerFamily._()
    : super(
        retry: null,
        name: r'formBuilderControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FormBuilderControllerProvider call(String formId) =>
      FormBuilderControllerProvider._(argument: formId, from: this);

  @override
  String toString() => r'formBuilderControllerProvider';
}

abstract class _$FormBuilderController
    extends $AsyncNotifier<FormBuilderState> {
  late final _$args = ref.$arg as String;
  String get formId => _$args;

  FutureOr<FormBuilderState> build(String formId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<FormBuilderState>, FormBuilderState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<FormBuilderState>, FormBuilderState>,
              AsyncValue<FormBuilderState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
