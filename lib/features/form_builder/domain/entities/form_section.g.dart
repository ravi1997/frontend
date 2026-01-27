// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_section.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FormSection _$FormSectionFromJson(Map<String, dynamic> json) => _FormSection(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  questions: (json['questions'] as List<dynamic>)
      .map((e) => FormQuestion.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$FormSectionToJson(_FormSection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'questions': instance.questions,
    };
