
/// Represents timeline data for form analytics.
///
/// Contains a list of data points showing metrics over time.
class AnalyticsTimeline {
  final String formId;
  final List<TimelineDataPoint> dataPoints;
  final String? period;
  final DateTime? startDate;
  final DateTime? endDate;

  const AnalyticsTimeline({
    required this.formId,
    required this.dataPoints,
    this.period,
    this.startDate,
    this.endDate,
  });

  AnalyticsTimeline copyWith({
    String? formId,
    List<TimelineDataPoint>? dataPoints,
    String? period,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return AnalyticsTimeline(
      formId: formId ?? this.formId,
      dataPoints: dataPoints ?? this.dataPoints,
      period: period ?? this.period,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  factory AnalyticsTimeline.fromJson(Map<String, dynamic> json) {
    return AnalyticsTimeline(
      formId: json['form_id'] as String,
      dataPoints: (json['data_points'] as List?)
          ?.map((e) => TimelineDataPoint.fromJson(Map<String, dynamic>.from(e)))
          .toList() ?? <TimelineDataPoint>[],
      period: json['period'] as String?,
      startDate: json['start_date'] != null ? DateTime.parse(json['start_date']) : null,
      endDate: json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'form_id': formId,
      'data_points': dataPoints.map((e) => e.toJson()).toList(),
      'period': period,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
    };
  }
}

/// Represents a single data point in the timeline.
class TimelineDataPoint {
  final DateTime date;
  final int count;
  final int? submissions;
  final int? completions;
  final double? rate;

  const TimelineDataPoint({
    required this.date,
    required this.count,
    this.submissions,
    this.completions,
    this.rate,
  });

  TimelineDataPoint copyWith({
    DateTime? date,
    int? count,
    int? submissions,
    int? completions,
    double? rate,
  }) {
    return TimelineDataPoint(
      date: date ?? this.date,
      count: count ?? this.count,
      submissions: submissions ?? this.submissions,
      completions: completions ?? this.completions,
      rate: rate ?? this.rate,
    );
  }

  factory TimelineDataPoint.fromJson(Map<String, dynamic> json) {
    return TimelineDataPoint(
      date: DateTime.parse(json['date']),
      count: json['count'] as int,
      submissions: json['submissions'] as int?,
      completions: json['completions'] as int?,
      rate: json['rate']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'count': count,
      'submissions': submissions,
      'completions': completions,
      'rate': rate,
    };
  }
}
