//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'project_version_schema.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ProjectVersionSchema {
  /// Returns a new [ProjectVersionSchema] instance.
  ProjectVersionSchema({

     this.id,

     this.createdAt,

     this.forms,

    required  this.project,

     this.status = const ProjectVersionSchemaStatusEnum._('draft'),

     this.subProjects,

     this.updatedAt,

    required  this.version,
  });

  @JsonKey(
    
    name: r'_id',
    required: false,
    includeIfNull: false,
  )


  final Object? id;



  @JsonKey(
    
    name: r'created_at',
    required: false,
    includeIfNull: false,
  )


  final Object? createdAt;



  @JsonKey(
    
    name: r'forms',
    required: false,
    includeIfNull: false,
  )


  final List<String>? forms;



  @JsonKey(
    
    name: r'project',
    required: true,
    includeIfNull: false,
  )


  final String project;



  @JsonKey(
    defaultValue: 'draft',
    name: r'status',
    required: false,
    includeIfNull: false,
  )


  final ProjectVersionSchemaStatusEnum? status;



  @JsonKey(
    
    name: r'sub_projects',
    required: false,
    includeIfNull: false,
  )


  final List<String>? subProjects;



  @JsonKey(
    
    name: r'updated_at',
    required: false,
    includeIfNull: false,
  )


  final Object? updatedAt;



  @JsonKey(
    
    name: r'version',
    required: true,
    includeIfNull: false,
  )


  final String version;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ProjectVersionSchema &&
      other.id == id &&
      other.createdAt == createdAt &&
      other.forms == forms &&
      other.project == project &&
      other.status == status &&
      other.subProjects == subProjects &&
      other.updatedAt == updatedAt &&
      other.version == version;

    @override
    int get hashCode =>
        id.hashCode +
        createdAt.hashCode +
        forms.hashCode +
        project.hashCode +
        status.hashCode +
        subProjects.hashCode +
        updatedAt.hashCode +
        version.hashCode;

  factory ProjectVersionSchema.fromJson(Map<String, dynamic> json) => _$ProjectVersionSchemaFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectVersionSchemaToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


enum ProjectVersionSchemaStatusEnum {
@JsonValue(r'draft')
draft(r'draft'),
@JsonValue(r'published')
published(r'published'),
@JsonValue(r'archived')
archived(r'archived');

const ProjectVersionSchemaStatusEnum(this.value);

final String value;

@override
String toString() => value;
}


