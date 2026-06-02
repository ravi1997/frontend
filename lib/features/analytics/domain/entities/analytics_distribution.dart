class AnalyticsDistribution {
  final String id;
  final String fieldName;
  final String fieldType;
  final Map<String, int> valueDistribution;
  final int totalResponses;

  AnalyticsDistribution({
    required this.id,
    required this.fieldName,
    required this.fieldType,
    required this.valueDistribution,
    required this.totalResponses,
  });

  factory AnalyticsDistribution.fromJson(Map<String, dynamic> json) {
    Map<String, int> distribution = {};
    if (json['value_distribution'] != null) {
      json['value_distribution'].forEach((key, value) {
        distribution[key.toString()] = int.parse(value.toString());
      });
    }

    return AnalyticsDistribution(
      id: json['id'] ?? '',
      fieldName: json['field_name'] ?? '',
      fieldType: json['field_type'] ?? '',
      valueDistribution: distribution,
      totalResponses: json['total_responses'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'field_name': fieldName,
      'field_type': fieldType,
      'value_distribution': valueDistribution,
      'total_responses': totalResponses,
    };
  }
}