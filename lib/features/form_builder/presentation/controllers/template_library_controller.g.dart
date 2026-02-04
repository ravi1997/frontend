// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template_library_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TemplateLibraryController)
final templateLibraryControllerProvider = TemplateLibraryControllerProvider._();

final class TemplateLibraryControllerProvider
    extends
        $AsyncNotifierProvider<
          TemplateLibraryController,
          TemplateLibraryState
        > {
  TemplateLibraryControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'templateLibraryControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$templateLibraryControllerHash();

  @$internal
  @override
  TemplateLibraryController create() => TemplateLibraryController();
}

String _$templateLibraryControllerHash() =>
    r'a83490c9253db86018cb0bca2092519e1e405de0';

abstract class _$TemplateLibraryController
    extends $AsyncNotifier<TemplateLibraryState> {
  FutureOr<TemplateLibraryState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<TemplateLibraryState>, TemplateLibraryState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<TemplateLibraryState>,
                TemplateLibraryState
              >,
              AsyncValue<TemplateLibraryState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
