/// Shared utility for reading ID fields from JSON maps.
///
/// The backend may return IDs as either `id` or `_id` (MongoDB convention).
/// This utility centralizes the fallback logic.
class IdReader {
  /// Read an ID value from a JSON map, trying `id` then `_id`.
  /// Returns null if neither key exists.
  static Object? readId(Map<String, dynamic> map) {
    return map['id'] ?? map['_id'];
  }

  /// Read an ID value from a JSON map with a fallback to `_id`.
  /// Keep identifiers UUID-based for API calls; slug is not a stable id.
  static Object? readIdWithSlug(Map<String, dynamic> map) {
    return map['id'] ?? map['_id'];
  }

  /// Freezed-compatible `readValue` callback for `@JsonKey` with slug fallback.
  /// Matches the required signature: `Object? Function(Map<dynamic, dynamic>, String)`
  /// Usage: `@JsonKey(readValue: IdReader.readIdWithSlugCallback)`
  static Object? readIdWithSlugCallback(Map json, String key) {
    final id = json['id'] ?? json['_id'] ?? json['form_id'];
    return id ?? '';
  }

  /// Freezed-compatible `readValue` callback for `@JsonKey`.
  /// Usage: `@JsonKey(readValue: IdReader.readIdCallback)`
  static Object? readIdCallback(Map json, String key) {
    if (key == 'id') {
      return json['id'] ?? json['_id'];
    }
    return json[key];
  }
}
