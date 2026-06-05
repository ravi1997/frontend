class IdReader {
  static Object? readIdCallback(
    Map<dynamic, dynamic> json,
    String key,
  ) {
    return json[key] ?? json['_id'];
  }

  static Object? readIdWithSlugCallback(
    Map<dynamic, dynamic> json,
    String key,
  ) {
    return json[key] ?? json['_id'] ?? json['slug'];
  }
}
