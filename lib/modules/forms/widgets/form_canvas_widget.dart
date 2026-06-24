import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../app/localization/locale_controller.dart';
import 'package:frontend/modules/forms/models/custom_field_template.dart';
import 'package:frontend/modules/forms/models/form_layout_type.dart';
import 'package:frontend/modules/forms/services/form_builder_controller.dart';
import 'section_widget.dart';
import 'package:frontend/shared/models/form_models.dart';
import 'package:frontend/core/services/collaboration_service.dart';

class FormCanvasWidget extends ConsumerStatefulWidget {
  final String controllerKey;
  final String projectId;
  final String formId;
  final String? mode;

  const FormCanvasWidget({
    super.key,
    required this.controllerKey,
    required this.projectId,
    required this.formId,
    this.mode,
  });

  @override
  ConsumerState<FormCanvasWidget> createState() => _FormCanvasWidgetState();
}

class _FormCanvasWidgetState extends ConsumerState<FormCanvasWidget> {
  @override
  void initState() {
    super.initState();
    // Initialize room subscription
    Future.microtask(() {
      ref.read(collaborationProvider(widget.formId).notifier);
    });
  }

  @override
  Widget build(BuildContext context) {
    final builderState = ref.watch(
      formBuilderControllerProvider(widget.controllerKey),
    );

    // Watch for selected question changes to acquire/release leases
    ref.listen<String?>(
      formBuilderControllerProvider(widget.controllerKey).select((state) => state.value?.selectedQuestionId),
      (previous, next) {
        final collabNotifier = ref.read(collaborationProvider(widget.formId).notifier);
        if (previous != null) {
          collabNotifier.releaseLease(previous);
        }
        if (next != null) {
          collabNotifier.acquireLease(next);
          collabNotifier.updateCursor(next);
        }
      },
    );

    // Watch for collaboration collisions
    ref.listen(collaborationProvider(widget.formId), (previous, next) {
      if (next.collisionTarget != null) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Edit Collision Warning'),
            content: Text('This field is currently locked by ${next.collisionHeldBy}. Please wait or edit a different section.'),
            actions: [
              TextButton(
                onPressed: () {
                  ref.read(collaborationProvider(widget.formId).notifier).clearCollision();
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    });

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

        return DragTarget<Object>(
          onWillAcceptWithDetails: (details) {
            if (details.data is CustomFieldTemplate) {
              final template = details.data as CustomFieldTemplate;
              return template.template_type == 'section' ||
                  template.template_type == 'workflow';
            }
            return false;
          },
          onAcceptWithDetails: (details) {
            final template = details.data as CustomFieldTemplate;
            ref
                .read(formBuilderControllerProvider(widget.controllerKey).notifier)
                .addFromTemplate(null, template);
          },
          builder: (context, candidateData, rejectedData) => GestureDetector(
            onTap: () {
              ref
                  .read(formBuilderControllerProvider(widget.controllerKey).notifier)
                  .selectQuestion(null, null);
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              color: canvasColor,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(DesignTokens.spaceXXL),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: formStyle.maxWidth),
                    child: Column(
                      children: [
                        // Form Title Input
                        InkWell(
                          onTap: () {
                            ref
                                .read(
                                  formBuilderControllerProvider(
                                    widget.controllerKey,
                                  ).notifier,
                                )
                                .selectQuestion(null, null);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: DesignTokens.spaceM,
                              horizontal: DesignTokens.spaceL,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(
                                DesignTokens.radiusS,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: DesignTokens.spaceS + 2,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Text(
                              () {
                                String titleText = state.form.title.translate(
                                  state.editingLocale,
                                );
                                if (widget.mode != null && widget.mode != 'form') {
                                  if (widget.mode == 'question') {
                                    titleText = 'Question Designer';
                                  }
                                  if (widget.mode == 'section') {
                                    titleText = 'Section Designer';
                                  }
                                  if (widget.mode == 'workflow') {
                                    titleText = 'Workflow Designer';
                                  }
                                }
                                return titleText.isEmpty
                                    ? 'Untitled Form'
                                    : titleText;
                              }(),
                              style: const TextStyle(
                                fontSize: DesignTokens.fontXL,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(height: DesignTokens.spaceL),

                        // Empty State
                        if (state.form.sections.isEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              vertical: DesignTokens.spaceXXL + 32,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.borderLight,
                                style: BorderStyle.none,
                              ),
                            ),
                            child: CustomPaint(
                              painter: _DashedBorderPainter(
                                color: AppColors.textGrey.withValues(
                                  alpha: 0.3,
                                ),
                                borderRadius: DesignTokens.radiusL,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FaIcon(FontAwesomeIcons.layerGroup,
                                    size: 48,
                                    color: AppColors.textGrey.withValues(
                                      alpha: 0.2,
                                    ),
                                  ),
                                  const SizedBox(height: DesignTokens.spaceL),
                                  const Text(
                                    'Your form is empty',
                                    style: TextStyle(
                                      fontSize: DesignTokens.fontL,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                  const SizedBox(height: DesignTokens.spaceM),
                                  const Text(
                                    'Start by adding a section or dragging a field',
                                    style: TextStyle(
                                      color: AppColors.textGrey,
                                      fontSize: DesignTokens.fontM,
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
                              final spacing = DesignTokens.spaceL;

                              int crossAxisCount = 1;
                              if (state.form.layout ==
                                  FormLayoutType.twoColumns.name) {
                                crossAxisCount = 2;
                              } else if (state.form.layout ==
                                  FormLayoutType.threeColumns.name) {
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
                                    child: SectionWidget(
                                      controllerKey: widget.controllerKey,
                                      projectId: widget.projectId,
                                      formId: widget.formId,
                                      section: section,
                                      sectionIndex: index,
                                      selectedQuestionId:
                                          state.selectedQuestionId,
                                      selectedQuestionIds:
                                          state.selectedQuestionIds,
                                      selectedSectionId:
                                          state.selectedSectionId,
                                      locale: state.editingLocale,
                                      mode: widget.mode,
                                    ),
                                  );

                                  return DragTarget<SectionDragData>(
                                    onWillAcceptWithDetails: (details) =>
                                        details.data.sectionId != section.id,
                                    onAcceptWithDetails: (details) {
                                      ref
                                          .read(
                                            formBuilderControllerProvider(
                                              widget.controllerKey,
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
                                                        BorderRadius.circular(
                                                          2,
                                                        ),
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

                        const SizedBox(height: DesignTokens.spaceL),

                        // Add Section Button (only if not in question/section/workflow mode)
                        if (widget.mode == null || widget.mode == 'form')
                          Center(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                debugPrint(
                                  'ADD_SECTION_CLICKED: controllerKey=${widget.controllerKey}, projectId=${widget.projectId}, formId=${widget.formId}',
                                );
                                ref
                                    .read(
                                      formBuilderControllerProvider(
                                        widget.controllerKey,
                                      ).notifier,
                                    )
                                    .addSection();
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Add New Section'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.builderElement,
                                foregroundColor: AppColors.textDark,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: DesignTokens.spaceL,
                                  vertical: DesignTokens.spaceS + 4,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    DesignTokens.radiusM,
                                  ),
                                ),
                              ),
                            ),
                          ),

                        const SizedBox(height: DesignTokens.spaceXXL + 12),
                      ],
                    ),
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

}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double borderRadius;
  final double strokeWidth = 1;
  final double dashWidth = 5;
  final double dashSpace = 3;

  _DashedBorderPainter({
    this.color = AppColors.borderLight,
    this.borderRadius = 6,
  });

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
