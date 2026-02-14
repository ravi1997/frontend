import 'package:freezed_annotation/freezed_annotation.dart';

part 'form_response.freezed.dart';
part 'form_response.g.dart';

@freezed
abstract class FormResponse with _$FormResponse {
  const factory FormResponse({
    required String id,
    required String formId,
    required DateTime submittedAt,
    required Map<String, dynamic> answers,
    @Default({}) Map<String, dynamic> aiResults,
  }) = _FormResponse;

  factory FormResponse.fromJson(Map<String, dynamic> json) =>
      _$FormResponseFromJson(json);
}
