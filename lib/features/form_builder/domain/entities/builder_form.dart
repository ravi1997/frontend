import 'package:freezed_annotation/freezed_annotation.dart';
import 'form_section.dart';

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
    DateTime? updatedAt,
  }) = _BuilderForm;

  factory BuilderForm.fromJson(Map<String, dynamic> json) =>
      _$BuilderFormFromJson(json);
}
