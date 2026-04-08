import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/condition_rule.dart';
import '../../domain/entities/condition_enums.dart';
import '../../domain/repositories/condition_repository.dart';
import '../../../../core/controllers/base_controller_mixin.dart';

part 'condition_controller.g.dart';

/// Controller for managing conditional logic rules.
@riverpod
class ConditionController extends _$ConditionController
    with BaseControllerMixin {
  @override
  List<ConditionalRule> build() {
    return [];
  }

  /// Loads all rules for a form.
  Future<void> loadRules(String formId) async {
    await executeOperation(
      operation: () async {
        final repository = ref.read(conditionRepositoryProvider);
        final rules = await repository.getRules(formId);
        rules.sort((a, b) => a.priority.compareTo(b.priority));
        state = rules;
      },
    );
  }

  /// Gets rules for a specific field.
  Future<List<ConditionalRule>> getRulesForField(
    String formId,
    String fieldId,
  ) async {
    final repository = ref.read(conditionRepositoryProvider);
    return repository.getRulesForField(formId, fieldId);
  }

  /// Creates a new rule.
  Future<ConditionalRule> createRule({
    required String formId,
    required String name,
    required List<Condition> conditions,
    required LogicalOperator logicalOperator,
    required ConditionAction action,
    required String targetId,
    required ConditionTargetType targetType,
    String? description,
  }) async {
    final repository = ref.read(conditionRepositoryProvider);

    final rule = ConditionalRule(
      id: const Uuid().v4(),
      name: name,
      conditions: conditions,
      logicalOperator: logicalOperator,
      action: action,
      targetId: targetId,
      targetType: targetType,
      description: description,
      priority: state.length,
    );

    final created = await executeCreate(
      createOperation: () => repository.createRule(rule),
      entityName: 'condition rule',
    );

    if (created != null) {
      state = [...state, created];
      return created;
    }

    throw Exception('Failed to create condition rule');
  }

  /// Updates an existing rule.
  Future<void> updateRule(ConditionalRule rule) async {
    await executeUpdate(
      item: rule,
      updateOperation: (r) async {
        final repository = ref.read(conditionRepositoryProvider);
        final updated = await repository.updateRule(r);
        state = state.map((r) => r.id == updated.id ? updated : r).toList();
        return updated;
      },
      entityName: 'condition rule',
    );
  }

  /// Deletes a rule.
  Future<void> deleteRule(String ruleId) async {
    await executeDelete(
      id: ruleId,
      deleteOperation: (id) async {
        final repository = ref.read(conditionRepositoryProvider);
        await repository.deleteRule(id);
      },
      refreshAfterDelete: () async {
        state = state.where((r) => r.id != ruleId).toList();
        _reorderPriorities();
      },
      entityName: 'condition rule',
    );
  }

  /// Toggles rule enabled state.
  Future<void> toggleRule(String ruleId) async {
    final rule = state.firstWhere((r) => r.id == ruleId);
    final updated = rule.copyWith(isEnabled: !rule.isEnabled);
    await updateRule(updated);
  }

  /// Reorders rules by priority.
  Future<void> reorderRules(List<String> ruleIds) async {
    if (state.isEmpty) return;

    final formId = state.first.targetId.split('.').first;
    final updatedRules = <ConditionalRule>[];

    for (int i = 0; i < ruleIds.length; i++) {
      final rule = state.firstWhere((r) => r.id == ruleIds[i]);
      updatedRules.add(rule.copyWith(priority: i));
    }

    state = updatedRules;
    await ref.read(conditionRepositoryProvider).reorderRules(formId, ruleIds);
  }

  /// Evaluates all enabled rules against field values.
  Map<String, bool> evaluateAll(Map<String, dynamic> fieldValues) {
    final results = <String, bool>{};

    for (final rule in state.where((r) => r.isEnabled)) {
      results[rule.targetId] = rule.evaluate(fieldValues);
    }

    return results;
  }

  /// Gets rules that affect a specific target.
  List<ConditionalRule> getRulesAffecting(String targetId) {
    return state.where((r) => r.targetId == targetId).toList();
  }

  /// Gets all unique target IDs.
  List<String> getAllTargets() {
    return state.map((r) => r.targetId).toSet().toList();
  }

  /// Gets operators grouped by type for UI selection.
  static Map<String, List<ConditionOperator>> getOperatorsByCategory() {
    return {
      'Comparison': [ConditionOperator.equals, ConditionOperator.notEquals],
      'Text': [
        ConditionOperator.contains,
        ConditionOperator.notContains,
        ConditionOperator.isEmpty,
        ConditionOperator.isNotEmpty,
      ],
      'Number': [
        ConditionOperator.greaterThan,
        ConditionOperator.lessThan,
        ConditionOperator.greaterThanOrEquals,
        ConditionOperator.lessThanOrEquals,
      ],
      'Null/List': [
        ConditionOperator.isNull,
        ConditionOperator.isNotNull,
        ConditionOperator.inList,
        ConditionOperator.notInList,
      ],
    };
  }

  /// Gets actions for UI display.
  static List<ConditionAction> getAvailableActions() {
    return ConditionAction.values;
  }

  void _reorderPriorities() {
    final updated = <ConditionalRule>[];
    int priority = 0;
    for (final rule in state) {
      updated.add(rule.copyWith(priority: priority++));
    }
    state = updated;
  }
}
