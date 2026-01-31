import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/form_builder/domain/entities/form_question.dart';
import 'package:frontend/features/form_builder/domain/entities/question_type.dart';
import 'package:frontend/features/form_builder/presentation/controllers/form_builder_controller.dart';
import 'property_builder_utils.dart';

class FieldGeneralSettings extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        PropertyBuilderUtils.buildTextField(
          label: 'Field Label',
          controller: labelController,
          onChanged: (val) {
            ref
                .read(formBuilderControllerProvider(formId).notifier)
                .updateQuestion(question.copyWith(label: val));
          },
        ),
        const SizedBox(height: 20),

        // Helper Text
        PropertyBuilderUtils.buildTextField(
          label: 'Helper Text',
          placeholder: 'e.g. Please enter your full name',
          controller: helperTextController,
          onChanged: (val) {
            ref
                .read(formBuilderControllerProvider(formId).notifier)
                .updateQuestion(question.copyWith(helperText: val));
          },
        ),
        const SizedBox(height: 20),

        // Placeholder
        PropertyBuilderUtils.buildTextField(
          label: 'Placeholder',
          placeholder: 'Input placeholder...',
          controller: placeholderController,
          onChanged: (val) {
            ref
                .read(formBuilderControllerProvider(formId).notifier)
                .updateQuestion(question.copyWith(placeholder: val));
          },
        ),

        // Options Editor
        if (question.type == QuestionType.dropdown ||
            question.type == QuestionType.checkboxes ||
            question.type == QuestionType.multipleChoice) ...[
          const SizedBox(height: 24),
          _buildOptionsEditor(ref, question),
        ],
      ],
    );
  }

  Widget _buildOptionsEditor(WidgetRef ref, FormQuestion question) {
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
                    .read(formBuilderControllerProvider(formId).notifier)
                    .updateQuestion(question.copyWith(options: newOptions));
              },
              onDelete: () {
                final newOptions = List<String>.from(options);
                newOptions.removeAt(index);
                ref
                    .read(formBuilderControllerProvider(formId).notifier)
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
                .read(formBuilderControllerProvider(formId).notifier)
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
