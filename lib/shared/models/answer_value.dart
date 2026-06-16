class AnswerValue {
  final dynamic value;
  final String? displayValue;
  final List<String> fileIds;
  final DateTime answeredAt;
  final int iterationIndex;

  AnswerValue({
    required this.value,
    this.displayValue,
    this.fileIds = const [],
    DateTime? answeredAt,
    this.iterationIndex = 0,
  }) : answeredAt = answeredAt ?? DateTime.now();

  factory AnswerValue.fromJson(Map<String, dynamic> json) {
    return AnswerValue(
      value: json['value'],
      displayValue: json['display_value']?.toString() ?? json['displayValue']?.toString(),
      fileIds: (json['file_ids'] as List? ?? json['fileIds'] as List? ?? const [])
          .map((e) => e.toString())
          .toList(),
      answeredAt: json['answered_at'] != null 
          ? DateTime.parse(json['answered_at'].toString())
          : json['answeredAt'] != null
              ? DateTime.parse(json['answeredAt'].toString())
              : null,
      iterationIndex: (json['iteration_index'] ?? json['iterationIndex'] ?? 0) as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'display_value': displayValue,
      'file_ids': fileIds,
      'answered_at': answeredAt.toIso8601String(),
      'iteration_index': iterationIndex,
    };
  }

  AnswerValue copyWith({
    dynamic value,
    String? displayValue,
    List<String>? fileIds,
    DateTime? answeredAt,
    int? iterationIndex,
  }) {
    return AnswerValue(
      value: value ?? this.value,
      displayValue: displayValue ?? this.displayValue,
      fileIds: fileIds ?? this.fileIds,
      answeredAt: answeredAt ?? this.answeredAt,
      iterationIndex: iterationIndex ?? this.iterationIndex,
    );
  }
}
