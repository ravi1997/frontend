// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FormQuestion _$FormQuestionFromJson(Map<String, dynamic> json) =>
    _FormQuestion(
      id: _readId(json, 'id') as String,
      label: json['label'],
      type: $enumDecode(_$QuestionTypeEnumMap, json['field_type']),
      helperText: json['helperText'],
      placeholder: json['placeholder'],
      isRequired: json['isRequired'] as bool? ?? false,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => FormQuestionOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      isReadOnly: json['isReadOnly'] as bool? ?? false,
      isHidden: json['isHidden'] as bool? ?? false,
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
      conditionalLogic: json['conditionalLogic'] as Map<String, dynamic>?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      style: json['style'] == null
          ? const QuestionStyle()
          : QuestionStyle.fromJson(json['style'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FormQuestionToJson(_FormQuestion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'field_type': _$QuestionTypeEnumMap[instance.type]!,
      'helperText': instance.helperText,
      'placeholder': instance.placeholder,
      'isRequired': instance.isRequired,
      'options': instance.options,
      'isReadOnly': instance.isReadOnly,
      'isHidden': instance.isHidden,
      'validationRegex': instance.validationRegex,
      'minLength': instance.minLength,
      'maxLength': instance.maxLength,
      'minValue': instance.minValue,
      'maxValue': instance.maxValue,
      'inputMask': instance.inputMask,
      'customErrorMessage': instance.customErrorMessage,
      'dateMin': instance.dateMin?.toIso8601String(),
      'dateMax': instance.dateMax?.toIso8601String(),
      'allowedFileTypes': instance.allowedFileTypes,
      'maxFileSize': instance.maxFileSize,
      'maxFiles': instance.maxFiles,
      'isUnique': instance.isUnique,
      'requiresConfirmation': instance.requiresConfirmation,
      'conditionalLogic': instance.conditionalLogic,
      'metadata': instance.metadata,
      'style': instance.style,
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
