//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'question_schema.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class QuestionSchema {
  /// Returns a new [QuestionSchema] instance.
  QuestionSchema({

     this.id,

     this.createdAt,

     this.defaultValue,

    required  this.fieldType,

     this.helpText,

     this.isHidden = false,

     this.isReadOnly = false,

     this.isRepeatable = false,

     this.keepLastValue = false,

    required  this.label,

     this.logic,

     this.metaData,

     this.options,

     this.order,

     this.repeatMax,

     this.repeatMin,

     this.responseTemplates,

     this.tags,

     this.ui,

     this.updatedAt,

     this.validation,

     this.variableName,
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
    
    name: r'default_value',
    required: false,
    includeIfNull: false
  )


  final Object? defaultValue;



  @JsonKey(
    
    name: r'field_type',
    required: true,
    includeIfNull: false
  )


  final QuestionSchemaFieldTypeEnum fieldType;



  @JsonKey(
    
    name: r'help_text',
    required: false,
    includeIfNull: false
  )


  final Object? helpText;



  @JsonKey(
    defaultValue: false,
    name: r'is_hidden',
    required: false,
    includeIfNull: false
  )


  final bool? isHidden;



  @JsonKey(
    defaultValue: false,
    name: r'is_read_only',
    required: false,
    includeIfNull: false
  )


  final bool? isReadOnly;



  @JsonKey(
    defaultValue: false,
    name: r'is_repeatable',
    required: false,
    includeIfNull: false
  )


  final bool? isRepeatable;



  @JsonKey(
    defaultValue: false,
    name: r'keep_last_value',
    required: false,
    includeIfNull: false
  )


  final bool? keepLastValue;



  @JsonKey(
    
    name: r'label',
    required: true,
    includeIfNull: false
  )


  final String label;



  @JsonKey(
    
    name: r'logic',
    required: false,
    includeIfNull: false
  )


  final Object? logic;



  @JsonKey(
    
    name: r'meta_data',
    required: false,
    includeIfNull: false
  )


  final Object? metaData;



  @JsonKey(
    
    name: r'options',
    required: false,
    includeIfNull: false
  )


  final List<Object>? options;



          // minimum: 0
  @JsonKey(
    
    name: r'order',
    required: false,
    includeIfNull: false
  )


  final int? order;



  @JsonKey(
    
    name: r'repeat_max',
    required: false,
    includeIfNull: false
  )


  final Object? repeatMax;



          // minimum: 0
  @JsonKey(
    
    name: r'repeat_min',
    required: false,
    includeIfNull: false
  )


  final int? repeatMin;



  @JsonKey(
    
    name: r'response_templates',
    required: false,
    includeIfNull: false
  )


  final List<Object>? responseTemplates;



  @JsonKey(
    
    name: r'tags',
    required: false,
    includeIfNull: false
  )


  final List<String>? tags;



  @JsonKey(
    
    name: r'ui',
    required: false,
    includeIfNull: false
  )


  final Object? ui;



  @JsonKey(
    
    name: r'updated_at',
    required: false,
    includeIfNull: false
  )


  final Object? updatedAt;



  @JsonKey(
    
    name: r'validation',
    required: false,
    includeIfNull: false
  )


  final Object? validation;



  @JsonKey(
    
    name: r'variable_name',
    required: false,
    includeIfNull: false
  )


  final Object? variableName;



  @override
  bool operator ==(Object other) => identical(this, other) || other is QuestionSchema &&
     other.id == id &&
     other.createdAt == createdAt &&
     other.defaultValue == defaultValue &&
     other.fieldType == fieldType &&
     other.helpText == helpText &&
     other.isHidden == isHidden &&
     other.isReadOnly == isReadOnly &&
     other.isRepeatable == isRepeatable &&
     other.keepLastValue == keepLastValue &&
     other.label == label &&
     other.logic == logic &&
     other.metaData == metaData &&
     other.options == options &&
     other.order == order &&
     other.repeatMax == repeatMax &&
     other.repeatMin == repeatMin &&
     other.responseTemplates == responseTemplates &&
     other.tags == tags &&
     other.ui == ui &&
     other.updatedAt == updatedAt &&
     other.validation == validation &&
     other.variableName == variableName;

  @override
  int get hashCode =>
    id.hashCode +
    createdAt.hashCode +
    defaultValue.hashCode +
    fieldType.hashCode +
    helpText.hashCode +
    isHidden.hashCode +
    isReadOnly.hashCode +
    isRepeatable.hashCode +
    keepLastValue.hashCode +
    label.hashCode +
    logic.hashCode +
    metaData.hashCode +
    options.hashCode +
    order.hashCode +
    repeatMax.hashCode +
    repeatMin.hashCode +
    responseTemplates.hashCode +
    tags.hashCode +
    ui.hashCode +
    updatedAt.hashCode +
    validation.hashCode +
    variableName.hashCode;

  factory QuestionSchema.fromJson(Map<String, dynamic> json) => _$QuestionSchemaFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionSchemaToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


enum QuestionSchemaFieldTypeEnum {
  @JsonValue(r'input')
  input,
  @JsonValue(r'textarea')
  textarea,
  @JsonValue(r'number')
  number,
  @JsonValue(r'email')
  email,
  @JsonValue(r'mobile')
  mobile,
  @JsonValue(r'url')
  url,
  @JsonValue(r'password')
  password,
}


