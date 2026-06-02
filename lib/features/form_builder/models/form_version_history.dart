class FormVersionHistory {
  final String version;
  final DateTime created_at;
  final String? authorId;
  final String? changeLog;

  FormVersionHistory({
    required this.version,
    required this.created_at,
    this.authorId,
    this.changeLog,
  });

  factory FormVersionHistory.fromJson(Map<String, dynamic> json) {
    return FormVersionHistory(
      version: json['version'] as String? ?? '',
      created_at: _parseDate(json['created_at']),
      authorId: json['authorId'] as String?,
      changeLog: json['changeLog'] as String?,
    );
  }

  static DateTime _parseDate(dynamic value) {
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'created_at': created_at.toIso8601String(),
      'authorId': authorId,
      'changeLog': changeLog,
    };
  }

  FormVersionHistory copyWith({
    String? version,
    DateTime? created_at,
    String? authorId,
    String? changeLog,
  }) {
    return FormVersionHistory(
      version: version ?? this.version,
      created_at: created_at ?? this.created_at,
      authorId: authorId ?? this.authorId,
      changeLog: changeLog ?? this.changeLog,
    );
  }
}
