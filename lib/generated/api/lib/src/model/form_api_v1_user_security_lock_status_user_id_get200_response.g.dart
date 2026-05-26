// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_api_v1_user_security_lock_status_user_id_get200_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FormApiV1UserSecurityLockStatusUserIdGet200Response
_$FormApiV1UserSecurityLockStatusUserIdGet200ResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'FormApiV1UserSecurityLockStatusUserIdGet200Response',
  json,
  ($checkedConvert) {
    final val = FormApiV1UserSecurityLockStatusUserIdGet200Response(
      failedLoginAttempts: $checkedConvert(
        'failed_login_attempts',
        (v) => (v as num?)?.toInt(),
      ),
      isLocked: $checkedConvert('is_locked', (v) => v as bool?),
      lockUntil: $checkedConvert(
        'lock_until',
        (v) => v == null ? null : DateTime.parse(v as String),
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'failedLoginAttempts': 'failed_login_attempts',
    'isLocked': 'is_locked',
    'lockUntil': 'lock_until',
  },
);

Map<String, dynamic>
_$FormApiV1UserSecurityLockStatusUserIdGet200ResponseToJson(
  FormApiV1UserSecurityLockStatusUserIdGet200Response instance,
) => <String, dynamic>{
  'failed_login_attempts': ?instance.failedLoginAttempts,
  'is_locked': ?instance.isLocked,
  'lock_until': ?instance.lockUntil?.toIso8601String(),
};
