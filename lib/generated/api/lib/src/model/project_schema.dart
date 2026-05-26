//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'project_schema.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ProjectSchema {
  /// Returns a new [ProjectSchema] instance.
  ProjectSchema({

     this.id,

     this.activeVersion,

     this.createdAt,

     this.deletedAt,

     this.description,

     this.forms,

     this.helpText,

     this.isDeleted = false,

    required  this.organizationId,

     this.status = const ProjectSchemaStatusEnum._('draft'),

     this.subProjects,

     this.tags,

    required  this.title,

     this.triggers,

     this.updatedAt,
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
    
    name: r'created_at',
    required: false,
    includeIfNull: false
  )


  final Object? createdAt;



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
    
    name: r'forms',
    required: false,
    includeIfNull: false
  )


  final List<String>? forms;



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
    
    name: r'organization_id',
    required: true,
    includeIfNull: false
  )


  final String organizationId;



  @JsonKey(
    defaultValue: 'draft',
    name: r'status',
    required: false,
    includeIfNull: false
  )


  final ProjectSchemaStatusEnum? status;



  @JsonKey(
    
    name: r'sub_projects',
    required: false,
    includeIfNull: false
  )


  final List<String>? subProjects;



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
    
    name: r'updated_at',
    required: false,
    includeIfNull: false
  )


  final Object? updatedAt;



  @override
  bool operator ==(Object other) => identical(this, other) || other is ProjectSchema &&
     other.id == id &&
     other.activeVersion == activeVersion &&
     other.createdAt == createdAt &&
     other.deletedAt == deletedAt &&
     other.description == description &&
     other.forms == forms &&
     other.helpText == helpText &&
     other.isDeleted == isDeleted &&
     other.organizationId == organizationId &&
     other.status == status &&
     other.subProjects == subProjects &&
     other.tags == tags &&
     other.title == title &&
     other.triggers == triggers &&
     other.updatedAt == updatedAt;

  @override
  int get hashCode =>
    id.hashCode +
    activeVersion.hashCode +
    createdAt.hashCode +
    deletedAt.hashCode +
    description.hashCode +
    forms.hashCode +
    helpText.hashCode +
    isDeleted.hashCode +
    organizationId.hashCode +
    status.hashCode +
    subProjects.hashCode +
    tags.hashCode +
    title.hashCode +
    triggers.hashCode +
    updatedAt.hashCode;

  factory ProjectSchema.fromJson(Map<String, dynamic> json) => _$ProjectSchemaFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectSchemaToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


enum ProjectSchemaStatusEnum {
  @JsonValue(r'draft')
  draft,
  @JsonValue(r'published')
  published,
  @JsonValue(r'archived')
  archived,
}


