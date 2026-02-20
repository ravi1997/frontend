// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_fields_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CustomFields)
final customFieldsProvider = CustomFieldsProvider._();

final class CustomFieldsProvider
    extends $NotifierProvider<CustomFields, List<CustomFieldTemplate>> {
  CustomFieldsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customFieldsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customFieldsHash();

  @$internal
  @override
  CustomFields create() => CustomFields();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<CustomFieldTemplate> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<CustomFieldTemplate>>(value),
    );
  }
}

String _$customFieldsHash() => r'8c0c1edd9e5f9166a3dafb02618f6583a6dcf589';

abstract class _$CustomFields extends $Notifier<List<CustomFieldTemplate>> {
  List<CustomFieldTemplate> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<List<CustomFieldTemplate>, List<CustomFieldTemplate>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<CustomFieldTemplate>, List<CustomFieldTemplate>>,
              List<CustomFieldTemplate>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
