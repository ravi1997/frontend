// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'question_type.dart';
import 'form_style.dart';
import 'form_question_option.dart';

part 'form_question.freezed.dart';
part 'form_question.g.dart';

Object? _readId(Map map, String key) {
  if (key == 'id') {
    return map['id'] ?? map['_id'];
  }
  return map[key];
}

@freezed
abstract class FormQuestion with _$FormQuestion {
  const FormQuestion._();
  const factory FormQuestion({
    @JsonKey(readValue: _readId) required String id,
    required Object? label,
    @JsonKey(name: 'field_type') required QuestionType type,
    Object? helperText,
    Object? placeholder,
    @Default(false) bool isRequired,
    List<FormQuestionOption>? options,
    @Default(false) bool isReadOnly,
    @Default(false) bool isHidden,
    String? validationRegex,
    int? minLength,
    int? maxLength,
    num? minValue,
    num? maxValue,
    String? inputMask,
    String? customErrorMessage,
    Map<String, dynamic>? conditionalLogic,
    Map<String, dynamic>? metadata,
    @Default(QuestionStyle()) QuestionStyle style,
  }) = _FormQuestion;

  factory FormQuestion.fromJson(Map<String, dynamic> json) =>
      _$FormQuestionFromJson(json);
}
