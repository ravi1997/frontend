import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

import '../controllers/form_builder_controller.dart';
import '../widgets/field_library_widget.dart';
import '../widgets/field_properties_widget.dart';
import '../widgets/form_canvas_widget.dart';

class FormBuilderPage extends ConsumerStatefulWidget {
  final String formId;

  const FormBuilderPage({super.key, required this.formId});

  @override
  ConsumerState<FormBuilderPage> createState() => _FormBuilderPageState();
}

class _FormBuilderPageState extends ConsumerState<FormBuilderPage> {
  @override
  Widget build(BuildContext context) {
    // Watch the form state
    final builderStateAsync = ref.watch(
      formBuilderControllerProvider(widget.formId),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: builderStateAsync.when(
        data: (builderState) {
          return Column(
            children: [
              // Top Bar
              _buildTopBar(context, builderState.form.title, ref),

              // Main Workspace
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Left Sidebar: Field Library
                    const SizedBox(width: 300, child: FieldLibraryWidget()),

                    // Center: Form Canvas
                    Expanded(child: FormCanvasWidget(formId: widget.formId)),

                    // Right Sidebar: Properties
                    // Only show if a question is selected
                    if (builderState.selectedQuestionId != null)
                      SizedBox(
                        width: 320,
                        child: FieldPropertiesWidget(
                          formId: widget.formId,
                          selectedQuestionId: builderState.selectedQuestionId!,
                        ),
                      ),
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

  Widget _buildTopBar(BuildContext context, String title, WidgetRef ref) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.builderSidebar,
        border: Border(
          bottom: BorderSide(color: AppColors.borderLight, width: 1),
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
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Editing',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildActionButton(
            icon: FontAwesomeIcons.eye,
            label: 'Preview',
            onTap: () {},
          ),
          const SizedBox(width: 8),
          _buildActionButton(
            icon: FontAwesomeIcons.clockRotateLeft,
            label: 'History',
            onTap: () {},
          ),
          const SizedBox(width: 8),
          _buildActionButton(
            icon: FontAwesomeIcons.shareNodes,
            label: 'Workflows',
            onTap: () {},
          ),
          const SizedBox(width: 16),
          // Save Button
          Container(
            height: 36,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextButton.icon(
              onPressed: () => ref
                  .read(formBuilderControllerProvider(widget.formId).notifier)
                  .saveForm(),
              icon: const Icon(
                Icons.save_outlined,
                size: 16,
                color: AppColors.primary,
              ),
              label: const Text(
                'Save Changes',
                style: TextStyle(color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Publish Button
          ElevatedButton(
            onPressed: () {},
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
