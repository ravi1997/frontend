import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import 'package:frontend/core/networking/api_client.dart';
import 'package:frontend/core/networking/api_requests.dart';
import 'package:frontend/core/networking/dio_provider.dart';
import 'package:frontend/modules/dashboard_builder/models/dashboard_canvas_models.dart';

class DashboardBuilderRepository {
  final ApiClient _dio;
  DashboardBuilderRepository(this._dio);

  // ── List dashboards for a project ──────────────────────────────────────────
  Future<List<DashboardModel>> listForProject(String projectId) async {
    final data = await _dio.listDashboardsForProject(projectId);
    return data
        .map((e) => DashboardModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  // ── Create dashboard ────────────────────────────────────────────────────────
  Future<DashboardModel> create({
    required String projectId,
    required String name,
    String description = '',
  }) async {
    final resp = await _dio.createDashboard(
      DashboardCreateRequest(
        projectId: projectId,
        name: name,
        description: description,
      ),
    );
    return DashboardModel.fromJson(resp);
  }

  // ── Get dashboard canvas ────────────────────────────────────────────────────
  Future<DashboardModel> getCanvas(
    String dashboardId, {
    bool includeData = false,
  }) async {
    final resp = await _dio.getDashboardCanvas(
      dashboardId,
      includeData: includeData,
    );
    return DashboardModel.fromJson(resp);
  }

  // ── Save canvas ─────────────────────────────────────────────────────────────
  Future<void> saveCanvas(String dashboardId, DashboardCanvas canvas) async {
    await _dio.saveDashboardCanvas(dashboardId, canvas);
  }

  // ── Update dashboard metadata ───────────────────────────────────────────────
  Future<DashboardModel> updateMeta(
    String dashboardId, {
    String? name,
    String? description,
    DashboardSettings? settings,
  }) async {
    final resp = await _dio.updateDashboard(
      dashboardId,
      DashboardUpdateRequest(
        name: name,
        description: description,
        settings: settings?.toJson(),
      ),
    );
    return DashboardModel.fromJson(resp);
  }

  // ── Share dashboard ─────────────────────────────────────────────────────────
  Future<String?> share(String dashboardId) async {
    return _dio.shareDashboard(dashboardId);
  }

  // ── Unshare dashboard ───────────────────────────────────────────────────────
  Future<void> unshare(String dashboardId) async {
    await _dio.unshareDashboard(dashboardId);
  }

  // ── Get public dashboard (no auth) ─────────────────────────────────────────
  Future<DashboardModel> getPublic(String shareToken) async {
    final resp = await _dio.publicDashboard(shareToken);
    return DashboardModel.fromJson(resp);
  }

  // ── Get widget resolved data ────────────────────────────────────────────────
  Future<Map<String, dynamic>> getWidgetData(
    String dashboardId,
    String widgetId,
  ) async {
    return _dio.dashboardWidgetData(dashboardId, widgetId);
  }

  // ── Delete dashboard ────────────────────────────────────────────────────────
  Future<void> delete(String dashboardId) async {
    await _dio.deleteDashboard(dashboardId);
  }

  // ── Get snapshot ────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> getSnapshot(String dashboardId, String snapshotId) async {
    return _dio.dashboardSnapshot(dashboardId, snapshotId);
  }

  // ── List snapshots ──────────────────────────────────────────────────────────
  Future<List<dynamic>> listSnapshots(String dashboardId) async {
    return _dio.dashboardSnapshots(dashboardId);
  }

  // ── Create snapshot ─────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> createSnapshot(String dashboardId) async {
    final resp = await _dio.postMap('/dashboards/$dashboardId/snapshots');
    return Map<String, dynamic>.from(resp);
  }

  // ── Delete snapshot ─────────────────────────────────────────────────────────
  Future<void> deleteSnapshot(String dashboardId, String snapshotId) async {
    await _dio.delete('/dashboards/$dashboardId/snapshots/$snapshotId');
  }

  // ── Get filter options ──────────────────────────────────────────────────────
  Future<Map<String, dynamic>> getFilterOptions(
    String dashboardId, {
    required String analysisId,
    required String nodeId,
    required String column,
    int? limit,
  }) async {
    return _dio.getMap(
      '/dashboards/$dashboardId/filter-options',
      queryParameters: {
        'analysis_id': analysisId,
        'node_id': nodeId,
        'column': column,
        if (limit != null) 'limit': limit,
      },
    );
  }

  // ── Get dashboard data (authenticated polling) ──────────────────────────────
  Future<Map<String, dynamic>> getDashboardData(
    String dashboardId, {
    Map<String, dynamic>? filterState,
  }) async {
    return _dio.getMap(
      '/dashboards/$dashboardId/data',
      queryParameters: {
        if (filterState != null && filterState.isNotEmpty)
          'filter_state': jsonEncode(filterState),
      },
    );
  }

  // ── Get public dashboard data (unauthenticated polling) ─────────────────────
  Future<Map<String, dynamic>> getPublicDashboardData(
    String shareToken, {
    Map<String, dynamic>? filterState,
  }) async {
    return _dio.getMap(
      '/public/dashboards/$shareToken/data',
      queryParameters: {
        if (filterState != null && filterState.isNotEmpty)
          'filter_state': jsonEncode(filterState),
      },
    );
  }
}

// ─── Providers ─────────────────────────────────────────────────────────────────

final dashboardBuilderRepositoryProvider =
    Provider<DashboardBuilderRepository>((ref) {
  return DashboardBuilderRepository(ref.watch(apiClientProvider));
});

// List dashboards for project
final projectDashboardsProvider =
    FutureProvider.family<List<DashboardModel>, String>((ref, projectId) async {
  return ref
      .watch(dashboardBuilderRepositoryProvider)
      .listForProject(projectId);
});

// Single dashboard canvas
final dashboardCanvasProvider =
    FutureProvider.family<DashboardModel, String>((ref, dashboardId) async {
  return ref
      .watch(dashboardBuilderRepositoryProvider)
      .getCanvas(dashboardId);
});
