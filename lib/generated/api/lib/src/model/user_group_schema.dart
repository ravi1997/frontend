//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_group_schema.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UserGroupSchema {
  /// Returns a new [UserGroupSchema] instance.
  UserGroupSchema({

     this.id,

     this.createdAt,

     this.description,

     this.isActive = true,

     this.members,

     this.metaData,

    required  this.name,

     this.organizationId,

     this.owners,

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
    defaultValue: true,
    name: r'is_active',
    required: false,
    includeIfNull: false,
  )


  final bool? isActive;



  @JsonKey(
    
    name: r'members',
    required: false,
    includeIfNull: false,
  )


  final List<String>? members;



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
    
    name: r'organization_id',
    required: false,
    includeIfNull: false,
  )


  final Object? organizationId;



  @JsonKey(
    
    name: r'owners',
    required: false,
    includeIfNull: false,
  )


  final List<String>? owners;



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
    bool operator ==(Object other) => identical(this, other) || other is UserGroupSchema &&
      other.id == id &&
      other.createdAt == createdAt &&
      other.description == description &&
      other.isActive == isActive &&
      other.members == members &&
      other.metaData == metaData &&
      other.name == name &&
      other.organizationId == organizationId &&
      other.owners == owners &&
      other.tags == tags &&
      other.updatedAt == updatedAt;

    @override
    int get hashCode =>
        id.hashCode +
        createdAt.hashCode +
        description.hashCode +
        isActive.hashCode +
        members.hashCode +
        metaData.hashCode +
        name.hashCode +
        organizationId.hashCode +
        owners.hashCode +
        tags.hashCode +
        updatedAt.hashCode;

  factory UserGroupSchema.fromJson(Map<String, dynamic> json) => _$UserGroupSchemaFromJson(json);

  Map<String, dynamic> toJson() => _$UserGroupSchemaToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

