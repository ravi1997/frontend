import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/localization/locale_controller.dart';
import '../controllers/form_builder_controller.dart';

class TranslatorPage extends ConsumerStatefulWidget {
  final String formId;

  const TranslatorPage({super.key, required this.formId});

  @override
  ConsumerState<TranslatorPage> createState() => _TranslatorPageState();
}

class _TranslatorPageState extends ConsumerState<TranslatorPage> {
  String _targetLocale = 'es';

  @override
  Widget build(BuildContext context) {
    final builderStateAsync = ref.watch(
      formBuilderControllerProvider(widget.formId),
    );

    return Scaffold(
      backgroundColor: AppColors.builderBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Bulk Translator',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textGrey),
          onPressed: () => context.pop(),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: AppColors.builderBackground,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _targetLocale,
                items: const [
                  DropdownMenuItem(value: 'es', child: Text('Spanish (ES)')),
                  DropdownMenuItem(value: 'fr', child: Text('French (FR)')),
                  DropdownMenuItem(value: 'hi', child: Text('Hindi (HI)')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _targetLocale = val);
                },
              ),
            ),
          ),
        ],
      ),
      body: builderStateAsync.when(
        data: (state) {
          final form = state.form;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader('Form Details'),
                _buildTranslationRow(
                  label: 'Form Title',
                  original: form.title.translate('en'),
                  currentValue: form.title.translate(_targetLocale),
                  onChanged: (val) => ref
                      .read(
                        formBuilderControllerProvider(widget.formId).notifier,
                      )
                      .updateLocalizedFormTitle(val, _targetLocale),
                ),
                const SizedBox(height: 32),
                ...form.sections.asMap().entries.map((entry) {
                  final sectionIndex = entry.key;
                  final section = entry.value;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader(
                        'Section ${sectionIndex + 1}: ${section.title.translate('en')}',
                      ),
                      _buildTranslationRow(
                        label: 'Section Title',
                        original: section.title.translate('en'),
                        currentValue: section.title.translate(_targetLocale),
                        onChanged: (val) => ref
                            .read(
                              formBuilderControllerProvider(
                                widget.formId,
                              ).notifier,
                            )
                            .updateLocalizedSectionTitle(
                              section.id,
                              val,
                              _targetLocale,
                            ),
                      ),
                      if (section.description.translate('en').isNotEmpty)
                        _buildTranslationRow(
                          label: 'Description',
                          original: section.description.translate('en'),
                          currentValue: section.description.translate(
                            _targetLocale,
                          ),
                          onChanged: (val) => ref
                              .read(
                                formBuilderControllerProvider(
                                  widget.formId,
                                ).notifier,
                              )
                              .updateLocalizedSectionDescription(
                                section.id,
                                val,
                                _targetLocale,
                              ),
                        ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Column(
                          children: section.questions.map((question) {
                            return Card(
                              margin: const EdgeInsets.only(bottom: 16),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: AppColors.borderLight),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Question: ${question.label.translate('en')}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: AppColors.textDark,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    _buildTranslationRow(
                                      label: 'Label',
                                      original: question.label.translate('en'),
                                      currentValue: question.label.translate(
                                        _targetLocale,
                                      ),
                                      onChanged: (val) => ref
                                          .read(
                                            formBuilderControllerProvider(
                                              widget.formId,
                                            ).notifier,
                                          )
                                          .updateLocalizedQuestionLabel(
                                            question.id,
                                            val,
                                            _targetLocale,
                                          ),
                                    ),
                                    if (question.helperText
                                        .translate('en')
                                        .isNotEmpty)
                                      _buildTranslationRow(
                                        label: 'Helper Text',
                                        original: question.helperText.translate(
                                          'en',
                                        ),
                                        currentValue: question.helperText
                                            .translate(_targetLocale),
                                        onChanged: (val) => ref
                                            .read(
                                              formBuilderControllerProvider(
                                                widget.formId,
                                              ).notifier,
                                            )
                                            .updateLocalizedQuestionHelperText(
                                              question.id,
                                              val,
                                              _targetLocale,
                                            ),
                                      ),
                                    if (question.placeholder
                                        .translate('en')
                                        .isNotEmpty)
                                      _buildTranslationRow(
                                        label: 'Placeholder',
                                        original: question.placeholder
                                            .translate('en'),
                                        currentValue: question.placeholder
                                            .translate(_targetLocale),
                                        onChanged: (val) => ref
                                            .read(
                                              formBuilderControllerProvider(
                                                widget.formId,
                                              ).notifier,
                                            )
                                            .updateLocalizedQuestionPlaceholder(
                                              question.id,
                                              val,
                                              _targetLocale,
                                            ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  );
                }),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildTranslationRow({
    required String label,
    required String original,
    required String currentValue,
    required Function(String) onChanged,
  }) {
    final controller = TextEditingController(text: currentValue);
    // Move cursor to end
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  original,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          const Icon(Icons.arrow_forward, color: AppColors.textGrey, size: 16),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.borderLight),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
