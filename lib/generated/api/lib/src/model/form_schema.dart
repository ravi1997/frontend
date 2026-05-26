//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'form_schema.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class FormSchema {
  /// Returns a new [FormSchema] instance.
  FormSchema({

     this.id,

     this.activeVersion,

     this.approvalEnabled = false,

     this.createdAt,

    required  this.createdBy,

     this.defaultLanguage = 'en',

     this.deletedAt,

     this.description,

     this.editors,

     this.expiresAt,

     this.helpText,

     this.isDeleted = false,

     this.isPublic = false,

     this.isTemplate = false,

    required  this.organizationId,

     this.publishAt,

     this.responseTemplates,

    required  this.slug,

     this.status = const FormSchemaStatusEnum._('draft'),

     this.style,

     this.submitters,

     this.supportedLanguages,

     this.tags,

    required  this.title,

     this.triggers,

     this.uiType = const FormSchemaUiTypeEnum._('flex'),

     this.updatedAt,

     this.viewers,
  });

  @JsonKey(
    
    name: r'_id',
    required: false,
    includeIfNull: false
  )


  final Object? id;



  @JsonKey(
    
    name: r'active_version',
    required: false,
    includeIfNull: false
  )


  final Object? activeVersion;



  @JsonKey(
    defaultValue: false,
    name: r'approval_enabled',
    required: false,
    includeIfNull: false
  )


  final bool? approvalEnabled;



  @JsonKey(
    
    name: r'created_at',
    required: false,
    includeIfNull: false
  )


  final Object? createdAt;



  @JsonKey(
    
    name: r'created_by',
    required: true,
    includeIfNull: false
  )


  final String createdBy;



  @JsonKey(
    defaultValue: 'en',
    name: r'default_language',
    required: false,
    includeIfNull: false
  )


  final String? defaultLanguage;



  @JsonKey(
    
    name: r'deleted_at',
    required: false,
    includeIfNull: false
  )


  final Object? deletedAt;



  @JsonKey(
    
    name: r'description',
    required: false,
    includeIfNull: false
  )


  final Object? description;



  @JsonKey(
    
    name: r'editors',
    required: false,
    includeIfNull: false
  )


  final List<String>? editors;



  @JsonKey(
    
    name: r'expires_at',
    required: false,
    includeIfNull: false
  )


  final Object? expiresAt;



  @JsonKey(
    
    name: r'help_text',
    required: false,
    includeIfNull: false
  )


  final Object? helpText;



  @JsonKey(
    defaultValue: false,
    name: r'is_deleted',
    required: false,
    includeIfNull: false
  )


  final bool? isDeleted;



  @JsonKey(
    defaultValue: false,
    name: r'is_public',
    required: false,
    includeIfNull: false
  )


  final bool? isPublic;



  @JsonKey(
    defaultValue: false,
    name: r'is_template',
    required: false,
    includeIfNull: false
  )


  final bool? isTemplate;



  @JsonKey(
    
    name: r'organization_id',
    required: true,
    includeIfNull: false
  )


  final String organizationId;



  @JsonKey(
    
    name: r'publish_at',
    required: false,
    includeIfNull: false
  )


  final Object? publishAt;



  @JsonKey(
    
    name: r'response_templates',
    required: false,
    includeIfNull: false
  )


  final List<Object>? responseTemplates;



  @JsonKey(
    
    name: r'slug',
    required: true,
    includeIfNull: false
  )


  final String slug;



  @JsonKey(
    defaultValue: 'draft',
    name: r'status',
    required: false,
    includeIfNull: false
  )


  final FormSchemaStatusEnum? status;



  @JsonKey(
    
    name: r'style',
    required: false,
    includeIfNull: false
  )


  final Object? style;



  @JsonKey(
    
    name: r'submitters',
    required: false,
    includeIfNull: false
  )


  final List<String>? submitters;



  @JsonKey(
    
    name: r'supported_languages',
    required: false,
    includeIfNull: false
  )


  final List<String>? supportedLanguages;



  @JsonKey(
    
    name: r'tags',
    required: false,
    includeIfNull: false
  )


  final List<String>? tags;



  @JsonKey(
    
    name: r'title',
    required: true,
    includeIfNull: false
  )


  final String title;



  @JsonKey(
    
    name: r'triggers',
    required: false,
    includeIfNull: false
  )


  final List<Object>? triggers;



  @JsonKey(
    defaultValue: 'flex',
    name: r'ui_type',
    required: false,
    includeIfNull: false
  )


  final FormSchemaUiTypeEnum? uiType;



  @JsonKey(
    
    name: r'updated_at',
    required: false,
    includeIfNull: false
  )


  final Object? updatedAt;



  @JsonKey(
    
    name: r'viewers',
    required: false,
    includeIfNull: false
  )


  final List<String>? viewers;



  @override
  bool operator ==(Object other) => identical(this, other) || other is FormSchema &&
     other.id == id &&
     other.activeVersion == activeVersion &&
     other.approvalEnabled == approvalEnabled &&
     other.createdAt == createdAt &&
     other.createdBy == createdBy &&
     other.defaultLanguage == defaultLanguage &&
     other.deletedAt == deletedAt &&
     other.description == description &&
     other.editors == editors &&
     other.expiresAt == expiresAt &&
     other.helpText == helpText &&
     other.isDeleted == isDeleted &&
     other.isPublic == isPublic &&
     other.isTemplate == isTemplate &&
     other.organizationId == organizationId &&
     other.publishAt == publishAt &&
     other.responseTemplates == responseTemplates &&
     other.slug == slug &&
     other.status == status &&
     other.style == style &&
     other.submitters == submitters &&
     other.supportedLanguages == supportedLanguages &&
     other.tags == tags &&
     other.title == title &&
     other.triggers == triggers &&
     other.uiType == uiType &&
     other.updatedAt == updatedAt &&
     other.viewers == viewers;

  @override
  int get hashCode =>
    id.hashCode +
    activeVersion.hashCode +
    approvalEnabled.hashCode +
    createdAt.hashCode +
    createdBy.hashCode +
    defaultLanguage.hashCode +
    deletedAt.hashCode +
    description.hashCode +
    editors.hashCode +
    expiresAt.hashCode +
    helpText.hashCode +
    isDeleted.hashCode +
    isPublic.hashCode +
    isTemplate.hashCode +
    organizationId.hashCode +
    publishAt.hashCode +
    responseTemplates.hashCode +
    slug.hashCode +
    status.hashCode +
    style.hashCode +
    submitters.hashCode +
    supportedLanguages.hashCode +
    tags.hashCode +
    title.hashCode +
    triggers.hashCode +
    uiType.hashCode +
    updatedAt.hashCode +
    viewers.hashCode;

  factory FormSchema.fromJson(Map<String, dynamic> json) => _$FormSchemaFromJson(json);

  Map<String, dynamic> toJson() => _$FormSchemaToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


enum FormSchemaStatusEnum {
  @JsonValue(r'draft')
  draft,
  @JsonValue(r'published')
  published,
  @JsonValue(r'archived')
  archived,
}



enum FormSchemaUiTypeEnum {
  @JsonValue(r'flex')
  flex,
  @JsonValue(r'grid-cols-2')
  gridCols2,
  @JsonValue(r'tabbed')
  tabbed,
  @JsonValue(r'custom')
  custom,
  @JsonValue(r'grid-cols-3')
  gridCols3,
  @JsonValue(r'full-width')
  fullWidth,
  @JsonValue(r'cards')
  cards,
  @JsonValue(r'card')
  card,
}


