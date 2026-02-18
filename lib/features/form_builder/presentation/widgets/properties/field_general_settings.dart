import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/form_builder/domain/entities/form_question.dart';
import 'package:frontend/features/form_builder/domain/entities/form_question_option.dart';
import 'package:frontend/features/form_builder/domain/entities/question_type.dart';
import 'package:frontend/features/form_builder/presentation/controllers/form_builder_controller.dart';
import 'package:uuid/uuid.dart';
import 'property_builder_utils.dart';

class FieldGeneralSettings extends ConsumerStatefulWidget {
  // Changed to ConsumerStatefulWidget
  final String formId;
  final FormQuestion question;
  final TextEditingController labelController;
  final TextEditingController helperTextController;
  final TextEditingController placeholderController;

  const FieldGeneralSettings({
    super.key,
    required this.formId,
    required this.question,
    required this.labelController,
    required this.helperTextController,
    required this.placeholderController,
  });

  @override
  ConsumerState<FieldGeneralSettings> createState() =>
      _FieldGeneralSettingsState();
}

class _FieldGeneralSettingsState extends ConsumerState<FieldGeneralSettings> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _defaultValueController;
  late TextEditingController _dividerTextController;

  @override
  void initState() {
    super.initState();
    _defaultValueController = TextEditingController(
      text: widget.question.metadata?['defaultValue']?.toString() ?? '',
    );
    _dividerTextController = TextEditingController(
      text: widget.question.metadata?['dividerText']?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _defaultValueController.dispose();
    _dividerTextController.dispose();
    super.dispose();
  }

  bool get _showLabel =>
      widget.question.type != QuestionType.divider &&
      widget.question.type != QuestionType.spacer;

  bool get _showHelperText =>
      widget.question.type != QuestionType.divider &&
      widget.question.type != QuestionType.spacer;

  bool get _showPlaceholder => ![
    QuestionType.dropdown,
    QuestionType.checkboxes,
    QuestionType.multipleChoice,
    QuestionType.rating,
    QuestionType.matrixChoice,
    QuestionType.slider,
    QuestionType.fileUpload,
    QuestionType.image,
    QuestionType.signature,
    QuestionType.divider,
    QuestionType.spacer,
    QuestionType.date,
    QuestionType.time,
  ].contains(widget.question.type);

  bool get _showDefaultValue => [
    QuestionType.shortText,
    QuestionType.paragraph,
    QuestionType.number,
  ].contains(widget.question.type);

  bool get _showDividerText => widget.question.type == QuestionType.divider;

  bool get _showOptions => [
    QuestionType.dropdown,
    QuestionType.checkboxes,
    QuestionType.multipleChoice,
  ].contains(widget.question.type);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Field Type
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Field Type',
                style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.builderElement.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Text(
                  widget.question.type.label,
                  style: const TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Label
          if (_showLabel) ...[
            PropertyBuilderUtils.buildTextField(
              label: 'Field Label',
              controller: widget.labelController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Field label cannot be empty';
                }
                return null;
              },
              onChanged: (val) {
                if (_formKey.currentState!.validate()) {
                  ref
                      .read(
                        formBuilderControllerProvider(widget.formId).notifier,
                      )
                      .updateQuestionLabel(widget.question.id, val);
                }
              },
            ),
            const SizedBox(height: 20),
          ],

          // Divider Text
          if (_showDividerText) ...[
            PropertyBuilderUtils.buildTextField(
              label: 'Divider Text',
              placeholder: 'Section Break',
              controller: _dividerTextController,
              onChanged: (val) {
                ref
                    .read(formBuilderControllerProvider(widget.formId).notifier)
                    .updateQuestionMetadata(widget.question.id, {
                      'dividerText': val,
                    });
              },
            ),
            const SizedBox(height: 20),
          ],

          // Helper Text
          if (_showHelperText) ...[
            PropertyBuilderUtils.buildTextField(
              label: 'Helper Text',
              placeholder: 'e.g. Please enter your full name',
              controller: widget.helperTextController,
              onChanged: (val) {
                ref
                    .read(formBuilderControllerProvider(widget.formId).notifier)
                    .updateQuestionHelperText(widget.question.id, val);
              },
            ),
            const SizedBox(height: 20),
          ],

          // Placeholder
          if (_showPlaceholder) ...[
            PropertyBuilderUtils.buildTextField(
              label: 'Placeholder',
              placeholder: 'Input placeholder...',
              controller: widget.placeholderController,
              onChanged: (val) {
                ref
                    .read(formBuilderControllerProvider(widget.formId).notifier)
                    .updateQuestionPlaceholder(widget.question.id, val);
              },
            ),
            const SizedBox(height: 20),
          ],

          // Default Value
          if (_showDefaultValue) ...[
            PropertyBuilderUtils.buildTextField(
              label: 'Default Value',
              placeholder: 'Initial value',
              controller: _defaultValueController,
              onChanged: (val) {
                ref
                    .read(formBuilderControllerProvider(widget.formId).notifier)
                    .updateQuestionMetadata(widget.question.id, {
                      'defaultValue': val,
                    });
              },
            ),
            const SizedBox(height: 20),
          ],

          // Options Editor
          if (_showOptions) ...[
            const SizedBox(height: 4),
            _buildOptionsEditor(ref, widget.question),
          ],
        ],
      ),
    );
  }

  Widget _buildOptionsEditor(WidgetRef ref, FormQuestion question) {
    final options = question.options ?? [];

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
            final option = options[index];
            return _OptionRow(
              key: ValueKey(option.id),
              initialValue: option.label,
              onChanged: (newValue) {
                final newOptions = List<FormQuestionOption>.from(options);
                newOptions[index] = option.copyWith(
                  label: newValue,
                  value: newValue,
                );
                ref
                    .read(formBuilderControllerProvider(widget.formId).notifier)
                    .updateQuestion(question.copyWith(options: newOptions));
              },
              onDelete: () {
                final newOptions = List<FormQuestionOption>.from(options);
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
            final newOptions = List<FormQuestionOption>.from(options);
            newOptions.add(
              FormQuestionOption(
                id: const Uuid().v4(),
                label: 'Option ${newOptions.length + 1}',
                value: 'Option ${newOptions.length + 1}',
                order: newOptions.length,
              ),
            );
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
