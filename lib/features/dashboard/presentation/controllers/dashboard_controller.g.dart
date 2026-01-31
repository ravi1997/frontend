// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DashboardController)
final dashboardControllerProvider = DashboardControllerProvider._();

final class DashboardControllerProvider
    extends $AsyncNotifierProvider<DashboardController, DashboardData> {
  DashboardControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dashboardControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dashboardControllerHash();

  @$internal
  @override
  DashboardController create() => DashboardController();
}

String _$dashboardControllerHash() =>
    r'af8f47348e30d91d48a5b10462ee7a24d67f4811';

abstract class _$DashboardController extends $AsyncNotifier<DashboardData> {
  FutureOr<DashboardData> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<DashboardData>, DashboardData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<DashboardData>, DashboardData>,
              AsyncValue<DashboardData>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(DashboardSearchQuery)
final dashboardSearchQueryProvider = DashboardSearchQueryProvider._();

final class DashboardSearchQueryProvider
    extends $NotifierProvider<DashboardSearchQuery, String> {
  DashboardSearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dashboardSearchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dashboardSearchQueryHash();

  @$internal
  @override
  DashboardSearchQuery create() => DashboardSearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$dashboardSearchQueryHash() =>
    r'3259821c9f2f586d1fcb3992fb860f4169184eb6';

abstract class _$DashboardSearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(DashboardSortBy)
final dashboardSortByProvider = DashboardSortByProvider._();

final class DashboardSortByProvider
    extends $NotifierProvider<DashboardSortBy, String> {
  DashboardSortByProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dashboardSortByProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dashboardSortByHash();

  @$internal
  @override
  DashboardSortBy create() => DashboardSortBy();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$dashboardSortByHash() => r'3e3b73df5f3fe578072c07ec3fae211422bf6fc9';

abstract class _$DashboardSortBy extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(filteredRecentForms)
final filteredRecentFormsProvider = FilteredRecentFormsProvider._();

final class FilteredRecentFormsProvider
    extends
        $FunctionalProvider<
          List<RecentForm>,
          List<RecentForm>,
          List<RecentForm>
        >
    with $Provider<List<RecentForm>> {
  FilteredRecentFormsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredRecentFormsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredRecentFormsHash();

  @$internal
  @override
  $ProviderElement<List<RecentForm>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<RecentForm> create(Ref ref) {
    return filteredRecentForms(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<RecentForm> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<RecentForm>>(value),
    );
  }
}

String _$filteredRecentFormsHash() =>
    r'02b338c3ece203093b8daf98b675c012c19ac3bd';
