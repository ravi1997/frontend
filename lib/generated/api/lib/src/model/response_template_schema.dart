//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'response_template_schema.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ResponseTemplateSchema {
  /// Returns a new [ResponseTemplateSchema] instance.
  ResponseTemplateSchema({

     this.id,

     this.createdAt,

     this.description,

     this.metaData,

    required  this.name,

     this.structure,

     this.tags,

     this.updatedAt,
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
    
    name: r'description',
    required: false,
    includeIfNull: false
  )


  final Object? description;



  @JsonKey(
    
    name: r'meta_data',
    required: false,
    includeIfNull: false
  )


  final Object? metaData;



  @JsonKey(
    
    name: r'name',
    required: true,
    includeIfNull: false
  )


  final String name;



  @JsonKey(
    
    name: r'structure',
    required: false,
    includeIfNull: false
  )


  final Object? structure;



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



  @override
  bool operator ==(Object other) => identical(this, other) || other is ResponseTemplateSchema &&
     other.id == id &&
     other.createdAt == createdAt &&
     other.description == description &&
     other.metaData == metaData &&
     other.name == name &&
     other.structure == structure &&
     other.tags == tags &&
     other.updatedAt == updatedAt;

  @override
  int get hashCode =>
    id.hashCode +
    createdAt.hashCode +
    description.hashCode +
    metaData.hashCode +
    name.hashCode +
    structure.hashCode +
    tags.hashCode +
    updatedAt.hashCode;

  factory ResponseTemplateSchema.fromJson(Map<String, dynamic> json) => _$ResponseTemplateSchemaFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseTemplateSchemaToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

