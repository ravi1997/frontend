import 'package:flutter/material.dart';
import 'package:frontend/app/theme/app_colors.dart';
import 'package:frontend/shared/models/form_models.dart';

import 'logic_rule_dialog.dart';

class SectionLogicSettings extends StatelessWidget {
  final Map<String, dynamic> section;
  final List<FormSection> sections;
  final String locale;
  final Function(Map<String, dynamic>) onChanged;

  const SectionLogicSettings({
    super.key,
    required this.section,
    required this.sections,
    required this.locale,
    required this.onChanged,
  });

  Map<String, dynamic> _getLogicState() {
    final logic = section['conditional_logic'];
    if (logic is Map && logic['version'] == 3) {
      return Map<String, dynamic>.from(logic);
    }

    final rules = logic is Map
        ? (logic['rules'] as List? ?? const [])
        : const [];
    return {
      'version': 3,
      'rules': rules.whereType<Map>().map((rule) {
        final mapped = Map<String, dynamic>.from(rule);
        if (mapped.containsKey('conditionGroup')) return mapped;
        return {
          'action': mapped['action'] ?? 'show',
          'conditionGroup': {
            'matchType': 'and',
            'rules': [mapped],
          },
        };
      }).toList(),
    };
  }

  void _updateLogic(Map<String, dynamic> logic) {
    onChanged({...section, 'conditional_logic': logic});
  }

  FormQuestion? _firstQuestion() {
    for (final section in sections) {
      if (section.questions.isNotEmpty) return section.questions.first;
      for (final nested in section.sections) {
        final found = _firstQuestionInSection(nested);
        if (found != null) return found;
      }
    }
    return null;
  }

  FormQuestion? _firstQuestionInSection(FormSection section) {
    if (section.questions.isNotEmpty) return section.questions.first;
    for (final nested in section.sections) {
      final found = _firstQuestionInSection(nested);
      if (found != null) return found;
    }
    return null;
  }

  FormQuestion? _questionById(String id) {
    for (final section in sections) {
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final logicState = _getLogicState();
    final rules = (logicState['rules'] as List? ?? const [])
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Logic Settings', style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),
        Text(
          'Use rules to show or hide this section based on answers elsewhere in the form.',
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.dividerColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (rules.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'No logic rules defined yet.',
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Add a rule to show or hide this section based on answers elsewhere in the form.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.72,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                ...rules.asMap().entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _LogicSummaryCard(
                      rule: entry.value,
                      index: entry.key,
                      locale: locale,
                      sections: sections,
                      onEdit: () async {
                        final targetId = entry.value['targetId']?.toString();
                        final result = await showDialog<Map<String, dynamic>>(
                          context: context,
                          builder: (context) => LogicRuleDialog(
                            question: targetId != null
                                ? _questionById(targetId) ?? _firstQuestion()!
                                : _firstQuestion()!,
                            sections: sections,
                            initialRule: entry.value,
                            locale: locale,
                            allowedActions: const ['show', 'hide'],
                          ),
                        );
                        if (result == null) return;
                        final newRules = List<Map<String, dynamic>>.from(rules);
                        result['targetId'] ??= targetId ?? _firstQuestion()?.id;
                        newRules[entry.key] = result;
                        _updateLogic({...logicState, 'rules': newRules});
                      },
                      onDelete: () {
                        final newRules = List<Map<String, dynamic>>.from(rules)
                          ..removeAt(entry.key);
                        _updateLogic({...logicState, 'rules': newRules});
                      },
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _firstQuestion() == null
                    ? null
                    : () async {
                        final result = await showDialog<Map<String, dynamic>>(
                          context: context,
                          builder: (context) => LogicRuleDialog(
                            question: _firstQuestion()!,
                            sections: sections,
                            locale: locale,
                            allowedActions: const ['show', 'hide'],
                          ),
                        );
                        if (result == null) return;
                        final newRules = List<Map<String, dynamic>>.from(rules)
                          ..add(result);
                        _updateLogic({...logicState, 'rules': newRules});
                      },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add rule'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 44),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LogicSummaryCard extends StatelessWidget {
  final Map<String, dynamic> rule;
  final int index;
  final String locale;
  final List<FormSection> sections;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _LogicSummaryCard({
    required this.rule,
    required this.index,
    required this.locale,
    required this.sections,
    required this.onEdit,
    required this.onDelete,
  });

  String _getFieldLabel(String id) {
    for (final section in sections) {
      final found = _findInSection(section, id);
      if (found != null) return found;
    }
    return id;
  }

  String? _findInSection(FormSection section, String id) {
    for (final question in section.questions) {
      if (question.id == id) {
        final varName = question.variableName?.isNotEmpty == true
            ? question.variableName!
            : question.id;
        return '${question.label} ($varName)';
      }
    }
    for (final nested in section.sections) {
      final found = _findInSection(nested, id);
      if (found != null) return found;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final action = rule['action']?.toString() ?? 'show';
    final conditions =
        ((rule['conditionGroup'] as Map?)?['rules'] as List? ?? const [])
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();

    final color = action == 'hide' ? Colors.orange : AppColors.brandBlue;
    final icon = action == 'hide' ? Icons.visibility_off : Icons.visibility;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 8),
              Text(
                action.toUpperCase(),
                style: TextStyle(color: color, fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.edit, size: 16),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline, size: 16),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'If ${conditions.length} condition(s) are met:',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          ...conditions
              .take(2)
              .map(
                (condition) => Text(
                  '• ${_getFieldLabel(condition['triggerId']?.toString() ?? '')} ${condition['operator'] ?? ''} ${condition['value'] ?? ''}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall,
                ),
              ),
          if (conditions.length > 2)
            Text('...', style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
