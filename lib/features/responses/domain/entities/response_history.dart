import 'package:freezed_annotation/freezed_annotation.dart';

part 'response_history.freezed.dart';
part 'response_history.g.dart';

@freezed
abstract class ResponseHistory with _$ResponseHistory {
  const factory ResponseHistory({
    required String id,
    required String responseId,
    required String formId,
    required Map<String, dynamic> dataBefore,
    required Map<String, dynamic> dataAfter,
    required String changedBy,
    required DateTime changedAt,
    required String changeType,
  }) = _ResponseHistory;

  factory ResponseHistory.fromJson(Map<String, dynamic> json) =>
      _$ResponseHistoryFromJson(json);
}
