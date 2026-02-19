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
    required String super.argument,
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
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<FormResponse> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<FormResponse> create(Ref ref) {
    final argument = this.argument as String;
    return responseDetail(ref, argument);
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

String _$responseDetailHash() => r'0ad017eee15143cd1032176aac6c3dee85cf8de7';

final class ResponseDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<FormResponse>, String> {
  ResponseDetailFamily._()
    : super(
        retry: null,
        name: r'responseDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ResponseDetailProvider call(String responseId) =>
      ResponseDetailProvider._(argument: responseId, from: this);

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
    required String super.argument,
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
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ResponseHistory>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ResponseHistory>> create(Ref ref) {
    final argument = this.argument as String;
    return responseHistory(ref, argument);
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

String _$responseHistoryHash() => r'f103a5f66cd122e0f71510abbe5eb7e4b7b9e8e7';

final class ResponseHistoryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<ResponseHistory>>, String> {
  ResponseHistoryFamily._()
    : super(
        retry: null,
        name: r'responseHistoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ResponseHistoryProvider call(String responseId) =>
      ResponseHistoryProvider._(argument: responseId, from: this);

  @override
  String toString() => r'responseHistoryProvider';
}
