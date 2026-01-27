// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_builder_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(formBuilderRepository)
final formBuilderRepositoryProvider = FormBuilderRepositoryProvider._();

final class FormBuilderRepositoryProvider
    extends
        $FunctionalProvider<
          FormBuilderRepository,
          FormBuilderRepository,
          FormBuilderRepository
        >
    with $Provider<FormBuilderRepository> {
  FormBuilderRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'formBuilderRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$formBuilderRepositoryHash();

  @$internal
  @override
  $ProviderElement<FormBuilderRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FormBuilderRepository create(Ref ref) {
    return formBuilderRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FormBuilderRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FormBuilderRepository>(value),
    );
  }
}

String _$formBuilderRepositoryHash() =>
    r'92f13c61b0fa574d70ecc115c795832d788296a6';
