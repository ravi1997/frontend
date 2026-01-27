import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_stats.freezed.dart';
part 'dashboard_stats.g.dart';

@freezed
abstract class DashboardStats with _$DashboardStats {
  const DashboardStats._();
  const factory DashboardStats({
    @Default(0) int totalForms,
    @Default(0) int totalResponses,
    @Default(0) int activeForms,
  }) = _DashboardStats;

  factory DashboardStats.fromJson(Map<String, dynamic> json) =>
      _$DashboardStatsFromJson(json);
}
