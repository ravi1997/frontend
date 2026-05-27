//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'project_blueprint_schema.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ProjectBlueprintSchema {
  /// Returns a new [ProjectBlueprintSchema] instance.
  ProjectBlueprintSchema({

     this.id,

     this.createdAt,

     this.description,

     this.formBlueprints,

     this.hierarchyDefinition,

     this.isTemplate = true,

     this.metaData,

    required  this.name,

     this.tags,

     this.updatedAt,
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
    
    name: r'description',
    required: false,
    includeIfNull: false,
  )


  final Object? description;



  @JsonKey(
    
    name: r'form_blueprints',
    required: false,
    includeIfNull: false,
  )


  final List<String>? formBlueprints;



  @JsonKey(
    
    name: r'hierarchy_definition',
    required: false,
    includeIfNull: false,
  )


  final Object? hierarchyDefinition;



  @JsonKey(
    defaultValue: true,
    name: r'is_template',
    required: false,
    includeIfNull: false,
  )


  final bool? isTemplate;



  @JsonKey(
    
    name: r'meta_data',
    required: false,
    includeIfNull: false,
  )


  final Object? metaData;



  @JsonKey(
    
    name: r'name',
    required: true,
    includeIfNull: false,
  )


  final String name;



  @JsonKey(
    
    name: r'tags',
    required: false,
    includeIfNull: false,
  )


  final List<String>? tags;



  @JsonKey(
    
    name: r'updated_at',
    required: false,
    includeIfNull: false,
  )


  final Object? updatedAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ProjectBlueprintSchema &&
      other.id == id &&
      other.createdAt == createdAt &&
      other.description == description &&
      other.formBlueprints == formBlueprints &&
      other.hierarchyDefinition == hierarchyDefinition &&
      other.isTemplate == isTemplate &&
      other.metaData == metaData &&
      other.name == name &&
      other.tags == tags &&
      other.updatedAt == updatedAt;

    @override
    int get hashCode =>
        id.hashCode +
        createdAt.hashCode +
        description.hashCode +
        formBlueprints.hashCode +
        hierarchyDefinition.hashCode +
        isTemplate.hashCode +
        metaData.hashCode +
        name.hashCode +
        tags.hashCode +
        updatedAt.hashCode;

  factory ProjectBlueprintSchema.fromJson(Map<String, dynamic> json) => _$ProjectBlueprintSchemaFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectBlueprintSchemaToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

