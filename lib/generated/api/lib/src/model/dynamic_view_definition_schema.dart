//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'dynamic_view_definition_schema.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DynamicViewDefinitionSchema {
  /// Returns a new [DynamicViewDefinitionSchema] instance.
  DynamicViewDefinitionSchema({

     this.id,

     this.createdAt,

     this.deletedAt,

     this.description,

     this.form,

     this.isDeleted = false,

    required  this.organizationId,

    required  this.pipeline,

     this.project,

     this.tags,

     this.updatedAt,

    required  this.viewName,
  });

  @JsonKey(
    
    name: r'_id',
    required: false,
    includeIfNull: false
  )


  final Object? id;



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
    
    name: r'form',
    required: false,
    includeIfNull: false
  )


  final Object? form;



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
    
    name: r'pipeline',
    required: true,
    includeIfNull: false
  )


  final List<Object> pipeline;



  @JsonKey(
    
    name: r'project',
    required: false,
    includeIfNull: false
  )


  final Object? project;



  @JsonKey(
    
    name: r'tags',
    required: false,
    includeIfNull: false
  )


  final List<String>? tags;



  @JsonKey(
    
    name: r'updated_at',
    required: false,
    includeIfNull: false
  )


  final Object? updatedAt;



  @JsonKey(
    
    name: r'view_name',
    required: true,
    includeIfNull: false
  )


  final String viewName;



  @override
  bool operator ==(Object other) => identical(this, other) || other is DynamicViewDefinitionSchema &&
     other.id == id &&
     other.createdAt == createdAt &&
     other.deletedAt == deletedAt &&
     other.description == description &&
     other.form == form &&
     other.isDeleted == isDeleted &&
     other.organizationId == organizationId &&
     other.pipeline == pipeline &&
     other.project == project &&
     other.tags == tags &&
     other.updatedAt == updatedAt &&
     other.viewName == viewName;

  @override
  int get hashCode =>
    id.hashCode +
    createdAt.hashCode +
    deletedAt.hashCode +
    description.hashCode +
    form.hashCode +
    isDeleted.hashCode +
    organizationId.hashCode +
    pipeline.hashCode +
    project.hashCode +
    tags.hashCode +
    updatedAt.hashCode +
    viewName.hashCode;

  factory DynamicViewDefinitionSchema.fromJson(Map<String, dynamic> json) => _$DynamicViewDefinitionSchemaFromJson(json);

  Map<String, dynamic> toJson() => _$DynamicViewDefinitionSchemaToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

