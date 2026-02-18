import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/form_builder/domain/entities/builder_form.dart';
import 'package:frontend/features/form_builder/presentation/controllers/form_builder_controller.dart';
import '../logic_rule_dialog.dart';

class FormLogicSettings extends ConsumerWidget {
  final String formId;
  final BuilderForm form;

  const FormLogicSettings({
    super.key,
    required this.formId,
    required this.form,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = form.metadata['logicSettings'] ?? {'rules': []};
    final rules = (settings['rules'] as List? ?? [])
        .cast<Map<String, dynamic>>();
    final locale =
        ref.watch(formBuilderControllerProvider(formId)).value?.editingLocale ??
        'en';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'GLOBAL INTELLIGENT ROUTING',
          style: TextStyle(
            color: AppColors.textGrey,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 16),
        _buildAetherisPromo(),
        const SizedBox(height: 24),
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
              if (rules.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 30),
                    child: Column(
                      children: [
                        Icon(
                          Icons.route_outlined,
                          size: 40,
                          color: AppColors.textGrey,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'No global routing rules defined.\nSubmissions will use default workflow.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textGrey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...rules.asMap().entries.map(
                  (e) => _buildGlobalRule(context, ref, e.value, e.key, locale),
                ),

              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () => _addGlobalRule(context, ref),
                icon: const Icon(Icons.add_task),
                label: const Text('Add Routing Rule'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  backgroundColor: AppColors.brandBlue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _buildWebhookSettings(ref),
      ],
    );
  }

  Widget _buildAetherisPromo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.brandBlue, Color(0xFF6A11CB)],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          Icon(Icons.auto_awesome, color: Colors.white, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Aetheris AI Orchestration Enabled: Map submissions directly to Expert Departments based on user input.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlobalRule(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> rule,
    int index,
    String locale,
  ) {
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
              const Icon(
                Icons.business_center,
                size: 16,
                color: AppColors.brandBlue,
              ),
              const SizedBox(width: 8),
              Text(
                'Route to: ${rule['department'] ?? 'General'}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  size: 16,
                  color: Colors.red,
                ),
                onPressed: () => _deleteRule(ref, index),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Conditions: match ${rule['conditionGroup']?['matchType'] ?? 'all'}',
            style: const TextStyle(fontSize: 11, color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildWebhookSettings(WidgetRef ref) {
    final webhook = form.metadata['webhookUrl'] as String?;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'GLOBAL WEBHOOK',
          style: TextStyle(
            color: AppColors.textGrey,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: TextEditingController(text: webhook),
          decoration: const InputDecoration(
            hintText: 'https://api.yourdomain.com/webhook',
            border: OutlineInputBorder(),
            isDense: true,
            prefixIcon: Icon(Icons.link, size: 18),
          ),
          onChanged: (val) {
            ref
                .read(formBuilderControllerProvider(formId).notifier)
                .updateFormMetadata({'webhookUrl': val});
          },
        ),
      ],
    );
  }

  void _addGlobalRule(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => LogicRuleDialog(
        sections: form.sections,
        locale: 'en', // Default for global
      ),
    );

    if (result != null) {
      final settings = form.metadata['logicSettings'] ?? {'rules': []};
      final newRules = List<Map<String, dynamic>>.from(settings['rules'])
        ..add(result);
      ref
          .read(formBuilderControllerProvider(formId).notifier)
          .updateFormMetadata({
            'logicSettings': {'rules': newRules},
          });
    }
  }

  void _deleteRule(WidgetRef ref, int index) {
    final settings = form.metadata['logicSettings'] ?? {'rules': []};
    final newRules = List<Map<String, dynamic>>.from(settings['rules'])
      ..removeAt(index);
    ref.read(formBuilderControllerProvider(formId).notifier).updateFormMetadata(
      {
        'logicSettings': {'rules': newRules},
      },
    );
  }
}
