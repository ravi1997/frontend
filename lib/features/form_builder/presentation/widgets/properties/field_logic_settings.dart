import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/form_builder/domain/entities/form_question.dart';
import 'package:frontend/features/form_builder/domain/entities/form_section.dart';
import 'package:frontend/features/form_builder/presentation/controllers/form_builder_controller.dart';
import 'package:frontend/core/localization/locale_controller.dart';
import '../logic_rule_dialog.dart';

class FieldLogicSettings extends ConsumerWidget {
  final String formId;
  final FormQuestion question;
  final List<FormSection> sections;

  const FieldLogicSettings({
    super.key,
    required this.formId,
    required this.question,
    required this.sections,
  });

  Map<String, dynamic> _getLogicState(FormQuestion question) {
    final logic = question.conditionalLogic ?? {};

    // Check for V2 structure
    if (logic['version'] == 2 && logic['rules'] is List) {
      return Map<String, dynamic>.from(logic);
    }

    // Convert V1 (or empty) to V2
    final v1Rules = (logic['rules'] as List? ?? [])
        .cast<Map<String, dynamic>>();

    if (v1Rules.isNotEmpty) {
      return {
        'version': 2,
        'rules': [
          {
            'action': 'show',
            'conditionGroup': {
              'matchType': logic['matchType'] ?? 'and',
              'rules': v1Rules,
            },
          },
        ],
      };
    }

    return {'version': 2, 'rules': []};
  }

  void _updateLogic(
    WidgetRef ref,
    FormQuestion question,
    Map<String, dynamic> newLogic,
  ) {
    ref
        .read(formBuilderControllerProvider(formId).notifier)
        .updateQuestion(question.copyWith(conditionalLogic: newLogic));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logicState = _getLogicState(question);
    final rules = (logicState['rules'] as List? ?? [])
        .cast<Map<String, dynamic>>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'CONDITIONAL LOGIC',
          style: TextStyle(
            color: AppColors.textGrey,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.borderLight,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(8),
            color: AppColors.builderElement,
          ),
          child: Column(
            children: [
              if (rules.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'Add logic to control visibility, validation, and requirements.',
                    style: TextStyle(color: AppColors.textGrey, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                )
              else
                Column(
                  children: rules.asMap().entries.map((entry) {
                    final index = entry.key;
                    final rule = entry.value;
                    final locale =
                        ref
                            .watch(formBuilderControllerProvider(formId))
                            .value
                            ?.editingLocale ??
                        'en';
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: _buildLogicRuleCard(
                        context,
                        ref,
                        rule,
                        index,
                        locale,
                      ),
                    );
                  }).toList(),
                ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => _showRuleDialog(context, ref),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Rule'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogicRuleCard(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> rule,
    int index,
    String locale,
  ) {
    final action = rule['action'] ?? 'show';
    final actionLabel = action.toString().toUpperCase().replaceAll('_', ' ');
    final conditionGroup =
        rule['conditionGroup'] as Map<String, dynamic>? ?? {};
    final conditions = (conditionGroup['rules'] as List? ?? []);

    Color color = AppColors.brandBlue;
    if (action == 'hide') color = Colors.orange;
    if (action == 'validate') color = Colors.red;
    if (action == 'require') color = Colors.purple;
    if (action == 'disable_option') color = Colors.grey;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  actionLabel,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () => _editRule(context, ref, index),
                    child: const Icon(
                      Icons.edit,
                      size: 16,
                      color: AppColors.textGrey,
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () => _deleteRule(ref, index),
                    child: const Icon(
                      Icons.delete_outline,
                      size: 16,
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (action == 'validate')
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                "Error: \"${rule['errorMessage'] ?? ''}\"",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.red,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          if (action == 'disable_option')
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                "Target: \"${rule['targetOption'] ?? ''}\"",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          Text(
            '${conditions.length} Condition(s)',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          ...conditions
              .map((c) {
                final triggerId = c['triggerId'];
                String triggerLabel = 'Unknown';
                for (final s in sections) {
                  for (final q in s.questions) {
                    if (q.id == triggerId) {
                      triggerLabel = q.label.translate(locale);
                      break;
                    }
                  }
                }
                final op = c['operator'] ?? 'equals';
                final val = c['value'] ?? '';
                final isUnary = op == 'is_empty' || op == 'is_not_empty';

                return Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    "• $triggerLabel $op ${isUnary ? '' : '"$val"'}".trim(),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textGrey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              })
              .take(3),
          if (conditions.length > 3)
            const Text(
              '...',
              style: TextStyle(fontSize: 10, color: AppColors.textGrey),
            ),
        ],
      ),
    );
  }

  void _editRule(BuildContext context, WidgetRef ref, int index) async {
    final state = ref.read(formBuilderControllerProvider(formId)).value;
    final locale = state?.editingLocale ?? 'en';
    final logicState = _getLogicState(question);
    final rules = (logicState['rules'] as List).cast<Map<String, dynamic>>();
    final ruleToEdit = rules[index];

    final updatedRule = await showDialog(
      context: context,
      builder: (_) => LogicRuleDialog(
        currentQuestion: question,
        sections: sections,
        initialRule: ruleToEdit,
        locale: locale,
      ),
    );

    if (updatedRule != null) {
      final newRules = List<Map<String, dynamic>>.from(rules);
      newRules[index] = updatedRule;
      _updateLogic(ref, question, {...logicState, 'rules': newRules});
    }
  }

  void _deleteRule(WidgetRef ref, int index) {
    final logicState = _getLogicState(question);
    final rules = (logicState['rules'] as List).cast<Map<String, dynamic>>();
    final newRules = List<Map<String, dynamic>>.from(rules);
    newRules.removeAt(index);
    _updateLogic(ref, question, {...logicState, 'rules': newRules});
  }

  void _showRuleDialog(BuildContext context, WidgetRef ref) async {
    final state = ref.read(formBuilderControllerProvider(formId)).value;
    final locale = state?.editingLocale ?? 'en';
    final resultRule = await showDialog(
      context: context,
      builder: (context) => LogicRuleDialog(
        currentQuestion: question,
        sections: sections,
        locale: locale,
      ),
    );

    if (resultRule != null) {
      final logicState = _getLogicState(question);
      final rules = (logicState['rules'] as List).cast<Map<String, dynamic>>();
      final newRules = List<Map<String, dynamic>>.from(rules)..add(resultRule);
      _updateLogic(ref, question, {...logicState, 'rules': newRules});
    }
  }
}
