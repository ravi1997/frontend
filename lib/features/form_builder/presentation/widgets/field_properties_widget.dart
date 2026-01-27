import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/form_question.dart';
import '../../domain/entities/question_type.dart';
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

        // Sync main controllers
        if (_labelController.text != question.label) {
          _labelController.value = _labelController.value.copyWith(
            text: question.label,
            selection: TextSelection.collapsed(offset: question.label.length),
          );
        }
        if (_helperTextController.text != (question.helperText ?? '')) {
          _helperTextController.text = question.helperText ?? '';
        }
        if (_placeholderController.text != (question.placeholder ?? '')) {
          _placeholderController.text = question.placeholder ?? '';
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
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
                          // Debounce could be added here
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

                      // Options Editor (for Dropdown, Checkbox, Radio)
                      if (question.type == QuestionType.dropdown ||
                          question.type == QuestionType.checkboxes ||
                          question.type == QuestionType.multipleChoice) ...[
                        const SizedBox(height: 24),
                        _buildOptionsEditor(question),
                      ],

                      const SizedBox(height: 24),
                      const Text(
                        'VALIDATION',
                        style: TextStyle(
                          color: AppColors.textGrey,
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
                          color: AppColors.textGrey,
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
                              'Add logic to show/hide this field.',
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
          controller: controller,
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
          activeColor: AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildOptionsEditor(FormQuestion question) {
    final options = question.options ?? ['Option 1', 'Option 2', 'Option 3'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'OPTIONS',
          style: TextStyle(
            color: AppColors.textGrey,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: options.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            return _OptionRow(
              key: ValueKey('${question.id}_opt_$index'),
              initialValue: options[index],
              onChanged: (newValue) {
                final newOptions = List<String>.from(options);
                newOptions[index] = newValue;
                ref
                    .read(formBuilderControllerProvider(widget.formId).notifier)
                    .updateQuestion(question.copyWith(options: newOptions));
              },
              onDelete: () {
                final newOptions = List<String>.from(options);
                newOptions.removeAt(index);
                ref
                    .read(formBuilderControllerProvider(widget.formId).notifier)
                    .updateQuestion(question.copyWith(options: newOptions));
              },
            );
          },
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () {
            final newOptions = List<String>.from(options);
            newOptions.add('Option ${newOptions.length + 1}');
            ref
                .read(formBuilderControllerProvider(widget.formId).notifier)
                .updateQuestion(question.copyWith(options: newOptions));
          },
          icon: const Icon(Icons.add, size: 16),
          label: const Text('Add Option'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 44),
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}

class _OptionRow extends StatefulWidget {
  final String initialValue;
  final Function(String) onChanged;
  final VoidCallback onDelete;

  const _OptionRow({
    super.key,
    required this.initialValue,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  State<_OptionRow> createState() => _OptionRowState();
}

class _OptionRowState extends State<_OptionRow> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(_OptionRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue &&
        _controller.text != widget.initialValue) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.drag_indicator, color: AppColors.textGrey, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              fillColor: AppColors.builderElement,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide.none,
              ),
            ),
            style: const TextStyle(fontSize: 14),
            onChanged: widget.onChanged,
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.close, size: 18, color: AppColors.textGrey),
          onPressed: widget.onDelete,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }
}
