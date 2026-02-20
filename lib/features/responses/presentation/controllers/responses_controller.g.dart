// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'responses_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(formResponses)
final formResponsesProvider = FormResponsesFamily._();

final class FormResponsesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<FormResponse>>,
          List<FormResponse>,
          FutureOr<List<FormResponse>>
        >
    with
        $FutureModifier<List<FormResponse>>,
        $FutureProvider<List<FormResponse>> {
  FormResponsesProvider._({
    required FormResponsesFamily super.from,
    required (String, {String? searchQuery}) super.argument,
  }) : super(
         retry: null,
         name: r'formResponsesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$formResponsesHash();

  @override
  String toString() {
    return r'formResponsesProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<FormResponse>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<FormResponse>> create(Ref ref) {
    final argument = this.argument as (String, {String? searchQuery});
    return formResponses(ref, argument.$1, searchQuery: argument.searchQuery);
  }

  @override
  bool operator ==(Object other) {
    return other is FormResponsesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$formResponsesHash() => r'd63956a5f62b1faaaff78eb73c3df84deb2e0746';

final class FormResponsesFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<FormResponse>>,
          (String, {String? searchQuery})
        > {
  FormResponsesFamily._()
    : super(
        retry: null,
        name: r'formResponsesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FormResponsesProvider call(String formId, {String? searchQuery}) =>
      FormResponsesProvider._(
        argument: (formId, searchQuery: searchQuery),
        from: this,
      );

  @override
  String toString() => r'formResponsesProvider';
}

@ProviderFor(responseDetail)
final responseDetailProvider = ResponseDetailFamily._();

final class ResponseDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<FormResponse>,
          FormResponse,
          FutureOr<FormResponse>
        >
    with $FutureModifier<FormResponse>, $FutureProvider<FormResponse> {
  ResponseDetailProvider._({
    required ResponseDetailFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'responseDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$responseDetailHash();

  @override
  String toString() {
    return r'responseDetailProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<FormResponse> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<FormResponse> create(Ref ref) {
    final argument = this.argument as (String, String);
    return responseDetail(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is ResponseDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$responseDetailHash() => r'fc3f7bf2ca6669c12ad1e79b3bf1e8ae8cee27a6';

final class ResponseDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<FormResponse>, (String, String)> {
  ResponseDetailFamily._()
    : super(
        retry: null,
        name: r'responseDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ResponseDetailProvider call(String formId, String responseId) =>
      ResponseDetailProvider._(argument: (formId, responseId), from: this);

  @override
  String toString() => r'responseDetailProvider';
}

@ProviderFor(responseHistory)
final responseHistoryProvider = ResponseHistoryFamily._();

final class ResponseHistoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ResponseHistory>>,
          List<ResponseHistory>,
          FutureOr<List<ResponseHistory>>
        >
    with
        $FutureModifier<List<ResponseHistory>>,
        $FutureProvider<List<ResponseHistory>> {
  ResponseHistoryProvider._({
    required ResponseHistoryFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'responseHistoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$responseHistoryHash();

  @override
  String toString() {
    return r'responseHistoryProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<ResponseHistory>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ResponseHistory>> create(Ref ref) {
    final argument = this.argument as (String, String);
    return responseHistory(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is ResponseHistoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$responseHistoryHash() => r'cb8f177b5f87bfa032b82b3a376ab25fc978b0c9';

final class ResponseHistoryFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<ResponseHistory>>,
          (String, String)
        > {
  ResponseHistoryFamily._()
    : super(
        retry: null,
        name: r'responseHistoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ResponseHistoryProvider call(String formId, String responseId) =>
      ResponseHistoryProvider._(argument: (formId, responseId), from: this);

  @override
  String toString() => r'responseHistoryProvider';
}
