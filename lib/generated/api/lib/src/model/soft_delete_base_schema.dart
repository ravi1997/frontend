//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'soft_delete_base_schema.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SoftDeleteBaseSchema {
  /// Returns a new [SoftDeleteBaseSchema] instance.
  SoftDeleteBaseSchema({

     this.id,

     this.createdAt,

     this.deletedAt,

     this.isDeleted = false,

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
    
    name: r'deleted_at',
    required: false,
    includeIfNull: false,
  )


  final Object? deletedAt;



  @JsonKey(
    defaultValue: false,
    name: r'is_deleted',
    required: false,
    includeIfNull: false,
  )


  final bool? isDeleted;



  @JsonKey(
    
    name: r'updated_at',
    required: false,
    includeIfNull: false,
  )


  final Object? updatedAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is SoftDeleteBaseSchema &&
      other.id == id &&
      other.createdAt == createdAt &&
      other.deletedAt == deletedAt &&
      other.isDeleted == isDeleted &&
      other.updatedAt == updatedAt;

    @override
    int get hashCode =>
        id.hashCode +
        createdAt.hashCode +
        deletedAt.hashCode +
        isDeleted.hashCode +
        updatedAt.hashCode;

  factory SoftDeleteBaseSchema.fromJson(Map<String, dynamic> json) => _$SoftDeleteBaseSchemaFromJson(json);

  Map<String, dynamic> toJson() => _$SoftDeleteBaseSchemaToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

