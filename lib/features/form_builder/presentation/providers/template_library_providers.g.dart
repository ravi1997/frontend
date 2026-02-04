// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template_library_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(templateLibraryRepository)
final templateLibraryRepositoryProvider = TemplateLibraryRepositoryProvider._();

final class TemplateLibraryRepositoryProvider
    extends
        $FunctionalProvider<
          TemplateLibraryRepository,
          TemplateLibraryRepository,
          TemplateLibraryRepository
        >
    with $Provider<TemplateLibraryRepository> {
  TemplateLibraryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'templateLibraryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$templateLibraryRepositoryHash();

  @$internal
  @override
  $ProviderElement<TemplateLibraryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TemplateLibraryRepository create(Ref ref) {
    return templateLibraryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TemplateLibraryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TemplateLibraryRepository>(value),
    );
  }
}

String _$templateLibraryRepositoryHash() =>
    r'670ffb7cbbc0bce2c28c7e900976b305173dfbb1';
