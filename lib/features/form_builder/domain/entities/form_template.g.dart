// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FormTemplate _$FormTemplateFromJson(Map<String, dynamic> json) =>
    _FormTemplate(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: $enumDecode(_$FormTemplateCategoryEnumMap, json['category']),
      form: BuilderForm.fromJson(json['form'] as Map<String, dynamic>),
      thumbnailUrl: json['thumbnailUrl'] as String? ?? '',
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      usageCount: (json['usageCount'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$FormTemplateToJson(_FormTemplate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'category': _$FormTemplateCategoryEnumMap[instance.category]!,
      'form': instance.form,
      'thumbnailUrl': instance.thumbnailUrl,
      'tags': instance.tags,
      'usageCount': instance.usageCount,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$FormTemplateCategoryEnumMap = {
  FormTemplateCategory.contact: 'contact',
  FormTemplateCategory.survey: 'survey',
  FormTemplateCategory.registration: 'registration',
  FormTemplateCategory.event: 'event',
  FormTemplateCategory.assessment: 'assessment',
  FormTemplateCategory.feedback: 'feedback',
  FormTemplateCategory.order: 'order',
  FormTemplateCategory.application: 'application',
  FormTemplateCategory.other: 'other',
};
