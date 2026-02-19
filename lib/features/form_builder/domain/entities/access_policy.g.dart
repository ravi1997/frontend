// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_policy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AccessPolicy _$AccessPolicyFromJson(Map<String, dynamic> json) =>
    _AccessPolicy(
      canViewResponses:
          (json['canViewResponses'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      canEditResponses:
          (json['canEditResponses'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      canDeleteResponses:
          (json['canDeleteResponses'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      responseVisibility: json['responseVisibility'] as String? ?? 'all',
      canCreateVersions:
          (json['canCreateVersions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      canEditDesign:
          (json['canEditDesign'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      canCloneForm:
          (json['canCloneForm'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      canManageAccess:
          (json['canManageAccess'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      canViewAuditLogs:
          (json['canViewAuditLogs'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      canDeleteForm:
          (json['canDeleteForm'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      formVisibility: json['formVisibility'] as String? ?? 'private',
      allowedDepartments:
          (json['allowedDepartments'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$AccessPolicyToJson(_AccessPolicy instance) =>
    <String, dynamic>{
      'canViewResponses': instance.canViewResponses,
      'canEditResponses': instance.canEditResponses,
      'canDeleteResponses': instance.canDeleteResponses,
      'responseVisibility': instance.responseVisibility,
      'canCreateVersions': instance.canCreateVersions,
      'canEditDesign': instance.canEditDesign,
      'canCloneForm': instance.canCloneForm,
      'canManageAccess': instance.canManageAccess,
      'canViewAuditLogs': instance.canViewAuditLogs,
      'canDeleteForm': instance.canDeleteForm,
      'formVisibility': instance.formVisibility,
      'allowedDepartments': instance.allowedDepartments,
    };
