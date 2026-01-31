import 'package:freezed_annotation/freezed_annotation.dart';
import 'form_section.dart';
import 'form_style.dart';
import 'form_layout_type.dart';

part 'form_version.freezed.dart';
part 'form_version.g.dart';

@freezed
abstract class FormVersion with _$FormVersion {
  const factory FormVersion({
    required String id,
    required String versionNumber,
    required List<FormSection> sections,
    @Default(FormStyle()) FormStyle style,
    @Default(FormLayoutType.singleColumn) FormLayoutType layout,
    required DateTime createdAt,
    String? description,
  }) = _FormVersion;

  factory FormVersion.fromJson(Map<String, dynamic> json) =>
      _$FormVersionFromJson(json);
}
