import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/app/theme/app_colors.dart';
import 'package:frontend/app/theme/tokens.dart';
import 'package:frontend/shared/models/form_models.dart';
import 'package:frontend/modules/forms/services/form_builder_controller.dart';
import 'package:frontend/app/localization/locale_controller.dart';
import 'logic_rule_dialog.dart';

class FieldLogicSettings extends ConsumerWidget {
  final String projectId;
  final String formId;
  final FormQuestion question;
  final List<FormSection> sections;

  const FieldLogicSettings({
    super.key,
    required this.projectId,
    required this.formId,
    required this.question,
    required this.sections,
  });

  Map<String, dynamic> _getLogicState(FormQuestion question) {
    final logic = question.conditionalLogic ?? {};
    if (logic['version'] == 3) return Map<String, dynamic>.from(logic);

    // Auto-migrate to V3 smoothly
    final rules = (logic['rules'] as List? ?? []).cast<Map<String, dynamic>>();
    return {
      'version': 3,
      'rules': rules.map((r) {
        if (r.containsKey('conditionGroup')) return r;
        // Convert old flat rule to group
        return {
          'action': r['action'] ?? 'show',
          'conditionGroup': {
            'matchType': 'and',
            'rules': [r],
          },
        };
      }).toList(),
    };
  }

  void _updateLogic(WidgetRef ref, Map<String, dynamic> newLogic) {
    ref
        .read(formBuilderControllerProvider('$projectId::$formId').notifier)
        .updateQuestion(
          question.copyWith(
            logic: {
              ...question.logic ?? {},
              'conditional_logic': newLogic,
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logicState = _getLogicState(question);
    final rules = (logicState['rules'] as List? ?? [])
        .cast<Map<String, dynamic>>();
    final locale =
        ref
            .watch(formBuilderControllerProvider('$projectId::$formId'))
            .value
            ?.editingLocale ??
        'en';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'FIELD LOGIC CONTROLS',
          style: TextStyle(
            color: AppColors.textGrey,
            fontSize: DesignTokens.fontS,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: DesignTokens.spaceM),
        Container(
          padding: const EdgeInsets.all(DesignTokens.spaceL),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderLight),
            borderRadius: BorderRadius.circular(DesignTokens.radiusS),
            color: AppColors.builderElement,
          ),
          child: Column(
            children: [
              if (rules.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: DesignTokens.spaceL),
                  child: Text(
                    'No logic rules applied to this field.',
                    style: TextStyle(
                      color: AppColors.textGrey,
                      fontSize: DesignTokens.fontS,
                    ),
                  ),
                )
              else
                ...rules.asMap().entries.map(
                  (entry) => _buildLogicSummary(
                    context,
                    ref,
                    entry.value,
                    entry.key,
                    locale,
                  ),
                ),
              const SizedBox(height: DesignTokens.spaceM),
              ElevatedButton.icon(
                onPressed: () async {
                  final state = ref
                      .read(formBuilderControllerProvider('$projectId::$formId'))
                      .value;
                  final locale = state?.editingLocale ?? 'en';

                  final result = await showDialog<Map<String, dynamic>>(
                    context: context,
                    builder: (context) => LogicRuleDialog(
                      question: question,
                      sections: sections,
                      initialRule: null,
                      locale: locale,
                    ),
                  );

                  if (result != null) {
                    final logicState = _getLogicState(question);
                    final newRules = List<Map<String, dynamic>>.from(
                      logicState['rules'],
                    );
                    newRules.add(result);
                    _updateLogic(ref, {...logicState, 'rules': newRules});
                  }
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Logical Action'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  minimumSize: const Size(double.infinity, 44),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogicSummary(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> rule,
    int index,
    String locale,
  ) {
    final action = rule['action'] ?? 'show';
    final conditions = (rule['conditionGroup']?['rules'] as List? ?? []);

    Color actionColor = AppColors.brandBlue;
    IconData icon = Icons.visibility;

    if (action == 'hide') {
      actionColor = Colors.orange;
      icon = Icons.visibility_off;
    }
    if (action == 'validate') {
      actionColor = Colors.red;
      icon = Icons.error_outline;
    }
    if (action == 'set_value') {
      actionColor = Colors.green;
      icon = Icons.edit;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: actionColor),
              const SizedBox(width: DesignTokens.spaceS),
              Text(
                action.toString().toUpperCase().replaceAll('_', ' '),
                style: TextStyle(
                  color: actionColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.edit, size: 14),
                onPressed: () async {
                  final state = ref
                      .read(formBuilderControllerProvider('$projectId::$formId'))
                      .value;
                  final locale = state?.editingLocale ?? 'en';

                  final result = await showDialog<Map<String, dynamic>>(
                    context: context,
                    builder: (context) => LogicRuleDialog(
                      question: question,
                      sections: sections,
                      initialRule: rule,
                      locale: locale,
                    ),
                  );

                  if (result != null) {
                    final logicState = _getLogicState(question);
                    final newRules = List<Map<String, dynamic>>.from(
                      logicState['rules'],
                    );
                    newRules[index] = result;
                    _updateLogic(ref, {...logicState, 'rules': newRules});
                  }
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  size: 14,
                  color: Colors.red,
                ),
                onPressed: () {
                  final state = _getLogicState(question);
                  final newRules = List<Map<String, dynamic>>.from(
                    state['rules'],
                  )..removeAt(index);
                  _updateLogic(ref, {...state, 'rules': newRules});
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spaceS),
          Text(
            'If ${conditions.length} condition(s) are met:',
            style: const TextStyle(
              fontSize: DesignTokens.fontS,
              fontWeight: FontWeight.w600,
            ),
          ),
          ...conditions.take(2).map((c) {
            return Text(
              '• ${c['triggerId'] != null ? _getFieldLabel(c['triggerId'], locale) : 'Unknown'} ${c['operator']} "${c['value']}"',
              style: const TextStyle(
                fontSize: DesignTokens.fontXS,
                color: AppColors.textGrey,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            );
          }),
          if (conditions.length > 2)
            const Text('...', style: TextStyle(fontSize: DesignTokens.fontXS)),
        ],
      ),
    );
  }

  String _getFieldLabel(String id, String locale) {
    for (final s in sections) {
      for (final q in s.questions) {
        if (q.id == id) {
          final varName = q.variableName?.isNotEmpty == true
              ? q.variableName
              : q.id;
          return '${q.label.translate(locale)} ($varName)';
        }
      }
    }
    return id;
  }

}
