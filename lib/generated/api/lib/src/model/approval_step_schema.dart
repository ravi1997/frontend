//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'approval_step_schema.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ApprovalStepSchema {
  /// Returns a new [ApprovalStepSchema] instance.
  ApprovalStepSchema({

     this.id,

     this.approvalType = const ApprovalStepSchemaApprovalTypeEnum._('any_one'),

     this.approverGroups,

     this.approvers,

     this.createdAt,

     this.minApprovalsRequired,

     this.onApproveScript,

     this.onRejectScript,

     this.order,

    required  this.stepName,

     this.updatedAt,
  });

  @JsonKey(
    
    name: r'_id',
    required: false,
    includeIfNull: false,
  )


  final Object? id;



  @JsonKey(
    defaultValue: 'any_one',
    name: r'approval_type',
    required: false,
    includeIfNull: false,
  )


  final ApprovalStepSchemaApprovalTypeEnum? approvalType;



  @JsonKey(
    
    name: r'approver_groups',
    required: false,
    includeIfNull: false,
  )


  final List<String>? approverGroups;



  @JsonKey(
    
    name: r'approvers',
    required: false,
    includeIfNull: false,
  )


  final List<String>? approvers;



  @JsonKey(
    
    name: r'created_at',
    required: false,
    includeIfNull: false,
  )


  final Object? createdAt;



          // minimum: 1
  @JsonKey(
    
    name: r'min_approvals_required',
    required: false,
    includeIfNull: false,
  )


  final int? minApprovalsRequired;



  @JsonKey(
    
    name: r'on_approve_script',
    required: false,
    includeIfNull: false,
  )


  final Object? onApproveScript;



  @JsonKey(
    
    name: r'on_reject_script',
    required: false,
    includeIfNull: false,
  )


  final Object? onRejectScript;



  @JsonKey(
    
    name: r'order',
    required: false,
    includeIfNull: false,
  )


  final int? order;



  @JsonKey(
    
    name: r'step_name',
    required: true,
    includeIfNull: false,
  )


  final String stepName;



  @JsonKey(
    
    name: r'updated_at',
    required: false,
    includeIfNull: false,
  )


  final Object? updatedAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ApprovalStepSchema &&
      other.id == id &&
      other.approvalType == approvalType &&
      other.approverGroups == approverGroups &&
      other.approvers == approvers &&
      other.createdAt == createdAt &&
      other.minApprovalsRequired == minApprovalsRequired &&
      other.onApproveScript == onApproveScript &&
      other.onRejectScript == onRejectScript &&
      other.order == order &&
      other.stepName == stepName &&
      other.updatedAt == updatedAt;

    @override
    int get hashCode =>
        id.hashCode +
        approvalType.hashCode +
        approverGroups.hashCode +
        approvers.hashCode +
        createdAt.hashCode +
        minApprovalsRequired.hashCode +
        onApproveScript.hashCode +
        onRejectScript.hashCode +
        order.hashCode +
        stepName.hashCode +
        updatedAt.hashCode;

  factory ApprovalStepSchema.fromJson(Map<String, dynamic> json) => _$ApprovalStepSchemaFromJson(json);

  Map<String, dynamic> toJson() => _$ApprovalStepSchemaToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


enum ApprovalStepSchemaApprovalTypeEnum {
@JsonValue(r'sequential')
sequential(r'sequential'),
@JsonValue(r'parallel')
parallel(r'parallel'),
@JsonValue(r'maker-checker')
makerChecker(r'maker-checker'),
@JsonValue(r'any_one')
anyOne(r'any_one');

const ApprovalStepSchemaApprovalTypeEnum(this.value);

final String value;

@override
String toString() => value;
}


