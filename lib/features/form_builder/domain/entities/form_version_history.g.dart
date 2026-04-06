// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_version_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FormVersionHistory _$FormVersionHistoryFromJson(Map<String, dynamic> json) =>
    _FormVersionHistory(
      version: json['version'] as String,
      created_at: _parseDate(json['created_at']),
      authorId: json['authorId'] as String?,
      changeLog: json['changeLog'] as String?,
    );

Map<String, dynamic> _$FormVersionHistoryToJson(_FormVersionHistory instance) =>
    <String, dynamic>{
      'version': instance.version,
      'created_at': instance.created_at.toIso8601String(),
      'authorId': instance.authorId,
      'changeLog': instance.changeLog,
    };
