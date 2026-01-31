import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/form_builder/domain/entities/form_section.dart';
import 'package:frontend/features/form_builder/presentation/controllers/form_builder_controller.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'CONDITIONAL VISIBILITY',
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
            children: [
              _buildLogicList(ref),
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

  Widget _buildLogicList(WidgetRef ref) {
    final logic = section.conditionalLogic ?? {'matchType': 'and', 'rules': []};
    final rules = (logic['rules'] as List? ?? []).cast<Map<String, dynamic>>();

    if (rules.isEmpty) {
      return const Text(
        'This section is always visible.',
        style: TextStyle(color: AppColors.textGrey, fontSize: 13),
      );
    }

    return Column(
      children: rules.asMap().entries.map((entry) {
        final index = entry.key;
        final rule = entry.value;
        return _buildRuleItem(ref, rule, index);
      }).toList(),
    );
  }

  Widget _buildRuleItem(WidgetRef ref, Map<String, dynamic> rule, int index) {
    // Basic representation
    return ListTile(
      title: Text(
        'Rule ${index + 1}',
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        'If ${rule['triggerId']} ${rule['condition']} ${rule['value']}',
        style: const TextStyle(fontSize: 12),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
        onPressed: () {
          final newRules = List<Map<String, dynamic>>.from(
            section.conditionalLogic?['rules'] ?? [],
          );
          newRules.removeAt(index);
          ref
              .read(formBuilderControllerProvider(formId).notifier)
              .updateSection(
                section.copyWith(
                  conditionalLogic: {
                    ...section.conditionalLogic ?? {},
                    'rules': newRules,
                  },
                ),
              );
        },
      ),
    );
  }

  void _showRuleDialog(BuildContext context, WidgetRef ref) {
    // Reusing logic would be better but for now let's just make it a placeholder
    // In a real app we'd want a shared LogicRuleDialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Visibility Rule'),
        content: const Text(
          'Please use the field logic settings for more granular control. Section logic is managed via rules.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
