import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frontend/core/networking/dio_provider.dart';
import 'package:frontend/modules/dashboard_builder/models/dashboard_canvas_models.dart';

class DashboardBuilderRepository {
  final Dio _dio;
  DashboardBuilderRepository(this._dio);

  // ── List dashboards for a project ──────────────────────────────────────────
  Future<List<DashboardModel>> listForProject(String projectId) async {
    final resp = await _dio.get(
      '/dashboards/',
      queryParameters: {'project_id': projectId},
    );
    final data = resp.data;
    final payload = data is Map ? (data['data'] ?? data['dashboards'] ?? data) : data;
    if (payload is List) {
      return payload
          .map((e) => DashboardModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }
    return [];
  }

  // ── Create dashboard ────────────────────────────────────────────────────────
  Future<DashboardModel> create({
    required String projectId,
    required String name,
    String description = '',
  }) async {
    final resp = await _dio.post('/dashboards/', data: {
      'name': name,
      'description': description,
      'project_id': projectId,
      'canvas': {'width': 1920, 'height': 1080, 'background_color': '#F5F5F5', 'widgets': []},
      'settings': {'auto_refresh': false, 'refresh_interval_seconds': 60},
    });
    return DashboardModel.fromJson(Map<String, dynamic>.from(resp.data as Map));
  }

  // ── Get dashboard canvas ────────────────────────────────────────────────────
  Future<DashboardModel> getCanvas(
    String dashboardId, {
    bool includeData = false,
  }) async {
    final resp = await _dio.get(
      '/dashboards/$dashboardId/canvas',
      queryParameters: includeData ? {'include_data': '1'} : null,
    );
    return DashboardModel.fromJson(Map<String, dynamic>.from(resp.data as Map));
  }

  // ── Save canvas ─────────────────────────────────────────────────────────────
  Future<void> saveCanvas(String dashboardId, DashboardCanvas canvas) async {
    await _dio.put(
      '/dashboards/$dashboardId/canvas',
      data: canvas.toJson(),
    );
  }

  // ── Update dashboard metadata ───────────────────────────────────────────────
  Future<DashboardModel> updateMeta(
    String dashboardId, {
    String? name,
    String? description,
    DashboardSettings? settings,
  }) async {
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    if (description != null) body['description'] = description;
    if (settings != null) body['settings'] = settings.toJson();

    final resp = await _dio.put('/dashboards/$dashboardId', data: body);
    return DashboardModel.fromJson(Map<String, dynamic>.from(resp.data as Map));
  }

  // ── Share dashboard ─────────────────────────────────────────────────────────
  Future<String?> share(String dashboardId) async {
    final resp = await _dio.post('/dashboards/$dashboardId/share');
    final data = resp.data;
    if (data is Map) {
      return data['public_token'] as String? ??
          (data['dashboard'] as Map?)?['public_token'] as String?;
    }
    return null;
  }

  // ── Unshare dashboard ───────────────────────────────────────────────────────
  Future<void> unshare(String dashboardId) async {
    await _dio.delete('/dashboards/$dashboardId/share');
  }

  // ── Get public dashboard (no auth) ─────────────────────────────────────────
  Future<DashboardModel> getPublic(String shareToken) async {
    final resp = await _dio.get('/dashboards/shared/$shareToken');
    return DashboardModel.fromJson(Map<String, dynamic>.from(resp.data as Map));
  }

  // ── Get widget resolved data ────────────────────────────────────────────────
  Future<Map<String, dynamic>> getWidgetData(
    String dashboardId,
    String widgetId,
  ) async {
    final resp =
        await _dio.get('/dashboards/$dashboardId/widgets/$widgetId/data');
    if (resp.data is Map) return Map<String, dynamic>.from(resp.data as Map);
    return {};
  }

  // ── Delete dashboard ────────────────────────────────────────────────────────
  Future<void> delete(String dashboardId) async {
    await _dio.delete('/dashboards/$dashboardId');
  }
}

// ─── Providers ─────────────────────────────────────────────────────────────────

final dashboardBuilderRepositoryProvider =
    Provider<DashboardBuilderRepository>((ref) {
  return DashboardBuilderRepository(ref.watch(dioProvider));
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
