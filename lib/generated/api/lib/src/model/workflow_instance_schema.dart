//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'workflow_instance_schema.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class WorkflowInstanceSchema {
  /// Returns a new [WorkflowInstanceSchema] instance.
  WorkflowInstanceSchema({

     this.id,

     this.completedAt,

     this.createdAt,

     this.currentStepOrder,

     this.deletedAt,

     this.history,

     this.isDeleted = false,

     this.metaData,

    required  this.organizationId,

    required  this.resourceId,

     this.resourceType = 'form_response',

     this.startedAt,

     this.status = const WorkflowInstanceSchemaStatusEnum._('pending'),

     this.updatedAt,

    required  this.workflowDefinition,
  });

  @JsonKey(
    
    name: r'_id',
    required: false,
    includeIfNull: false,
  )


  final Object? id;



  @JsonKey(
    
    name: r'completed_at',
    required: false,
    includeIfNull: false,
  )


  final Object? completedAt;



  @JsonKey(
    
    name: r'created_at',
    required: false,
    includeIfNull: false,
  )


  final Object? createdAt;



  @JsonKey(
    
    name: r'current_step_order',
    required: false,
    includeIfNull: false,
  )


  final int? currentStepOrder;



  @JsonKey(
    
    name: r'deleted_at',
    required: false,
    includeIfNull: false,
  )


  final Object? deletedAt;



  @JsonKey(
    
    name: r'history',
    required: false,
    includeIfNull: false,
  )


  final List<Object>? history;



  @JsonKey(
    defaultValue: false,
    name: r'is_deleted',
    required: false,
    includeIfNull: false,
  )


  final bool? isDeleted;



  @JsonKey(
    
    name: r'meta_data',
    required: false,
    includeIfNull: false,
  )


  final Object? metaData;



  @JsonKey(
    
    name: r'organization_id',
    required: true,
    includeIfNull: false,
  )


  final String organizationId;



  @JsonKey(
    
    name: r'resource_id',
    required: true,
    includeIfNull: false,
  )


  final String resourceId;



  @JsonKey(
    defaultValue: 'form_response',
    name: r'resource_type',
    required: false,
    includeIfNull: false,
  )


  final String? resourceType;



  @JsonKey(
    
    name: r'started_at',
    required: false,
    includeIfNull: false,
  )


  final Object? startedAt;



  @JsonKey(
    defaultValue: 'pending',
    name: r'status',
    required: false,
    includeIfNull: false,
  )


  final WorkflowInstanceSchemaStatusEnum? status;



  @JsonKey(
    
    name: r'updated_at',
    required: false,
    includeIfNull: false,
  )


  final Object? updatedAt;



  @JsonKey(
    
    name: r'workflow_definition',
    required: true,
    includeIfNull: false,
  )


  final String workflowDefinition;





    @override
    bool operator ==(Object other) => identical(this, other) || other is WorkflowInstanceSchema &&
      other.id == id &&
      other.completedAt == completedAt &&
      other.createdAt == createdAt &&
      other.currentStepOrder == currentStepOrder &&
      other.deletedAt == deletedAt &&
      other.history == history &&
      other.isDeleted == isDeleted &&
      other.metaData == metaData &&
      other.organizationId == organizationId &&
      other.resourceId == resourceId &&
      other.resourceType == resourceType &&
      other.startedAt == startedAt &&
      other.status == status &&
      other.updatedAt == updatedAt &&
      other.workflowDefinition == workflowDefinition;

    @override
    int get hashCode =>
        id.hashCode +
        completedAt.hashCode +
        createdAt.hashCode +
        currentStepOrder.hashCode +
        deletedAt.hashCode +
        history.hashCode +
        isDeleted.hashCode +
        metaData.hashCode +
        organizationId.hashCode +
        resourceId.hashCode +
        resourceType.hashCode +
        startedAt.hashCode +
        status.hashCode +
        updatedAt.hashCode +
        workflowDefinition.hashCode;

  factory WorkflowInstanceSchema.fromJson(Map<String, dynamic> json) => _$WorkflowInstanceSchemaFromJson(json);

  Map<String, dynamic> toJson() => _$WorkflowInstanceSchemaToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


enum WorkflowInstanceSchemaStatusEnum {
@JsonValue(r'pending')
pending(r'pending'),
@JsonValue(r'in_review')
inReview(r'in_review'),
@JsonValue(r'approved')
approved(r'approved'),
@JsonValue(r'rejected')
rejected(r'rejected'),
@JsonValue(r'reverted')
reverted(r'reverted');

const WorkflowInstanceSchemaStatusEnum(this.value);

final String value;

@override
String toString() => value;
}


