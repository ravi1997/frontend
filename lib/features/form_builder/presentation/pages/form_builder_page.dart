import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';

import '../controllers/form_builder_controller.dart';
import '../widgets/field_library_widget.dart';
import '../widgets/field_properties_widget.dart';
import '../widgets/form_properties_widget.dart';
import '../widgets/section_properties_widget.dart';
import '../widgets/form_builder_top_bar.dart';
import '../widgets/form_canvas_widget.dart';
import '../../domain/entities/question_type.dart';

class FormBuilderPage extends ConsumerStatefulWidget {
  final String formId;
  final String? projectId;
  final String? mode;

  const FormBuilderPage({
    super.key,
    required this.formId,
    this.projectId,
    this.mode,
  });

  @override
  ConsumerState<FormBuilderPage> createState() => _FormBuilderPageState();
}

class _FormBuilderPageState extends ConsumerState<FormBuilderPage> {
  double _leftPanelWidth = 300;
  double _rightPanelWidth = 320;

  @override
  Widget build(BuildContext context) {
    final controllerKey = widget.projectId == null
        ? widget.formId
        : '${widget.projectId}::${widget.formId}';

    // Watch the form state
    final builderStateAsync = ref.watch(
      formBuilderControllerProvider(controllerKey),
    );

    ref.listen(formBuilderControllerProvider(controllerKey), (previous, next) {
      if (next.hasValue) {
        final state = next.value!;
        // Auto-initialize first question if in question mode and empty
        if (widget.mode == 'question' &&
            state.form.sections.isNotEmpty &&
            state.form.sections[0].questions.isEmpty &&
            state.selectedQuestionId == null) {
          Future.microtask(() {
            ref
                .read(formBuilderControllerProvider(controllerKey).notifier)
                .addQuestion(state.form.sections[0].id, QuestionType.shortText);
          });
        }
      }
    });

    return Scaffold(
      backgroundColor: AppColors.builderBackground,
      body: builderStateAsync.when(
        data: (builderState) {
          final isRightPanelVisible =
              builderState.selectedQuestionId != null ||
              builderState.isFormSelected ||
              builderState.selectedSectionId != null;

          return Column(
            children: [
              _buildTopBar(context),

              // Main Workspace
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Left Sidebar: Field Library
                    SizedBox(
                      width: _leftPanelWidth,
                      child: FieldLibraryWidget(formId: widget.formId),
                    ),

                    // Left Resize Handle
                    MouseRegion(
                      cursor: SystemMouseCursors.resizeColumn,
                      child: GestureDetector(
                        onHorizontalDragUpdate: (details) {
                          setState(() {
                            _leftPanelWidth += details.delta.dx;
                            if (_leftPanelWidth < 200) _leftPanelWidth = 200;
                            if (_leftPanelWidth > 500) _leftPanelWidth = 500;
                          });
                        },
                        child: Container(
                          width: 1,
                          color: AppColors.builderBorder,
                        ),
                      ),
                    ),

                    // Center: Form Canvas
                    Expanded(
                      child: FormCanvasWidget(
                        controllerKey: controllerKey,
                        projectId: widget.projectId ?? '',
                        formId: widget.formId,
                        mode: widget.mode,
                      ),
                    ),

                    // Right Resize Handle & Sidebar
                    if (isRightPanelVisible) ...[
                      MouseRegion(
                        cursor: SystemMouseCursors.resizeColumn,
                        child: GestureDetector(
                          onHorizontalDragUpdate: (details) {
                            setState(() {
                              _rightPanelWidth -= details.delta.dx;
                              if (_rightPanelWidth < 250) {
                                _rightPanelWidth = 250;
                              }
                              if (_rightPanelWidth > 600) {
                                _rightPanelWidth = 600;
                              }
                            });
                          },
                          child: Container(
                            width: 1,
                            color: AppColors.builderBorder,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: _rightPanelWidth,
                        child: Builder(
                          builder: (context) {
                            if (builderState.selectedQuestionId != null) {
                              return FieldPropertiesWidget(
                                controllerKey: controllerKey,
                                projectId: widget.projectId ?? '',
                                formId: widget.formId,
                                selectedQuestionId:
                                    builderState.selectedQuestionId!,
                              );
                            } else if (builderState.isFormSelected) {
                              return FormPropertiesWidget(
                                controllerKey: controllerKey,
                                projectId: widget.projectId ?? '',
                                formId: widget.formId,
                              );
                            } else if (builderState.selectedSectionId != null) {
                              return SectionPropertiesWidget(
                                controllerKey: controllerKey,
                                projectId: widget.projectId ?? '',
                                formId: widget.formId,
                                selectedSectionId:
                                    builderState.selectedSectionId!,
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Error loading form: $error',
                style: const TextStyle(color: Colors.red),
              ),
              ElevatedButton(
                onPressed: () =>
                    ref.refresh(formBuilderControllerProvider(controllerKey)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return FormBuilderTopBar(
      controllerKey: widget.projectId == null
          ? widget.formId
          : '${widget.projectId}::${widget.formId}',
      projectId: widget.projectId,
      formId: widget.formId,
      mode: widget.mode,
    );
  }
}
