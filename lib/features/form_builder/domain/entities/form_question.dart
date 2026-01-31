import 'package:freezed_annotation/freezed_annotation.dart';
import 'question_type.dart';
import 'form_style.dart';

part 'form_question.freezed.dart';
part 'form_question.g.dart';

@freezed
abstract class FormQuestion with _$FormQuestion {
  const FormQuestion._();
  const factory FormQuestion({
    required String id,
    required String label,
    required QuestionType type,
    String? helperText,
    String? placeholder,
    @Default(false) bool isRequired,
    List<String>? options,
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
