import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/app/localization/locale_controller.dart';
import 'package:frontend/app/theme/app_colors.dart';
import 'package:frontend/app/theme/tokens.dart';
import 'package:frontend/modules/forms/models/custom_field_template.dart';
import 'package:frontend/shared/models/form_models.dart';
import 'package:frontend/modules/forms/models/question_type.dart';
import 'package:frontend/modules/forms/models/section_layout_type.dart';
import 'package:frontend/modules/forms/models/form_style.dart';
import 'package:frontend/modules/forms/services/form_builder_controller.dart';
import 'package:frontend/modules/forms/utility/layout_engine.dart';
import 'builder_field_widget.dart';
import 'package:frontend/core/services/collaboration_service.dart';

// Drag and drop data classes
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

class SectionWidget extends ConsumerWidget {
  final String controllerKey;
  final String projectId;
  final String formId;
  final FormSection section;
  final int sectionIndex;
  final String? selectedQuestionId;
  final List<String> selectedQuestionIds;
  final String? selectedSectionId;
  final String? parentSectionId;
  final String locale;
  final String? mode;

  const SectionWidget({
    super.key,
    required this.controllerKey,
    required this.projectId,
    required this.formId,
    required this.section,
    required this.sectionIndex,
    required this.selectedQuestionId,
    required this.selectedQuestionIds,
    required this.selectedSectionId,
    this.parentSectionId,
    required this.locale,
    this.mode,
  });

  SectionStyle _sectionStyle(FormSection section) {
    final raw = section.ui['style'];
    if (raw is Map) {
      return SectionStyle.fromJson(Map<String, dynamic>.from(raw));
    }
    return const SectionStyle();
  }

  QuestionStyle _questionStyle(FormQuestion question) {
    final raw = question.ui['style'];
    if (raw is Map) {
      return QuestionStyle.fromJson(Map<String, dynamic>.from(raw));
    }
    return const QuestionStyle();
  }

  SectionLayoutType _parseLayout(String raw) {
    for (final value in SectionLayoutType.values) {
      if (value.name == raw) return value;
    }
    return SectionLayoutType.standard;
  }

  TextStyle _sectionTypographyStyle({
    required String baseColor,
    required Color fallbackColor,
    required String sizeKey,
    required String weightKey,
    required double fallbackSize,
    required Map<String, dynamic> metadata,
  }) {
    final color = _parseColor(baseColor, fallbackColor);
    final size = (metadata[sizeKey] as num?)?.toDouble() ?? fallbackSize;
    final weight = switch (metadata[weightKey]?.toString()) {
      'medium' => FontWeight.w500,
      'bold' => FontWeight.bold,
      _ => FontWeight.normal,
    };
    return TextStyle(color: color, fontSize: size, fontWeight: weight);
  }

  Color _parseColor(String value, Color fallback) {
    try {
      return Color(int.parse(value.replaceAll('#', '0xFF')));
    } catch (_) {
      return fallback;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collabState = ref.watch(collaborationProvider(formId));
    final isSectionSelected =
        selectedSectionId == section.id && selectedQuestionId == null;
    final sectionStyle = _sectionStyle(section);
    final metadata = section.metadata;
    final layout = _parseLayout(section.layout);
    final double fieldGap =
        (metadata['fieldGap'] as num?)?.toDouble() ?? 16.0;
    final double verticalPadding =
        (metadata['verticalPadding'] as num?)?.toDouble() ??
        sectionStyle.padding;
    final double horizontalPadding =
        (metadata['horizontalPadding'] as num?)?.toDouble() ??
        sectionStyle.padding;
    final alignStr = metadata['alignment']?.toString() ?? 'left';
    AlignmentGeometry sectionAlignment = Alignment.centerLeft;
    if (alignStr == 'center') sectionAlignment = Alignment.center;
    if (alignStr == 'right') sectionAlignment = Alignment.centerRight;
    final double sectionMaxWidth =
        (metadata['maxWidth'] as num?)?.toDouble() ??
        (layout == SectionLayoutType.centered ? 760.0 : 1200.0);

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
      sectionBg = Theme.of(context).colorScheme.surface;
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
          formBuilderControllerProvider(controllerKey).notifier,
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
        final questionSpacing = fieldGap;

        final sectionShell = Container(
          margin: const EdgeInsets.only(bottom: 24),
          child: Material(
            elevation: sectionStyle.elevation,
            borderRadius: BorderRadius.circular(sectionStyle.borderRadius),
            color: sectionBg,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(sectionStyle.borderRadius),
                border: isHovered || isSectionSelected
                    ? Border.all(color: AppColors.primary, width: 2)
                    : Border.all(
                        color: _parseColor(
                          metadata['borderColor']?.toString() ??
                              sectionStyle.borderColor,
                          AppColors.borderLight,
                        ),
                        width: (metadata['borderWidth'] as num?)?.toDouble() ??
                            sectionStyle.borderWidth,
                        style: switch (metadata['borderStyle']?.toString() ??
                            'solid') {
                          'dashed' || 'dotted' => BorderStyle.solid,
                          _ => BorderStyle.solid,
                        },
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
                              controllerKey,
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
                                const SizedBox(width: DesignTokens.spaceS),
                                Expanded(
                                  child: Text(
                                    section.title.translate(locale),
                                    style: _sectionTypographyStyle(
                                      baseColor: sectionStyle.titleColor,
                                      fallbackColor: AppColors.textDark,
                                      sizeKey: 'titleSize',
                                      weightKey: 'titleWeight',
                                      fallbackSize: 18,
                                      metadata: metadata,
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
                                            controllerKey,
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
                                        controllerKey,
                                      ).notifier,
                                    );
                                    if (value == 'duplicate') {
                                      // notifier.duplicateSection(section.id);
                                    } else if (value == 'add_child') {
                                      notifier.addSection(
                                        parentSectionId: section.id,
                                      );
                                    } else if (value == 'move_up') {
                                      if (sectionIndex > 0) {
                                        if (parentSectionId == null) {
                                          notifier.reorderSections(
                                            sectionIndex,
                                            sectionIndex - 1,
                                          );
                                        } else {
                                          notifier.reorderNestedSections(
                                            parentSectionId!,
                                            sectionIndex,
                                            sectionIndex - 1,
                                          );
                                        }
                                      }
                                    } else if (value == 'move_down') {
                                      if (parentSectionId == null) {
                                        notifier.reorderSections(
                                          sectionIndex,
                                          sectionIndex + 1,
                                        );
                                      } else {
                                        notifier.reorderNestedSections(
                                          parentSectionId!,
                                          sectionIndex,
                                          sectionIndex + 1,
                                        );
                                      }
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: 'duplicate',
                                      child: Row(
                                        children: [
                                          Icon(Icons.copy, size: 18),
                                          SizedBox(width: DesignTokens.spaceS),
                                          Text('Duplicate'),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: 'add_child',
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.subdirectory_arrow_right,
                                            size: 18,
                                          ),
                                          SizedBox(width: DesignTokens.spaceS),
                                          Text('Add Sub-section'),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: 'move_up',
                                      child: Row(
                                        children: [
                                          Icon(Icons.arrow_upward, size: 18),
                                          SizedBox(width: DesignTokens.spaceS),
                                          Text('Move Up'),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: 'move_down',
                                      child: Row(
                                        children: [
                                          Icon(Icons.arrow_downward, size: 18),
                                          SizedBox(width: DesignTokens.spaceS),
                                          Text('Move Down'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _SectionMetaChip(
                                  icon: Icons.view_agenda_outlined,
                                  label: layout.name,
                                ),
                                _SectionMetaChip(
                                  icon: Icons.format_list_bulleted,
                                  label:
                                      '${section.questions.length} question${section.questions.length == 1 ? '' : 's'}',
                                ),
                                if (isSectionSelected)
                                  const _SectionMetaChip(
                                    icon: Icons.radio_button_checked,
                                    label: 'Selected',
                                    selected: true,
                                  ),
                                if (section.sections.isNotEmpty)
                                  _SectionMetaChip(
                                    icon: Icons.subdirectory_arrow_right,
                                    label:
                                        '${section.sections.length} sub-section${section.sections.length == 1 ? '' : 's'}',
                                  ),
                              ],
                            ),
                            if ((section.description?.translate(locale) ?? '')
                                .isNotEmpty) ...[
                              const SizedBox(height: 10),
                              Text(
                                section.description?.translate(locale) ?? '',
                                style: _sectionTypographyStyle(
                                  baseColor: sectionStyle.descriptionColor,
                                  fallbackColor: AppColors.textGrey,
                                  sizeKey: 'descSize',
                                  weightKey: 'descWeight',
                                  fallbackSize: 14,
                                  metadata: metadata,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),

                  // Questions List
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: verticalPadding,
                      horizontal: horizontalPadding,
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final availableWidth = constraints.maxWidth;

                        int crossAxisCount = switch (layout) {
                          SectionLayoutType.grid => section.gridColumns,
                          SectionLayoutType.threeColumns => 3,
                          SectionLayoutType.fullWidth ||
                          SectionLayoutType.list ||
                          SectionLayoutType.sidebar ||
                          SectionLayoutType.custom ||
                          SectionLayoutType.overlay ||
                          SectionLayoutType.dashboard ||
                          SectionLayoutType.centered ||
                          SectionLayoutType.wizard ||
                          SectionLayoutType.masonry ||
                          SectionLayoutType.fixed ||
                          SectionLayoutType.standard ||
                          SectionLayoutType.accordion ||
                          SectionLayoutType.tabbed ||
                          SectionLayoutType.card => 1,
                        };

                        if (availableWidth < 400 && crossAxisCount > 1) {
                          crossAxisCount = 1;
                        } else if (availableWidth < 700 && crossAxisCount > 2) {
                          crossAxisCount = 2;
                        }

                        final itemWidth =
                            (availableWidth -
                                (fieldGap * (crossAxisCount - 1))) /
                            crossAxisCount;

                        return Wrap(
                          spacing: questionSpacing,
                          runSpacing: questionSpacing,
                          children: [
                            if (section.questions.isEmpty)
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(DesignTokens.spaceXXL),
                                  child: Text(
                                    'Drag and drop fields here',
                                    style: TextStyle(color: AppColors.textGrey),
                                  ),
                                ),
                              ),

                            ...section.questions.asMap().entries.map((entry) {
                              final qIndex = entry.key;
                              final q = entry.value;
                              final isSelected =
                                  selectedQuestionIds.contains(q.id) ||
                                  q.id == selectedQuestionId;

                              // Calculate width based on span or fixed mode
                              double width = itemWidth; // Default to 1 column

                            final qStyle = _questionStyle(q);
                            if (qStyle.widthMode == 'fixed') {
                              if (qStyle.fixedWidth <= 240) {
                                width = 200.0;
                              } else if (qStyle.fixedWidth <= 480) {
                                width = 400.0;
                              } else {
                                width = 600.0;
                              }
                              } else {
                                // Auto mode (Smart Grid Span)
                                int span = LayoutEngine.getFieldSpan(
                                  q,
                                  crossAxisCount,
                                );

                                // Calculate spanned width:
                                // (single_col_width * span) + (spacing * (span - 1))
                                width =
                                    (itemWidth * span) +
                                    (fieldGap * (span - 1));
                              }

                              // Ensure we don't exceed available width (with some buffer)
                              if (width > availableWidth) {
                                width = availableWidth;
                              }

                              final questionWidget = BuilderFieldWidget(
                                formId: formId,
                                question: q,
                                isSelected: isSelected,
                                locale: locale,
                                onTap: () {
                                  final lease = collabState.leases[q.id];
                                  if (lease != null && lease['user_id'] != collabState.myUserId) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Field is locked by ${lease['display_name']}'),
                                        backgroundColor: Colors.amber.shade800,
                                      ),
                                    );
                                    return;
                                  }
                                  ref
                                      .read(
                                        formBuilderControllerProvider(
                                          controllerKey,
                                        ).notifier,
                                      )
                                      .selectQuestion(section.id, q.id);
                                },
                                onLongPress: () {
                                  final lease = collabState.leases[q.id];
                                  if (lease != null && lease['user_id'] != collabState.myUserId) {
                                    return;
                                  }
                                  ref
                                      .read(
                                        formBuilderControllerProvider(
                                          controllerKey,
                                        ).notifier,
                                      )
                                      .toggleQuestionSelection(
                                        section.id,
                                        q.id,
                                      );
                                },
                                onDelete: () {
                                  final lease = collabState.leases[q.id];
                                  if (lease != null && lease['user_id'] != collabState.myUserId) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Cannot delete: field is locked by ${lease['display_name']}'),
                                        backgroundColor: Colors.amber.shade800,
                                      ),
                                    );
                                    return;
                                  }
                                  ref
                                      .read(
                                        formBuilderControllerProvider(
                                          controllerKey,
                                        ).notifier,
                                      )
                                      .removeQuestion(section.id, q.id);
                                },
                                onDuplicate: () {
                                  final lease = collabState.leases[q.id];
                                  if (lease != null && lease['user_id'] != collabState.myUserId) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Cannot duplicate: field is locked by ${lease['display_name']}'),
                                        backgroundColor: Colors.amber.shade800,
                                      ),
                                    );
                                    return;
                                  }
                                  ref
                                      .read(
                                        formBuilderControllerProvider(
                                          controllerKey,
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
                                        controllerKey,
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

                  if (section.sections.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 24,
                        right: 24,
                        bottom: 24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: section.sections.asMap().entries.map((entry) {
                          final childIndex = entry.key;
                          final childSection = entry.value;
                          return Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: SectionWidget(
                              controllerKey: controllerKey,
                              projectId: projectId,
                              formId: formId,
                              section: childSection,
                              sectionIndex: childIndex,
                              selectedQuestionId: selectedQuestionId,
                              selectedQuestionIds: selectedQuestionIds,
                              selectedSectionId: selectedSectionId,
                              parentSectionId: section.id,
                              locale: locale,
                              mode: mode,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );

        return Align(
          alignment: sectionAlignment,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: sectionMaxWidth),
            child: switch (layout) {
              SectionLayoutType.card => Container(
                  decoration: BoxDecoration(
                    color: sectionBg,
                    borderRadius:
                        BorderRadius.circular(sectionStyle.borderRadius + 4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: sectionShell,
                ),
              SectionLayoutType.centered => Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 760),
                    child: sectionShell,
                  ),
                ),
              SectionLayoutType.sidebar => Container(
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: AppColors.primary.withValues(alpha: 0.55),
                        width: 4,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _LayoutModeBanner(
                        icon: Icons.view_sidebar_outlined,
                        label: 'Sidebar Layout',
                        hint: section.sections.isEmpty
                            ? 'Add sub-sections to activate sidebar navigation'
                            : '${section.sections.length} sub-section(s) shown as nav items',
                        color: AppColors.primary,
                        isReady: section.sections.isNotEmpty,
                      ),
                      sectionShell,
                    ],
                  ),
                ),
              SectionLayoutType.dashboard => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 0.10),
                        sectionBg,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius:
                        BorderRadius.circular(sectionStyle.borderRadius),
                  ),
                  child: sectionShell,
                ),
              SectionLayoutType.overlay => Container(
                  decoration: BoxDecoration(
                    color: sectionBg,
                    borderRadius:
                        BorderRadius.circular(sectionStyle.borderRadius),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.28),
                      width: 2,
                    ),
                  ),
                  child: sectionShell,
                ),
              SectionLayoutType.accordion => Container(
                  decoration: BoxDecoration(
                    color: sectionBg,
                    borderRadius:
                        BorderRadius.circular(sectionStyle.borderRadius),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.22),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _LayoutModeBanner(
                        icon: Icons.expand_more,
                        label: 'Accordion Layout',
                        hint: 'Section collapses/expands in the preview',
                        color: const Color(0xFF8B5CF6),
                        isReady: true,
                      ),
                      sectionShell,
                    ],
                  ),
                ),
              SectionLayoutType.wizard => Container(
                  decoration: BoxDecoration(
                    color: sectionBg,
                    borderRadius:
                        BorderRadius.circular(sectionStyle.borderRadius),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.14),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _LayoutModeBanner(
                        icon: Icons.linear_scale,
                        label: 'Wizard / Multi-Step Layout',
                        hint: section.sections.isEmpty
                            ? 'Add sub-sections - each becomes a step'
                            : '${section.sections.length} step(s) with Next/Back navigation',
                        color: const Color(0xFF10B981),
                        isReady: section.sections.isNotEmpty,
                      ),
                      sectionShell,
                    ],
                  ),
                ),
              SectionLayoutType.masonry => Container(
                  decoration: BoxDecoration(
                    color: sectionBg,
                    borderRadius:
                        BorderRadius.circular(sectionStyle.borderRadius),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.10),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _LayoutModeBanner(
                        icon: Icons.dashboard_outlined,
                        label: 'Masonry Layout',
                        hint: section.sections.length < 2
                            ? 'Add at least 2 sub-sections for staggered columns'
                            : '${section.sections.length} sub-sections in 2 staggered columns',
                        color: const Color(0xFFF59E0B),
                        isReady: section.sections.length >= 2,
                      ),
                      sectionShell,
                    ],
                  ),
                ),
              SectionLayoutType.tabbed => Container(
                  decoration: BoxDecoration(
                    color: sectionBg,
                    borderRadius:
                        BorderRadius.circular(sectionStyle.borderRadius),
                    border: Border(
                      top: BorderSide(
                        color: AppColors.primary.withValues(alpha: 0.55),
                        width: 4,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _LayoutModeBanner(
                        icon: Icons.tab_outlined,
                        label: 'Tabbed Layout',
                        hint: 'Each sub-section is a tab',
                        color: const Color(0xFF6366F1),
                        isReady: section.sections.isNotEmpty,
                      ),
                      sectionShell,
                    ],
                  ),
                ),
              SectionLayoutType.standard => sectionShell,
              _ => sectionShell,
            },
          ),
        );
      },
    );
  }

}

class _SectionMetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;

  const _SectionMetaChip({
    required this.icon,
    required this.label,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final fg = selected ? AppColors.primary : AppColors.textGrey;
    final bg = selected
        ? AppColors.primary.withValues(alpha: 0.08)
        : AppColors.builderElement.withValues(alpha: 0.12);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.25)
              : AppColors.borderLight,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: DesignTokens.fontS,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Layout mode info banner shown in the builder canvas
// isReady = false → shows an amber "setup needed" warning
// isReady = true  → shows a green "active" badge
// ---------------------------------------------------------------------------
class _LayoutModeBanner extends StatelessWidget {
  final IconData icon;
  final String label;
  final String hint;
  final Color color;
  final bool isReady;

  const _LayoutModeBanner({
    required this.icon,
    required this.label,
    required this.hint,
    required this.color,
    required this.isReady,
  });

  @override
  Widget build(BuildContext context) {
    final bannerColor = isReady
        ? color.withValues(alpha: 0.08)
        : const Color(0xFFFFFBEB);
    final borderColor = isReady
        ? color.withValues(alpha: 0.25)
        : const Color(0xFFFBBF24);
    final iconColor = isReady ? color : const Color(0xFFD97706);
    final labelColor = isReady ? color : const Color(0xFF92400E);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: bannerColor,
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: Row(
        children: [
          Icon(isReady ? icon : Icons.info_outline, size: 15, color: iconColor),
          const SizedBox(width: DesignTokens.spaceS),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$label  ',
                    style: TextStyle(
                      fontSize: DesignTokens.fontS,
                      fontWeight: FontWeight.w700,
                      color: labelColor,
                    ),
                  ),
                  TextSpan(
                    text: hint,
                    style: TextStyle(
                      fontSize: DesignTokens.fontS,
                      fontWeight: FontWeight.normal,
                      color: labelColor.withValues(alpha: 0.75),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: isReady
                  ? color.withValues(alpha: 0.12)
                  : const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: borderColor),
            ),
            child: Text(
              isReady ? 'Active' : 'Setup needed',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: iconColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
