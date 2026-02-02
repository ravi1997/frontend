// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AnalyticsController)
final analyticsControllerProvider = AnalyticsControllerFamily._();

final class AnalyticsControllerProvider
    extends $AsyncNotifierProvider<AnalyticsController, FormAnalytics> {
  AnalyticsControllerProvider._({
    required AnalyticsControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'analyticsControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$analyticsControllerHash();

  @override
  String toString() {
    return r'analyticsControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AnalyticsController create() => AnalyticsController();

  @override
  bool operator ==(Object other) {
    return other is AnalyticsControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$analyticsControllerHash() =>
    r'852382d7a57111ba798e2ebca74241f70b6fd404';

final class AnalyticsControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          AnalyticsController,
          AsyncValue<FormAnalytics>,
          FormAnalytics,
          FutureOr<FormAnalytics>,
          String
        > {
  AnalyticsControllerFamily._()
    : super(
        retry: null,
        name: r'analyticsControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AnalyticsControllerProvider call(String formId) =>
      AnalyticsControllerProvider._(argument: formId, from: this);

  @override
  String toString() => r'analyticsControllerProvider';
}

abstract class _$AnalyticsController extends $AsyncNotifier<FormAnalytics> {
  late final _$args = ref.$arg as String;
  String get formId => _$args;

  FutureOr<FormAnalytics> build(String formId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<FormAnalytics>, FormAnalytics>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<FormAnalytics>, FormAnalytics>,
              AsyncValue<FormAnalytics>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
