// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_version_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FormVersionHistory _$FormVersionHistoryFromJson(Map<String, dynamic> json) =>
    _FormVersionHistory(
      version: json['version'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      authorId: json['authorId'] as String?,
      changeLog: json['changeLog'] as String?,
    );

Map<String, dynamic> _$FormVersionHistoryToJson(_FormVersionHistory instance) =>
    <String, dynamic>{
      'version': instance.version,
      'createdAt': instance.createdAt.toIso8601String(),
      'authorId': instance.authorId,
      'changeLog': instance.changeLog,
    };
