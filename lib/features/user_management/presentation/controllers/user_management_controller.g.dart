// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_management_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UserManagementController)
final userManagementControllerProvider = UserManagementControllerProvider._();

final class UserManagementControllerProvider
    extends $AsyncNotifierProvider<UserManagementController, List<User>> {
  UserManagementControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userManagementControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userManagementControllerHash();

  @$internal
  @override
  UserManagementController create() => UserManagementController();
}

String _$userManagementControllerHash() =>
    r'823fa2ca4fe25a0713394be5838907968e2d0728';

abstract class _$UserManagementController extends $AsyncNotifier<List<User>> {
  FutureOr<List<User>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<User>>, List<User>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<User>>, List<User>>,
              AsyncValue<List<User>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(departments)
final departmentsProvider = DepartmentsProvider._();

final class DepartmentsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  DepartmentsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'departmentsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$departmentsHash();

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    return departments(ref);
  }
}

String _$departmentsHash() => r'4c58b55b9fb497569108fd95bb95da63c2ff1130';

@ProviderFor(userActivity)
final userActivityProvider = UserActivityFamily._();

final class UserActivityProvider
    extends
        $FunctionalProvider<
          AsyncValue<UserActivity>,
          UserActivity,
          FutureOr<UserActivity>
        >
    with $FutureModifier<UserActivity>, $FutureProvider<UserActivity> {
  UserActivityProvider._({
    required UserActivityFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userActivityProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userActivityHash();

  @override
  String toString() {
    return r'userActivityProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<UserActivity> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<UserActivity> create(Ref ref) {
    final argument = this.argument as String;
    return userActivity(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UserActivityProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userActivityHash() => r'75d9a2de563136c2ab8c3be6b731f30639981bb0';

final class UserActivityFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<UserActivity>, String> {
  UserActivityFamily._()
    : super(
        retry: null,
        name: r'userActivityProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UserActivityProvider call(String userId) =>
      UserActivityProvider._(argument: userId, from: this);

  @override
  String toString() => r'userActivityProvider';
}
