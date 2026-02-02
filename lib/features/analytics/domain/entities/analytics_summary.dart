import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_summary.freezed.dart';
part 'analytics_summary.g.dart';

/// Represents summary statistics for form analytics.
///
/// Contains aggregated metrics like total submissions and completion rate.
@freezed
class AnalyticsSummary with _$AnalyticsSummary {
  const factory AnalyticsSummary({
    required String formId,
    required int totalSubmissions,
    required double completionRate,
    int? uniqueResponders,
    double? averageCompletionTime,
    Map<String, int>? statusBreakdown,
  }) = _AnalyticsSummary;

  factory AnalyticsSummary.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsSummaryFromJson(json);
}
