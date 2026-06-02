class AnalysisDashboard {
  final String id;
  final String title;
  final String description;
  final int totalResponses;
  final int completedResponses;
  final double completionRate;
  final DateTime createdAt;
  final DateTime updatedAt;

  AnalysisDashboard({
    required this.id,
    required this.title,
    required this.description,
    required this.totalResponses,
    required this.completedResponses,
    required this.completionRate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AnalysisDashboard.fromJson(Map<String, dynamic> json) {
    return AnalysisDashboard(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      totalResponses: json['total_responses'] ?? 0,
      completedResponses: json['completed_responses'] ?? 0,
      completionRate: (json['completion_rate'] ?? 0.0).toDouble(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'total_responses': totalResponses,
      'completed_responses': completedResponses,
      'completion_rate': completionRate,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}