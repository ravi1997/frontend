class AppDateUtils {
  static DateTime? parse(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  static String? toIso8601(DateTime? value) => value?.toIso8601String();
}
