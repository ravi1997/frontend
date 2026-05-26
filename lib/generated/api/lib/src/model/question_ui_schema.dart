//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'question_ui_schema.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class QuestionUISchema {
  /// Returns a new [QuestionUISchema] instance.
  QuestionUISchema({

     this.id,

     this.createdAt,

     this.placeholder,

     this.style,

     this.updatedAt,

     this.visibleHeader = false,

     this.visibleName,
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
    
    name: r'placeholder',
    required: false,
    includeIfNull: false
  )


  final Object? placeholder;



  @JsonKey(
    
    name: r'style',
    required: false,
    includeIfNull: false
  )


  final Object? style;



  @JsonKey(
    
    name: r'updated_at',
    required: false,
    includeIfNull: false
  )


  final Object? updatedAt;



  @JsonKey(
    defaultValue: false,
    name: r'visible_header',
    required: false,
    includeIfNull: false
  )


  final bool? visibleHeader;



  @JsonKey(
    
    name: r'visible_name',
    required: false,
    includeIfNull: false
  )


  final Object? visibleName;



  @override
  bool operator ==(Object other) => identical(this, other) || other is QuestionUISchema &&
     other.id == id &&
     other.createdAt == createdAt &&
     other.placeholder == placeholder &&
     other.style == style &&
     other.updatedAt == updatedAt &&
     other.visibleHeader == visibleHeader &&
     other.visibleName == visibleName;

  @override
  int get hashCode =>
    id.hashCode +
    createdAt.hashCode +
    placeholder.hashCode +
    style.hashCode +
    updatedAt.hashCode +
    visibleHeader.hashCode +
    visibleName.hashCode;

  factory QuestionUISchema.fromJson(Map<String, dynamic> json) => _$QuestionUISchemaFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionUISchemaToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

