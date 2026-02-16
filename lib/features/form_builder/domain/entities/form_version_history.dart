// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'form_version_history.freezed.dart';
part 'form_version_history.g.dart';

DateTime _dateTimeFromJson(String date) {
  try {
    return DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'").parse(date, true);
  } catch (_) {
    return DateTime.parse(date);
  }
}

@freezed
abstract class FormVersionHistory with _$FormVersionHistory {
  const factory FormVersionHistory({
    required String version,
    @JsonKey(fromJson: _dateTimeFromJson) required DateTime createdAt,
    String? authorId,
    String? changeLog,
  }) = _FormVersionHistory;

  factory FormVersionHistory.fromJson(Map<String, dynamic> json) =>
      _$FormVersionHistoryFromJson(json);
}
