import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/app/theme/app_colors.dart';
import 'package:frontend/app/theme/tokens.dart';
import 'package:frontend/shared/models/form_models.dart';
import 'package:frontend/modules/forms/models/form_style.dart';
import 'package:frontend/modules/forms/services/form_builder_controller.dart';
import 'property_builder_utils.dart';
import 'package:frontend/modules/forms/models/question_type.dart';

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

  void _updateLayoutMetadata(
    WidgetRef ref,
    void Function(Map<String, dynamic> layout) update,
  ) {
    final layout = Map<String, dynamic>.from(question.metadata['layout'] ?? {});
    update(layout);
    ref
        .read(formBuilderControllerProvider('$projectId::$formId').notifier)
        .updateQuestionMetadata(question.id, {'layout': layout});
  }

  Widget _buildVisualSpanSelector(BuildContext context, WidgetRef ref, String currentSpan) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Visual Column Span',
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: DesignTokens.fontS,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            // Auto Button
            GestureDetector(
              onTap: () {
                _updateLayoutMetadata(ref, (layout) {
                  layout['span'] = 'auto';
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: currentSpan == 'auto' ? AppColors.brandBlue : Colors.white,
                  border: Border.all(
                    color: currentSpan == 'auto' ? AppColors.brandBlue : Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Auto',
                  style: TextStyle(
                    color: currentSpan == 'auto' ? Colors.white : AppColors.textDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // The Grid Blocks
            Expanded(
              child: Container(
                height: 38,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade50,
                ),
                child: Row(
                  children: List.generate(4, (index) {
                    final blockNum = index + 1;
                    final isHighlighted = currentSpan != 'auto' &&
                        (currentSpan == 'full' || int.tryParse(currentSpan) != null && int.parse(currentSpan) >= blockNum);
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _updateLayoutMetadata(ref, (layout) {
                            layout['span'] = blockNum.toString();
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: isHighlighted ? AppColors.brandBlue.withValues(alpha: 0.85) : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: Text(
                              '$blockNum/4',
                              style: TextStyle(
                                color: isHighlighted ? Colors.white : Colors.grey.shade600,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ],
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
              fontSize: DesignTokens.fontS,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: DesignTokens.spaceM),
          PropertyBuilderUtils.buildNumberSlider(
            label: 'Height (px)',
            value: question.styleObject.height,
            min: 8,
            max: 500,
            onChanged: (val) {
              _updateStyle(
                ref,
                question.styleObject.copyWith(height: val > 0 ? val : null),
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
            fontSize: DesignTokens.fontS,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: DesignTokens.spaceM),
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
              _updateLayoutMetadata(ref, (layout) {
                layout['widthPreset'] = val;
              });
            }
          },
        ),
        const SizedBox(height: DesignTokens.spaceS + 4),
        _buildVisualSpanSelector(context, ref, (question.metadata['layout']?['span'] as String?) ?? 'auto'),

        const SizedBox(height: DesignTokens.spaceS + 4),
        PropertyBuilderUtils.buildNumberSlider(
          label: 'Custom Height (Optional)',
          value: question.styleObject.height,
          min: 0,
          max: 500,
          onChanged: (val) {
            _updateStyle(
              ref,
              question.styleObject.copyWith(height: val > 0 ? val : null),
            );
          },
        ),
        const SizedBox(height: DesignTokens.spaceL),

        if (!hideLabelPosition) ...[
          const Text(
            'POSITIONING',
            style: TextStyle(
              color: AppColors.textGrey,
              fontSize: DesignTokens.fontS,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: DesignTokens.spaceM),
          PropertyBuilderUtils.buildDropdown<String>(
            label: 'Label Position',
            value: question.styleObject.labelPosition,
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
                _updateStyle(ref, question.styleObject.copyWith(labelPosition: val));
              }
            },
          ),
          if (question.styleObject.labelPosition == 'left') ...[
            const SizedBox(height: DesignTokens.spaceS + 4),
          PropertyBuilderUtils.buildNumberSlider(
            label: 'Label Column Width',
            value: question.styleObject.labelColumnWidth,
              min: 50,
              max: 300,
              onChanged: (val) => _updateStyle(
                ref,
                question.styleObject.copyWith(labelColumnWidth: val),
              ),
            ),
          ],
          const SizedBox(height: DesignTokens.spaceL),
        ],

        const Text(
          'SPACING',
          style: TextStyle(
            color: AppColors.textGrey,
            fontSize: DesignTokens.fontS,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: DesignTokens.spaceM),
        PropertyBuilderUtils.buildNumberSlider(
          label: 'Vertical Bottom Margin',
          value: question.styleObject.verticalMargin,
          min: 0,
          max: 64,
          onChanged: (val) =>
              _updateStyle(ref, question.styleObject.copyWith(verticalMargin: val)),
        ),
        const SizedBox(height: DesignTokens.spaceS + 4),
        PropertyBuilderUtils.buildNumberSlider(
          label: 'Internal Padding',
          value: question.styleObject.containerPadding,
          min: 0,
          max: 48,
          onChanged: (val) =>
              _updateStyle(ref, question.styleObject.copyWith(containerPadding: val)),
        ),
      ],
    );
  }
}
