// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for accessing the analytics state.
///
/// This provider watches the analytics controller and provides
/// access to the current analytics state including summary,
/// timeline, and distribution data.

@ProviderFor(analyticsState)
final analyticsStateProvider = AnalyticsStateFamily._();

/// Provider for accessing the analytics state.
///
/// This provider watches the analytics controller and provides
/// access to the current analytics state including summary,
/// timeline, and distribution data.

final class AnalyticsStateProvider
    extends $FunctionalProvider<AnalyticsState, AnalyticsState, AnalyticsState>
    with $Provider<AnalyticsState> {
  /// Provider for accessing the analytics state.
  ///
  /// This provider watches the analytics controller and provides
  /// access to the current analytics state including summary,
  /// timeline, and distribution data.
  AnalyticsStateProvider._({
    required AnalyticsStateFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'analyticsStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$analyticsStateHash();

  @override
  String toString() {
    return r'analyticsStateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<AnalyticsState> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AnalyticsState create(Ref ref) {
    final argument = this.argument as String;
    return analyticsState(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AnalyticsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AnalyticsState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AnalyticsStateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$analyticsStateHash() => r'da2f41c3b12d718522936f3e19816023bb6feaab';

/// Provider for accessing the analytics state.
///
/// This provider watches the analytics controller and provides
/// access to the current analytics state including summary,
/// timeline, and distribution data.

final class AnalyticsStateFamily extends $Family
    with $FunctionalFamilyOverride<AnalyticsState, String> {
  AnalyticsStateFamily._()
    : super(
        retry: null,
        name: r'analyticsStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for accessing the analytics state.
  ///
  /// This provider watches the analytics controller and provides
  /// access to the current analytics state including summary,
  /// timeline, and distribution data.

  AnalyticsStateProvider call(String formId) =>
      AnalyticsStateProvider._(argument: formId, from: this);

  @override
  String toString() => r'analyticsStateProvider';
}

/// Provider for accessing the summary analytics data.
///
/// This provider provides access to the summary statistics
/// for a specific form.

@ProviderFor(analyticsSummary)
final analyticsSummaryProvider = AnalyticsSummaryFamily._();

/// Provider for accessing the summary analytics data.
///
/// This provider provides access to the summary statistics
/// for a specific form.

final class AnalyticsSummaryProvider
    extends
        $FunctionalProvider<
          AnalyticsSummary?,
          AnalyticsSummary?,
          AnalyticsSummary?
        >
    with $Provider<AnalyticsSummary?> {
  /// Provider for accessing the summary analytics data.
  ///
  /// This provider provides access to the summary statistics
  /// for a specific form.
  AnalyticsSummaryProvider._({
    required AnalyticsSummaryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'analyticsSummaryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$analyticsSummaryHash();

  @override
  String toString() {
    return r'analyticsSummaryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<AnalyticsSummary?> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AnalyticsSummary? create(Ref ref) {
    final argument = this.argument as String;
    return analyticsSummary(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AnalyticsSummary? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AnalyticsSummary?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AnalyticsSummaryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$analyticsSummaryHash() => r'2c35467bb0f3ce679a995e98550a213352b239f9';

/// Provider for accessing the summary analytics data.
///
/// This provider provides access to the summary statistics
/// for a specific form.

final class AnalyticsSummaryFamily extends $Family
    with $FunctionalFamilyOverride<AnalyticsSummary?, String> {
  AnalyticsSummaryFamily._()
    : super(
        retry: null,
        name: r'analyticsSummaryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for accessing the summary analytics data.
  ///
  /// This provider provides access to the summary statistics
  /// for a specific form.

  AnalyticsSummaryProvider call(String formId) =>
      AnalyticsSummaryProvider._(argument: formId, from: this);

  @override
  String toString() => r'analyticsSummaryProvider';
}

/// Provider for accessing the timeline analytics data.
///
/// This provider provides access to the timeline data
/// for a specific form.

@ProviderFor(analyticsTimeline)
final analyticsTimelineProvider = AnalyticsTimelineFamily._();

/// Provider for accessing the timeline analytics data.
///
/// This provider provides access to the timeline data
/// for a specific form.

final class AnalyticsTimelineProvider
    extends
        $FunctionalProvider<
          AnalyticsTimeline?,
          AnalyticsTimeline?,
          AnalyticsTimeline?
        >
    with $Provider<AnalyticsTimeline?> {
  /// Provider for accessing the timeline analytics data.
  ///
  /// This provider provides access to the timeline data
  /// for a specific form.
  AnalyticsTimelineProvider._({
    required AnalyticsTimelineFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'analyticsTimelineProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$analyticsTimelineHash();

  @override
  String toString() {
    return r'analyticsTimelineProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<AnalyticsTimeline?> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AnalyticsTimeline? create(Ref ref) {
    final argument = this.argument as String;
    return analyticsTimeline(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AnalyticsTimeline? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AnalyticsTimeline?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AnalyticsTimelineProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$analyticsTimelineHash() => r'5fa5dad2cc8dd9f03f154bc82fb720e5089e0614';

/// Provider for accessing the timeline analytics data.
///
/// This provider provides access to the timeline data
/// for a specific form.

final class AnalyticsTimelineFamily extends $Family
    with $FunctionalFamilyOverride<AnalyticsTimeline?, String> {
  AnalyticsTimelineFamily._()
    : super(
        retry: null,
        name: r'analyticsTimelineProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for accessing the timeline analytics data.
  ///
  /// This provider provides access to the timeline data
  /// for a specific form.

  AnalyticsTimelineProvider call(String formId) =>
      AnalyticsTimelineProvider._(argument: formId, from: this);

  @override
  String toString() => r'analyticsTimelineProvider';
}

/// Provider for accessing the distribution analytics data.
///
/// This provider provides access to the distribution data
/// for a specific form.

@ProviderFor(analyticsDistribution)
final analyticsDistributionProvider = AnalyticsDistributionFamily._();

/// Provider for accessing the distribution analytics data.
///
/// This provider provides access to the distribution data
/// for a specific form.

final class AnalyticsDistributionProvider
    extends
        $FunctionalProvider<
          AnalyticsDistribution?,
          AnalyticsDistribution?,
          AnalyticsDistribution?
        >
    with $Provider<AnalyticsDistribution?> {
  /// Provider for accessing the distribution analytics data.
  ///
  /// This provider provides access to the distribution data
  /// for a specific form.
  AnalyticsDistributionProvider._({
    required AnalyticsDistributionFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'analyticsDistributionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$analyticsDistributionHash();

  @override
  String toString() {
    return r'analyticsDistributionProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<AnalyticsDistribution?> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AnalyticsDistribution? create(Ref ref) {
    final argument = this.argument as String;
    return analyticsDistribution(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AnalyticsDistribution? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AnalyticsDistribution?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AnalyticsDistributionProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$analyticsDistributionHash() =>
    r'cb25fffc19a955b467f0219053896beac2c52072';

/// Provider for accessing the distribution analytics data.
///
/// This provider provides access to the distribution data
/// for a specific form.

final class AnalyticsDistributionFamily extends $Family
    with $FunctionalFamilyOverride<AnalyticsDistribution?, String> {
  AnalyticsDistributionFamily._()
    : super(
        retry: null,
        name: r'analyticsDistributionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for accessing the distribution analytics data.
  ///
  /// This provider provides access to the distribution data
  /// for a specific form.

  AnalyticsDistributionProvider call(String formId) =>
      AnalyticsDistributionProvider._(argument: formId, from: this);

  @override
  String toString() => r'analyticsDistributionProvider';
}

/// Provider for accessing the loading state.
///
/// This provider provides access to the loading state
/// for analytics data.

@ProviderFor(analyticsIsLoading)
final analyticsIsLoadingProvider = AnalyticsIsLoadingFamily._();

/// Provider for accessing the loading state.
///
/// This provider provides access to the loading state
/// for analytics data.

final class AnalyticsIsLoadingProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Provider for accessing the loading state.
  ///
  /// This provider provides access to the loading state
  /// for analytics data.
  AnalyticsIsLoadingProvider._({
    required AnalyticsIsLoadingFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'analyticsIsLoadingProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$analyticsIsLoadingHash();

  @override
  String toString() {
    return r'analyticsIsLoadingProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    final argument = this.argument as String;
    return analyticsIsLoading(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AnalyticsIsLoadingProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$analyticsIsLoadingHash() =>
    r'c4e2a3a569ed4497678e314dae4912dcb8425b3c';

/// Provider for accessing the loading state.
///
/// This provider provides access to the loading state
/// for analytics data.

final class AnalyticsIsLoadingFamily extends $Family
    with $FunctionalFamilyOverride<bool, String> {
  AnalyticsIsLoadingFamily._()
    : super(
        retry: null,
        name: r'analyticsIsLoadingProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for accessing the loading state.
  ///
  /// This provider provides access to the loading state
  /// for analytics data.

  AnalyticsIsLoadingProvider call(String formId) =>
      AnalyticsIsLoadingProvider._(argument: formId, from: this);

  @override
  String toString() => r'analyticsIsLoadingProvider';
}

/// Provider for accessing the error state.
///
/// This provider provides access to any error that occurred
/// while loading analytics data.

@ProviderFor(analyticsError)
final analyticsErrorProvider = AnalyticsErrorFamily._();

/// Provider for accessing the error state.
///
/// This provider provides access to any error that occurred
/// while loading analytics data.

final class AnalyticsErrorProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// Provider for accessing the error state.
  ///
  /// This provider provides access to any error that occurred
  /// while loading analytics data.
  AnalyticsErrorProvider._({
    required AnalyticsErrorFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'analyticsErrorProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$analyticsErrorHash();

  @override
  String toString() {
    return r'analyticsErrorProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    final argument = this.argument as String;
    return analyticsError(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AnalyticsErrorProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$analyticsErrorHash() => r'df7285dc4da2e93f88a730b47280319928adc689';

/// Provider for accessing the error state.
///
/// This provider provides access to any error that occurred
/// while loading analytics data.

final class AnalyticsErrorFamily extends $Family
    with $FunctionalFamilyOverride<String?, String> {
  AnalyticsErrorFamily._()
    : super(
        retry: null,
        name: r'analyticsErrorProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for accessing the error state.
  ///
  /// This provider provides access to any error that occurred
  /// while loading analytics data.

  AnalyticsErrorProvider call(String formId) =>
      AnalyticsErrorProvider._(argument: formId, from: this);

  @override
  String toString() => r'analyticsErrorProvider';
}

/// Provider for checking if there is an error.
///
/// This provider returns true if there is an error state.

@ProviderFor(analyticsHasError)
final analyticsHasErrorProvider = AnalyticsHasErrorFamily._();

/// Provider for checking if there is an error.
///
/// This provider returns true if there is an error state.

final class AnalyticsHasErrorProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Provider for checking if there is an error.
  ///
  /// This provider returns true if there is an error state.
  AnalyticsHasErrorProvider._({
    required AnalyticsHasErrorFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'analyticsHasErrorProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$analyticsHasErrorHash();

  @override
  String toString() {
    return r'analyticsHasErrorProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    final argument = this.argument as String;
    return analyticsHasError(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AnalyticsHasErrorProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$analyticsHasErrorHash() => r'f7fe088dd9e86cd7a80f08245d8de16b2ae07714';

/// Provider for checking if there is an error.
///
/// This provider returns true if there is an error state.

final class AnalyticsHasErrorFamily extends $Family
    with $FunctionalFamilyOverride<bool, String> {
  AnalyticsHasErrorFamily._()
    : super(
        retry: null,
        name: r'analyticsHasErrorProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for checking if there is an error.
  ///
  /// This provider returns true if there is an error state.

  AnalyticsHasErrorProvider call(String formId) =>
      AnalyticsHasErrorProvider._(argument: formId, from: this);

  @override
  String toString() => r'analyticsHasErrorProvider';
}
