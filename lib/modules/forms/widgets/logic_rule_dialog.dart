import 'package:flutter/material.dart';
import 'package:frontend/app/theme/tokens.dart';
import 'package:frontend/shared/models/form_models.dart';

class LogicRuleDialog extends StatefulWidget {
  final FormQuestion question;
  final List<FormSection> sections;
  final Map<String, dynamic>? initialRule;
  final String locale;
  final List<String>? allowedActions;

  const LogicRuleDialog({
    super.key,
    required this.question,
    required this.sections,
    this.initialRule,
    required this.locale,
    this.allowedActions,
  });

  @override
  State<LogicRuleDialog> createState() => _LogicRuleDialogState();
}

class _LogicRuleDialogState extends State<LogicRuleDialog> {
  late String _action;
  late String _matchType;
  late List<Map<String, dynamic>> _conditions;

  static const _operators = <String>[
    'equals',
    'not_equals',
    'contains',
    'not_contains',
    'is_empty',
    'is_not_empty',
    'greater_than',
    'less_than',
  ];

  @override
  void initState() {
    super.initState();
    final rule = widget.initialRule ?? const {};
    _action = _normalizeAction(rule['action']?.toString() ?? 'show');
    final group = Map<String, dynamic>.from(rule['conditionGroup'] ?? const {});
    _matchType = group['matchType']?.toString() == 'or' ? 'or' : 'and';
    _conditions = (group['rules'] as List? ?? const [])
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
    if (_conditions.isEmpty) {
      _conditions = [
        {
          'triggerId': _questionOptions.firstOrNull?.id ?? widget.question.id,
          'operator': 'equals',
          'value': '',
        },
      ];
    }
  }

  String _normalizeAction(String action) {
    final allowed = widget.allowedActions;
    if (allowed == null || allowed.contains(action)) return action;
    return allowed.firstOrNull ?? 'show';
  }

  List<_QuestionOption> get _questionOptions {
    final questions = <_QuestionOption>[];
    for (final section in widget.sections) {
      for (final question in section.questions) {
        final varName = question.variableName?.isNotEmpty == true
            ? question.variableName!
            : question.id;
        questions.add(
          _QuestionOption(
            id: question.id,
            label: '${question.label} ($varName)',
          ),
        );
      }
      for (final nested in section.sections) {
        questions.addAll(_flattenQuestions(nested));
      }
    }
    return questions;
  }

  FormQuestion? _questionById(String id) {
    for (final section in widget.sections) {
      final found = _findQuestionInSection(section, id);
      if (found != null) return found;
    }
    return null;
  }

  FormQuestion? _findQuestionInSection(FormSection section, String id) {
    for (final question in section.questions) {
      if (question.id == id) return question;
    }
    for (final nested in section.sections) {
      final found = _findQuestionInSection(nested, id);
      if (found != null) return found;
    }
    return null;
  }

  List<_QuestionOption> _flattenQuestions(FormSection section) {
    final questions = <_QuestionOption>[];
    for (final question in section.questions) {
      final varName = question.variableName?.isNotEmpty == true
          ? question.variableName!
          : question.id;
      questions.add(
        _QuestionOption(id: question.id, label: '${question.label} ($varName)'),
      );
    }
    for (final nested in section.sections) {
      questions.addAll(_flattenQuestions(nested));
    }
    return questions;
  }

  void _addCondition() {
    setState(() {
      _conditions.add({
        'triggerId': _questionOptions.firstOrNull?.id ?? widget.question.id,
        'operator': 'equals',
        'value': '',
      });
    });
  }

  void _save() {
    Navigator.pop(context, {
      'targetId': widget.question.id,
      'action': _action,
      'conditionGroup': {'matchType': _matchType, 'rules': _conditions},
      'version': 3,
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final targetQuestion =
        _questionById(
          (widget.initialRule?['targetId'] ?? widget.question.id).toString(),
        ) ??
        widget.question;
    return Dialog(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 640,
          maxHeight: MediaQuery.sizeOf(context).height * 0.8,
        ),
        padding: const EdgeInsets.all(DesignTokens.spaceL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Logic Rules',
              style: TextStyle(
                fontSize: DesignTokens.fontL,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: DesignTokens.spaceL),
            Text(
              'Logic rules configuration for: ${targetQuestion.label}',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
              ),
            ),
            const SizedBox(height: DesignTokens.spaceM),
            DropdownButtonFormField<String>(
              key: ValueKey('action:$_action'),
              initialValue: _action,
              decoration: const InputDecoration(
                labelText: 'Action',
                border: OutlineInputBorder(),
              ),
              items: (widget.allowedActions ?? const ['show', 'hide'])
                  .map(
                    (action) => DropdownMenuItem(
                      value: action,
                      child: Text(action.toUpperCase()),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() => _action = value);
              },
            ),
            const SizedBox(height: DesignTokens.spaceM),
            DropdownButtonFormField<String>(
              key: ValueKey('match:$_matchType'),
              initialValue: _matchType,
              decoration: const InputDecoration(
                labelText: 'Match type',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'and', child: Text('ALL of')),
                DropdownMenuItem(value: 'or', child: Text('ANY of')),
              ],
              onChanged: (value) {
                if (value == null) return;
                setState(() => _matchType = value);
              },
            ),
            const SizedBox(height: DesignTokens.spaceM),
            Expanded(
              child: ListView.separated(
                itemCount: _conditions.length + 1,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  if (index == _conditions.length) {
                    return TextButton.icon(
                      onPressed: _addCondition,
                      icon: const Icon(Icons.add),
                      label: const Text('Add condition'),
                    );
                  }
                  final condition = _conditions[index];
                  final currentTrigger =
                      condition['triggerId']?.toString() ??
                      _questionOptions.firstOrNull?.id ??
                      widget.question.id;
                  final currentOperator =
                      condition['operator']?.toString() ?? 'equals';
                  final currentValue = condition['value']?.toString() ?? '';
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.dividerColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                key: ValueKey('trigger:$index:$currentTrigger'),
                                initialValue: currentTrigger,
                                decoration: const InputDecoration(
                                  labelText: 'Trigger question',
                                  border: OutlineInputBorder(),
                                ),
                                items: _questionOptions
                                    .map(
                                      (q) => DropdownMenuItem(
                                        value: q.id,
                                        child: Text(q.label),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  if (value == null) return;
                                  setState(() {
                                    condition['triggerId'] = value;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                key: ValueKey(
                                  'operator:$index:$currentOperator',
                                ),
                                initialValue: currentOperator,
                                decoration: const InputDecoration(
                                  labelText: 'Operator',
                                  border: OutlineInputBorder(),
                                ),
                                items: _operators
                                    .map(
                                      (operator) => DropdownMenuItem(
                                        value: operator,
                                        child: Text(operator),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  if (value == null) return;
                                  setState(() {
                                    condition['operator'] = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                initialValue: currentValue,
                                decoration: const InputDecoration(
                                  labelText: 'Value',
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  condition['value'] = value;
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: _conditions.length == 1
                                  ? null
                                  : () {
                                      setState(() {
                                        _conditions.removeAt(index);
                                      });
                                    },
                              icon: const Icon(Icons.delete_outline),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: DesignTokens.spaceM),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _save, child: const Text('Save')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestionOption {
  final String id;
  final String label;

  const _QuestionOption({required this.id, required this.label});
}
