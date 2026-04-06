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

  /// Read an ID value from a JSON map with a fallback to `slug`.
  /// Used for FormDto which may use slug as an identifier.
  static Object? readIdWithSlug(Map<String, dynamic> map) {
    return map['id'] ?? map['_id'] ?? map['slug'];
  }

  /// Freezed-compatible readValue callback for @JsonKey.
  /// Usage: @JsonKey(readValue: IdReader.readIdCallback)
  static Object? readIdCallback(Map json, String key) {
    if (key == 'id') {
      return json['id'] ?? json['_id'];
    }
    return json[key];
  }
}
