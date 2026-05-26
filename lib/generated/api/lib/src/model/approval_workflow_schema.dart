//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'approval_workflow_schema.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ApprovalWorkflowSchema {
  /// Returns a new [ApprovalWorkflowSchema] instance.
  ApprovalWorkflowSchema({

     this.id,

     this.createdAt,

     this.description,

     this.initiatorGroups,

     this.isActive = true,

     this.metaData,

    required  this.name,

     this.steps,

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
    
    name: r'initiator_groups',
    required: false,
    includeIfNull: false
  )


  final List<String>? initiatorGroups;



  @JsonKey(
    defaultValue: true,
    name: r'is_active',
    required: false,
    includeIfNull: false
  )


  final bool? isActive;



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
    
    name: r'steps',
    required: false,
    includeIfNull: false
  )


  final List<Object>? steps;



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
  bool operator ==(Object other) => identical(this, other) || other is ApprovalWorkflowSchema &&
     other.id == id &&
     other.createdAt == createdAt &&
     other.description == description &&
     other.initiatorGroups == initiatorGroups &&
     other.isActive == isActive &&
     other.metaData == metaData &&
     other.name == name &&
     other.steps == steps &&
     other.tags == tags &&
     other.updatedAt == updatedAt;

  @override
  int get hashCode =>
    id.hashCode +
    createdAt.hashCode +
    description.hashCode +
    initiatorGroups.hashCode +
    isActive.hashCode +
    metaData.hashCode +
    name.hashCode +
    steps.hashCode +
    tags.hashCode +
    updatedAt.hashCode;

  factory ApprovalWorkflowSchema.fromJson(Map<String, dynamic> json) => _$ApprovalWorkflowSchemaFromJson(json);

  Map<String, dynamic> toJson() => _$ApprovalWorkflowSchemaToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

