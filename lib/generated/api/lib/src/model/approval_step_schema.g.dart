// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'approval_step_schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApprovalStepSchema _$ApprovalStepSchemaFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ApprovalStepSchema',
      json,
      ($checkedConvert) {
        $checkKeys(json, requiredKeys: const ['step_name']);
        final val = ApprovalStepSchema(
          id: $checkedConvert('_id', (v) => v),
          approvalType: $checkedConvert(
            'approval_type',
            (v) =>
                $enumDecodeNullable(
                  _$ApprovalStepSchemaApprovalTypeEnumEnumMap,
                  v,
                ) ??
                'any_one',
          ),
          approverGroups: $checkedConvert(
            'approver_groups',
            (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
          ),
          approvers: $checkedConvert(
            'approvers',
            (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
          ),
          createdAt: $checkedConvert('created_at', (v) => v),
          minApprovalsRequired: $checkedConvert(
            'min_approvals_required',
            (v) => (v as num?)?.toInt(),
          ),
          onApproveScript: $checkedConvert('on_approve_script', (v) => v),
          onRejectScript: $checkedConvert('on_reject_script', (v) => v),
          order: $checkedConvert('order', (v) => (v as num?)?.toInt()),
          stepName: $checkedConvert('step_name', (v) => v as String),
          updatedAt: $checkedConvert('updated_at', (v) => v),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': '_id',
        'approvalType': 'approval_type',
        'approverGroups': 'approver_groups',
        'createdAt': 'created_at',
        'minApprovalsRequired': 'min_approvals_required',
        'onApproveScript': 'on_approve_script',
        'onRejectScript': 'on_reject_script',
        'stepName': 'step_name',
        'updatedAt': 'updated_at',
      },
    );

Map<String, dynamic> _$ApprovalStepSchemaToJson(ApprovalStepSchema instance) =>
    <String, dynamic>{
      '_id': ?instance.id,
      'approval_type':
          ?_$ApprovalStepSchemaApprovalTypeEnumEnumMap[instance.approvalType],
      'approver_groups': ?instance.approverGroups,
      'approvers': ?instance.approvers,
      'created_at': ?instance.createdAt,
      'min_approvals_required': ?instance.minApprovalsRequired,
      'on_approve_script': ?instance.onApproveScript,
      'on_reject_script': ?instance.onRejectScript,
      'order': ?instance.order,
      'step_name': instance.stepName,
      'updated_at': ?instance.updatedAt,
    };

const _$ApprovalStepSchemaApprovalTypeEnumEnumMap = {
  ApprovalStepSchemaApprovalTypeEnum.sequential: 'sequential',
  ApprovalStepSchemaApprovalTypeEnum.parallel: 'parallel',
  ApprovalStepSchemaApprovalTypeEnum.makerChecker: 'maker-checker',
  ApprovalStepSchemaApprovalTypeEnum.anyOne: 'any_one',
};
