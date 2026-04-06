import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/utils/date_utils.dart';

part 'form_response.freezed.dart';
part 'form_response.g.dart';

@freezed
abstract class FormResponse with _$FormResponse {
  const factory FormResponse({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'form') required String formId,

    @JsonKey(
      name: 'submitted_at',
      fromJson: DateUtils.parse,
      toJson: DateUtils.toIso8601,
    )
    required DateTime? submittedAt,
    @JsonKey(name: 'data') required Map<String, dynamic> answers,
    @JsonKey(name: 'ai_results') @Default({}) Map<String, dynamic> aiResults,
    @Default('pending') String status,
  }) = _FormResponse;

  factory FormResponse.fromJson(Map<String, dynamic> json) =>
      _$FormResponseFromJson(json);
}
