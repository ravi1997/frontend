// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'form_question_option.freezed.dart';
part 'form_question_option.g.dart';

@freezed
abstract class FormQuestionOption with _$FormQuestionOption {
  const factory FormQuestionOption({
    @JsonKey(name: 'id', readValue: _readId) required String id,
    String? description,
    @JsonKey(name: 'is_default') @Default(false) bool isDefault,
    @JsonKey(name: 'is_disabled') @Default(false) bool isDisabled,
    @JsonKey(name: 'option_label') required String label,
    @JsonKey(name: 'option_value') required String value,
    @Default(0) int order,
    @JsonKey(name: 'followup_visibility_condition')
    String? followupVisibilityCondition,
  }) = _FormQuestionOption;

  factory FormQuestionOption.fromJson(Map<String, dynamic> json) =>
      _$FormQuestionOptionFromJson(json);
}

Object? _readId(Map map, String key) {
  if (key == 'id') {
    return map['_id'] ?? map['id'];
  }
  return map[key];
}
