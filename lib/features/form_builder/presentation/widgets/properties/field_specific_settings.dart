import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/form_builder/domain/entities/form_question.dart';
import 'package:frontend/features/form_builder/domain/entities/question_type.dart';
import 'package:frontend/features/form_builder/presentation/controllers/form_builder_controller.dart';
import 'package:frontend/core/theme/app_colors.dart';

class FieldSpecificSettings extends ConsumerWidget {
  final String formId;
  final FormQuestion question;

  const FieldSpecificSettings({
    super.key,
    required this.formId,
    required this.question,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metadata = question.metadata ?? {};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Specific Settings for ${question.type.label}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textGrey,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 16),

        if (question.type == QuestionType.rating)
          _buildRatingSettings(context, ref, metadata),

        if (question.type == QuestionType.slider)
          _buildSliderSettings(context, ref, metadata),

        if (question.type == QuestionType.matrixChoice)
          _buildMatrixSettings(context, ref, metadata),

        if (question.type != QuestionType.rating &&
            question.type != QuestionType.slider &&
            question.type != QuestionType.matrixChoice)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'No specific settings for this field type.',
                style: TextStyle(color: AppColors.textGrey, fontSize: 13),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildRatingSettings(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> metadata,
  ) {
    return Column(
      children: [
        _buildNumberField(
          label: 'Number of Stars',
          value: metadata['maxStars'] ?? 5,
          onChanged: (val) {
            ref
                .read(formBuilderControllerProvider(formId).notifier)
                .updateQuestionMetadata(question.id, {'maxStars': val});
          },
        ),
      ],
    );
  }

  Widget _buildSliderSettings(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> metadata,
  ) {
    return Column(
      children: [
        _buildNumberField(
          label: 'Minimum Value',
          value: metadata['min'] ?? 0,
          onChanged: (val) {
            ref
                .read(formBuilderControllerProvider(formId).notifier)
                .updateQuestionMetadata(question.id, {'min': val});
          },
        ),
        const SizedBox(height: 12),
        _buildNumberField(
          label: 'Maximum Value',
          value: metadata['max'] ?? 100,
          onChanged: (val) {
            ref
                .read(formBuilderControllerProvider(formId).notifier)
                .updateQuestionMetadata(question.id, {'max': val});
          },
        ),
        const SizedBox(height: 12),
        _buildNumberField(
          label: 'Step Size',
          value: metadata['step'] ?? 1,
          onChanged: (val) {
            ref
                .read(formBuilderControllerProvider(formId).notifier)
                .updateQuestionMetadata(question.id, {'step': val});
          },
        ),
      ],
    );
  }

  Widget _buildMatrixSettings(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> metadata,
  ) {
    // Basic row/col count for now
    final rows = (metadata['rows'] as List?)?.length ?? 2;
    final cols = (metadata['columns'] as List?)?.length ?? 3;

    return Column(
      children: [
        _buildNumberField(
          label: 'Number of Rows',
          value: rows,
          onChanged: (val) {
            final newRows = List.generate(val.toInt(), (i) => 'Row ${i + 1}');
            ref
                .read(formBuilderControllerProvider(formId).notifier)
                .updateQuestionMetadata(question.id, {'rows': newRows});
          },
        ),
        const SizedBox(height: 12),
        _buildNumberField(
          label: 'Number of Columns',
          value: cols,
          onChanged: (val) {
            final newCols = List.generate(val.toInt(), (i) => 'Col ${i + 1}');
            ref
                .read(formBuilderControllerProvider(formId).notifier)
                .updateQuestionMetadata(question.id, {'columns': newCols});
          },
        ),
      ],
    );
  }

  Widget _buildNumberField({
    required String label,
    required num value,
    required Function(num) onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: AppColors.textDark),
          ),
        ),
        Expanded(
          child: SizedBox(
            height: 36,
            child: TextField(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                isDense: true,
              ),
              keyboardType: TextInputType.number,
              controller: TextEditingController(text: value.toString()),
              onSubmitted: (val) {
                final n = num.tryParse(val);
                if (n != null) onChanged(n);
              },
            ),
          ),
        ),
      ],
    );
  }
}
