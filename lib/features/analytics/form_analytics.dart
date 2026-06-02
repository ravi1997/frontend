
/// Represents analytics data for a form including submission metrics and trends.
///
/// Contains total submissions, completion rate, time series trends for
/// submissions, and field-level distribution data.
class FormAnalytics {
  final String formId;
  final int totalSubmissions;
  final double completionRate;
  final List<TimeSeriesData> trends;
  final Map<String, List<DistributionData>> fieldDistributions;

  const FormAnalytics({
    required this.formId,
    required this.totalSubmissions,
    required this.completionRate,
    this.trends = const [],
    this.fieldDistributions = const {},
  });

  FormAnalytics copyWith({
    String? formId,
    int? totalSubmissions,
    double? completionRate,
    List<TimeSeriesData>? trends,
    Map<String, List<DistributionData>>? fieldDistributions,
  }) {
    return FormAnalytics(
      formId: formId ?? this.formId,
      totalSubmissions: totalSubmissions ?? this.totalSubmissions,
      completionRate: completionRate ?? this.completionRate,
      trends: trends ?? this.trends,
      fieldDistributions: fieldDistributions ?? this.fieldDistributions,
    );
  }

  factory FormAnalytics.fromJson(Map<String, dynamic> json) {
    return FormAnalytics(
      formId: json['form_id'] as String,
      totalSubmissions: json['total_submissions'] as int,
      completionRate: (json['completion_rate'] as num).toDouble(),
      trends: (json['trends'] as List?)
          ?.map((e) => TimeSeriesData.fromJson(Map<String, dynamic>.from(e)))
          .toList() ?? <TimeSeriesData>[],
      fieldDistributions: (json['field_distributions'] as Map?)?.map(
        (key, value) => MapEntry(
          key,
          (value as List).map((e) => DistributionData.fromJson(Map<String, dynamic>.from(e))).toList(),
        ),
      ) ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'form_id': formId,
      'total_submissions': totalSubmissions,
      'completion_rate': completionRate,
      'trends': trends.map((e) => e.toJson()).toList(),
      'field_distributions': fieldDistributions.map(
        (key, value) => MapEntry(key, value.map((e) => e.toJson()).toList()),
      ),
    };
  }
}

class TimeSeriesData {
  final DateTime date;
  final int value;

  const TimeSeriesData({
    required this.date,
    required this.value,
  });

  TimeSeriesData copyWith({
    DateTime? date,
    int? value,
  }) {
    return TimeSeriesData(
      date: date ?? this.date,
      value: value ?? this.value,
    );
  }

  factory TimeSeriesData.fromJson(Map<String, dynamic> json) {
    return TimeSeriesData(
      date: DateTime.parse(json['date']),
      value: json['value'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'value': value,
    };
  }
}

class DistributionData {
  final String label;
  final int count;
  final double percentage;

  const DistributionData({
    required this.label,
    required this.count,
    required this.percentage,
  });

  DistributionData copyWith({
    String? label,
    int? count,
    double? percentage,
  }) {
    return DistributionData(
      label: label ?? this.label,
      count: count ?? this.count,
      percentage: percentage ?? this.percentage,
    );
  }

  factory DistributionData.fromJson(Map<String, dynamic> json) {
    return DistributionData(
      label: json['label'] as String,
      count: json['count'] as int,
      percentage: (json['percentage'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'count': count,
      'percentage': percentage,
    };
  }
}
