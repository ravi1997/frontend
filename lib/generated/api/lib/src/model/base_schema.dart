//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'base_schema.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class BaseSchema {
  /// Returns a new [BaseSchema] instance.
  BaseSchema({

     this.id,

     this.createdAt,

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
    
    name: r'updated_at',
    required: false,
    includeIfNull: false,
  )


  final Object? updatedAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is BaseSchema &&
      other.id == id &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt;

    @override
    int get hashCode =>
        id.hashCode +
        createdAt.hashCode +
        updatedAt.hashCode;

  factory BaseSchema.fromJson(Map<String, dynamic> json) => _$BaseSchemaFromJson(json);

  Map<String, dynamic> toJson() => _$BaseSchemaToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

