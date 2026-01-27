import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/form_question.dart';
import '../controllers/form_builder_controller.dart';

class FieldPropertiesWidget extends ConsumerStatefulWidget {
  final String formId;
  final String selectedQuestionId;

  const FieldPropertiesWidget({
    super.key,
    required this.formId,
    required this.selectedQuestionId,
  });

  @override
  ConsumerState<FieldPropertiesWidget> createState() =>
      _FieldPropertiesWidgetState();
}

class _FieldPropertiesWidgetState extends ConsumerState<FieldPropertiesWidget> {
  late TextEditingController _labelController;
  late TextEditingController _helperTextController;
  late TextEditingController _placeholderController;

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController();
    _helperTextController = TextEditingController();
    _placeholderController = TextEditingController();
  }

  @override
  void dispose() {
    _labelController.dispose();
    _helperTextController.dispose();
    _placeholderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final builderState = ref.watch(
      formBuilderControllerProvider(widget.formId),
    );

    return builderState.when(
      data: (state) {
        // Find the question
        FormQuestion? question;
        for (final section in state.form.sections) {
          final found = section.questions
              .where((q) => q.id == widget.selectedQuestionId)
              .firstOrNull;
          if (found != null) {
            question = found;
            break;
          }
        }

        if (question == null) return const SizedBox();

        // Sync controllers if ID changed or text inconsistent (handled carefully to avoid cursor jumps)
        if (_labelController.text != question.label) {
          _labelController.text = question.label;
        }
        if (_helperTextController.text != (question.helperText ?? '')) {
          _helperTextController.text = question.helperText ?? '';
        }
        if (_placeholderController.text != (question.placeholder ?? '')) {
          _placeholderController.text = question.placeholder ?? '';
        }

        return Container(
          decoration: BoxDecoration(
            color: AppColors.builderSidebar,
            border: Border(
              left: BorderSide(color: AppColors.borderLight, width: 1),
            ),
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(
                      FontAwesomeIcons.sliders,
                      size: 16,
                      color: AppColors.textGrey,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Field Properties',
                      style: TextStyle(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.textGrey,
                        size: 20,
                      ),
                      onPressed: () => ref
                          .read(
                            formBuilderControllerProvider(
                              widget.formId,
                            ).notifier,
                          )
                          .selectQuestion(null, null),
                    ),
                  ],
                ),
              ),
              const Divider(color: AppColors.borderLight, height: 1),

              // Properties Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Label
                      _buildTextField(
                        label: 'Field Label',
                        controller: _labelController,
                        onChanged: (val) {
                          ref
                              .read(
                                formBuilderControllerProvider(
                                  widget.formId,
                                ).notifier,
                              )
                              .updateQuestion(question!.copyWith(label: val));
                        },
                      ),
                      const SizedBox(height: 20),

                      // Helper Text
                      _buildTextField(
                        label: 'Helper Text',
                        placeholder: 'e.g. Please enter your full name',
                        controller: _helperTextController,
                        onChanged: (val) {
                          ref
                              .read(
                                formBuilderControllerProvider(
                                  widget.formId,
                                ).notifier,
                              )
                              .updateQuestion(
                                question!.copyWith(helperText: val),
                              );
                        },
                      ),
                      const SizedBox(height: 20),

                      // Placeholder
                      _buildTextField(
                        label: 'Placeholder',
                        placeholder: 'Input placeholder...',
                        controller: _placeholderController,
                        onChanged: (val) {
                          ref
                              .read(
                                formBuilderControllerProvider(
                                  widget.formId,
                                ).notifier,
                              )
                              .updateQuestion(
                                question!.copyWith(placeholder: val),
                              );
                        },
                      ),

                      const SizedBox(height: 24),
                      const Text(
                        'VALIDATION',
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Required Toggle
                      _buildSwitch(
                        label: 'Required Field',
                        value: question.isRequired,
                        onChanged: (val) {
                          ref
                              .read(
                                formBuilderControllerProvider(
                                  widget.formId,
                                ).notifier,
                              )
                              .updateQuestion(
                                question!.copyWith(isRequired: val),
                              );
                        },
                      ),

                      // Conditional Logic Placeholder
                      const SizedBox(height: 24),
                      const Text(
                        'CONDITIONAL LOGIC',
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.borderLight,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.builderElement,
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Add logic to show/hide this field based on other answers.',
                              style: TextStyle(
                                color: AppColors.textGrey,
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.add, size: 16),
                              label: const Text('Add Rule'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primary,
                                side: const BorderSide(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => const SizedBox(),
    );
  }

  Widget _buildTextField({
    required String label,
    String? placeholder,
    required TextEditingController controller,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textDark,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller:
              controller, // Using controller with sync logic in build is tricky.
          // Better approach for production: State in local widget initialized from props.
          // But for this demo, onChanged callback handles the state update effectively.
          // The issue is cursor jumping if we rebuild while typing.
          // We can just use the controller and update on submit or debounce.
          // For now, simpler: Use standard TextField with onChanged.
          // To fix cursor issues, usually we don't bind 'value' prop, but here we sync logic above.
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: const TextStyle(color: Colors.black26),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            filled: true,
            fillColor: AppColors.builderElement,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
          style: const TextStyle(color: AppColors.textDark),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildSwitch({
    required String label,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textDark,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: AppColors.primary,
        ),
      ],
    );
  }
}
