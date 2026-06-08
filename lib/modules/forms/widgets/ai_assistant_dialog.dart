import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/core/services/snackbar_service.dart';
import '../../../../app/theme/app_colors.dart';
import 'package:frontend/modules/forms/services/form_builder_controller.dart'; // Assuming this controller handles AI interactions

class AiAssistantDialog extends ConsumerStatefulWidget {
  final String formId;

  const AiAssistantDialog({super.key, required this.formId});

  @override
  ConsumerState<AiAssistantDialog> createState() => _AiAssistantDialogState();
}

class _AiAssistantDialogState extends ConsumerState<AiAssistantDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _promptController = TextEditingController();

  bool _isGenerating = false;
  bool _isLoadingSuggestions = false;
  bool _isValidating = false;

  List<Map<String, dynamic>> _suggestions = [];
  Map<String, dynamic>? _validationResults;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _promptController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchSuggestions() async {
    setState(() => _isLoadingSuggestions = true);
    final suggestions = await ref
        .read(formBuilderControllerProvider(widget.formId).notifier)
        .getAISuggestions();
    setState(() {
      _suggestions = suggestions;
      _isLoadingSuggestions = false;
    });
  }

  Future<void> _runValidation() async {
    setState(() => _isValidating = true);
    final results = await ref
        .read(formBuilderControllerProvider(widget.formId).notifier)
        .validateFormWithAI();
    setState(() {
      _validationResults = results;
      _isValidating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 500,
        height: 600,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.auto_awesome, color: AppColors.primary),
                const SizedBox(width: 12),
                Text(
                  'Form AI Assistant',
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textGrey,
              indicatorColor: AppColors.primary,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: const [
                Tab(text: 'Generate'),
                Tab(text: 'Suggestions'),
                Tab(text: 'Validator'),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildGenerateTab(),
                  _buildSuggestionsTab(),
                  _buildValidationTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenerateTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Describe what you want to build and let AI handle the structure.',
          style: GoogleFonts.inter(color: AppColors.textGrey, fontSize: 13),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _promptController,
          maxLines: 5,
          decoration: InputDecoration(
            hintText:
                'e.g., "Add a section for emergency contact details with name, relation, and phone number."',
            filled: true,
            fillColor: AppColors.builderBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: _isGenerating
              ? null
              : () async {
                  if (_promptController.text.trim().isEmpty) return;
                  setState(() => _isGenerating = true);
                  await ref
                      .read(
                        formBuilderControllerProvider(widget.formId).notifier,
                      )
                      .generateFieldsWithAI(_promptController.text);
                  if (mounted) Navigator.pop(context);
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: _isGenerating
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Generate Fields'),
        ),
      ],
    );
  }

  Widget _buildSuggestionsTab() {
    if (_suggestions.isEmpty && !_isLoadingSuggestions) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lightbulb_outline,
              size: 48,
              color: AppColors.primary.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            const Text(
              'Need ideas? Let AI scan your form\nand suggest missing pieces.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textGrey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _fetchSuggestions,
              child: const Text('Get Suggestions'),
            ),
          ],
        ),
      );
    }

    if (_isLoadingSuggestions) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: _suggestions.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final s = _suggestions[index];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.builderBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.add_circle_outline,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          s['label'] ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            (s['field_type'] ?? '').toString().toUpperCase(),
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      s['reason'] ?? '',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textGrey,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        // Logic to add this field
                        // ref.read(formBuilderControllerProvider(widget.formId).notifier).addQuestion(...)
                        ref.read(snackbarServiceProvider).showInfo(
                          'Adding field suggestions currently requires manual confirmation in this version.',
                        );
                      },
                      child: const Text('Add to Form'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        TextButton.icon(
          onPressed: _fetchSuggestions,
          icon: const Icon(Icons.refresh, size: 16),
          label: const Text('Refresh Suggestions'),
        ),
      ],
    );
  }

  Widget _buildValidationTab() {
    if (_validationResults == null && !_isValidating) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.fact_check_outlined,
              size: 48,
              color: AppColors.primary.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            const Text(
              'Run an AI scan to check for UX issues,\ngaps, or logical inconsistencies.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textGrey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _runValidation,
              child: const Text('Analyze Form Design'),
            ),
          ],
        ),
      );
    }

    if (_isValidating) {
      return const Center(child: CircularProgressIndicator());
    }

    final score = _validationResults!['score'] ?? 0;
    final issues = _validationResults!['issues'] as List<dynamic>? ?? [];
    final suggestions =
        _validationResults!['suggestions'] as List<dynamic>? ?? [];

    return ListView(
      children: [
        Center(
          child: Column(
            children: [
              Text(
                'Design Score',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: AppColors.textGrey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$score',
                style: GoogleFonts.outfit(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: score >= 80 ? Colors.green : Colors.orange,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        if (issues.isNotEmpty) ...[
          const Text(
            'Potential Issues',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          ...issues.map((issue) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.withValues(alpha: 0.1)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.warning_amber, size: 16, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      issue['message'] ?? '',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
        const SizedBox(height: 24),
        const Text(
          'Improvement Tips',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        ...suggestions.map((s) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_circle, size: 16, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    s.toString(),
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _runValidation,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.builderBackground,
            foregroundColor: AppColors.primary,
          ),
          child: const Text('Re-run Analysis'),
        ),
      ],
    );
  }
}
