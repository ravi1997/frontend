// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/utils/date_utils.dart';

part 'form_version_history.freezed.dart';
part 'form_version_history.g.dart';

@freezed
abstract class FormVersionHistory with _$FormVersionHistory {
  const factory FormVersionHistory({
    required String version,
    @JsonKey(fromJson: DateUtils.parse) required DateTime created_at,
    String? authorId,
    String? changeLog,
  }) = _FormVersionHistory;

  factory FormVersionHistory.fromJson(Map<String, dynamic> json) =>
      _$FormVersionHistoryFromJson(json);
}
