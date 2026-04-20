// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'version_history_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Controller for managing version history using Riverpod.
///
/// Provides async access to:
/// - List of all versions for a form
/// - Selected version details
/// - Version restoration functionality

@ProviderFor(VersionHistoryController)
final versionHistoryControllerProvider = VersionHistoryControllerFamily._();

/// Controller for managing version history using Riverpod.
///
/// Provides async access to:
/// - List of all versions for a form
/// - Selected version details
/// - Version restoration functionality
final class VersionHistoryControllerProvider
    extends $NotifierProvider<VersionHistoryController, VersionHistoryState> {
  /// Controller for managing version history using Riverpod.
  ///
  /// Provides async access to:
  /// - List of all versions for a form
  /// - Selected version details
  /// - Version restoration functionality
  VersionHistoryControllerProvider._({
    required VersionHistoryControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'versionHistoryControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$versionHistoryControllerHash();

  @override
  String toString() {
    return r'versionHistoryControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  VersionHistoryController create() => VersionHistoryController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VersionHistoryState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VersionHistoryState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is VersionHistoryControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$versionHistoryControllerHash() =>
    r'a157b4cf38e29c8456f4643341931a99320202fe';

/// Controller for managing version history using Riverpod.
///
/// Provides async access to:
/// - List of all versions for a form
/// - Selected version details
/// - Version restoration functionality

final class VersionHistoryControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          VersionHistoryController,
          VersionHistoryState,
          VersionHistoryState,
          VersionHistoryState,
          String
        > {
  VersionHistoryControllerFamily._()
    : super(
        retry: null,
        name: r'versionHistoryControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Controller for managing version history using Riverpod.
  ///
  /// Provides async access to:
  /// - List of all versions for a form
  /// - Selected version details
  /// - Version restoration functionality

  VersionHistoryControllerProvider call(String formKey) =>
      VersionHistoryControllerProvider._(argument: formKey, from: this);

  @override
  String toString() => r'versionHistoryControllerProvider';
}

/// Controller for managing version history using Riverpod.
///
/// Provides async access to:
/// - List of all versions for a form
/// - Selected version details
/// - Version restoration functionality

abstract class _$VersionHistoryController
    extends $Notifier<VersionHistoryState> {
  late final _$args = ref.$arg as String;
  String get formKey => _$args;

  VersionHistoryState build(String formKey);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<VersionHistoryState, VersionHistoryState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<VersionHistoryState, VersionHistoryState>,
              VersionHistoryState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
