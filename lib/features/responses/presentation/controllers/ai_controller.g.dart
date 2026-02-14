// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AIController)
final aIControllerProvider = AIControllerProvider._();

final class AIControllerProvider
    extends $AsyncNotifierProvider<AIController, void> {
  AIControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aIControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aIControllerHash();

  @$internal
  @override
  AIController create() => AIController();
}

String _$aIControllerHash() => r'605a495021dd351177bd2b9532717ec5ca1f7470';

abstract class _$AIController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(sentimentTrends)
final sentimentTrendsProvider = SentimentTrendsFamily._();

final class SentimentTrendsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, dynamic>>,
          Map<String, dynamic>,
          FutureOr<Map<String, dynamic>>
        >
    with
        $FutureModifier<Map<String, dynamic>>,
        $FutureProvider<Map<String, dynamic>> {
  SentimentTrendsProvider._({
    required SentimentTrendsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'sentimentTrendsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sentimentTrendsHash();

  @override
  String toString() {
    return r'sentimentTrendsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Map<String, dynamic>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, dynamic>> create(Ref ref) {
    final argument = this.argument as String;
    return sentimentTrends(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SentimentTrendsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sentimentTrendsHash() => r'52a8c7d56a3b910d56e577085ef16d35afd45213';

final class SentimentTrendsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Map<String, dynamic>>, String> {
  SentimentTrendsFamily._()
    : super(
        retry: null,
        name: r'sentimentTrendsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SentimentTrendsProvider call(String formId) =>
      SentimentTrendsProvider._(argument: formId, from: this);

  @override
  String toString() => r'sentimentTrendsProvider';
}

@ProviderFor(anomalies)
final anomaliesProvider = AnomaliesFamily._();

final class AnomaliesProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, dynamic>>,
          Map<String, dynamic>,
          FutureOr<Map<String, dynamic>>
        >
    with
        $FutureModifier<Map<String, dynamic>>,
        $FutureProvider<Map<String, dynamic>> {
  AnomaliesProvider._({
    required AnomaliesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'anomaliesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$anomaliesHash();

  @override
  String toString() {
    return r'anomaliesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Map<String, dynamic>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, dynamic>> create(Ref ref) {
    final argument = this.argument as String;
    return anomalies(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AnomaliesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$anomaliesHash() => r'792c8259b3c83525ddb0c35085853f13126fcd72';

final class AnomaliesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Map<String, dynamic>>, String> {
  AnomaliesFamily._()
    : super(
        retry: null,
        name: r'anomaliesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AnomaliesProvider call(String formId) =>
      AnomaliesProvider._(argument: formId, from: this);

  @override
  String toString() => r'anomaliesProvider';
}
