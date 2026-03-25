// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analysis_builder_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AnalysisBuilderController)
final analysisBuilderControllerProvider = AnalysisBuilderControllerFamily._();

final class AnalysisBuilderControllerProvider
    extends $NotifierProvider<AnalysisBuilderController, AnalysisBuilderState> {
  AnalysisBuilderControllerProvider._({
    required AnalysisBuilderControllerFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'analysisBuilderControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$analysisBuilderControllerHash();

  @override
  String toString() {
    return r'analysisBuilderControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AnalysisBuilderController create() => AnalysisBuilderController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AnalysisBuilderState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AnalysisBuilderState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AnalysisBuilderControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$analysisBuilderControllerHash() =>
    r'cbfc8ad323dee3e9cc96eeed088f71ba5935d47c';

final class AnalysisBuilderControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          AnalysisBuilderController,
          AnalysisBuilderState,
          AnalysisBuilderState,
          AnalysisBuilderState,
          String?
        > {
  AnalysisBuilderControllerFamily._()
    : super(
        retry: null,
        name: r'analysisBuilderControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AnalysisBuilderControllerProvider call(String? dashboardId) =>
      AnalysisBuilderControllerProvider._(argument: dashboardId, from: this);

  @override
  String toString() => r'analysisBuilderControllerProvider';
}

abstract class _$AnalysisBuilderController
    extends $Notifier<AnalysisBuilderState> {
  late final _$args = ref.$arg as String?;
  String? get dashboardId => _$args;

  AnalysisBuilderState build(String? dashboardId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AnalysisBuilderState, AnalysisBuilderState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AnalysisBuilderState, AnalysisBuilderState>,
              AnalysisBuilderState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(formFields)
final formFieldsProvider = FormFieldsFamily._();

final class FormFieldsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  FormFieldsProvider._({
    required FormFieldsFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'formFieldsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$formFieldsHash();

  @override
  String toString() {
    return r'formFieldsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    final argument = this.argument as String?;
    return formFields(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FormFieldsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$formFieldsHash() => r'7c71235d44f49fb6ecfc1da240408267efaf9827';

final class FormFieldsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<String>>, String?> {
  FormFieldsFamily._()
    : super(
        retry: null,
        name: r'formFieldsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FormFieldsProvider call(String? formId) =>
      FormFieldsProvider._(argument: formId, from: this);

  @override
  String toString() => r'formFieldsProvider';
}
