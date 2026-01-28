import 'package:freezed_annotation/freezed_annotation.dart';
import 'form_section.dart';
import 'form_layout_type.dart';
import 'form_style.dart';

part 'builder_form.freezed.dart';
part 'builder_form.g.dart';

@freezed
abstract class BuilderForm with _$BuilderForm {
  const BuilderForm._();
  const factory BuilderForm({
    required String id,
    required String title,
    @Default('draft') String status,
    required List<FormSection> sections,
    @Default(FormLayoutType.singleColumn) FormLayoutType layout,
    DateTime? updatedAt,
    @Default(FormStyle()) FormStyle style,
  }) = _BuilderForm;

  factory BuilderForm.fromJson(Map<String, dynamic> json) =>
      _$BuilderFormFromJson(json);
}
