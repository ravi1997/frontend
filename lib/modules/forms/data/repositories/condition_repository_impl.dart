import 'package:logger/logger.dart';
import 'package:frontend/core/networking/api_client.dart';
import 'package:frontend/modules/forms/models/condition_rule.dart';
import 'package:frontend/modules/forms/services/condition_repository.dart';

/// Implementation of [ConditionRepository] for conditional rule operations.
///
/// Handles CRUD operations for conditional logic rules via the backend API.
class ConditionRepositoryImpl implements ConditionRepository {
  final ApiClient _apiClient;
  final Logger _logger = Logger();

  ConditionRepositoryImpl(this._apiClient);

  @override
  Future<List<ConditionalRule>> getRules(String formId) async {
    try {
      final data = await _apiClient.getRules(formId);

      final rules = data.map((item) {
        return ConditionalRule.fromJson(item as Map<String, dynamic>);
      }).toList();

      _logger.i('Loaded ${rules.length} rules for form: $formId');
      return rules;
    } catch (e, stack) {
      _logger.e('Failed to load rules', error: e, stackTrace: stack);
      throw _createException(
        'Failed to load rules for form: $formId',
        e,
        stack,
      );
    }
  }

  @override
  Future<List<ConditionalRule>> getRulesForField(
    String formId,
    String fieldId,
  ) async {
    try {
      final data = await _apiClient.getRulesForField(formId, fieldId);

      final rules = data.map((item) {
        return ConditionalRule.fromJson(item as Map<String, dynamic>);
      }).toList();

      _logger.i('Loaded ${rules.length} rules for field: $fieldId');
      return rules;
    } catch (e, stack) {
      _logger.e('Failed to load rules for field', error: e, stackTrace: stack);
      throw _createException(
        'Failed to load rules for field: $fieldId',
        e,
        stack,
      );
    }
  }

  @override
  Future<ConditionalRule> getRule(String ruleId) async {
    try {
      final response = await _apiClient.getRule(ruleId);
      _logger.i('Loaded rule: $ruleId');
      return ConditionalRule.fromJson(response);
    } catch (e, stack) {
      _logger.e('Failed to load rule', error: e, stackTrace: stack);
      throw _createException('Failed to load rule: $ruleId', e, stack);
    }
  }

  @override
  Future<ConditionalRule> createRule(ConditionalRule rule) async {
    try {
      final response = await _apiClient.createRule(rule);
      _logger.i('Created rule: ${rule.name}');
      return ConditionalRule.fromJson(response);
    } catch (e, stack) {
      _logger.e('Failed to create rule', error: e, stackTrace: stack);
      throw _createException('Failed to create rule: ${rule.name}', e, stack);
    }
  }

  @override
  Future<ConditionalRule> updateRule(ConditionalRule rule) async {
    try {
      final response = await _apiClient.updateRule(rule);
      _logger.i('Updated rule: ${rule.name}');
      return ConditionalRule.fromJson(response);
    } catch (e, stack) {
      _logger.e('Failed to update rule', error: e, stackTrace: stack);
      throw _createException('Failed to update rule: ${rule.name}', e, stack);
    }
  }

  @override
  Future<void> deleteRule(String ruleId) async {
    try {
      await _apiClient.deleteRule(ruleId);
      _logger.i('Deleted rule: $ruleId');
    } catch (e, stack) {
      _logger.e('Failed to delete rule', error: e, stackTrace: stack);
      throw _createException('Failed to delete rule: $ruleId', e, stack);
    }
  }

  @override
  Future<void> reorderRules(String formId, List<String> ruleIds) async {
    try {
      await _apiClient.reorderRules(formId, ruleIds);
      _logger.i('Reordered rules for form: $formId');
    } catch (e, stack) {
      _logger.e('Failed to reorder rules', error: e, stackTrace: stack);
      throw _createException('Failed to reorder rules', e, stack);
    }
  }

  @override
  Future<Map<String, bool>> evaluateRules(
    String formId,
    Map<String, dynamic> fieldValues,
  ) async {
    try {
      final data = await _apiClient.evaluateRules(formId, fieldValues);
      final results = <String, bool>{};

      for (final entry in data.entries) {
        results[entry.key] = entry.value;
      }

      return results;
    } catch (e, stack) {
      _logger.e('Failed to evaluate rules', error: e, stackTrace: stack);
      throw _createException('Failed to evaluate rules', e, stack);
    }
  }

  Exception _createException(String message, Object error, StackTrace stack) {
    return Exception('$message: $error');
  }
}
