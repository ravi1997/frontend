// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FormQuestion _$FormQuestionFromJson(Map<String, dynamic> json) =>
    _FormQuestion(
      id: IdReader.readIdCallback(json, 'id') as String,
      variableName: (json['variable_name'] ?? json['variableName']) as String?,
      label: json['label'],
      type: $enumDecode(_$QuestionTypeEnumMap, json['field_type']),
      helperText: json['help_text'] ?? json['helperText'],
      placeholder: json['placeholder'],
      defaultValue: json['default_value'] ?? json['defaultValue'],
      validation: json['validation'] as Map<String, dynamic>?,
      isRequired: json['is_required'] as bool? ?? json['isRequired'] as bool? ?? false,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => FormQuestionOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      isReadOnly: json['is_read_only'] as bool? ?? json['isReadOnly'] as bool? ?? false,
      isHidden: json['is_hidden'] as bool? ?? json['isHidden'] as bool? ?? false,
      validationRegex: json['validationRegex'] as String?,
      minLength: (json['minLength'] as num?)?.toInt(),
      maxLength: (json['maxLength'] as num?)?.toInt(),
      minValue: json['minValue'] as num?,
      maxValue: json['maxValue'] as num?,
      inputMask: json['inputMask'] as String?,
      customErrorMessage: json['customErrorMessage'] as String?,
      dateMin: json['dateMin'] == null
          ? null
          : DateTime.parse(json['dateMin'] as String),
      dateMax: json['dateMax'] == null
          ? null
          : DateTime.parse(json['dateMax'] as String),
      allowedFileTypes: (json['allowedFileTypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      maxFileSize: (json['maxFileSize'] as num?)?.toInt(),
      maxFiles: (json['maxFiles'] as num?)?.toInt(),
      isUnique: json['isUnique'] as bool?,
      requiresConfirmation: json['requiresConfirmation'] as bool?,
      minSelection: (json['minSelection'] as num?)?.toInt(),
      maxSelection: (json['maxSelection'] as num?)?.toInt(),
      minWordCount: (json['minWordCount'] as num?)?.toInt(),
      maxWordCount: (json['maxWordCount'] as num?)?.toInt(),
      disablePastDates: json['disablePastDates'] as bool?,
      disableFutureDates: json['disableFutureDates'] as bool?,
      disableWeekends: json['disableWeekends'] as bool?,
      conditionalLogic: json['conditional_logic'] as Map<String, dynamic>? ?? json['conditionalLogic'] as Map<String, dynamic>?,
      actionConfig: json['action_config'] as Map<String, dynamic>? ?? json['actionConfig'] as Map<String, dynamic>?,
      metadata: json['meta_data'] as Map<String, dynamic>? ?? json['metadata'] as Map<String, dynamic>?,
      style: json['style'] == null
          ? const QuestionStyle()
          : QuestionStyle.fromJson(json['style'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FormQuestionToJson(_FormQuestion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'variable_name': instance.variableName,
      'label': instance.label,
      'field_type': _$QuestionTypeEnumMap[instance.type]!,
      'help_text': instance.helperText,
      'default_value': instance.defaultValue,
      'is_required': instance.isRequired,
      'options': instance.options,
      'is_read_only': instance.isReadOnly,
      'is_hidden': instance.isHidden,
      'validation': instance.validation,
      'meta_data': instance.metadata,
    };

const _$QuestionTypeEnumMap = {
  QuestionType.shortText: 'short_text',
  QuestionType.paragraph: 'paragraph',
  QuestionType.number: 'number',
  QuestionType.date: 'date',
  QuestionType.time: 'time',
  QuestionType.dropdown: 'dropdown',
  QuestionType.checkboxes: 'checkboxes',
  QuestionType.multipleChoice: 'multiple_choice',
  QuestionType.fileUpload: 'file_upload',
  QuestionType.email: 'email',
  QuestionType.mobile: 'mobile',
  QuestionType.url: 'url',
  QuestionType.rating: 'rating',
  QuestionType.signature: 'signature',
  QuestionType.slider: 'slider',
  QuestionType.image: 'image',
  QuestionType.divider: 'divider',
  QuestionType.spacer: 'spacer',
  QuestionType.matrixChoice: 'matrix_choice',
};
