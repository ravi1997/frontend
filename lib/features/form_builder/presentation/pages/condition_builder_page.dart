import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/condition_controller.dart';
import '../../domain/entities/condition_rule.dart';
import '../../domain/entities/condition_enums.dart';

/// Condition Builder Page.
///
/// Provides UI for creating and editing conditional logic rules.
class ConditionBuilderPage extends ConsumerStatefulWidget {
  final String formId;
  final List<String> availableFieldIds;
  final Map<String, String> fieldNames;

  const ConditionBuilderPage({
    super.key,
    required this.formId,
    required this.availableFieldIds,
    required this.fieldNames,
  });

  @override
  ConsumerState<ConditionBuilderPage> createState() =>
      _ConditionBuilderPageState();
}

class _ConditionBuilderPageState extends ConsumerState<ConditionBuilderPage> {
  final _ruleNameController = TextEditingController();
  final _valueController = TextEditingController();

  bool _isLoading = false;
  String? _selectedFieldId;
  ConditionOperator _selectedOperator = ConditionOperator.equals;
  ConditionAction _selectedAction = ConditionAction.show;
  LogicalOperator _selectedLogicalOperator = LogicalOperator.and;

  @override
  void initState() {
    super.initState();
    _loadRules();
  }

  Future<void> _loadRules() async {
    setState(() => _isLoading = true);
    try {
      await ref
          .read(conditionControllerProvider.notifier)
          .loadRules(widget.formId);
    } catch (e) {
      _showError('Failed to load rules: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _createRule() async {
    if (_ruleNameController.text.isEmpty) {
      _showError('Please enter a rule name');
      return;
    }
    if (_selectedFieldId == null) {
      _showError('Please select a field');
      return;
    }

    try {
      final condition = Condition(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        fieldId: _selectedFieldId!,
        fieldName: widget.fieldNames[_selectedFieldId] ?? _selectedFieldId!,
        operator: _selectedOperator,
        value: _valueController.text,
      );

      await ref
          .read(conditionControllerProvider.notifier)
          .createRule(
            formId: widget.formId,
            name: _ruleNameController.text,
            conditions: [condition],
            logicalOperator: _selectedLogicalOperator,
            action: _selectedAction,
            targetId: _selectedFieldId!,
            targetType: ConditionTargetType.field,
          );

      _clearForm();
      _showSuccess('Rule created successfully');
    } catch (e) {
      _showError('Failed to create rule: $e');
    }
  }

  Future<void> _deleteRule(String ruleId) async {
    try {
      await ref.read(conditionControllerProvider.notifier).deleteRule(ruleId);
      _showSuccess('Rule deleted');
    } catch (e) {
      _showError('Failed to delete rule: $e');
    }
  }

  Future<void> _toggleRule(String ruleId) async {
    try {
      await ref.read(conditionControllerProvider.notifier).toggleRule(ruleId);
    } catch (e) {
      _showError('Failed to toggle rule: $e');
    }
  }

  void _clearForm() {
    _ruleNameController.clear();
    _valueController.clear();
    _selectedFieldId = null;
    _selectedOperator = ConditionOperator.equals;
    _selectedAction = ConditionAction.show;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rules = ref.watch(conditionControllerProvider);
    final operatorsByCategory = ConditionController.getOperatorsByCategory();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Conditional Logic'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadRules),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRuleCreator(operatorsByCategory),
                  const SizedBox(height: 24),
                  _buildRulesList(rules),
                ],
              ),
            ),
    );
  }

  Widget _buildRuleCreator(Map<String, List<ConditionOperator>> operators) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create New Rule',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _ruleNameController,
              decoration: const InputDecoration(
                labelText: 'Rule Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedFieldId,
              decoration: const InputDecoration(
                labelText: 'Field to Watch',
                border: OutlineInputBorder(),
              ),
              items: widget.availableFieldIds.map((fieldId) {
                return DropdownMenuItem(
                  value: fieldId,
                  child: Text(widget.fieldNames[fieldId] ?? fieldId),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedFieldId = value);
              },
            ),
            const SizedBox(height: 16),
            _buildOperatorDropdown(operators),
            const SizedBox(height: 16),
            TextField(
              controller: _valueController,
              decoration: const InputDecoration(
                labelText: 'Value to Compare',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<ConditionAction>(
                    initialValue: _selectedAction,
                    decoration: const InputDecoration(
                      labelText: 'Action',
                      border: OutlineInputBorder(),
                    ),
                    items: ConditionAction.values.map((action) {
                      return DropdownMenuItem(
                        value: action,
                        child: Text(action.name.toUpperCase()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedAction = value!);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<LogicalOperator>(
                    initialValue: _selectedLogicalOperator,
                    decoration: const InputDecoration(
                      labelText: 'Logic',
                      border: OutlineInputBorder(),
                    ),
                    items: LogicalOperator.values.map((op) {
                      return DropdownMenuItem(
                        value: op,
                        child: Text(op.name.toUpperCase()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedLogicalOperator = value!);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _createRule,
                child: const Text('Create Rule'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOperatorDropdown(
    Map<String, List<ConditionOperator>> operators,
  ) {
    final allOperators = operators.values.expand((e) => e).toList();

    return DropdownButtonFormField<ConditionOperator>(
      initialValue: _selectedOperator,
      decoration: const InputDecoration(
        labelText: 'Operator',
        border: OutlineInputBorder(),
      ),
      items: [
        ...operators.entries.map((entry) {
          return DropdownMenuItem<ConditionOperator>(
            value: entry.value.first,
            enabled: false,
            child: Text(
              entry.key,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          );
        }),
        ...allOperators.map((op) {
          return DropdownMenuItem(
            value: op,
            child: Text(_getOperatorLabel(op)),
          );
        }),
      ],
      onChanged: (value) {
        if (value != null) {
          setState(() => _selectedOperator = value);
        }
      },
    );
  }

  String _getOperatorLabel(ConditionOperator op) {
    switch (op) {
      case ConditionOperator.equals:
        return 'Equals';
      case ConditionOperator.notEquals:
        return 'Not Equals';
      case ConditionOperator.contains:
        return 'Contains';
      case ConditionOperator.notContains:
        return 'Not Contains';
      case ConditionOperator.greaterThan:
        return 'Greater Than';
      case ConditionOperator.lessThan:
        return 'Less Than';
      case ConditionOperator.greaterThanOrEquals:
        return 'Greater Than or Equals';
      case ConditionOperator.lessThanOrEquals:
        return 'Less Than or Equals';
      case ConditionOperator.isEmpty:
        return 'Is Empty';
      case ConditionOperator.isNotEmpty:
        return 'Is Not Empty';
      case ConditionOperator.isNull:
        return 'Is Null';
      case ConditionOperator.isNotNull:
        return 'Is Not Null';
      case ConditionOperator.inList:
        return 'In List';
      case ConditionOperator.notInList:
        return 'Not In List';
    }
  }

  Widget _buildRulesList(List<ConditionalRule> rules) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Active Rules',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text('${rules.length} rules'),
              ],
            ),
            const SizedBox(height: 16),
            if (rules.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('No rules defined yet.'),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                itemCount: rules.length,
                itemBuilder: (context, index) {
                  final rule = rules[index];
                  return _buildRuleCard(rule);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRuleCard(ConditionalRule rule) {
    final condition = rule.conditions.firstOrNull;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: rule.isEnabled ? null : Colors.grey[200],
      child: ListTile(
        leading: Switch(
          value: rule.isEnabled,
          onChanged: (_) => _toggleRule(rule.id),
        ),
        title: Row(
          children: [
            Text(rule.name),
            const Spacer(),
            _buildActionChip(rule.action),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            if (condition != null) ...[
              Text(
                'IF "${condition.fieldName}" ${_getOperatorLabel(condition.operator)} "${condition.value}"',
                style: const TextStyle(fontSize: 13),
              ),
            ],
            const SizedBox(height: 4),
            Text(
              'Target: ${rule.targetId}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _deleteRule(rule.id),
        ),
      ),
    );
  }

  Widget _buildActionChip(ConditionAction action) {
    Color color;
    switch (action) {
      case ConditionAction.show:
        color = Colors.green;
        break;
      case ConditionAction.hide:
        color = Colors.orange;
        break;
      case ConditionAction.require:
        color = Colors.blue;
        break;
      case ConditionAction.optional:
        color = Colors.grey;
        break;
      case ConditionAction.disable:
        color = Colors.purple;
        break;
      case ConditionAction.enable:
        color = Colors.teal;
        break;
      case ConditionAction.setValue:
        color = Colors.amber;
        break;
      case ConditionAction.webhook:
        color = Colors.indigo;
        break;
      case ConditionAction.updateOptions:
        color = Colors.cyan;
        break;
    }

    return Chip(
      label: Text(
        action.name.toUpperCase(),
        style: const TextStyle(color: Colors.white, fontSize: 11),
      ),
      backgroundColor: color,
      padding: EdgeInsets.zero,
    );
  }

  @override
  void dispose() {
    _ruleNameController.dispose();
    _valueController.dispose();
    super.dispose();
  }
}
