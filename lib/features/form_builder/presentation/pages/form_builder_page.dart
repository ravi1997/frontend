import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/builder_form.dart';

import '../controllers/form_builder_controller.dart';
import '../widgets/field_library_widget.dart';
import '../widgets/field_properties_widget.dart';
import '../widgets/form_properties_widget.dart';
import '../widgets/section_properties_widget.dart';
import '../widgets/form_canvas_widget.dart';
import '../widgets/feature_verification_dialog.dart';
import '../widgets/workflow_configuration_dialog.dart';
import '../widgets/publish_success_dialog.dart';

class FormBuilderPage extends ConsumerStatefulWidget {
  final String formId;

  const FormBuilderPage({super.key, required this.formId});

  @override
  ConsumerState<FormBuilderPage> createState() => _FormBuilderPageState();
}

class _FormBuilderPageState extends ConsumerState<FormBuilderPage> {
  double _leftPanelWidth = 300;
  double _rightPanelWidth = 320;

  @override
  Widget build(BuildContext context) {
    // Watch the form state
    final builderStateAsync = ref.watch(
      formBuilderControllerProvider(widget.formId),
    );

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
              // Top Bar
              _buildTopBar(
                context,
                builderState.form,
                ref,
                builderState.isSaving,
              ),

              // Main Workspace
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Left Sidebar: Field Library
                    SizedBox(
                      width: _leftPanelWidth,
                      child: const FieldLibraryWidget(),
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
                    Expanded(child: FormCanvasWidget(formId: widget.formId)),

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
                                formId: widget.formId,
                                selectedQuestionId:
                                    builderState.selectedQuestionId!,
                              );
                            } else if (builderState.isFormSelected) {
                              return FormPropertiesWidget(
                                formId: widget.formId,
                              );
                            } else if (builderState.selectedSectionId != null) {
                              return SectionPropertiesWidget(
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
                    ref.refresh(formBuilderControllerProvider(widget.formId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(
    BuildContext context,
    BuilderForm form,
    WidgetRef ref,
    bool isSaving,
  ) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.builderSidebar,
        border: Border(
          bottom: BorderSide(color: AppColors.builderBorder, width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textGrey),
            onPressed: () => context.go('/dashboard'),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Row(
              children: [
                InkWell(
                  onTap: () => ref
                      .read(
                        formBuilderControllerProvider(widget.formId).notifier,
                      )
                      .selectForm(),
                  child: Text(
                    form.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'v${form.version}',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Editing',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildActionButton(
            icon: FontAwesomeIcons.listCheck,
            label: 'Features',
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => const FeatureVerificationDialog(),
              );
            },
          ),
          const SizedBox(width: 8),
          _buildActionButton(
            icon: FontAwesomeIcons.eye,
            label: 'Preview',
            onTap: () {
              context.push('/form-preview', extra: form);
            },
          ),
          const SizedBox(width: 8),
          _buildActionButton(
            icon: FontAwesomeIcons.clockRotateLeft,
            label: 'History',
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Version History'),
                  content: SizedBox(
                    width: 400,
                    height: 300,
                    child: form.versionHistory.isEmpty
                        ? const Center(child: Text('No version history yet.'))
                        : ListView.separated(
                            itemCount: form.versionHistory.length,
                            separatorBuilder: (_, __) => const Divider(),
                            itemBuilder: (context, index) {
                              final history = form.versionHistory.reversed
                                  .toList()[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  radius: 16,
                                  backgroundColor: AppColors.primary,
                                  child: Text(
                                    history.version.substring(0, 1),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                title: Text('Version ${history.version}'),
                                subtitle: Text(
                                  'Published on ${history.createdAt.toString().split('.')[0]}',
                                ),
                                trailing: const Icon(
                                  Icons.chevron_right,
                                  size: 16,
                                ),
                              );
                            },
                          ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 8),
          _buildActionButton(
            icon: FontAwesomeIcons.shareNodes,
            label: 'Workflows',
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => WorkflowConfigurationDialog(
                  initialWorkflows: form.workflows,
                  onSave: (config) {
                    ref
                        .read(
                          formBuilderControllerProvider(widget.formId).notifier,
                        )
                        .updateWorkflows(config);
                  },
                ),
              );
            },
          ),
          const SizedBox(width: 16),
          // Save Button
          Container(
            height: 36,
            decoration: BoxDecoration(
              border: Border.all(
                color: isSaving ? AppColors.textGrey : AppColors.primary,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextButton.icon(
              onPressed: isSaving
                  ? null
                  : () {
                      ref
                          .read(
                            formBuilderControllerProvider(
                              widget.formId,
                            ).notifier,
                          )
                          .saveForm()
                          .then((success) {
                            if (success && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Form saved successfully'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else if (!success && context.mounted) {
                              final error = ref
                                  .read(
                                    formBuilderControllerProvider(
                                      widget.formId,
                                    ),
                                  )
                                  .value
                                  ?.error;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Failed to save form: ${error ?? "Unknown error"}',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          });
                    },
              icon: isSaving
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(
                      Icons.save_outlined,
                      size: 16,
                      color: AppColors.primary,
                    ),
              label: Text(
                'Save Changes',
                style: TextStyle(
                  color: isSaving ? AppColors.textGrey : AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Publish Button
          ElevatedButton(
            onPressed: () async {
              final success = await ref
                  .read(formBuilderControllerProvider(widget.formId).notifier)
                  .publishForm();

              if (success && context.mounted) {
                showDialog(
                  context: context,
                  builder: (_) => PublishSuccessDialog(formId: widget.formId),
                );
              } else if (!success && context.mounted) {
                final error = ref
                    .read(formBuilderControllerProvider(widget.formId))
                    .value
                    ?.error;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Failed to publish form: ${error ?? "Unknown error"}',
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
            child: const Text('Publish'),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 14, color: AppColors.textGrey),
      label: Text(
        label,
        style: const TextStyle(color: AppColors.textGrey, fontSize: 13),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }
}
