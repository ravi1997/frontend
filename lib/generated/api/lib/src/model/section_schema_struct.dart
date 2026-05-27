//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'section_schema_struct.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SectionSchemaStruct {
  /// Returns a new [SectionSchemaStruct] instance.
  SectionSchemaStruct({

     this.id,

     this.createdAt,

     this.description,

     this.helpText,

     this.logic,

     this.metaData,

     this.order,

     this.questions,

     this.responseTemplates,

     this.sections,

     this.tags,

    required  this.title,

     this.ui,

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
    
    name: r'help_text',
    required: false,
    includeIfNull: false,
  )


  final Object? helpText;



  @JsonKey(
    
    name: r'logic',
    required: false,
    includeIfNull: false,
  )


  final Object? logic;



  @JsonKey(
    
    name: r'meta_data',
    required: false,
    includeIfNull: false,
  )


  final Object? metaData;



  @JsonKey(
    
    name: r'order',
    required: false,
    includeIfNull: false,
  )


  final Object? order;



  @JsonKey(
    
    name: r'questions',
    required: false,
    includeIfNull: false,
  )


  final List<Object>? questions;



  @JsonKey(
    
    name: r'response_templates',
    required: false,
    includeIfNull: false,
  )


  final List<Object>? responseTemplates;



  @JsonKey(
    
    name: r'sections',
    required: false,
    includeIfNull: false,
  )


  final List<Object>? sections;



  @JsonKey(
    
    name: r'tags',
    required: false,
    includeIfNull: false,
  )


  final List<String>? tags;



  @JsonKey(
    
    name: r'title',
    required: true,
    includeIfNull: false,
  )


  final String title;



  @JsonKey(
    
    name: r'ui',
    required: false,
    includeIfNull: false,
  )


  final Object? ui;



  @JsonKey(
    
    name: r'updated_at',
    required: false,
    includeIfNull: false,
  )


  final Object? updatedAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is SectionSchemaStruct &&
      other.id == id &&
      other.createdAt == createdAt &&
      other.description == description &&
      other.helpText == helpText &&
      other.logic == logic &&
      other.metaData == metaData &&
      other.order == order &&
      other.questions == questions &&
      other.responseTemplates == responseTemplates &&
      other.sections == sections &&
      other.tags == tags &&
      other.title == title &&
      other.ui == ui &&
      other.updatedAt == updatedAt;

    @override
    int get hashCode =>
        id.hashCode +
        createdAt.hashCode +
        description.hashCode +
        helpText.hashCode +
        logic.hashCode +
        metaData.hashCode +
        order.hashCode +
        questions.hashCode +
        responseTemplates.hashCode +
        sections.hashCode +
        tags.hashCode +
        title.hashCode +
        ui.hashCode +
        updatedAt.hashCode;

  factory SectionSchemaStruct.fromJson(Map<String, dynamic> json) => _$SectionSchemaStructFromJson(json);

  Map<String, dynamic> toJson() => _$SectionSchemaStructToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

