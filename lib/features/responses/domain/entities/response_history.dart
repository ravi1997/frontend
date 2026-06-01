import 'package:freezed_annotation/freezed_annotation.dart';

part 'response_history.freezed.dart';
part 'response_history.g.dart';

Object? _readId(Map json, String key) => json['_id'] ?? json['id'] ?? '';

@freezed
abstract class ResponseHistory with _$ResponseHistory {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ResponseHistory({
    @JsonKey(readValue: _readId) required String id,
    required String responseId,
    required String formId,
    required Map<String, dynamic> dataBefore,
    required Map<String, dynamic> dataAfter,
    required String changedBy,
    required DateTime changedAt,
    required String changeType,
    String? version,
  }) = _ResponseHistory;

  factory ResponseHistory.fromJson(Map<String, dynamic> json) =>
      _$ResponseHistoryFromJson(json);
}
