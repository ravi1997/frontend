import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/localization/locale_controller.dart';
import '../../domain/entities/custom_field_template.dart';
import '../../domain/entities/form_layout_type.dart';
import '../controllers/form_builder_controller.dart';
import 'form_drag_data.dart';
import 'section_widget.dart';

class FormCanvasWidget extends ConsumerWidget {
  final String formId;
  final String? mode;

  const FormCanvasWidget({super.key, required this.formId, this.mode});

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
                .read(formBuilderControllerProvider(formId).notifier)
                .addFromTemplate(null, template);
          },
          builder: (context, candidateData, rejectedData) => GestureDetector(
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
                          mode,
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
                                color: AppColors.textGrey.withValues(
                                  alpha: 0.3,
                                ),
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
                                  const Text(
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
                                    child: SectionWidget(
                                      formId: formId,
                                      section: section,
                                      sectionIndex: index,
                                      selectedQuestionId:
                                          state.selectedQuestionId,
                                      selectedSectionId:
                                          state.selectedSectionId,
                                      locale: state.editingLocale,
                                      mode: mode,
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

                        const SizedBox(height: 24),

                        // Add Section Button (only if not in question/section/workflow mode)
                        if (mode == null || mode == 'form')
                          Center(
                            child: ElevatedButton.icon(
                              onPressed: () => ref
                                  .read(
                                    formBuilderControllerProvider(
                                      formId,
                                    ).notifier,
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
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildFormHeader(
    Object? title,
    WidgetRef ref,
    String locale,
    String? mode,
  ) {
    String titleText = title.translate(locale);

    if (mode != null && mode != 'form') {
      if (mode == 'question') titleText = 'Question Designer';
      if (mode == 'section') titleText = 'Section Designer';
      if (mode == 'workflow') titleText = 'Workflow Designer';
    }

    return InkWell(
      onTap: () {
        ref
            .read(formBuilderControllerProvider(formId).notifier)
            .selectQuestion(null, null);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          titleText.isEmpty ? 'Untitled Form' : titleText,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
          textAlign: TextAlign.center,
        ),
      ),
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
