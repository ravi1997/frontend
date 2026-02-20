// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_management_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(userManagementRepositoryImpl)
final userManagementRepositoryImplProvider =
    UserManagementRepositoryImplProvider._();

final class UserManagementRepositoryImplProvider
    extends
        $FunctionalProvider<
          UserManagementRepository,
          UserManagementRepository,
          UserManagementRepository
        >
    with $Provider<UserManagementRepository> {
  UserManagementRepositoryImplProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userManagementRepositoryImplProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userManagementRepositoryImplHash();

  @$internal
  @override
  $ProviderElement<UserManagementRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UserManagementRepository create(Ref ref) {
    return userManagementRepositoryImpl(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserManagementRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserManagementRepository>(value),
    );
  }
}

String _$userManagementRepositoryImplHash() =>
    r'4beef7e32c46260e429d8087b9dd817fa2b3da3c';
