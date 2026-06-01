// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Controller for managing analytics data using Riverpod state management.
///
/// Provides async access to all three types of analytics data:
/// - Summary statistics
/// - Timeline data
/// - Distribution data
///
/// Supports individual loading of each analytics type and batch refresh.

@ProviderFor(AnalyticsController)
final analyticsControllerProvider = AnalyticsControllerFamily._();

/// Controller for managing analytics data using Riverpod state management.
///
/// Provides async access to all three types of analytics data:
/// - Summary statistics
/// - Timeline data
/// - Distribution data
///
/// Supports individual loading of each analytics type and batch refresh.
final class AnalyticsControllerProvider
    extends $NotifierProvider<AnalyticsController, AnalyticsState> {
  /// Controller for managing analytics data using Riverpod state management.
  ///
  /// Provides async access to all three types of analytics data:
  /// - Summary statistics
  /// - Timeline data
  /// - Distribution data
  ///
  /// Supports individual loading of each analytics type and batch refresh.
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

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AnalyticsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AnalyticsState>(value),
    );
  }

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
    r'fb643ce91fc9877967f6c7cfcecb71466299376f';

/// Controller for managing analytics data using Riverpod state management.
///
/// Provides async access to all three types of analytics data:
/// - Summary statistics
/// - Timeline data
/// - Distribution data
///
/// Supports individual loading of each analytics type and batch refresh.

final class AnalyticsControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          AnalyticsController,
          AnalyticsState,
          AnalyticsState,
          AnalyticsState,
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

  /// Controller for managing analytics data using Riverpod state management.
  ///
  /// Provides async access to all three types of analytics data:
  /// - Summary statistics
  /// - Timeline data
  /// - Distribution data
  ///
  /// Supports individual loading of each analytics type and batch refresh.

  AnalyticsControllerProvider call(String formId) =>
      AnalyticsControllerProvider._(argument: formId, from: this);

  @override
  String toString() => r'analyticsControllerProvider';
}

/// Controller for managing analytics data using Riverpod state management.
///
/// Provides async access to all three types of analytics data:
/// - Summary statistics
/// - Timeline data
/// - Distribution data
///
/// Supports individual loading of each analytics type and batch refresh.

abstract class _$AnalyticsController extends $Notifier<AnalyticsState> {
  late final _$args = ref.$arg as String;
  String get formId => _$args;

  AnalyticsState build(String formId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AnalyticsState, AnalyticsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AnalyticsState, AnalyticsState>,
              AnalyticsState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
