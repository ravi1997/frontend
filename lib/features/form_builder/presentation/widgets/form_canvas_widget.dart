import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/localization/locale_controller.dart';
import '../../domain/entities/form_section.dart';
import '../../domain/entities/question_type.dart';
import '../../domain/entities/custom_field_template.dart';
import '../../domain/entities/form_layout_type.dart';
import '../../domain/entities/section_layout_type.dart';
import '../controllers/form_builder_controller.dart';
import 'builder_field_widget.dart';

class SectionDragData {
  final String sectionId;
  final int index;
  SectionDragData({required this.sectionId, required this.index});
}

class QuestionDragData {
  final String sectionId;
  final String questionId;
  final int index;
  QuestionDragData({
    required this.sectionId,
    required this.questionId,
    required this.index,
  });
}

class FormCanvasWidget extends ConsumerWidget {
  final String formId;

  const FormCanvasWidget({super.key, required this.formId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final builderState = ref.watch(formBuilderControllerProvider(formId));

    return builderState.when(
      data: (state) {
        final formStyle = state.form.style;
        Color canvasColor;
        try {
          canvasColor = Color(
            int.parse(formStyle.backgroundColor.replaceAll('#', '0xFF')),
          );
        } catch (_) {
          canvasColor = AppColors.builderCanvas;
        }

        return GestureDetector(
          onTap: () {
            ref
                .read(formBuilderControllerProvider(formId).notifier)
                .selectQuestion(null, null);
          },
          behavior: HitTestBehavior.opaque,
          child: Container(
            color: canvasColor,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: formStyle.maxWidth),
                  child: Column(
                    children: [
                      // Form Title Input
                      _buildFormHeader(
                        state.form.title,
                        ref,
                        state.editingLocale,
                      ),
                      const SizedBox(height: 24),

                      // Empty State
                      if (state.form.sections.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 80),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.borderLight,
                              style: BorderStyle.none,
                            ),
                          ),
                          child: CustomPaint(
                            painter: _DashedBorderPainter(
                              color: AppColors.textGrey.withValues(alpha: 0.3),
                              borderRadius: 16,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  FontAwesomeIcons.layerGroup,
                                  size: 48,
                                  color: AppColors.textGrey.withValues(
                                    alpha: 0.2,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                const Text(
                                  'Your form is empty',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Start by adding a section or dragging a field',
                                  style: TextStyle(
                                    color: AppColors.textGrey,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      // Sections
                      if (state.form.sections.isNotEmpty)
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final availableWidth = constraints.maxWidth;
                            final spacing = 24.0;

                            int crossAxisCount = 1;
                            if (state.form.layout ==
                                FormLayoutType.twoColumns) {
                              crossAxisCount = 2;
                            } else if (state.form.layout ==
                                FormLayoutType.threeColumns) {
                              crossAxisCount = 3;
                            }

                            if (availableWidth < 600 && crossAxisCount > 1) {
                              crossAxisCount = 1;
                            } else if (availableWidth < 900 &&
                                crossAxisCount > 2) {
                              crossAxisCount = 2;
                            }

                            final itemWidth =
                                (availableWidth -
                                    (spacing * (crossAxisCount - 1))) /
                                crossAxisCount;

                            return Wrap(
                              spacing: spacing,
                              runSpacing: spacing,
                              children: state.form.sections.asMap().entries.map((
                                entry,
                              ) {
                                final index = entry.key;
                                final section = entry.value;
                                final sectionWidget = SizedBox(
                                  width: itemWidth,
                                  child: _buildSection(
                                    context,
                                    section,
                                    index,
                                    state.selectedQuestionId,
                                    state.selectedSectionId,
                                    ref,
                                    state.editingLocale,
                                  ),
                                );

                                return DragTarget<SectionDragData>(
                                  onWillAcceptWithDetails: (details) =>
                                      details.data.sectionId != section.id,
                                  onAcceptWithDetails: (details) {
                                    ref
                                        .read(
                                          formBuilderControllerProvider(
                                            formId,
                                          ).notifier,
                                        )
                                        .reorderSections(
                                          details.data.index,
                                          index,
                                        );
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
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: AppColors.primary,
                                                  borderRadius:
                                                      BorderRadius.circular(2),
                                                ),
                                              ),
                                            Draggable<SectionDragData>(
                                              data: SectionDragData(
                                                sectionId: section.id,
                                                index: index,
                                              ),
                                              feedback: Material(
                                                elevation: 8,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: SizedBox(
                                                  width: itemWidth,
                                                  child: sectionWidget,
                                                ),
                                              ),
                                              childWhenDragging: Opacity(
                                                opacity: 0.3,
                                                child: sectionWidget,
                                              ),
                                              child: sectionWidget,
                                            ),
                                          ],
                                        );
                                      },
                                );
                              }).toList(),
                            );
                          },
                        ),

                      const SizedBox(height: 24),

                      // Add Section Button
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () => ref
                              .read(
                                formBuilderControllerProvider(formId).notifier,
                              )
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
              ),
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildFormHeader(Object? title, WidgetRef ref, String locale) {
    return InkWell(
      onTap: () =>
          ref.read(formBuilderControllerProvider(formId).notifier).selectForm(),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.builderSidebar, // White
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title.translate(locale),
              style: const TextStyle(
                color: AppColors.textDark,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Click to edit form properties',
              style: TextStyle(
                color: AppColors.textGrey.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    FormSection section,
    int sectionIndex,
    String? selectedQuestionId,
    String? selectedSectionId,
    WidgetRef ref,
    String locale,
  ) {
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
          formBuilderControllerProvider(formId).notifier,
        );
        if (details.data is QuestionType) {
          notifier.addQuestion(section.id, details.data as QuestionType);
        } else if (details.data is CustomFieldTemplate) {
          notifier.addQuestionFromTemplate(
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
                  if (sectionStyle.showHeader)
                    InkWell(
                      onTap: () => ref
                          .read(formBuilderControllerProvider(formId).notifier)
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
                                Icon(
                                  Icons.drag_indicator,
                                  color: AppColors.textGrey,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    section.title.translate(locale),
                                    style: TextStyle(
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
                                            formId,
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
                                        formId,
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
                            if (section.description
                                .translate(locale)
                                .isNotEmpty)
                              Text(
                                section.description.translate(locale),
                                style: TextStyle(color: AppColors.textGrey),
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
                          formBuilderControllerProvider(formId),
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
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(32.0),
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
                                          formId,
                                        ).notifier,
                                      )
                                      .selectQuestion(section.id, q.id);
                                },
                                onDelete: () {
                                  ref
                                      .read(
                                        formBuilderControllerProvider(
                                          formId,
                                        ).notifier,
                                      )
                                      .removeQuestion(section.id, q.id);
                                },
                                onDuplicate: () {
                                  ref
                                      .read(
                                        formBuilderControllerProvider(
                                          formId,
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

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double borderRadius;
  final double strokeWidth = 1;
  final double dashWidth = 5;
  final double dashSpace = 3;

  _DashedBorderPainter({this.color = Colors.grey, this.borderRadius = 6});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(borderRadius),
        ),
      );

    final dashPath = Path();
    double distance = 0.0;

    for (final pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
