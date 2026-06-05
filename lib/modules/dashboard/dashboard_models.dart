// lib/features/dashboard/dashboard_models.dart

import 'package:frontend/modules/dashboard/models/project_summary.dart';
export 'package:frontend/modules/dashboard/models/project_summary.dart';

class DashboardStats {
  final int totalForms;
  final int totalResponses;
  final int activeForms;

  const DashboardStats({
    this.totalForms = 0,
    this.totalResponses = 0,
    this.activeForms = 0,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalForms: json['total_forms'] as int? ?? 0,
      totalResponses: json['total_responses'] as int? ?? 0,
      activeForms: json['active_forms'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_forms': totalForms,
      'total_responses': totalResponses,
      'active_forms': activeForms,
    };
  }
}

class RecentForm {
  final String id;
  final String title;
  final String status;
  final DateTime updatedAt;
  final DateTime? createdAt;

  const RecentForm({
    required this.id,
    required this.title,
    required this.status,
    required this.updatedAt,
    this.createdAt,
  });

  factory RecentForm.fromJson(Map<String, dynamic> json) {
    return RecentForm(
      id: json['id'] as String,
      title: json['title'] as String,
      status: json['status'] as String,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'status': status,
      'updatedAt': updatedAt.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}

class DashboardData {
  final DashboardStats stats;
  final List<RecentForm> recentForms;
  final List<ProjectSummary> projects;

  const DashboardData({
    required this.stats,
    required this.recentForms,
    this.projects = const <ProjectSummary>[],
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      stats: DashboardStats.fromJson(json['stats'] as Map<String, dynamic>),
      recentForms: (json['recentForms'] as List<dynamic>).map((e) => RecentForm.fromJson(e as Map<String, dynamic>)).toList(),
      projects: (json['projects'] as List<dynamic>?)?.map((e) => ProjectSummary.fromJson(e as Map<String, dynamic>)).toList() ?? const <ProjectSummary>[],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stats': stats.toJson(),
      'recentForms': recentForms.map((e) => e.toJson()).toList(),
      'projects': projects.map((e) => e.toJson()).toList(),
    };
  }
}
