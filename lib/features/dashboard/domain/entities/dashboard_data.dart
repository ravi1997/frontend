import 'package:freezed_annotation/freezed_annotation.dart';
import 'dashboard_stats.dart';
import 'recent_form.dart';

part 'dashboard_data.freezed.dart';
part 'dashboard_data.g.dart';

@freezed
abstract class DashboardData with _$DashboardData {
  const DashboardData._();
  const factory DashboardData({
    required DashboardStats stats,
    required List<RecentForm> recentForms,
  }) = _DashboardData;

  factory DashboardData.fromJson(Map<String, dynamic> json) =>
      _$DashboardDataFromJson(json);
}
