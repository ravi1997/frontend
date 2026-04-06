// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enhanced_sync_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Enhanced sync service with retry logic and conflict resolution

@ProviderFor(EnhancedSyncService)
final enhancedSyncServiceProvider = EnhancedSyncServiceProvider._();

/// Enhanced sync service with retry logic and conflict resolution
final class EnhancedSyncServiceProvider
    extends $AsyncNotifierProvider<EnhancedSyncService, void> {
  /// Enhanced sync service with retry logic and conflict resolution
  EnhancedSyncServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'enhancedSyncServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$enhancedSyncServiceHash();

  @$internal
  @override
  EnhancedSyncService create() => EnhancedSyncService();
}

String _$enhancedSyncServiceHash() =>
    r'dc8e133c29eee70246c854f7f2113074fd6bc67c';

/// Enhanced sync service with retry logic and conflict resolution

abstract class _$EnhancedSyncService extends $AsyncNotifier<void> {
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
