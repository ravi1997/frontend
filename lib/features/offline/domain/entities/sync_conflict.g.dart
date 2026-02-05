// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_conflict.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SyncConflict _$SyncConflictFromJson(Map<String, dynamic> json) =>
    _SyncConflict(
      id: json['id'] as String,
      localId: json['localId'] as String,
      remoteId: json['remoteId'] as String?,
      type: $enumDecode(_$ConflictTypeEnumMap, json['type']),
      localTimestamp: DateTime.parse(json['localTimestamp'] as String),
      remoteTimestamp: DateTime.parse(json['remoteTimestamp'] as String),
      localData: json['localData'] as Map<String, dynamic>,
      remoteData: json['remoteData'] as Map<String, dynamic>,
      entityType: json['entityType'] as String,
      entityId: json['entityId'] as String?,
      status: $enumDecode(_$ConflictStatusEnumMap, json['status']),
      resolutionNote: json['resolutionNote'] as String?,
      retryCount: (json['retryCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$SyncConflictToJson(_SyncConflict instance) =>
    <String, dynamic>{
      'id': instance.id,
      'localId': instance.localId,
      'remoteId': instance.remoteId,
      'type': _$ConflictTypeEnumMap[instance.type]!,
      'localTimestamp': instance.localTimestamp.toIso8601String(),
      'remoteTimestamp': instance.remoteTimestamp.toIso8601String(),
      'localData': instance.localData,
      'remoteData': instance.remoteData,
      'entityType': instance.entityType,
      'entityId': instance.entityId,
      'status': _$ConflictStatusEnumMap[instance.status]!,
      'resolutionNote': instance.resolutionNote,
      'retryCount': instance.retryCount,
    };

const _$ConflictTypeEnumMap = {
  ConflictType.concurrentModification: 'concurrentModification',
  ConflictType.remoteDeletion: 'remoteDeletion',
  ConflictType.duplicateCreation: 'duplicateCreation',
  ConflictType.versionMismatch: 'versionMismatch',
};

const _$ConflictStatusEnumMap = {
  ConflictStatus.pending: 'pending',
  ConflictStatus.resolvedLocal: 'resolvedLocal',
  ConflictStatus.resolvedRemote: 'resolvedRemote',
  ConflictStatus.resolvedMerge: 'resolvedMerge',
  ConflictStatus.resolvedAuto: 'resolvedAuto',
  ConflictStatus.failed: 'failed',
};
