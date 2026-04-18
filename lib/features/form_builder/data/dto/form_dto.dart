import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/id_reader.dart';

part 'form_dto.freezed.dart';
part 'form_dto.g.dart';

// Updated for custom date parsing
@freezed
abstract class FormDto with _$FormDto {
  const FormDto._();

  const factory FormDto({
    // Handle both 'id' and '_id' from backend
    @JsonKey(name: 'id', readValue: IdReader.readIdWithSlugCallback)
    required String id,
    @Default('Untitled Form') String title,
    @Default('draft') String status,
    @JsonKey(name: 'active_version') String? activeVersion,

    // The backend returns a list of version objects under 'versions'
    @Default(<FormVersionDto>[]) List<FormVersionDto> versions,

    @JsonKey(
      name: 'created_at',
      fromJson: AppDateUtils.parse,
      toJson: AppDateUtils.toIso8601,
    )
    DateTime? createdAt,
    @JsonKey(
      name: 'updated_at',
      fromJson: AppDateUtils.parse,
      toJson: AppDateUtils.toIso8601,
    )
    DateTime? updatedAt,

    // Workflows might be a Map or dynamic
    @Default(<String, dynamic>{}) Map<String, dynamic> workflows,

    // Access Policy
    @JsonKey(name: 'accessPolicy') Map<String, dynamic>? accessPolicy,
  }) = _FormDto;

  factory FormDto.fromJson(Map<String, dynamic> json) =>
      _$FormDtoFromJson(_normalizeJson(json));

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

@freezed
abstract class FormVersionDto with _$FormVersionDto {
  const factory FormVersionDto({
    @Default('1.0') String version,
    @JsonKey(fromJson: _sectionsFromJson)
    @Default(<Map<String, dynamic>>[])
    List<Map<String, dynamic>> sections,
    @JsonKey(
      name: 'created_at',
      fromJson: AppDateUtils.parse,
      toJson: AppDateUtils.toIso8601,
    )
    DateTime? createdAt,
  }) = _FormVersionDto;

  factory FormVersionDto.fromJson(Map<String, dynamic> json) =>
      _$FormVersionDtoFromJson(json);
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
