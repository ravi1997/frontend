// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FormSchema _$FormSchemaFromJson(Map<String, dynamic> json) => $checkedCreate(
  'FormSchema',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const ['created_by', 'organization_id', 'slug', 'title'],
    );
    final val = FormSchema(
      id: $checkedConvert('_id', (v) => v),
      activeVersion: $checkedConvert('active_version', (v) => v),
      approvalEnabled: $checkedConvert(
        'approval_enabled',
        (v) => v as bool? ?? false,
      ),
      createdAt: $checkedConvert('created_at', (v) => v),
      createdBy: $checkedConvert('created_by', (v) => v as String),
      defaultLanguage: $checkedConvert(
        'default_language',
        (v) => v as String? ?? 'en',
      ),
      deletedAt: $checkedConvert('deleted_at', (v) => v),
      description: $checkedConvert('description', (v) => v),
      editors: $checkedConvert(
        'editors',
        (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
      ),
      expiresAt: $checkedConvert('expires_at', (v) => v),
      helpText: $checkedConvert('help_text', (v) => v),
      isDeleted: $checkedConvert('is_deleted', (v) => v as bool? ?? false),
      isPublic: $checkedConvert('is_public', (v) => v as bool? ?? false),
      isTemplate: $checkedConvert('is_template', (v) => v as bool? ?? false),
      organizationId: $checkedConvert('organization_id', (v) => v as String),
      publishAt: $checkedConvert('publish_at', (v) => v),
      responseTemplates: $checkedConvert(
        'response_templates',
        (v) => (v as List<dynamic>?)?.map((e) => e as Object).toList(),
      ),
      slug: $checkedConvert('slug', (v) => v as String),
      status: $checkedConvert(
        'status',
        (v) => $enumDecodeNullable(_$FormSchemaStatusEnumEnumMap, v) ?? 'draft',
      ),
      style: $checkedConvert('style', (v) => v),
      submitters: $checkedConvert(
        'submitters',
        (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
      ),
      supportedLanguages: $checkedConvert(
        'supported_languages',
        (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
      ),
      tags: $checkedConvert(
        'tags',
        (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
      ),
      title: $checkedConvert('title', (v) => v as String),
      triggers: $checkedConvert(
        'triggers',
        (v) => (v as List<dynamic>?)?.map((e) => e as Object).toList(),
      ),
      uiType: $checkedConvert(
        'ui_type',
        (v) => $enumDecodeNullable(_$FormSchemaUiTypeEnumEnumMap, v) ?? 'flex',
      ),
      updatedAt: $checkedConvert('updated_at', (v) => v),
      viewers: $checkedConvert(
        'viewers',
        (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'id': '_id',
    'activeVersion': 'active_version',
    'approvalEnabled': 'approval_enabled',
    'createdAt': 'created_at',
    'createdBy': 'created_by',
    'defaultLanguage': 'default_language',
    'deletedAt': 'deleted_at',
    'expiresAt': 'expires_at',
    'helpText': 'help_text',
    'isDeleted': 'is_deleted',
    'isPublic': 'is_public',
    'isTemplate': 'is_template',
    'organizationId': 'organization_id',
    'publishAt': 'publish_at',
    'responseTemplates': 'response_templates',
    'supportedLanguages': 'supported_languages',
    'uiType': 'ui_type',
    'updatedAt': 'updated_at',
  },
);

Map<String, dynamic> _$FormSchemaToJson(FormSchema instance) =>
    <String, dynamic>{
      '_id': ?instance.id,
      'active_version': ?instance.activeVersion,
      'approval_enabled': ?instance.approvalEnabled,
      'created_at': ?instance.createdAt,
      'created_by': instance.createdBy,
      'default_language': ?instance.defaultLanguage,
      'deleted_at': ?instance.deletedAt,
      'description': ?instance.description,
      'editors': ?instance.editors,
      'expires_at': ?instance.expiresAt,
      'help_text': ?instance.helpText,
      'is_deleted': ?instance.isDeleted,
      'is_public': ?instance.isPublic,
      'is_template': ?instance.isTemplate,
      'organization_id': instance.organizationId,
      'publish_at': ?instance.publishAt,
      'response_templates': ?instance.responseTemplates,
      'slug': instance.slug,
      'status': ?_$FormSchemaStatusEnumEnumMap[instance.status],
      'style': ?instance.style,
      'submitters': ?instance.submitters,
      'supported_languages': ?instance.supportedLanguages,
      'tags': ?instance.tags,
      'title': instance.title,
      'triggers': ?instance.triggers,
      'ui_type': ?_$FormSchemaUiTypeEnumEnumMap[instance.uiType],
      'updated_at': ?instance.updatedAt,
      'viewers': ?instance.viewers,
    };

const _$FormSchemaStatusEnumEnumMap = {
  FormSchemaStatusEnum.draft: 'draft',
  FormSchemaStatusEnum.published: 'published',
  FormSchemaStatusEnum.archived: 'archived',
};

const _$FormSchemaUiTypeEnumEnumMap = {
  FormSchemaUiTypeEnum.flex: 'flex',
  FormSchemaUiTypeEnum.gridCols2: 'grid-cols-2',
  FormSchemaUiTypeEnum.tabbed: 'tabbed',
  FormSchemaUiTypeEnum.custom: 'custom',
  FormSchemaUiTypeEnum.gridCols3: 'grid-cols-3',
  FormSchemaUiTypeEnum.fullWidth: 'full-width',
  FormSchemaUiTypeEnum.cards: 'cards',
  FormSchemaUiTypeEnum.card: 'card',
};
