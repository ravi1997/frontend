import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'form_response.freezed.dart';
part 'form_response.g.dart';

@freezed
abstract class FormResponse with _$FormResponse {
  const factory FormResponse({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'form') required String formId,

    @JsonKey(
      name: 'submitted_at',
      fromJson: _dateTimeFromJson,
      toJson: _dateTimeToJson,
    )
    required DateTime? submittedAt,
    @JsonKey(name: 'data') required Map<String, dynamic> answers,
    @JsonKey(name: 'ai_results') @Default({}) Map<String, dynamic> aiResults,
    @Default('pending') String status,
  }) = _FormResponse;

  factory FormResponse.fromJson(Map<String, dynamic> json) =>
      _$FormResponseFromJson(json);
}

DateTime? _dateTimeFromJson(String? date) {
  if (date == null) return null;
  try {
    return DateFormat("E, d MMM y HH:mm:ss 'GMT'").parse(date);
  } catch (_) {
    return DateTime.tryParse(date);
  }
}

String? _dateTimeToJson(DateTime? date) {
  if (date == null) return null;
  return DateFormat("E, d MMM y HH:mm:ss 'GMT'").format(date);
}
