import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/utils/error_handler.dart';
import '../entities/builder_form.dart';

abstract class WorkflowExecutor {
  Future<void> execute(BuilderForm form, Map<String, dynamic> responseData);
}

class WorkflowExecutorImpl implements WorkflowExecutor {
  final Dio? _dio; // Optional dio for webhooks

  WorkflowExecutorImpl([this._dio]);

  @override
  Future<void> execute(
    BuilderForm form,
    Map<String, dynamic> responseData,
  ) async {
    final workflows = form.workflows;
    if (workflows.isEmpty) return;

    debugPrint('Executing workflows for form: ${form.title}');

    // 1. Email Workflow
    if (workflows['email_notification']?['enabled'] == true) {
      final recipient = workflows['email_notification']?['recipient'];
      await _executeEmail(recipient, form.title, responseData);
    }

    // 2. Webhook Workflow
    if (workflows['webhook']?['enabled'] == true) {
      final url = workflows['webhook']?['url'];
      await _executeWebhook(url, responseData);
    }

    // 3. Slack Workflow
    if (workflows['slack_notification']?['enabled'] == true) {
      await _executeSlack(form.title, responseData);
    }
  }

  Future<void> _executeEmail(
    String? recipient,
    String formTitle,
    Map<String, dynamic> data,
  ) async {
    debugPrint(
      'SIMULATING EMAIL to $recipient: New submission for "$formTitle"',
    );
    // In a real app, this would call an API or Email Provider SDK
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> _executeWebhook(String? url, Map<String, dynamic> data) async {
    if (url == null || url.isEmpty) return;
    debugPrint('EXECUTING WEBHOOK to $url');
    try {
      if (_dio != null) {
        await _dio.post(url, data: data);
      } else {
        // Fallback or skip if dio not provided
        debugPrint('Webhook skipped: No Dio client provided to executor.');
      }
    } catch (e) {
      debugPrint('Webhook failed: ${ErrorHandler.handle(e)}');
    }
  }

  Future<void> _executeSlack(
    String formTitle,
    Map<String, dynamic> data,
  ) async {
    debugPrint('SIMULATING SLACK notification for "$formTitle"');
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
