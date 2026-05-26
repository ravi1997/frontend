//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'form_blueprint_schema.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class FormBlueprintSchema {
  /// Returns a new [FormBlueprintSchema] instance.
  FormBlueprintSchema({

     this.id,

     this.category,

     this.createdAt,

     this.description,

     this.estimatedCompletionTime,

     this.icon,

     this.industry,

     this.isOfficial = false,

     this.metaData,

    required  this.name,

     this.responseTemplates,

     this.sections,

     this.tags,

     this.updatedAt,

     this.usageCount,
  });

  @JsonKey(
    
    name: r'_id',
    required: false,
    includeIfNull: false
  )


  final Object? id;



  @JsonKey(
    
    name: r'category',
    required: false,
    includeIfNull: false
  )


  final Object? category;



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
    
    name: r'estimated_completion_time',
    required: false,
    includeIfNull: false
  )


  final Object? estimatedCompletionTime;



  @JsonKey(
    
    name: r'icon',
    required: false,
    includeIfNull: false
  )


  final Object? icon;



  @JsonKey(
    
    name: r'industry',
    required: false,
    includeIfNull: false
  )


  final Object? industry;



  @JsonKey(
    defaultValue: false,
    name: r'is_official',
    required: false,
    includeIfNull: false
  )


  final bool? isOfficial;



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
    
    name: r'response_templates',
    required: false,
    includeIfNull: false
  )


  final List<Object>? responseTemplates;



  @JsonKey(
    
    name: r'sections',
    required: false,
    includeIfNull: false
  )


  final List<Object>? sections;



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
    
    name: r'usage_count',
    required: false,
    includeIfNull: false
  )


  final int? usageCount;



  @override
  bool operator ==(Object other) => identical(this, other) || other is FormBlueprintSchema &&
     other.id == id &&
     other.category == category &&
     other.createdAt == createdAt &&
     other.description == description &&
     other.estimatedCompletionTime == estimatedCompletionTime &&
     other.icon == icon &&
     other.industry == industry &&
     other.isOfficial == isOfficial &&
     other.metaData == metaData &&
     other.name == name &&
     other.responseTemplates == responseTemplates &&
     other.sections == sections &&
     other.tags == tags &&
     other.updatedAt == updatedAt &&
     other.usageCount == usageCount;

  @override
  int get hashCode =>
    id.hashCode +
    category.hashCode +
    createdAt.hashCode +
    description.hashCode +
    estimatedCompletionTime.hashCode +
    icon.hashCode +
    industry.hashCode +
    isOfficial.hashCode +
    metaData.hashCode +
    name.hashCode +
    responseTemplates.hashCode +
    sections.hashCode +
    tags.hashCode +
    updatedAt.hashCode +
    usageCount.hashCode;

  factory FormBlueprintSchema.fromJson(Map<String, dynamic> json) => _$FormBlueprintSchemaFromJson(json);

  Map<String, dynamic> toJson() => _$FormBlueprintSchemaToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

