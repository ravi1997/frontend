import 'package:intl/intl.dart';

/// Shared date parsing utility that handles both ISO 8601 and RFC 1123 date formats.
///
/// The backend may return dates in either format:
/// - ISO 8601: "2024-01-15T10:30:00Z"
/// - RFC 1123: "Mon, 15 Jan 2024 10:30:00 GMT"
class AppDateUtils {
  static final DateFormat _rfc1123 = DateFormat(
    "EEE, dd MMM yyyy HH:mm:ss 'GMT'",
    'en_US',
  );

  /// Parse a date string, trying RFC 1123 first then ISO 8601.
  /// Returns null if the input is null or cannot be parsed.
  static DateTime? parse(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) {
      if (value.isEmpty) return null;
      // Try RFC 1123 first. This format uses English day/month names and is in GMT/UTC.
      try {
        return _rfc1123.parseUtc(value);
      } catch (_) {
        // Fall back to ISO 8601
        return DateTime.tryParse(value);
      }
    }
    return null;
  }

  /// Format a DateTime to RFC 1123 string for API requests.
  static String? toRfc1123(DateTime? date) {
    if (date == null) return null;
    return _rfc1123.format(date.toUtc());
  }

  /// Format a DateTime to ISO 8601 string.
  static String? toIso8601(DateTime? date) {
    if (date == null) return null;
    return date.toIso8601String();
  }
}
