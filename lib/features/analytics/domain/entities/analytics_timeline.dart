class AnalyticsTimeline {
  final String id;
  final DateTime date;
  final int responseCount;
  final double completionRate;

  AnalyticsTimeline({
    required this.id,
    required this.date,
    required this.responseCount,
    required this.completionRate,
  });

  factory AnalyticsTimeline.fromJson(Map<String, dynamic> json) {
    return AnalyticsTimeline(
      id: json['id'] ?? '',
      date: DateTime.parse(json['date']),
      responseCount: json['response_count'] ?? 0,
      completionRate: (json['completion_rate'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'response_count': responseCount,
      'completion_rate': completionRate,
    };
  }
}