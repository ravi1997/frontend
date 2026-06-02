import 'package:json_annotation/json_annotation.dart';

/// Represents summary statistics for form analytics.
///
/// Contains aggregated metrics like total submissions and completion rate.
class AnalyticsSummary {
  final String formId;
  final int totalSubmissions;
  final double completionRate;
  final int? uniqueResponders;
  final double? averageCompletionTime;
  final Map<String, int>? statusBreakdown;

  const AnalyticsSummary({
    required this.formId,
    required this.totalSubmissions,
    required this.completionRate,
    this.uniqueResponders,
    this.averageCompletionTime,
    this.statusBreakdown,
  });

  AnalyticsSummary copyWith({
    String? formId,
    int? totalSubmissions,
    double? completionRate,
    int? uniqueResponders,
    double? averageCompletionTime,
    Map<String, int>? statusBreakdown,
  }) {
    return AnalyticsSummary(
      formId: formId ?? this.formId,
      totalSubmissions: totalSubmissions ?? this.totalSubmissions,
      completionRate: completionRate ?? this.completionRate,
      uniqueResponders: uniqueResponders ?? this.uniqueResponders,
      averageCompletionTime: averageCompletionTime ?? this.averageCompletionTime,
      statusBreakdown: statusBreakdown ?? this.statusBreakdown,
    );
  }

  factory AnalyticsSummary.fromJson(Map<String, dynamic> json) {
    return AnalyticsSummary(
      formId: json['form_id'] as String,
      totalSubmissions: json['total_submissions'] as int,
      completionRate: (json['completion_rate'] as num).toDouble(),
      uniqueResponders: json['unique_responders'] as int?,
      averageCompletionTime: json['average_completion_time']?.toDouble(),
      statusBreakdown: json['status_breakdown'] != null 
          ? Map<String, int>.from(json['status_breakdown'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'form_id': formId,
      'total_submissions': totalSubmissions,
      'completion_rate': completionRate,
      'unique_responders': uniqueResponders,
      'average_completion_time': averageCompletionTime,
      'status_breakdown': statusBreakdown,
    };
  }
}