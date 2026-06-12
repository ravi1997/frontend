import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../app/theme/app_colors.dart';
import 'package:frontend/core/widgets/app_states.dart';
import '../../../../core/widgets/error_state_widget.dart';

import 'package:frontend/modules/forms/services/form_builder_controller.dart';
import 'package:frontend/modules/forms/widgets/field_library_widget.dart';
import 'package:frontend/modules/forms/widgets/bulk_question_properties_widget.dart';
import 'package:frontend/modules/forms/widgets/field_properties_widget.dart';
import 'package:frontend/modules/forms/widgets/form_properties_widget.dart';
import 'package:frontend/modules/forms/widgets/section_properties_widget.dart';
import 'package:frontend/modules/forms/widgets/form_builder_top_bar.dart';
import 'package:frontend/modules/forms/widgets/form_canvas_widget.dart';
import 'package:frontend/modules/forms/models/question_type.dart';

class FormBuilderPage extends ConsumerStatefulWidget {
  final String formId;
  final String projectId;
  final String? mode;

  const FormBuilderPage({
    super.key,
    required this.formId,
    this.projectId = '',
    this.mode,
  });

  @override
  ConsumerState<FormBuilderPage> createState() => _FormBuilderPageState();
}

class _FormBuilderPageState extends ConsumerState<FormBuilderPage> {
  static const String _layoutBoxName = 'form_builder_layout_preferences';
  static const String _leftPanelWidthKey = 'left_panel_width';
  static const String _rightPanelWidthKey = 'right_panel_width';
  static const double _defaultLeftPanelWidth = 300;
  static const double _defaultRightPanelWidth = 320;
  static const double _minLeftPanelWidth = 200;
  static const double _maxLeftPanelWidth = 500;
  static const double _minRightPanelWidth = 250;
  static const double _maxRightPanelWidth = 600;

  double _leftPanelWidth = 300;
  double _rightPanelWidth = 320;

  double _readWidth(
    Box<dynamic> box,
    String key,
    double fallback,
    double min,
    double max,
  ) {
    final value = box.get(key);
    final width = value is num ? value.toDouble() : fallback;
    return width.clamp(min, max).toDouble();
  }

  @override
  void initState() {
    super.initState();
    _restoreLayoutPreferences();
  }

  Future<void> _restoreLayoutPreferences() async {
    final box = await Hive.openBox(_layoutBoxName);
    final leftWidth = _readWidth(
      box,
      _leftPanelWidthKey,
      _defaultLeftPanelWidth,
      _minLeftPanelWidth,
      _maxLeftPanelWidth,
    );
    final rightWidth = _readWidth(
      box,
      _rightPanelWidthKey,
      _defaultRightPanelWidth,
      _minRightPanelWidth,
      _maxRightPanelWidth,
    );

    if (!mounted) return;
    setState(() {
      _leftPanelWidth = leftWidth;
      _rightPanelWidth = rightWidth;
    });
  }

  Future<void> _saveLayoutPreferences() async {
    final box = await Hive.openBox(_layoutBoxName);
    await box.put(_leftPanelWidthKey, _leftPanelWidth);
    await box.put(_rightPanelWidthKey, _rightPanelWidth);
  }

  @override
  Widget build(BuildContext context) {
    final controllerKey = widget.projectId.isEmpty
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
              builderState.selectedQuestionIds.isNotEmpty ||
              builderState.selectedQuestionId != null ||
              builderState.isFormSelected ||
              builderState.selectedSectionId != null;
          final screenWidth = MediaQuery.of(context).size.width;
          final isCompactLayout = screenWidth < 1100;

          return isCompactLayout
              ? DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      _buildTopBar(context, controllerKey),
                      Container(
                        color: AppColors.builderSidebar,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: const TabBar(
                          labelColor: AppColors.primary,
                          unselectedLabelColor: AppColors.textGrey,
                          indicatorColor: AppColors.primary,
                          tabs: [
                            Tab(text: 'Library'),
                            Tab(text: 'Canvas'),
                            Tab(text: 'Properties'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            FieldLibraryWidget(
                              controllerKey: controllerKey,
                              formId: widget.formId,
                            ),
                            FormCanvasWidget(
                              controllerKey: controllerKey,
                              projectId: widget.projectId,
                              formId: widget.formId,
                              mode: widget.mode,
                            ),
                            _CompactPropertiesPane(
                              controllerKey: controllerKey,
                              projectId: widget.projectId,
                              formId: widget.formId,
                              builderState: builderState,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    _buildTopBar(context, controllerKey),

                    // Main Workspace
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Left Sidebar: Field Library
                          SizedBox(
                            width: _leftPanelWidth,
                            child: FieldLibraryWidget(
                              controllerKey: controllerKey,
                              formId: widget.formId,
                            ),
                          ),

                          // Left Resize Handle
                          MouseRegion(
                            cursor: SystemMouseCursors.resizeColumn,
                            child: GestureDetector(
                              onHorizontalDragUpdate: (details) {
                                setState(() {
                                  _leftPanelWidth += details.delta.dx;
                                  _leftPanelWidth = _leftPanelWidth
                                      .clamp(
                                        _minLeftPanelWidth,
                                        _maxLeftPanelWidth,
                                      )
                                      .toDouble();
                                });
                              },
                              onHorizontalDragEnd: (_) =>
                                  _saveLayoutPreferences(),
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
                              projectId: widget.projectId,
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
                                    _rightPanelWidth = _rightPanelWidth
                                        .clamp(
                                          _minRightPanelWidth,
                                          _maxRightPanelWidth,
                                        )
                                        .toDouble();
                                  });
                                },
                                onHorizontalDragEnd: (_) =>
                                    _saveLayoutPreferences(),
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
                                  if (builderState.selectedQuestionIds.length >
                                      1) {
                                    return BulkQuestionPropertiesWidget(
                                      controllerKey: controllerKey,
                                      selectedQuestionIds:
                                          builderState.selectedQuestionIds,
                                    );
                                  } else if (builderState.selectedQuestionId !=
                                      null) {
                                    return FieldPropertiesWidget(
                                      controllerKey: controllerKey,
                                      projectId: widget.projectId,
                                      formId: widget.formId,
                                      selectedQuestionId:
                                          builderState.selectedQuestionId!,
                                    );
                                  } else if (builderState.isFormSelected) {
                                    return FormPropertiesWidget(
                                      controllerKey: controllerKey,
                                      projectId: widget.projectId,
                                      formId: widget.formId,
                                    );
                                  } else if (builderState.selectedSectionId !=
                                      null) {
                                    return SectionPropertiesWidget(
                                      controllerKey: controllerKey,
                                      projectId: widget.projectId,
                                      formId: widget.formId,
                                      selectedSectionId:
                                          builderState.selectedSectionId!,
                                    );
                                  }
                                  return AppStates.empty(
                                    title: 'Nothing selected',
                                    subtitle:
                                        'Choose a form, section, or question on the canvas to edit its properties.',
                                    icon: Icons.touch_app_outlined,
                                  );
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
        error: (error, stack) => Scaffold(
          body: ErrorStateWidget(
            title: 'Failed to load form builder',
            message:
                'We couldn\'t load the form structure. This might be due to a connection issue or an invalid form ID.',
            error: error.toString(),
            onRetry: () =>
                ref.refresh(formBuilderControllerProvider(controllerKey)),
            onBack: () => context.pop(),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, String controllerKey) {
    return FormBuilderTopBar(
      controllerKey: controllerKey,
      projectId: widget.projectId,
      formId: widget.formId,
      mode: widget.mode,
    );
  }
}

class _CompactPropertiesPane extends StatelessWidget {
  final String controllerKey;
  final String projectId;
  final String formId;
  final dynamic builderState;

  const _CompactPropertiesPane({
    required this.controllerKey,
    required this.projectId,
    required this.formId,
    required this.builderState,
  });

  @override
  Widget build(BuildContext context) {
    if (builderState.selectedQuestionIds.length > 1) {
      return BulkQuestionPropertiesWidget(
        controllerKey: controllerKey,
        selectedQuestionIds: builderState.selectedQuestionIds,
      );
    }
    if (builderState.selectedQuestionId != null) {
      return FieldPropertiesWidget(
        controllerKey: controllerKey,
        projectId: projectId,
        formId: formId,
        selectedQuestionId: builderState.selectedQuestionId!,
      );
    }
    if (builderState.isFormSelected) {
      return FormPropertiesWidget(
        controllerKey: controllerKey,
        projectId: projectId,
        formId: formId,
      );
    }
    if (builderState.selectedSectionId != null) {
      return SectionPropertiesWidget(
        controllerKey: controllerKey,
        projectId: projectId,
        formId: formId,
        selectedSectionId: builderState.selectedSectionId!,
      );
    }
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text('Select a field, section, or form to edit properties.'),
      ),
    );
  }
}
