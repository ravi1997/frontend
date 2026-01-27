// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_form.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RecentForm _$RecentFormFromJson(Map<String, dynamic> json) => _RecentForm(
  id: json['id'] as String,
  title: json['title'] as String,
  status: json['status'] as String,
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$RecentFormToJson(_RecentForm instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'status': instance.status,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
