import 'package:frontend/modules/forms/models/condition_rule.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/modules/forms/data/repositories/condition_repository_impl.dart';
import 'package:frontend/core/networking/api_client_wrapper.dart';

/// Repository interface for conditional rule operations.
///
/// Handles CRUD operations for conditional logic rules associated with forms.
abstract class ConditionRepository {
  /// Gets all rules for a form.
  Future<List<ConditionalRule>> getRules(String formId);

  /// Gets rules for a specific field.
  Future<List<ConditionalRule>> getRulesForField(String formId, String fieldId);

  /// Gets a rule by ID.
  Future<ConditionalRule> getRule(String ruleId);

  /// Creates a new rule.
  Future<ConditionalRule> createRule(ConditionalRule rule);

  /// Updates an existing rule.
  Future<ConditionalRule> updateRule(ConditionalRule rule);

  /// Deletes a rule.
  Future<void> deleteRule(String ruleId);

  /// Reorders rules by priority.
  Future<void> reorderRules(String formId, List<String> ruleIds);

  /// Evaluates all rules for a form against given field values.
  Future<Map<String, bool>> evaluateRules(
    String formId,
    Map<String, dynamic> fieldValues,
  );
}

final conditionRepositoryProvider = Provider<ConditionRepository>((ref) {
  // Use real implementation
  final apiClient = ref.watch(apiClientProvider);
  return ConditionRepositoryImpl(apiClient);
});
