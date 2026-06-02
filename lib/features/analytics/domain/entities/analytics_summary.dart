class AnalyticsSummary {
  final String formId;
  final int totalResponses;
  final int completedResponses;
  final int incompleteResponses;
  final double completionRate;
  final double averageCompletionTime;
  final DateTime firstResponse;
  final DateTime lastResponse;

  AnalyticsSummary({
    required this.formId,
    required this.totalResponses,
    required this.completedResponses,
    required this.incompleteResponses,
    required this.completionRate,
    required this.averageCompletionTime,
    required this.firstResponse,
    required this.lastResponse,
  });

  factory AnalyticsSummary.fromJson(Map<String, dynamic> json) {
    return AnalyticsSummary(
      formId: json['form_id'] ?? '',
      totalResponses: json['total_responses'] ?? 0,
      completedResponses: json['completed_responses'] ?? 0,
      incompleteResponses: json['incomplete_responses'] ?? 0,
      completionRate: (json['completion_rate'] ?? 0.0).toDouble(),
      averageCompletionTime: (json['average_completion_time'] ?? 0.0).toDouble(),
      firstResponse: DateTime.parse(json['first_response']),
      lastResponse: DateTime.parse(json['last_response']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'form_id': formId,
      'total_responses': totalResponses,
      'completed_responses': completedResponses,
      'incomplete_responses': incompleteResponses,
      'completion_rate': completionRate,
      'average_completion_time': averageCompletionTime,
      'first_response': firstResponse.toIso8601String(),
      'last_response': lastResponse.toIso8601String(),
    };
  }
}