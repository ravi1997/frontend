import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/form_builder/domain/entities/form_question.dart';
import 'package:frontend/features/form_builder/domain/entities/form_style.dart';
import 'package:frontend/features/form_builder/presentation/controllers/form_builder_controller.dart';
import 'property_builder_utils.dart';

class FieldLayoutSettings extends ConsumerWidget {
  final String formId;
  final FormQuestion question;

  const FieldLayoutSettings({
    super.key,
    required this.formId,
    required this.question,
  });

  void _updateStyle(WidgetRef ref, QuestionStyle newStyle) {
    ref
        .read(formBuilderControllerProvider(formId).notifier)
        .updateQuestion(question.copyWith(style: newStyle));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'GRID SETTINGS',
          style: TextStyle(
            color: AppColors.textGrey,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 16),
        PropertyBuilderUtils.buildDropdown<int>(
          label: 'Columns Spanned',
          value: question.style.columnSpan,
          items: const [
            DropdownMenuItem(value: 1, child: Text('1 Column')),
            DropdownMenuItem(value: 2, child: Text('2 Columns')),
            DropdownMenuItem(value: 3, child: Text('3 Columns')),
            DropdownMenuItem(value: 4, child: Text('4 Columns')),
          ],
          onChanged: (val) {
            if (val != null) {
              _updateStyle(ref, question.style.copyWith(columnSpan: val));
            }
          },
        ),
        const SizedBox(height: 24),
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
          label: 'Width Mode',
          value: question.style.widthMode,
          items: const [
            DropdownMenuItem(value: 'auto', child: Text('Auto (Full Grid)')),
            DropdownMenuItem(value: 'fixed', child: Text('Fixed Width')),
          ],
          onChanged: (val) {
            if (val != null) {
              _updateStyle(ref, question.style.copyWith(widthMode: val));
            }
          },
        ),
        if (question.style.widthMode == 'fixed') ...[
          const SizedBox(height: 12),
          PropertyBuilderUtils.buildDropdown<String>(
            label: 'Fixed Width',
            value: question.style.fixedWidth,
            items: const [
              DropdownMenuItem(value: 'small', child: Text('Small (200px)')),
              DropdownMenuItem(value: 'medium', child: Text('Medium (400px)')),
              DropdownMenuItem(value: 'large', child: Text('Large (600px)')),
            ],
            onChanged: (val) {
              if (val != null) {
                _updateStyle(ref, question.style.copyWith(fixedWidth: val));
              }
            },
          ),
        ],
        const SizedBox(height: 24),
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
        const SizedBox(height: 24),
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
      ],
    );
  }
}
