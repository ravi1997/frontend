import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/tokens.dart';
import '../services/form_builder_controller.dart';

class LlmCopilotDrawer extends ConsumerStatefulWidget {
  final String formId;

  const LlmCopilotDrawer({
    super.key,
    required this.formId,
  });

  @override
  ConsumerState<LlmCopilotDrawer> createState() => _LlmCopilotDrawerState();
}

class _LlmCopilotDrawerState extends ConsumerState<LlmCopilotDrawer> {
  final TextEditingController _promptController = TextEditingController();
  bool _isGenerating = false;

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.spaceL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Icon(Icons.auto_awesome, color: AppColors.primary),
                  const SizedBox(width: DesignTokens.spaceS),
                  Expanded(
                    child: Text(
                      'LLM Copilot',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: DesignTokens.spaceM),
              Text(
                'Describe the form you want and let the assistant draft the structure.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textGrey,
                    ),
              ),
              const SizedBox(height: DesignTokens.spaceM),
              TextField(
                controller: _promptController,
                maxLines: 6,
                decoration: const InputDecoration(
                  hintText:
                      'e.g. Create a discharge summary form with patient details, medications, and follow-up instructions.',
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: _isGenerating
                    ? null
                    : () async {
                        final prompt = _promptController.text.trim();
                        if (prompt.isEmpty) return;
                        final navigator = Navigator.of(context);
                        setState(() => _isGenerating = true);
                        try {
                          await ref
                              .read(
                                formBuilderControllerProvider(widget.formId)
                                    .notifier,
                              )
                              .generateFieldsWithAI(prompt);
                          if (!mounted) return;
                          navigator.maybePop();
                        } finally {
                          if (mounted) {
                            setState(() => _isGenerating = false);
                          }
                        }
                      },
                icon: _isGenerating
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.smart_toy_outlined),
                label: Text(_isGenerating ? 'Generating...' : 'Generate'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
