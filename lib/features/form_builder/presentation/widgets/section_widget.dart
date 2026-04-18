import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/localization/locale_controller.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/form_builder/domain/entities/custom_field_template.dart';
import 'package:frontend/features/form_builder/domain/entities/form_section.dart';
import 'package:frontend/features/form_builder/domain/entities/question_type.dart';
import 'package:frontend/features/form_builder/domain/entities/section_layout_type.dart';
import 'package:frontend/features/form_builder/presentation/controllers/form_builder_controller.dart';
import 'builder_field_widget.dart';
import 'form_drag_data.dart';

class SectionWidget extends ConsumerWidget {
  final String projectId;
  final String formId;
  final FormSection section;
  final int sectionIndex;
  final String? selectedQuestionId;
  final String? selectedSectionId;
  final String locale;
  final String? mode;

  const SectionWidget({
    super.key,
    required this.projectId,
    required this.formId,
    required this.section,
    required this.sectionIndex,
    required this.selectedQuestionId,
    required this.selectedSectionId,
    required this.locale,
    this.mode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSectionSelected =
        selectedSectionId == section.id && selectedQuestionId == null;
    final sectionStyle = section.style;

    Color sectionBg;
    Color headerBg;
    try {
      sectionBg = Color(
        int.parse(sectionStyle.backgroundColor.replaceAll('#', '0xFF')),
      );
      headerBg = Color(
        int.parse(sectionStyle.headerBackgroundColor.replaceAll('#', '0xFF')),
      );
    } catch (_) {
      sectionBg = Colors.white;
      headerBg = AppColors.builderElement.withValues(alpha: 0.5);
    }

    return DragTarget<Object>(
      onWillAcceptWithDetails: (details) {
        return details.data is QuestionType ||
            details.data is QuestionDragData ||
            details.data is CustomFieldTemplate;
      },
      onAcceptWithDetails: (details) {
        final notifier = ref.read(
          formBuilderControllerProvider('$projectId::$formId').notifier,
        );
        if (details.data is QuestionType) {
          notifier.addQuestion(section.id, details.data as QuestionType);
        } else if (details.data is CustomFieldTemplate) {
          notifier.addFromTemplate(
            section.id,
            details.data as CustomFieldTemplate,
          );
        } else if (details.data is QuestionDragData) {
          final data = details.data as QuestionDragData;
          if (data.sectionId == section.id) {
            notifier.reorderQuestions(
              section.id,
              data.index,
              section.questions.length,
            );
          } else {
            notifier.moveQuestion(
              data.sectionId,
              section.id,
              data.questionId,
              section.questions.length,
            );
          }
        }
      },
      builder: (context, candidateData, rejectedData) {
        final isHovered = candidateData.isNotEmpty;

        return Container(
          margin: const EdgeInsets.only(bottom: 24),
          child: Material(
            elevation: sectionStyle.elevation,
            borderRadius: BorderRadius.circular(sectionStyle.borderRadius),
            color: sectionBg,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(sectionStyle.borderRadius),
                border: Border.all(
                  color: isHovered || isSectionSelected
                      ? AppColors.primary
                      : AppColors.borderLight,
                  width: 2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section Header
                  if (sectionStyle.showHeader && mode != 'question')
                    InkWell(
                      onTap: () => ref
                          .read(
                            formBuilderControllerProvider(
                              '$projectId::$formId',
                            ).notifier,
                          )
                          .selectSection(section.id),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: AppColors.borderLight),
                          ),
                          color: isSectionSelected
                              ? AppColors.primary.withValues(alpha: 0.05)
                              : headerBg,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(sectionStyle.borderRadius),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.drag_indicator,
                                  color: AppColors.textGrey,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    (section.title?.translate(locale) ?? ''),
                                    style: const TextStyle(
                                      color: AppColors.textDark,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.redAccent,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    ref
                                        .read(
                                          formBuilderControllerProvider(
                                            '$projectId::$formId',
                                          ).notifier,
                                        )
                                        .removeSection(section.id);
                                  },
                                  tooltip: 'Delete Section',
                                ),
                                PopupMenuButton<String>(
                                  icon: const Icon(
                                    Icons.more_vert,
                                    color: AppColors.textGrey,
                                  ),
                                  onSelected: (value) {
                                    final notifier = ref.read(
                                      formBuilderControllerProvider(
                                        '$projectId::$formId',
                                      ).notifier,
                                    );
                                    if (value == 'duplicate') {
                                      // notifier.duplicateSection(section.id);
                                    } else if (value == 'move_up') {
                                      if (sectionIndex > 0) {
                                        notifier.reorderSections(
                                          sectionIndex,
                                          sectionIndex - 1,
                                        );
                                      }
                                    } else if (value == 'move_down') {
                                      notifier.reorderSections(
                                        sectionIndex,
                                        sectionIndex + 1,
                                      );
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: 'duplicate',
                                      child: Row(
                                        children: [
                                          Icon(Icons.copy, size: 18),
                                          SizedBox(width: 8),
                                          Text('Duplicate'),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: 'move_up',
                                      child: Row(
                                        children: [
                                          Icon(Icons.arrow_upward, size: 18),
                                          SizedBox(width: 8),
                                          Text('Move Up'),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: 'move_down',
                                      child: Row(
                                        children: [
                                          Icon(Icons.arrow_downward, size: 18),
                                          SizedBox(width: 8),
                                          Text('Move Down'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            if ((section.description?.translate(locale) ?? '')
                                .isNotEmpty)
                              Text(
                                section.description?.translate(locale) ?? '',
                                style: const TextStyle(
                                  color: AppColors.textGrey,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                  // Questions List
                  Padding(
                    padding: EdgeInsets.all(sectionStyle.padding),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final availableWidth = constraints.maxWidth;
                        final builderState = ref.watch(
                          formBuilderControllerProvider('$projectId::$formId'),
                        );
                        final questionSpacing = builderState.when(
                          data: (s) => s.form.style.questionSpacing,
                          loading: () => 16.0,
                          error: (e, s) => 16.0,
                        );

                        int crossAxisCount = 1;
                        if (section.layout == SectionLayoutType.grid) {
                          crossAxisCount = section.gridColumns;
                        }

                        if (availableWidth < 400 && crossAxisCount > 1) {
                          crossAxisCount = 1;
                        } else if (availableWidth < 700 && crossAxisCount > 2) {
                          crossAxisCount = 2;
                        }

                        final itemWidth =
                            (availableWidth -
                                (questionSpacing * (crossAxisCount - 1))) /
                            crossAxisCount;

                        return Wrap(
                          spacing: questionSpacing,
                          runSpacing: questionSpacing,
                          children: [
                            if (section.questions.isEmpty)
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(32.0),
                                  child: Text(
                                    'Drag and drop fields here',
                                    style: TextStyle(color: AppColors.textGrey),
                                  ),
                                ),
                              ),

                            ...section.questions.asMap().entries.map((entry) {
                              final qIndex = entry.key;
                              final q = entry.value;
                              final isSelected = q.id == selectedQuestionId;

                              // Calculate width based on span or fixed mode
                              double width = itemWidth; // Default to 1 column

                              if (q.style.widthMode == 'fixed') {
                                // Fixed widths
                                switch (q.style.fixedWidth) {
                                  case 'small':
                                    width = 200.0;
                                    break;
                                  case 'medium':
                                    width = 400.0;
                                    break;
                                  case 'large':
                                    width = 600.0;
                                    break;
                                  default:
                                    width = 400.0;
                                }
                              } else {
                                // Auto mode (Grid Column Span)
                                int span = q.style.columnSpan;
                                if (span > crossAxisCount) {
                                  span = crossAxisCount;
                                }
                                if (span < 1) {
                                  span = 1;
                                }

                                // Calculate spanned width:
                                // (single_col_width * span) + (spacing * (span - 1))
                                width =
                                    (itemWidth * span) +
                                    (questionSpacing * (span - 1));
                              }

                              // Ensure we don't exceed available width (with some buffer)
                              if (width > availableWidth) {
                                width = availableWidth;
                              }

                              final questionWidget = BuilderFieldWidget(
                                question: q,
                                isSelected: isSelected,
                                locale: locale,
                                onTap: () {
                                  ref
                                      .read(
                                        formBuilderControllerProvider(
                                          '$projectId::$formId',
                                        ).notifier,
                                      )
                                      .selectQuestion(section.id, q.id);
                                },
                                onDelete: () {
                                  ref
                                      .read(
                                        formBuilderControllerProvider(
                                          '$projectId::$formId',
                                        ).notifier,
                                      )
                                      .removeQuestion(section.id, q.id);
                                },
                                onDuplicate: () {
                                  ref
                                      .read(
                                        formBuilderControllerProvider(
                                          '$projectId::$formId',
                                        ).notifier,
                                      )
                                      .duplicateQuestion(section.id, q);
                                },
                              );

                              return SizedBox(
                                width: width,
                                child: DragTarget<QuestionDragData>(
                                  onWillAcceptWithDetails: (details) =>
                                      details.data.questionId != q.id,
                                  onAcceptWithDetails: (details) {
                                    final notifier = ref.read(
                                      formBuilderControllerProvider(
                                        formId,
                                      ).notifier,
                                    );
                                    if (details.data.sectionId == section.id) {
                                      notifier.reorderQuestions(
                                        section.id,
                                        details.data.index,
                                        qIndex,
                                      );
                                    } else {
                                      notifier.moveQuestion(
                                        details.data.sectionId,
                                        section.id,
                                        details.data.questionId,
                                        qIndex,
                                      );
                                    }
                                  },
                                  builder:
                                      (context, candidateData, rejectedData) {
                                        final isHovered =
                                            candidateData.isNotEmpty;
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (isHovered)
                                              Container(
                                                height: 4,
                                                margin: const EdgeInsets.only(
                                                  bottom: 8,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: AppColors.primary,
                                                  borderRadius:
                                                      BorderRadius.circular(2),
                                                ),
                                              ),
                                            Draggable<QuestionDragData>(
                                              data: QuestionDragData(
                                                sectionId: section.id,
                                                questionId: q.id,
                                                index: qIndex,
                                              ),
                                              feedback: Material(
                                                elevation: 8,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: SizedBox(
                                                  width: itemWidth,
                                                  child: questionWidget,
                                                ),
                                              ),
                                              childWhenDragging: Opacity(
                                                opacity: 0.3,
                                                child: questionWidget,
                                              ),
                                              child: questionWidget,
                                            ),
                                          ],
                                        );
                                      },
                                ),
                              );
                            }),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
