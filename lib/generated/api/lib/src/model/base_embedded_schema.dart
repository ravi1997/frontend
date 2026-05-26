//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'base_embedded_schema.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class BaseEmbeddedSchema {
  /// Returns a new [BaseEmbeddedSchema] instance.
  BaseEmbeddedSchema({

     this.id,

     this.createdAt,

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
    
    name: r'updated_at',
    required: false,
    includeIfNull: false
  )


  final Object? updatedAt;



  @override
  bool operator ==(Object other) => identical(this, other) || other is BaseEmbeddedSchema &&
     other.id == id &&
     other.createdAt == createdAt &&
     other.updatedAt == updatedAt;

  @override
  int get hashCode =>
    id.hashCode +
    createdAt.hashCode +
    updatedAt.hashCode;

  factory BaseEmbeddedSchema.fromJson(Map<String, dynamic> json) => _$BaseEmbeddedSchemaFromJson(json);

  Map<String, dynamic> toJson() => _$BaseEmbeddedSchemaToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

