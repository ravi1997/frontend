import 'package:freezed_annotation/freezed_annotation.dart';

part 'form_version_history.freezed.dart';
part 'form_version_history.g.dart';

@freezed
abstract class FormVersionHistory with _$FormVersionHistory {
  const factory FormVersionHistory({
    required String version,
    required DateTime createdAt,
    String? authorId,
    String? changeLog,
  }) = _FormVersionHistory;

  factory FormVersionHistory.fromJson(Map<String, dynamic> json) =>
      _$FormVersionHistoryFromJson(json);
}
