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
    r'8b7793ff1e0e9053cc2a9ca8d4a5a72a2d87dc72';
