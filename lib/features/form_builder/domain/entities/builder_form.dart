import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'form_section.dart';
import 'form_layout_type.dart';
import 'form_style.dart';
import 'form_version_history.dart';

part 'builder_form.freezed.dart';
part 'builder_form.g.dart';

@freezed
abstract class BuilderForm with _$BuilderForm {
  const BuilderForm._();
  const factory BuilderForm({
    required String id,
    required Object? title,
    @Default('draft') String status,
    @Default(false) bool isPublished,
    @Default('1.0.0') String version,
    @Default(true) bool isLatest,
    required List<FormSection> sections,
    @Default(FormLayoutType.singleColumn) FormLayoutType layout,
    // ignore: invalid_annotation_target
    @JsonKey(fromJson: _parseDateTime) DateTime? updatedAt,
    @Default(FormStyle()) FormStyle style,
    @Default([]) List<FormVersionHistory> versionHistory,
    @Default({}) Map<String, dynamic> workflows,
  }) = _BuilderForm;

  factory BuilderForm.fromJson(Map<String, dynamic> json) =>
      _$BuilderFormFromJson(json);
}

DateTime? _parseDateTime(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is String) {
    try {
      return DateTime.parse(value);
    } catch (_) {
      try {
        final format = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'");
        final date = format.parse(value);
        return DateTime.utc(
          date.year,
          date.month,
          date.day,
          date.hour,
          date.minute,
          date.second,
        );
      } catch (_) {
        return null;
      }
    }
  }
  return null;
}
