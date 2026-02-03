import 'package:logger/logger.dart';
import '../../domain/entities/condition_rule.dart';
import '../../domain/repositories/condition_repository.dart';
import '../../../../core/network/api_client_wrapper.dart';

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
      final response = await _apiClient.get('/forms/$formId/conditions');
      final data = response.data as List<dynamic>;

      final rules = data.map((item) {
        return ConditionalRule.fromJson(item as Map<String, dynamic>);
      }).toList();

      _logger.i('Loaded ${rules.length} rules for form: $formId');
      return rules;
    } catch (e, stack) {
      _logger.e('Failed to load rules: $e');
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
      final response = await _apiClient.get(
        '/forms/$formId/conditions?fieldId=$fieldId',
      );
      final data = response.data as List<dynamic>;

      final rules = data.map((item) {
        return ConditionalRule.fromJson(item as Map<String, dynamic>);
      }).toList();

      _logger.i('Loaded ${rules.length} rules for field: $fieldId');
      return rules;
    } catch (e, stack) {
      _logger.e('Failed to load rules for field: $e');
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
      final response = await _apiClient.get('/conditions/$ruleId');

      _logger.i('Loaded rule: $ruleId');
      return ConditionalRule.fromJson(response.data as Map<String, dynamic>);
    } catch (e, stack) {
      _logger.e('Failed to load rule: $e');
      throw _createException('Failed to load rule: $ruleId', e, stack);
    }
  }

  @override
  Future<ConditionalRule> createRule(ConditionalRule rule) async {
    try {
      final response = await _apiClient.post(
        '/forms/${rule.targetId.split('.')[0]}/conditions',
        data: rule.toJson(),
      );

      _logger.i('Created rule: ${rule.name}');
      return ConditionalRule.fromJson(response.data as Map<String, dynamic>);
    } catch (e, stack) {
      _logger.e('Failed to create rule: $e');
      throw _createException('Failed to create rule: ${rule.name}', e, stack);
    }
  }

  @override
  Future<ConditionalRule> updateRule(ConditionalRule rule) async {
    try {
      final response = await _apiClient.put(
        '/conditions/${rule.id}',
        data: rule.toJson(),
      );

      _logger.i('Updated rule: ${rule.name}');
      return ConditionalRule.fromJson(response.data as Map<String, dynamic>);
    } catch (e, stack) {
      _logger.e('Failed to update rule: $e');
      throw _createException('Failed to update rule: ${rule.name}', e, stack);
    }
  }

  @override
  Future<void> deleteRule(String ruleId) async {
    try {
      await _apiClient.delete('/conditions/$ruleId');
      _logger.i('Deleted rule: $ruleId');
    } catch (e, stack) {
      _logger.e('Failed to delete rule: $e');
      throw _createException('Failed to delete rule: $ruleId', e, stack);
    }
  }

  @override
  Future<void> reorderRules(String formId, List<String> ruleIds) async {
    try {
      await _apiClient.put(
        '/forms/$formId/conditions/reorder',
        data: {'ruleIds': ruleIds},
      );
      _logger.i('Reordered rules for form: $formId');
    } catch (e, stack) {
      _logger.e('Failed to reorder rules: $e');
      throw _createException('Failed to reorder rules', e, stack);
    }
  }

  @override
  Future<Map<String, bool>> evaluateRules(
    String formId,
    Map<String, dynamic> fieldValues,
  ) async {
    try {
      final response = await _apiClient.post(
        '/forms/$formId/conditions/evaluate',
        data: {'fieldValues': fieldValues},
      );

      final data = response.data as Map<String, dynamic>;
      final results = <String, bool>{};

      for (final entry in data.entries) {
        results[entry.key] = entry.value as bool;
      }

      return results;
    } catch (e, stack) {
      _logger.e('Failed to evaluate rules: $e');
      throw _createException('Failed to evaluate rules', e, stack);
    }
  }

  Exception _createException(String message, Object error, StackTrace stack) {
    return Exception('$message: $error');
  }
}
