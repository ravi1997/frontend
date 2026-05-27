//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'resource_access_control_schema.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ResourceAccessControlSchema {
  /// Returns a new [ResourceAccessControlSchema] instance.
  ResourceAccessControlSchema({

     this.id,

     this.accessLevel = const ResourceAccessControlSchemaAccessLevelEnum._('private'),

     this.approvalWorkflow,

     this.createdAt,

     this.entries,

     this.isActive = true,

     this.metaData,

    required  this.resourceId,

    required  this.resourceType,

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
    defaultValue: 'private',
    name: r'access_level',
    required: false,
    includeIfNull: false,
  )


  final ResourceAccessControlSchemaAccessLevelEnum? accessLevel;



  @JsonKey(
    
    name: r'approval_workflow',
    required: false,
    includeIfNull: false,
  )


  final Object? approvalWorkflow;



  @JsonKey(
    
    name: r'created_at',
    required: false,
    includeIfNull: false,
  )


  final Object? createdAt;



  @JsonKey(
    
    name: r'entries',
    required: false,
    includeIfNull: false,
  )


  final List<Object>? entries;



  @JsonKey(
    defaultValue: true,
    name: r'is_active',
    required: false,
    includeIfNull: false,
  )


  final bool? isActive;



  @JsonKey(
    
    name: r'meta_data',
    required: false,
    includeIfNull: false,
  )


  final Object? metaData;



  @JsonKey(
    
    name: r'resource_id',
    required: true,
    includeIfNull: false,
  )


  final String resourceId;



  @JsonKey(
    
    name: r'resource_type',
    required: true,
    includeIfNull: false,
  )


  final ResourceAccessControlSchemaResourceTypeEnum resourceType;



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
    bool operator ==(Object other) => identical(this, other) || other is ResourceAccessControlSchema &&
      other.id == id &&
      other.accessLevel == accessLevel &&
      other.approvalWorkflow == approvalWorkflow &&
      other.createdAt == createdAt &&
      other.entries == entries &&
      other.isActive == isActive &&
      other.metaData == metaData &&
      other.resourceId == resourceId &&
      other.resourceType == resourceType &&
      other.tags == tags &&
      other.updatedAt == updatedAt;

    @override
    int get hashCode =>
        id.hashCode +
        accessLevel.hashCode +
        approvalWorkflow.hashCode +
        createdAt.hashCode +
        entries.hashCode +
        isActive.hashCode +
        metaData.hashCode +
        resourceId.hashCode +
        resourceType.hashCode +
        tags.hashCode +
        updatedAt.hashCode;

  factory ResourceAccessControlSchema.fromJson(Map<String, dynamic> json) => _$ResourceAccessControlSchemaFromJson(json);

  Map<String, dynamic> toJson() => _$ResourceAccessControlSchemaToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


enum ResourceAccessControlSchemaAccessLevelEnum {
@JsonValue(r'private')
private(r'private'),
@JsonValue(r'group')
group(r'group'),
@JsonValue(r'organization')
organization(r'organization'),
@JsonValue(r'public')
public(r'public');

const ResourceAccessControlSchemaAccessLevelEnum(this.value);

final String value;

@override
String toString() => value;
}



enum ResourceAccessControlSchemaResourceTypeEnum {
@JsonValue(r'form')
form(r'form'),
@JsonValue(r'project')
project(r'project'),
@JsonValue(r'submission')
submission(r'submission'),
@JsonValue(r'view')
view(r'view');

const ResourceAccessControlSchemaResourceTypeEnum(this.value);

final String value;

@override
String toString() => value;
}


