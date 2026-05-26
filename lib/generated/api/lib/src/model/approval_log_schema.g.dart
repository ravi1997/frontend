// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'approval_log_schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApprovalLogSchema _$ApprovalLogSchemaFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ApprovalLogSchema',
      json,
      ($checkedConvert) {
        $checkKeys(json, requiredKeys: const ['action', 'action_by']);
        final val = ApprovalLogSchema(
          id: $checkedConvert('_id', (v) => v),
          action: $checkedConvert(
            'action',
            (v) => $enumDecode(_$ApprovalLogSchemaActionEnumEnumMap, v),
          ),
          actionBy: $checkedConvert('action_by', (v) => v as String),
          comment: $checkedConvert('comment', (v) => v),
          createdAt: $checkedConvert('created_at', (v) => v),
          stepName: $checkedConvert('step_name', (v) => v),
          timestamp: $checkedConvert('timestamp', (v) => v),
          updatedAt: $checkedConvert('updated_at', (v) => v),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': '_id',
        'actionBy': 'action_by',
        'createdAt': 'created_at',
        'stepName': 'step_name',
        'updatedAt': 'updated_at',
      },
    );

Map<String, dynamic> _$ApprovalLogSchemaToJson(ApprovalLogSchema instance) =>
    <String, dynamic>{
      '_id': ?instance.id,
      'action': _$ApprovalLogSchemaActionEnumEnumMap[instance.action]!,
      'action_by': instance.actionBy,
      'comment': ?instance.comment,
      'created_at': ?instance.createdAt,
      'step_name': ?instance.stepName,
      'timestamp': ?instance.timestamp,
      'updated_at': ?instance.updatedAt,
    };

const _$ApprovalLogSchemaActionEnumEnumMap = {
  ApprovalLogSchemaActionEnum.approve: 'approve',
  ApprovalLogSchemaActionEnum.reject: 'reject',
  ApprovalLogSchemaActionEnum.revert: 'revert',
  ApprovalLogSchemaActionEnum.claim: 'claim',
};
