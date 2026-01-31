// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_field_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CustomFieldTemplate _$CustomFieldTemplateFromJson(Map<String, dynamic> json) =>
    _CustomFieldTemplate(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      question: FormQuestion.fromJson(json['question'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CustomFieldTemplateToJson(
  _CustomFieldTemplate instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'category': instance.category,
  'question': instance.question,
};
