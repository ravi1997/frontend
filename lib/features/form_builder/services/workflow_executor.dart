import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend/core/form_models.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../core/localization/locale_controller.dart';

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

    for (final entry in workflows.entries) {
      final config = entry.value as Map<String, dynamic>;
      if (config['enabled'] != true) continue;

      // Evaluate condition if present
      if (config.containsKey('condition')) {
        final condition = config['condition'] as Map<String, dynamic>;
        if (!_evaluateCondition(condition, responseData)) {
          debugPrint('Workflow ${entry.key} skipped: Condition not met.');
          continue;
        }
      }

      switch (entry.key) {
        case 'email_notification':
          await _executeEmail(
            config['recipient'],
            form.title.translate('en'),
            responseData,
          );
          break;
        case 'webhook':
          await _executeWebhook(config['url'], responseData);
          break;
        case 'slack_notification':
          await _executeSlack(form.title.translate('en'), responseData);
          break;
      }
    }
  }

  bool _evaluateCondition(
    Map<String, dynamic> condition,
    Map<String, dynamic> data,
  ) {
    final field = condition['field'] as String?;
    final operator = condition['operator'] as String?;
    final expectedValue = condition['value'];

    if (field == null || operator == null) return true;

    // Support both direct value and nested answer map
    final dynamic actualValue = data[field];

    debugPrint(
      'Evaluating condition: $field $operator $expectedValue (Actual: $actualValue)',
    );

    switch (operator) {
      case 'equals':
        final result = actualValue.toString() == expectedValue.toString();
        debugPrint('Result: $result');
        return result;
      case 'not_equals':
        return actualValue.toString() != expectedValue.toString();
      case 'contains':
        return actualValue.toString().contains(expectedValue.toString());
      case 'is_empty':
        return actualValue == null || actualValue.toString().isEmpty;
      case 'is_not_empty':
        return actualValue != null && actualValue.toString().isNotEmpty;
      default:
        return true;
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
