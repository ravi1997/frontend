import 'package:freezed_annotation/freezed_annotation.dart';
import 'question_type.dart';

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
    Map<String, dynamic>? conditionalLogic,
  }) = _FormQuestion;

  factory FormQuestion.fromJson(Map<String, dynamic> json) =>
      _$FormQuestionFromJson(json);
}
