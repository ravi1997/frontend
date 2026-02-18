import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/form_builder/domain/entities/form_question.dart';
import 'package:frontend/features/form_builder/domain/entities/form_style.dart';
import 'package:frontend/features/form_builder/presentation/controllers/form_builder_controller.dart';
import 'property_builder_utils.dart';
import 'package:frontend/features/form_builder/domain/entities/question_type.dart';

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
            value: question.style.height ?? 32,
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
          label: 'Width Mode',
          value: question.style.widthMode,
          items: const [
            DropdownMenuItem(value: 'auto', child: Text('Auto (Full Grid)')),
            DropdownMenuItem(value: 'fixed', child: Text('Fixed Width')),
            DropdownMenuItem(value: 'percentage', child: Text('Percentage')),
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
          const SizedBox(height: 12),
          PropertyBuilderUtils.buildDropdown<String>(
            label: 'Alignment',
            value: question.style.containerAlignment ?? 'left',
            items: const [
              DropdownMenuItem(value: 'left', child: Text('Left')),
              DropdownMenuItem(value: 'center', child: Text('Center')),
              DropdownMenuItem(value: 'right', child: Text('Right')),
            ],
            onChanged: (val) {
              if (val != null) {
                _updateStyle(
                  ref,
                  question.style.copyWith(containerAlignment: val),
                );
              }
            },
          ),
        ],
        if (question.style.widthMode == 'percentage') ...[
          const SizedBox(height: 12),
          PropertyBuilderUtils.buildDropdown<int>(
            label: 'Quick Columns',
            value: null,
            items: const [
              DropdownMenuItem(value: 100, child: Text('Full Width (100%)')),
              DropdownMenuItem(value: 66, child: Text('2/3 (66%)')),
              DropdownMenuItem(value: 50, child: Text('1/2 (50%)')),
              DropdownMenuItem(value: 33, child: Text('1/3 (33%)')),
              DropdownMenuItem(value: 25, child: Text('1/4 (25%)')),
            ],
            onChanged: (val) {
              if (val != null) {
                ref
                    .read(formBuilderControllerProvider(formId).notifier)
                    .updateQuestionMetadata(question.id, {
                      'widthPercentage': val,
                    });
              }
            },
          ),
          const SizedBox(height: 12),
          PropertyBuilderUtils.buildNumberSlider(
            label: 'Width (%)',
            value: (question.metadata?['widthPercentage'] ?? 100).toDouble(),
            min: 10,
            max: 100,
            onChanged: (val) {
              ref
                  .read(formBuilderControllerProvider(formId).notifier)
                  .updateQuestionMetadata(question.id, {
                    'widthPercentage': val.toInt(),
                  });
            },
          ),
        ],
        const SizedBox(height: 12),
        // Force Full Width on Mobile
        PropertyBuilderUtils.buildSwitch(
          label: 'Force Full Width on Mobile',
          value: question.metadata?['mobileFullWidth'] ?? true,
          onChanged: (val) {
            ref
                .read(formBuilderControllerProvider(formId).notifier)
                .updateQuestionMetadata(question.id, {'mobileFullWidth': val});
          },
        ),

        const SizedBox(height: 12),
        PropertyBuilderUtils.buildNumberSlider(
          label: 'Custom Height (Optional)',
          value: question.style.height ?? 0,
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
              value: question.style.labelColumnWidth ?? 120,
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
          value: question.style.containerPadding ?? 0,
          min: 0,
          max: 48,
          onChanged: (val) =>
              _updateStyle(ref, question.style.copyWith(containerPadding: val)),
        ),
      ],
    );
  }
}
