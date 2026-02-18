import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/form_builder/domain/entities/form_question.dart';
import 'package:frontend/features/form_builder/domain/entities/question_type.dart';
import 'package:frontend/features/form_builder/presentation/controllers/form_builder_controller.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'property_builder_utils.dart';

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

        if (question.type == QuestionType.date)
          _buildDateSettings(context, ref, metadata),

        if (question.type == QuestionType.signature)
          _buildSignatureSettings(context, ref, metadata),

        if (question.type == QuestionType.shortText)
          _buildShortTextSettings(context, ref, metadata),

        if (![
          QuestionType.rating,
          QuestionType.slider,
          QuestionType.matrixChoice,
          QuestionType.date,
          QuestionType.signature,
          QuestionType.shortText,
        ].contains(question.type))
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

  Widget _buildShortTextSettings(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> metadata,
  ) {
    return Column(
      children: [
        PropertyBuilderUtils.buildSwitch(
          label: 'Obscure Text (Password)',
          value: metadata['obscureText'] ?? false,
          onChanged: (val) {
            ref
                .read(formBuilderControllerProvider(formId).notifier)
                .updateQuestionMetadata(question.id, {'obscureText': val});
          },
        ),
      ],
    );
  }

  Widget _buildDateSettings(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> metadata,
  ) {
    return Column(
      children: [
        PropertyBuilderUtils.buildDropdown<String>(
          label: 'Date Format',
          value: metadata['dateFormat'] ?? 'dd/MM/yyyy',
          items: const [
            DropdownMenuItem(value: 'dd/MM/yyyy', child: Text('DD/MM/YYYY')),
            DropdownMenuItem(value: 'MM/dd/yyyy', child: Text('MM/DD/YYYY')),
            DropdownMenuItem(value: 'yyyy-MM-dd', child: Text('YYYY-MM-DD')),
          ],
          onChanged: (val) {
            if (val != null) {
              ref
                  .read(formBuilderControllerProvider(formId).notifier)
                  .updateQuestionMetadata(question.id, {'dateFormat': val});
            }
          },
        ),
        const SizedBox(height: 12),
        PropertyBuilderUtils.buildDropdown<String>(
          label: 'Time Format',
          value: metadata['timeFormat'] ?? '24h',
          items: const [
            DropdownMenuItem(value: '12h', child: Text('12 Hour (AM/PM)')),
            DropdownMenuItem(value: '24h', child: Text('24 Hour')),
          ],
          onChanged: (val) {
            if (val != null) {
              ref
                  .read(formBuilderControllerProvider(formId).notifier)
                  .updateQuestionMetadata(question.id, {'timeFormat': val});
            }
          },
        ),
        const SizedBox(height: 12),
        PropertyBuilderUtils.buildDropdown<String>(
          label: 'Mode',
          value: metadata['mode'] ?? 'date',
          items: const [
            DropdownMenuItem(value: 'date', child: Text('Date Only')),
            DropdownMenuItem(value: 'time', child: Text('Time Only')),
            DropdownMenuItem(value: 'datetime', child: Text('Date & Time')),
          ],
          onChanged: (val) {
            if (val != null) {
              ref
                  .read(formBuilderControllerProvider(formId).notifier)
                  .updateQuestionMetadata(question.id, {'mode': val});
            }
          },
        ),
      ],
    );
  }

  Widget _buildSignatureSettings(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> metadata,
  ) {
    return Column(
      children: [
        PropertyBuilderUtils.buildColorPicker(
          label: 'Pen Color',
          value: metadata['penColor'] ?? '#000000',
          onChanged: (val) {
            ref
                .read(formBuilderControllerProvider(formId).notifier)
                .updateQuestionMetadata(question.id, {'penColor': val});
          },
        ),
        const SizedBox(height: 12),
        _buildNumberField(
          label: 'Stroke Width',
          value: metadata['strokeWidth'] ?? 2.0,
          onChanged: (val) {
            ref
                .read(formBuilderControllerProvider(formId).notifier)
                .updateQuestionMetadata(question.id, {'strokeWidth': val});
          },
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
        const SizedBox(height: 12),
        PropertyBuilderUtils.buildDropdown<String>(
          label: 'Icon Style',
          value: metadata['iconStyle'] ?? 'star',
          items: const [
            DropdownMenuItem(value: 'star', child: Text('Star')),
            DropdownMenuItem(value: 'heart', child: Text('Heart')),
            DropdownMenuItem(value: 'thumb_up', child: Text('Thumb Up')),
            DropdownMenuItem(value: 'sentiment', child: Text('Face')),
          ],
          onChanged: (val) {
            if (val != null) {
              ref
                  .read(formBuilderControllerProvider(formId).notifier)
                  .updateQuestionMetadata(question.id, {'iconStyle': val});
            }
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
    final rows =
        (metadata['rows'] as List?)?.cast<String>() ?? ['Row 1', 'Row 2'];
    final cols =
        (metadata['columns'] as List?)?.cast<String>() ??
        ['Col 1', 'Col 2', 'Col 3'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rows',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        const SizedBox(height: 8),
        _buildListEditor(context, rows, (newRows) {
          ref
              .read(formBuilderControllerProvider(formId).notifier)
              .updateQuestionMetadata(question.id, {'rows': newRows});
        }, 'Row'),
        const SizedBox(height: 24),
        const Text(
          'Columns',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        const SizedBox(height: 8),
        _buildListEditor(context, cols, (newCols) {
          ref
              .read(formBuilderControllerProvider(formId).notifier)
              .updateQuestionMetadata(question.id, {'columns': newCols});
        }, 'Column'),
      ],
    );
  }

  Widget _buildListEditor(
    BuildContext context,
    List<String> items,
    Function(List<String>) onChanged,
    String itemLabel,
  ) {
    return Column(
      children: [
        ...items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: item,
                    decoration: InputDecoration(
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
                    onChanged: (val) {
                      final newItems = List<String>.from(items);
                      newItems[index] = val;
                      onChanged(newItems);
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    size: 18,
                    color: AppColors.textGrey,
                  ),
                  onPressed: () {
                    final newItems = List<String>.from(items);
                    newItems.removeAt(index);
                    onChanged(newItems);
                  },
                ),
              ],
            ),
          );
        }),
        OutlinedButton.icon(
          onPressed: () {
            final newItems = List<String>.from(items);
            newItems.add('$itemLabel ${newItems.length + 1}');
            onChanged(newItems);
          },
          icon: const Icon(Icons.add, size: 16),
          label: Text('Add $itemLabel'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 36),
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
          ),
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
