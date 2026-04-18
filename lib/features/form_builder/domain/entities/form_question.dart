// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/utils/id_reader.dart';
import 'question_type.dart';
import 'form_style.dart';
import 'form_question_option.dart';

part 'form_question.freezed.dart';
part 'form_question.g.dart';

@freezed
abstract class FormQuestion with _$FormQuestion {
  const FormQuestion._();
  const factory FormQuestion({
    @JsonKey(readValue: IdReader.readIdCallback) required String id,
    @JsonKey(name: 'variable_name')
    String? variableName,
    required Object? label,
    @JsonKey(name: 'field_type') required QuestionType type,
    @JsonKey(name: 'help_text')
    Object? helperText,
    @JsonKey(includeToJson: false)
    Object? placeholder,
    @JsonKey(name: 'default_value')
    Object? defaultValue,
    @JsonKey(name: 'validation', includeToJson: false)
    Map<String, dynamic>? validation,
    @JsonKey(name: 'is_required', includeToJson: false)
    @Default(false) bool isRequired,
    List<FormQuestionOption>? options,
    @JsonKey(name: 'is_read_only')
    @Default(false) bool isReadOnly,
    @JsonKey(name: 'is_hidden')
    @Default(false) bool isHidden,
    @JsonKey(includeToJson: false) String? validationRegex,
    @JsonKey(includeToJson: false) int? minLength,
    @JsonKey(includeToJson: false) int? maxLength,
    @JsonKey(includeToJson: false) num? minValue,
    @JsonKey(includeToJson: false) num? maxValue,
    @JsonKey(includeToJson: false) String? inputMask,
    @JsonKey(includeToJson: false) String? customErrorMessage,

    // Advanced Validation
    @JsonKey(includeToJson: false) DateTime? dateMin,
    @JsonKey(includeToJson: false) DateTime? dateMax,
    @JsonKey(includeToJson: false) List<String>? allowedFileTypes,
    @JsonKey(includeToJson: false) int? maxFileSize, // in MB
    @JsonKey(includeToJson: false) int? maxFiles,
    @JsonKey(includeToJson: false) bool? isUnique,
    @JsonKey(includeToJson: false) bool? requiresConfirmation,

    // Checkbox / Select Limits
    @JsonKey(includeToJson: false) int? minSelection,
    @JsonKey(includeToJson: false) int? maxSelection,

    // Word Count (Paragraph)
    @JsonKey(includeToJson: false) int? minWordCount,
    @JsonKey(includeToJson: false) int? maxWordCount,

    // Date Constraints
    @JsonKey(includeToJson: false) bool? disablePastDates,
    @JsonKey(includeToJson: false) bool? disableFutureDates,
    @JsonKey(includeToJson: false) bool? disableWeekends,

    @JsonKey(name: 'conditional_logic', includeToJson: false)
    Map<String, dynamic>? conditionalLogic,
    @JsonKey(name: 'action_config', includeToJson: false)
    Map<String, dynamic>? actionConfig,
    @JsonKey(name: 'meta_data')
    Map<String, dynamic>? metadata,
    @JsonKey(includeToJson: false) @Default(QuestionStyle()) QuestionStyle style,
  }) = _FormQuestion;

  factory FormQuestion.fromJson(Map<String, dynamic> json) =>
      _$FormQuestionFromJson(json);
}
