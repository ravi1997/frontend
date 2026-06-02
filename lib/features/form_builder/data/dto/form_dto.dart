import 'package:json_annotation/json_annotation.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/id_reader.dart';

// Updated for custom date parsing
class FormDto {
  // Handle backend UUIDs from `id` or `_id`; do not fall back to slug.
  @JsonKey(name: 'id', readValue: IdReader.readIdWithSlugCallback)
  final String id;
  final String title;
  final String status;
  final String? uiType;
  final String? activeVersion;

  // The backend returns a list of version objects under 'versions'
  final List<FormVersionDto> versions;

  @JsonKey(
    name: 'created_at',
    fromJson: AppDateUtils.parse,
    toJson: AppDateUtils.toIso8601,
  )
  final DateTime? createdAt;
  
  @JsonKey(
    name: 'updated_at',
    fromJson: AppDateUtils.parse,
    toJson: AppDateUtils.toIso8601,
  )
  final DateTime? updatedAt;

  // Workflows might be a Map or dynamic
  final Map<String, dynamic> workflows;

  // Access Policy
  @JsonKey(name: 'accessPolicy')
  final Map<String, dynamic>? accessPolicy;

  const FormDto({
    required this.id,
    this.title = 'Untitled Form',
    this.status = 'draft',
    this.uiType,
    this.activeVersion,
    this.versions = const [],
    this.createdAt,
    this.updatedAt,
    this.workflows = const {},
    this.accessPolicy,
  });

  FormDto copyWith({
    String? id,
    String? title,
    String? status,
    String? uiType,
    String? activeVersion,
    List<FormVersionDto>? versions,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? workflows,
    Map<String, dynamic>? accessPolicy,
  }) {
    return FormDto(
      id: id ?? this.id,
      title: title ?? this.title,
      status: status ?? this.status,
      uiType: uiType ?? this.uiType,
      activeVersion: activeVersion ?? this.activeVersion,
      versions: versions ?? this.versions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      workflows: workflows ?? this.workflows,
      accessPolicy: accessPolicy ?? this.accessPolicy,
    );
  }

  factory FormDto.fromJson(Map<String, dynamic> json) {
    final normalizedJson = _normalizeJson(json);
    return FormDto(
      id: IdReader.readIdWithSlugCallback(normalizedJson, 'id') as String,
      title: normalizedJson['title'] as String? ?? 'Untitled Form',
      status: normalizedJson['status'] as String? ?? 'draft',
      uiType: normalizedJson['ui_type'] as String?,
      activeVersion: normalizedJson['active_version'] as String?,
      versions: (normalizedJson['versions'] as List?)
          ?.map((e) => FormVersionDto.fromJson(Map<String, dynamic>.from(e)))
          .toList() ?? <FormVersionDto>[],
      createdAt: normalizedJson['created_at'] != null 
          ? AppDateUtils.parse(normalizedJson['created_at']) 
          : null,
      updatedAt: normalizedJson['updated_at'] != null 
          ? AppDateUtils.parse(normalizedJson['updated_at']) 
          : null,
      workflows: Map<String, dynamic>.from(normalizedJson['workflows'] ?? {}),
      accessPolicy: normalizedJson['accessPolicy'] != null
          ? Map<String, dynamic>.from(normalizedJson['accessPolicy'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'status': status,
      'ui_type': uiType,
      'active_version': activeVersion,
      'versions': versions.map((e) => e.toJson()).toList(),
      'created_at': createdAt != null ? AppDateUtils.toIso8601(createdAt!) : null,
      'updated_at': updatedAt != null ? AppDateUtils.toIso8601(updatedAt!) : null,
      'workflows': workflows,
      'accessPolicy': accessPolicy,
    };
  }

  static Map<String, dynamic> _normalizeJson(Map<String, dynamic> json) {
    // If the backend returns sections at the top level (no versions array),
    // wrap them into a virtual version so the DTO stays consistent.
    if (!json.containsKey('versions') && json.containsKey('sections')) {
      final normalized = Map<String, dynamic>.from(json);
      normalized['versions'] = [
        {
          'version': normalized['active_version'] ?? '1.0.0',
          'sections': normalized['sections'],
          'created_at': normalized['created_at'],
        },
      ];
      return normalized;
    }
    return json;
  }

  List<Map<String, dynamic>> get sections {
    final active = activeVersion ?? '1.0';
    if (versions.isEmpty) return [];

    final versionData = versions.firstWhere(
      (v) => v.version == active,
      orElse: () => versions.last,
    );
    return versionData.sections;
  }
}

class FormVersionDto {
  final String version;
  final List<Map<String, dynamic>> sections;
  
  @JsonKey(
    name: 'created_at',
    fromJson: AppDateUtils.parse,
    toJson: AppDateUtils.toIso8601,
  )
  final DateTime? createdAt;

  const FormVersionDto({
    this.version = '1.0',
    this.sections = const [],
    this.createdAt,
  });

  FormVersionDto copyWith({
    String? version,
    List<Map<String, dynamic>>? sections,
    DateTime? createdAt,
  }) {
    return FormVersionDto(
      version: version ?? this.version,
      sections: sections ?? this.sections,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory FormVersionDto.fromJson(Map<String, dynamic> json) {
    return FormVersionDto(
      version: json['version'] as String? ?? '1.0',
      sections: _sectionsFromJson(json['sections']),
      createdAt: json['created_at'] != null 
          ? AppDateUtils.parse(json['created_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'sections': sections,
      'created_at': createdAt != null ? AppDateUtils.toIso8601(createdAt!) : null,
    };
  }
}

List<Map<String, dynamic>> _sectionsFromJson(dynamic value) {
  if (value is! List) return const <Map<String, dynamic>>[];
  return value.map((item) {
    if (item is Map<String, dynamic>) return item;
    if (item is Map) return Map<String, dynamic>.from(item);
    final id = item.toString();
    return {
      'id': id,
      'title': 'Untitled Section',
      'questions': const <Map<String, dynamic>>[],
    };
  }).toList();
}