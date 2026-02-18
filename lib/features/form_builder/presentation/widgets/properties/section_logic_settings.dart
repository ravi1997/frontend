import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/form_builder/domain/entities/form_section.dart';
import 'package:frontend/features/form_builder/presentation/controllers/form_builder_controller.dart';
import '../logic_rule_dialog.dart';
import 'property_builder_utils.dart';

class SectionLogicSettings extends ConsumerWidget {
  final String formId;
  final FormSection section;
  final List<FormSection> allSections;

  const SectionLogicSettings({
    super.key,
    required this.formId,
    required this.section,
    required this.allSections,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logic = section.conditionalLogic ?? {'version': 3, 'rules': []};
    final rules = (logic['rules'] as List? ?? []).cast<Map<String, dynamic>>();
    final locale =
        ref.watch(formBuilderControllerProvider(formId)).value?.editingLocale ??
        'en';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SECTION FLOW & VISIBILITY',
          style: TextStyle(
            color: AppColors.textGrey,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderLight),
            borderRadius: BorderRadius.circular(8),
            color: AppColors.builderElement,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (rules.isEmpty) ...[
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'This section is always visible and follows standard flow.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textGrey, fontSize: 13),
                    ),
                  ),
                ),
              ] else
                ...rules.asMap().entries.map(
                  (e) => _buildRuleItem(context, ref, e.value, e.key, locale),
                ),

              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => _showRuleDialog(context, ref),
                icon: const Icon(Icons.add_road, size: 18),
                label: const Text('Add Show/Jump Logic'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 44),
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        PropertyBuilderUtils.buildSwitch(
          label: 'Disable Section when hidden',
          value: section.metadata['disableWhenHidden'] ?? true,
          onChanged: (val) {
            ref
                .read(formBuilderControllerProvider(formId).notifier)
                .updateSectionMetadata(section.id, {'disableWhenHidden': val});
          },
        ),
      ],
    );
  }

  Widget _buildRuleItem(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> rule,
    int index,
    String locale,
  ) {
    final action = rule['action'] ?? 'show';
    final conditions = (rule['conditionGroup']?['rules'] as List? ?? []);

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
              _getActionBadge(action),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.edit, size: 14),
                onPressed: () => _showRuleDialog(
                  context,
                  ref,
                  initialRule: rule,
                  index: index,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  size: 14,
                  color: Colors.red,
                ),
                onPressed: () => _deleteRule(ref, index),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Conditions: match ${rule['conditionGroup']?['matchType'] ?? 'all'}',
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
          ...conditions
              .take(2)
              .map(
                (c) => Text(
                  '• ${c['triggerId'] ?? 'Field'} ${c['operator']} ${c['value']}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textGrey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
        ],
      ),
    );
  }

  Widget _getActionBadge(String action) {
    Color color = AppColors.brandBlue;
    if (action == 'jump_to_section') color = Colors.purple;
    if (action == 'end_form') color = Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        action.toUpperCase().replaceAll('_', ' '),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showRuleDialog(
    BuildContext context,
    WidgetRef ref, {
    Map<String, dynamic>? initialRule,
    int? index,
  }) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => LogicRuleDialog(
        currentSection: section,
        sections: allSections,
        initialRule: initialRule,
        locale:
            ref
                .read(formBuilderControllerProvider(formId))
                .value
                ?.editingLocale ??
            'en',
      ),
    );

    if (result != null) {
      final logic = section.conditionalLogic ?? {'version': 3, 'rules': []};
      final newRules = List<Map<String, dynamic>>.from(logic['rules'] ?? []);
      if (index != null) {
        newRules[index] = result;
      } else {
        newRules.add(result);
      }

      ref
          .read(formBuilderControllerProvider(formId).notifier)
          .updateSection(
            section.copyWith(conditionalLogic: {...logic, 'rules': newRules}),
          );
    }
  }

  void _deleteRule(WidgetRef ref, int index) {
    final logic = section.conditionalLogic ?? {'version': 3, 'rules': []};
    final newRules = List<Map<String, dynamic>>.from(logic['rules'] ?? [])
      ..removeAt(index);
    ref
        .read(formBuilderControllerProvider(formId).notifier)
        .updateSection(
          section.copyWith(conditionalLogic: {...logic, 'rules': newRules}),
        );
  }
}
