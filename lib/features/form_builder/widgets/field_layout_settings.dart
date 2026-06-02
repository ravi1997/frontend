import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/form_models.dart';
import 'package:frontend/features/form_builder/models/form_style.dart';
import 'package:frontend/features/form_builder/services/form_builder_controller.dart';
import 'property_builder_utils.dart';
import 'package:frontend/features/form_builder/models/question_type.dart';

class FieldLayoutSettings extends ConsumerWidget {
  final String projectId;
  final String formId;
  final FormQuestion question;

  const FieldLayoutSettings({
    super.key,
    required this.projectId,
    required this.formId,
    required this.question,
  });

  void _updateStyle(WidgetRef ref, QuestionStyle newStyle) {
    ref
        .read(formBuilderControllerProvider('$projectId::$formId').notifier)
        .updateQuestion(
          question.copyWith(
            ui: {
              ...question.ui,
              'style': newStyle.toJson(),
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (question.type == QuestionType.spacer) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SPACER SETTINGS',
            style: TextStyle(
              color: AppColors.textGrey,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 16),
          PropertyBuilderUtils.buildNumberSlider(
            label: 'Height (px)',
            value: question.style.height,
            min: 8,
            max: 500,
            onChanged: (val) {
              _updateStyle(
                ref,
                question.style.copyWith(height: val > 0 ? val : null),
              );
            },
          ),
        ],
      );
    }

    final hideLabelPosition = [
      QuestionType.divider,
      QuestionType.image,
      QuestionType.signature,
    ].contains(question.type);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SIZING & WIDTH',
          style: TextStyle(
            color: AppColors.textGrey,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 16),
        PropertyBuilderUtils.buildDropdown<String>(
          label: 'Width Preset',
          value:
              (question.metadata['layout']?['widthPreset'] as String?) ??
              'auto',
          items: const [
            DropdownMenuItem(value: 'auto', child: Text('Auto (Smart Span)')),
            DropdownMenuItem(value: 'small', child: Text('Small (1 Col)')),
            DropdownMenuItem(value: 'medium', child: Text('Medium (2 Cols)')),
            DropdownMenuItem(value: 'large', child: Text('Large (3 Cols)')),
            DropdownMenuItem(value: 'full', child: Text('Full Width')),
          ],
          onChanged: (val) {
            if (val != null) {
              final layout = Map<String, dynamic>.from(
                question.metadata['layout'] ?? {},
              );
              layout['widthPreset'] = val;
              ref
                  .read(
                    formBuilderControllerProvider(
                      '$projectId::$formId',
                    ).notifier,
                  )
                  .updateQuestionMetadata(question.id, {'layout': layout});
            }
          },
        ),
        const SizedBox(height: 12),
        PropertyBuilderUtils.buildDropdown<String>(
          label: 'Manual Span (Optional Override)',
          value: (question.metadata['layout']?['span'] as String?) ?? 'auto',
          items: const [
            DropdownMenuItem(value: 'auto', child: Text('Auto')),
            DropdownMenuItem(value: '1', child: Text('1 Column')),
            DropdownMenuItem(value: '2', child: Text('2 Columns')),
            DropdownMenuItem(value: '3', child: Text('3 Columns')),
            DropdownMenuItem(value: '4', child: Text('4 Columns')),
            DropdownMenuItem(value: 'full', child: Text('Full Width')),
          ],
          onChanged: (val) {
            if (val != null) {
              final layout = Map<String, dynamic>.from(
                question.metadata['layout'] ?? {},
              );
              layout['span'] = val;
              ref
                  .read(
                    formBuilderControllerProvider(
                      '$projectId::$formId',
                    ).notifier,
                  )
                  .updateQuestionMetadata(question.id, {'layout': layout});
            }
          },
        ),

        const SizedBox(height: 12),
        PropertyBuilderUtils.buildNumberSlider(
          label: 'Custom Height (Optional)',
          value: question.style.height,
          min: 0,
          max: 500,
          onChanged: (val) {
            _updateStyle(
              ref,
              question.style.copyWith(height: val > 0 ? val : null),
            );
          },
        ),
        const SizedBox(height: 24),

        if (!hideLabelPosition) ...[
          const Text(
            'POSITIONING',
            style: TextStyle(
              color: AppColors.textGrey,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 16),
          PropertyBuilderUtils.buildDropdown<String>(
            label: 'Label Position',
            value: question.style.labelPosition,
            items: const [
              DropdownMenuItem(value: 'top', child: Text('Top Aligned')),
              DropdownMenuItem(value: 'left', child: Text('Left Aligned')),
              DropdownMenuItem(
                value: 'floating',
                child: Text('Floating / Inline'),
              ),
              DropdownMenuItem(value: 'hidden', child: Text('Hidden')),
            ],
            onChanged: (val) {
              if (val != null) {
                _updateStyle(ref, question.style.copyWith(labelPosition: val));
              }
            },
          ),
          if (question.style.labelPosition == 'left') ...[
            const SizedBox(height: 12),
          PropertyBuilderUtils.buildNumberSlider(
            label: 'Label Column Width',
            value: question.style.labelColumnWidth,
              min: 50,
              max: 300,
              onChanged: (val) => _updateStyle(
                ref,
                question.style.copyWith(labelColumnWidth: val),
              ),
            ),
          ],
          const SizedBox(height: 24),
        ],

        const Text(
          'SPACING',
          style: TextStyle(
            color: AppColors.textGrey,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 16),
        PropertyBuilderUtils.buildNumberSlider(
          label: 'Vertical Bottom Margin',
          value: question.style.verticalMargin,
          min: 0,
          max: 64,
          onChanged: (val) =>
              _updateStyle(ref, question.style.copyWith(verticalMargin: val)),
        ),
        const SizedBox(height: 12),
        PropertyBuilderUtils.buildNumberSlider(
          label: 'Internal Padding',
          value: question.style.containerPadding,
          min: 0,
          max: 48,
          onChanged: (val) =>
              _updateStyle(ref, question.style.copyWith(containerPadding: val)),
        ),
      ],
    );
  }
}
