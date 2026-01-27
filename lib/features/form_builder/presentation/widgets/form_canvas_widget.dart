import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/form_section.dart';
import '../../domain/entities/question_type.dart';
import '../controllers/form_builder_controller.dart';
import 'builder_field_widget.dart';

class FormCanvasWidget extends ConsumerWidget {
  final String formId;

  const FormCanvasWidget({super.key, required this.formId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final builderState = ref.watch(formBuilderControllerProvider(formId));

    return builderState.when(
      data: (state) {
        return Container(
          color: AppColors.builderCanvas, // Slate 950
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                // Form Title Input
                _buildFormHeader(state.form.title, ref),
                const SizedBox(height: 24),

                // Sections
                ...state.form.sections.map(
                  (section) => _buildSection(
                    context,
                    section,
                    state.selectedQuestionId,
                    ref,
                  ),
                ),

                const SizedBox(height: 24),

                // Add Section Button
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () => ref
                        .read(formBuilderControllerProvider(formId).notifier)
                        .addSection(),
                    icon: const Icon(Icons.add),
                    label: const Text('Add New Section'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.builderElement,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 60), // Bottom padding
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildFormHeader(String title, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.builderSidebar, // White
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: TextEditingController(text: title)
              ..selection = TextSelection.collapsed(offset: title.length),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Form Title',
              hintStyle: TextStyle(
                color: AppColors.textGrey.withValues(alpha: 0.5),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: const TextStyle(
              color: AppColors.textDark,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            onSubmitted: (value) => ref
                .read(formBuilderControllerProvider(formId).notifier)
                .updateFormTitle(value),
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Form description (optional)',
              hintStyle: TextStyle(
                color: AppColors.textGrey.withValues(alpha: 0.5),
              ),
            ),
            style: TextStyle(color: AppColors.textGrey),
            maxLines: null,
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    FormSection section,
    String? selectedQuestionId,
    WidgetRef ref,
  ) {
    return DragTarget<QuestionType>(
      onWillAcceptWithDetails: (details) => true,
      onAcceptWithDetails: (details) {
        ref
            .read(formBuilderControllerProvider(formId).notifier)
            .addQuestion(section.id, details.data);
      },
      builder: (context, candidateData, rejectedData) {
        final isHovered = candidateData.isNotEmpty;

        return Container(
          margin: const EdgeInsets.only(bottom: 24),
          decoration: BoxDecoration(
            color: AppColors.builderSidebar, // White section bg
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isHovered ? AppColors.primary : AppColors.borderLight,
              width: 2, // Constant width to prevent layout shift during drag
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.borderLight),
                  ),
                  color: AppColors.builderElement.withValues(alpha: 0.5),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.drag_indicator, color: AppColors.textGrey),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            section.title,
                            style: TextStyle(
                              color: AppColors.textDark,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.more_vert,
                            color: AppColors.textGrey,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    Text(
                      section.description ?? 'Section description (optional)',
                      style: TextStyle(color: AppColors.textGrey),
                    ),
                  ],
                ),
              ),

              // Questions List
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    if (section.questions.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Text(
                            'Drag and drop fields here',
                            style: TextStyle(color: AppColors.textGrey),
                          ),
                        ),
                      ),

                    ...section.questions.map((q) {
                      final isSelected = q.id == selectedQuestionId;
                      return BuilderFieldWidget(
                        question: q,
                        isSelected: isSelected,
                        onTap: () {
                          ref
                              .read(
                                formBuilderControllerProvider(formId).notifier,
                              )
                              .selectQuestion(section.id, q.id);
                        },
                        onDelete: () {
                          ref
                              .read(
                                formBuilderControllerProvider(formId).notifier,
                              )
                              .removeQuestion(section.id, q.id);
                        },
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
