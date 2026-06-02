import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:frontend/features/form_builder/models/condition_enums.dart';
import 'package:frontend/features/form_builder/models/condition_rule.dart';
import 'package:frontend/features/form_builder/services/condition_repository.dart';

class ConditionController extends ChangeNotifier {
  ConditionController(this.ref);

  final Ref ref;
  List<ConditionalRule> _state = const [];

  List<ConditionalRule> get state => _state;

  set state(List<ConditionalRule> value) {
    _state = value;
    notifyListeners();
  }

  Future<void> loadRules(String formId) async {
    final repository = ref.read(conditionRepositoryProvider);
    final rules = await repository.getRules(formId);
    rules.sort((a, b) => a.priority.compareTo(b.priority));
    state = rules;
  }

  Future<List<ConditionalRule>> getRulesForField(
    String formId,
    String fieldId,
  ) async {
    final repository = ref.read(conditionRepositoryProvider);
    return repository.getRulesForField(formId, fieldId);
  }

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

    final created = await repository.createRule(rule);
    state = [...state, created];
    return created;
  }

  Future<void> updateRule(ConditionalRule rule) async {
    final repository = ref.read(conditionRepositoryProvider);
    final updated = await repository.updateRule(rule);
    state = state.map((item) => item.id == updated.id ? updated : item).toList();
  }

  Future<void> deleteRule(String ruleId) async {
    final repository = ref.read(conditionRepositoryProvider);
    await repository.deleteRule(ruleId);
    state = state.where((r) => r.id != ruleId).toList();
    _reorderPriorities();
  }

  Future<void> toggleRule(String ruleId) async {
    final rule = state.firstWhere((r) => r.id == ruleId);
    await updateRule(rule.copyWith(isEnabled: !rule.isEnabled));
  }

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

  Map<String, bool> evaluateAll(Map<String, dynamic> fieldValues) {
    final results = <String, bool>{};
    for (final rule in state.where((r) => r.isEnabled)) {
      results[rule.targetId] = rule.evaluate(fieldValues);
    }
    return results;
  }

  List<ConditionalRule> getRulesAffecting(String targetId) {
    return state.where((r) => r.targetId == targetId).toList();
  }

  List<String> getAllTargets() {
    return state.map((r) => r.targetId).toSet().toList();
  }

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

  static List<ConditionAction> getAvailableActions() => ConditionAction.values;

  void _reorderPriorities() {
    final updated = <ConditionalRule>[];
    var priority = 0;
    for (final rule in state) {
      updated.add(rule.copyWith(priority: priority++));
    }
    state = updated;
  }
}

final conditionControllerProvider = Provider<ConditionController>((ref) {
  final controller = ConditionController(ref);
  ref.onDispose(controller.dispose);
  return controller;
});
