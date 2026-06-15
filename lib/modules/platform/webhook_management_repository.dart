import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/networking/api_endpoints.dart';
import '../../core/networking/dio_provider.dart';

class WebhookManagementRepository {
  WebhookManagementRepository(this._apiClient);

  final Dio _apiClient;

  Future<List<Map<String, dynamic>>> listWebhooks({
    required String formId,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.adminWebhooks,
      queryParameters: {'form_id': formId},
    );
    final data = response.data;
    final payload = data is Map ? data['data'] : data;
    if (payload is List) {
      return payload
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }
    return const [];
  }

  Future<Map<String, dynamic>> createWebhook({
    required String formId,
    required String name,
    required String url,
    String eventType = 'on_submit',
    String description = '',
    bool isActive = true,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.createAdminWebhook,
      data: {
        'form_id': formId,
        'name': name,
        'event_type': eventType,
        'description': description,
        'is_active': isActive,
        'action_config': {'url': url},
      },
    );
    final data = response.data;
    if (data is Map) {
      final payload = data['data'];
      if (payload is Map) {
        return Map<String, dynamic>.from(payload);
      }
      return Map<String, dynamic>.from(data);
    }
    return const {};
  }

  Future<void> deleteWebhook(String webhookId) async {
    await _apiClient.delete(ApiEndpoints.deleteAdminWebhook(webhookId));
  }

  Future<List<Map<String, dynamic>>> listWebhookLogs({
    String? url,
    String? status,
    String? webhookId,
    int limit = 50,
  }) async {
    final response = await _apiClient.get(
      webhookId == null || webhookId.isEmpty
          ? ApiEndpoints.webhookLogs('')
          : ApiEndpoints.adminWebhookLogs(webhookId),
      queryParameters: {
        if (url != null && url.isNotEmpty) 'url': url,
        if (status != null && status.isNotEmpty) 'status': status,
        'limit': limit,
      },
    );
    final data = response.data;
    final payload = data is Map ? data['data'] : data;
    if (payload is Map && payload['logs'] is List) {
      return (payload['logs'] as List)
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }
    if (payload is List) {
      return payload
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }
    return const [];
  }

  Future<Map<String, dynamic>> testWebhook({
    String? webhookId,
    String? url,
    Map<String, dynamic>? payload,
  }) async {
    final response = await _apiClient.post(
      webhookId == null || webhookId.isEmpty
          ? ApiEndpoints.webhookTest('test')
          : ApiEndpoints.testAdminWebhook(webhookId),
      data: webhookId == null || webhookId.isEmpty
          ? {
              'url': url,
              'payload': payload,
            }
          : null,
    );
    final data = response.data;
    if (data is Map) {
      final payloadData = data['data'];
      if (payloadData is Map) {
        return Map<String, dynamic>.from(payloadData);
      }
      return Map<String, dynamic>.from(data);
    }
    return const {};
  }
}

final webhookManagementRepositoryProvider =
    Provider<WebhookManagementRepository>((ref) {
  return WebhookManagementRepository(ref.watch(dioProvider));
});
