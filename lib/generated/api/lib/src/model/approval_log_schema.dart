//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'approval_log_schema.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ApprovalLogSchema {
  /// Returns a new [ApprovalLogSchema] instance.
  ApprovalLogSchema({

     this.id,

    required  this.action,

    required  this.actionBy,

     this.comment,

     this.createdAt,

     this.stepName,

     this.timestamp,

     this.updatedAt,
  });

  @JsonKey(
    
    name: r'_id',
    required: false,
    includeIfNull: false
  )


  final Object? id;



  @JsonKey(
    
    name: r'action',
    required: true,
    includeIfNull: false
  )


  final ApprovalLogSchemaActionEnum action;



  @JsonKey(
    
    name: r'action_by',
    required: true,
    includeIfNull: false
  )


  final String actionBy;



  @JsonKey(
    
    name: r'comment',
    required: false,
    includeIfNull: false
  )


  final Object? comment;



  @JsonKey(
    
    name: r'created_at',
    required: false,
    includeIfNull: false
  )


  final Object? createdAt;



  @JsonKey(
    
    name: r'step_name',
    required: false,
    includeIfNull: false
  )


  final Object? stepName;



  @JsonKey(
    
    name: r'timestamp',
    required: false,
    includeIfNull: false
  )


  final Object? timestamp;



  @JsonKey(
    
    name: r'updated_at',
    required: false,
    includeIfNull: false
  )


  final Object? updatedAt;



  @override
  bool operator ==(Object other) => identical(this, other) || other is ApprovalLogSchema &&
     other.id == id &&
     other.action == action &&
     other.actionBy == actionBy &&
     other.comment == comment &&
     other.createdAt == createdAt &&
     other.stepName == stepName &&
     other.timestamp == timestamp &&
     other.updatedAt == updatedAt;

  @override
  int get hashCode =>
    id.hashCode +
    action.hashCode +
    actionBy.hashCode +
    comment.hashCode +
    createdAt.hashCode +
    stepName.hashCode +
    timestamp.hashCode +
    updatedAt.hashCode;

  factory ApprovalLogSchema.fromJson(Map<String, dynamic> json) => _$ApprovalLogSchemaFromJson(json);

  Map<String, dynamic> toJson() => _$ApprovalLogSchemaToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


enum ApprovalLogSchemaActionEnum {
  @JsonValue(r'approve')
  approve,
  @JsonValue(r'reject')
  reject,
  @JsonValue(r'revert')
  revert,
  @JsonValue(r'claim')
  claim,
}


