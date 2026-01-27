// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FormQuestion _$FormQuestionFromJson(Map<String, dynamic> json) =>
    _FormQuestion(
      id: json['id'] as String,
      label: json['label'] as String,
      type: $enumDecode(_$QuestionTypeEnumMap, json['type']),
      helperText: json['helperText'] as String?,
      placeholder: json['placeholder'] as String?,
      isRequired: json['isRequired'] as bool? ?? false,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      conditionalLogic: json['conditionalLogic'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$FormQuestionToJson(_FormQuestion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'type': _$QuestionTypeEnumMap[instance.type]!,
      'helperText': instance.helperText,
      'placeholder': instance.placeholder,
      'isRequired': instance.isRequired,
      'options': instance.options,
      'conditionalLogic': instance.conditionalLogic,
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
};
