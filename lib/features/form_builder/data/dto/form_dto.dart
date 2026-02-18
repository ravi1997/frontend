import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'form_dto.freezed.dart';
part 'form_dto.g.dart';

// Updated for custom date parsing
@freezed
abstract class FormDto with _$FormDto {
  const FormDto._();

  const factory FormDto({
    // Handle both 'id' and '_id' from backend
    // ignore: invalid_annotation_target
    @JsonKey(name: 'id', readValue: _readId) required String id,
    @Default('Untitled Form') String title,
    @Default('draft') String status,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'active_version') String? activeVersion,

    // The backend returns a list of version objects under 'versions'
    @Default([]) List<FormVersionDto> versions,

    // ignore: invalid_annotation_target
    @JsonKey(
      name: 'created_at',
      fromJson: _dateTimeFromJson,
      toJson: _dateTimeToJson,
    )
    DateTime? createdAt,
    // ignore: invalid_annotation_target
    @JsonKey(
      name: 'updated_at',
      fromJson: _dateTimeFromJson,
      toJson: _dateTimeToJson,
    )
    DateTime? updatedAt,

    // Workflows might be a Map or dynamic
    @Default({}) Map<String, dynamic> workflows,
  }) = _FormDto;

  factory FormDto.fromJson(Map<String, dynamic> json) =>
      _$FormDtoFromJson(json);

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

Object? _readId(Map json, String key) {
  return json['id'] ?? json['_id'];
}

@freezed
abstract class FormVersionDto with _$FormVersionDto {
  const factory FormVersionDto({
    @Default('1.0') String version,
    @Default([]) List<Map<String, dynamic>> sections,
    // ignore: invalid_annotation_target
    @JsonKey(
      name: 'created_at',
      fromJson: _dateTimeFromJson,
      toJson: _dateTimeToJson,
    )
    DateTime? createdAt,
  }) = _FormVersionDto;

  factory FormVersionDto.fromJson(Map<String, dynamic> json) =>
      _$FormVersionDtoFromJson(json);
}

DateTime? _dateTimeFromJson(String? date) {
  if (date == null) return null;
  try {
    return DateFormat("E, d MMM y HH:mm:ss 'GMT'").parse(date);
  } catch (_) {
    return DateTime.tryParse(date);
  }
}

String? _dateTimeToJson(DateTime? date) {
  if (date == null) return null;
  return DateFormat("E, d MMM y HH:mm:ss 'GMT'").format(date);
}
