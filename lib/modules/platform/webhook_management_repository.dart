import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/networking/api_client.dart';
import '../../core/networking/dio_provider.dart';

class WebhookManagementRepository {
  WebhookManagementRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<List<Map<String, dynamic>>> listWebhooks({
    required String formId,
  }) async {
    final payload = await _apiClient.listWebhooks(formId: formId);
    return payload
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  Future<Map<String, dynamic>> createWebhook({
    required String formId,
    required String name,
    required String url,
    String eventType = 'on_submit',
    String description = '',
    bool isActive = true,
  }) async {
    return _apiClient.createWebhook({
      'form_id': formId,
      'name': name,
      'event_type': eventType,
      'description': description,
      'is_active': isActive,
      'action_config': {'url': url},
    });
  }

  Future<void> deleteWebhook(String webhookId) async {
    await _apiClient.deleteWebhook(webhookId);
  }

  Future<List<Map<String, dynamic>>> listWebhookLogs({
    String? url,
    String? status,
    String? webhookId,
    int limit = 50,
  }) async {
    final payload = await _apiClient.webhookLogs(
      webhookId: webhookId,
      limit: limit,
    );
    return payload
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  Future<Map<String, dynamic>> testWebhook({
    String? webhookId,
    String? url,
    Map<String, dynamic>? payload,
  }) async {
    return _apiClient.testWebhook(
      webhookId,
      url: url,
      payload: payload,
    );
  }
}

final webhookManagementRepositoryProvider =
    Provider<WebhookManagementRepository>((ref) {
  return WebhookManagementRepository(ref.watch(apiClientProvider));
});
