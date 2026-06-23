import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/core/networking/api_client.dart';
import 'package:frontend/modules/platform/screens/webhook_management_screen.dart';
import 'package:frontend/modules/platform/webhook_management_repository.dart';

class _FakeRepo extends WebhookManagementRepository {
  _FakeRepo() : super(ApiClient(Dio()));

  @override
  Future<List<Map<String, dynamic>>> listWebhooks({
    required String formId,
  }) async {
    return [
      {
        'id': 'hook-1',
        'name': 'Primary webhook',
        'event_type': 'on_submit',
        'action_config': {'url': 'https://example.com/hook'},
      },
    ];
  }

  @override
  Future<Map<String, dynamic>> createWebhook({
    required String formId,
    required String name,
    required String url,
    String eventType = 'on_submit',
    String description = '',
    bool isActive = true,
  }) async {
    return {'id': 'hook-2', 'name': name};
  }

  @override
  Future<void> deleteWebhook(String webhookId) async {}

  @override
  Future<List<Map<String, dynamic>>> listWebhookLogs({
    String? url,
    String? status,
    String? webhookId,
    int limit = 50,
  }) async {
    return [
      {
        'event_type': 'webhook.test',
        'status': 'SUCCESS',
        'url': 'https://example.com/hook',
        'timestamp': '2026-06-15T12:00:00Z',
      },
    ];
  }

  @override
  Future<Map<String, dynamic>> testWebhook({
    String? webhookId,
    String? url,
    Map<String, dynamic>? payload,
  }) async {
    return {'status': 'queued'};
  }
}

void main() {
  testWidgets('shows webhook operations screen', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          webhookManagementRepositoryProvider.overrideWithValue(_FakeRepo()),
        ],
        child: const MaterialApp(
          home: WebhookManagementScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Webhook Management'), findsOneWidget);
    expect(find.text('Configured Webhooks'), findsOneWidget);
    expect(find.text('Test Delivery'), findsOneWidget);
    expect(find.text('Recent Logs'), findsOneWidget);
  });
}
