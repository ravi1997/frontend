// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Question _$QuestionFromJson(Map<String, dynamic> json) => _Question(
  id: json['id'] as String,
  variableName: json['variable_name'] as String?,
  label: json['label'] as String,
  fieldType: json['field_type'] as String,
  helpText: json['help_text'] as String?,
  defaultValue: json['default_value'],
  isReadOnly: json['is_read_only'] as bool? ?? false,
  isHidden: json['is_hidden'] as bool? ?? false,
  isRepeatable: json['is_repeatable'] as bool? ?? false,
  repeatMin: (json['repeat_min'] as num?)?.toInt(),
  repeatMax: (json['repeat_max'] as num?)?.toInt(),
  keepLastValue: json['keep_last_value'] as bool? ?? false,
  validation:
      json['validation'] as Map<String, dynamic>? ?? const <String, dynamic>{},
  logic: json['logic'] as Map<String, dynamic>? ?? const <String, dynamic>{},
  ui: json['ui'] as Map<String, dynamic>? ?? const <String, dynamic>{},
  options:
      (json['options'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList() ??
      const <Map<String, dynamic>>[],
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  metadata:
      json['meta_data'] as Map<String, dynamic>? ?? const <String, dynamic>{},
);

Map<String, dynamic> _$QuestionToJson(_Question instance) => <String, dynamic>{
  'id': instance.id,
  'variable_name': instance.variableName,
  'label': instance.label,
  'field_type': instance.fieldType,
  'help_text': instance.helpText,
  'default_value': instance.defaultValue,
  'is_read_only': instance.isReadOnly,
  'is_hidden': instance.isHidden,
  'is_repeatable': instance.isRepeatable,
  'repeat_min': instance.repeatMin,
  'repeat_max': instance.repeatMax,
  'keep_last_value': instance.keepLastValue,
  'validation': instance.validation,
  'logic': instance.logic,
  'ui': instance.ui,
  'options': instance.options,
  'tags': instance.tags,
  'meta_data': instance.metadata,
};

_Section _$SectionFromJson(Map<String, dynamic> json) => _Section(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  helpText: json['help_text'] as String?,
  order: (json['order'] as num?)?.toInt() ?? 0,
  questions:
      (json['questions'] as List<dynamic>?)
          ?.map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Question>[],
  sections:
      (json['sections'] as List<dynamic>?)
          ?.map((e) => Section.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Section>[],
  layout: json['layout'] as String? ?? 'standard',
  gridColumns: (json['grid_columns'] as num?)?.toInt() ?? 2,
  isHidden: json['is_hidden'] as bool? ?? false,
  isRepeatable: json['is_repeatable'] as bool? ?? false,
  repeatMin: (json['repeat_min'] as num?)?.toInt(),
  repeatMax: (json['repeat_max'] as num?)?.toInt(),
  logic: json['logic'] as Map<String, dynamic>? ?? const <String, dynamic>{},
  ui: json['ui'] as Map<String, dynamic>? ?? const <String, dynamic>{},
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  metadata:
      json['meta_data'] as Map<String, dynamic>? ?? const <String, dynamic>{},
);

Map<String, dynamic> _$SectionToJson(_Section instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'help_text': instance.helpText,
  'order': instance.order,
  'questions': instance.questions,
  'sections': instance.sections,
  'layout': instance.layout,
  'grid_columns': instance.gridColumns,
  'is_hidden': instance.isHidden,
  'is_repeatable': instance.isRepeatable,
  'repeat_min': instance.repeatMin,
  'repeat_max': instance.repeatMax,
  'logic': instance.logic,
  'ui': instance.ui,
  'tags': instance.tags,
  'meta_data': instance.metadata,
};

_FormVersion _$FormVersionFromJson(Map<String, dynamic> json) => _FormVersion(
  id: json['id'] as String,
  version: json['version'] as String,
  sections:
      (json['sections'] as List<dynamic>?)
          ?.map((e) => Section.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Section>[],
  status: json['status'] as String? ?? 'draft',
  translations:
      json['translations'] as Map<String, dynamic>? ??
      const <String, dynamic>{},
  createdAt: json['created_at'] as String?,
);

Map<String, dynamic> _$FormVersionToJson(_FormVersion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'version': instance.version,
      'sections': instance.sections,
      'status': instance.status,
      'translations': instance.translations,
      'created_at': instance.createdAt,
    };

_Form _$FormFromJson(Map<String, dynamic> json) => _Form(
  id: json['id'] as String,
  title: json['title'] as String,
  slug: json['slug'] as String,
  organizationId: json['organization_id'] as String,
  createdBy: json['created_by'] as String,
  status: json['status'] as String? ?? 'draft',
  uiType: json['ui_type'] as String? ?? 'flex',
  activeVersion: json['active_version'] as String?,
  versions:
      (json['versions'] as List<dynamic>?)
          ?.map((e) => FormVersion.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <FormVersion>[],
  description: json['description'] as String?,
  helpText: json['help_text'] as String?,
  expiresAt: json['expires_at'] as String?,
  publishAt: json['publish_at'] as String?,
  isTemplate: json['is_template'] as bool? ?? false,
  isPublic: json['is_public'] as bool? ?? false,
  supportedLanguages:
      (json['supported_languages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const ['en'],
  defaultLanguage: json['default_language'] as String? ?? 'en',
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  workflows:
      json['workflows'] as Map<String, dynamic>? ?? const <String, dynamic>{},
  accessPolicy:
      json['access_policy'] as Map<String, dynamic>? ??
      const <String, dynamic>{},
  style: json['style'] as Map<String, dynamic>? ?? const <String, dynamic>{},
);

Map<String, dynamic> _$FormToJson(_Form instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'slug': instance.slug,
  'organization_id': instance.organizationId,
  'created_by': instance.createdBy,
  'status': instance.status,
  'ui_type': instance.uiType,
  'active_version': instance.activeVersion,
  'versions': instance.versions,
  'description': instance.description,
  'help_text': instance.helpText,
  'expires_at': instance.expiresAt,
  'publish_at': instance.publishAt,
  'is_template': instance.isTemplate,
  'is_public': instance.isPublic,
  'supported_languages': instance.supportedLanguages,
  'default_language': instance.defaultLanguage,
  'tags': instance.tags,
  'workflows': instance.workflows,
  'access_policy': instance.accessPolicy,
  'style': instance.style,
};
