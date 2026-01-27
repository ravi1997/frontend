import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/theme/app_colors.dart';

import '../../domain/entities/question_type.dart';

class FieldLibraryWidget extends ConsumerWidget {
  const FieldLibraryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.builderSidebar,
        border: Border(
          right: BorderSide(color: AppColors.borderLight, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Field Library',
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Click or drag to add fields',
                  style: TextStyle(color: AppColors.textGrey, fontSize: 12),
                ),
                const SizedBox(height: 20),
                // AI Assistant Button - Updated styling
                Container(
                  width: double.infinity,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 0.1),
                        AppColors.primary.withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          FontAwesomeIcons.wandMagicSparkles,
                          color: AppColors.primary,
                          size: 14,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'AI Assistant',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: QuestionType.values.map((type) {
                  return _buildFieldButton(context, type);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldButton(BuildContext context, QuestionType type) {
    return Draggable<QuestionType>(
      data: type,
      feedback: Material(
        color: Colors.transparent,
        child: Opacity(
          opacity: 0.8,
          child: _FieldButtonCard(type: type, width: 120),
        ),
      ),
      child: _FieldButtonCard(
        type: type,
        width: 120, // Strict sizing
      ),
    );
  }
}

class _FieldButtonCard extends StatelessWidget {
  final QuestionType type;
  final double width;

  const _FieldButtonCard({required this.type, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 90, // Taller for better proportion
      decoration: BoxDecoration(
        color: AppColors.builderElement, // Slate 800
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(_getIconForType(type), color: AppColors.textGrey, size: 22),
          const SizedBox(height: 12),
          Text(
            type.label,
            style: const TextStyle(
              color: AppColors.textDark,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  IconData _getIconForType(QuestionType type) {
    switch (type) {
      case QuestionType.shortText:
        return FontAwesomeIcons.textWidth;
      case QuestionType.paragraph:
        return FontAwesomeIcons.alignLeft;
      case QuestionType.number:
        return FontAwesomeIcons.hashtag;
      case QuestionType.date:
        return FontAwesomeIcons.calendar;
      case QuestionType.time:
        return FontAwesomeIcons.clock;
      case QuestionType.dropdown:
        return FontAwesomeIcons.caretDown;
      case QuestionType.checkboxes:
        return FontAwesomeIcons.squareCheck;
      case QuestionType.multipleChoice:
        return FontAwesomeIcons.circleDot;
      case QuestionType.fileUpload:
        return FontAwesomeIcons.fileArrowUp;
      case QuestionType.email:
        return FontAwesomeIcons.envelope;
      case QuestionType.mobile:
        return FontAwesomeIcons.phone;
      case QuestionType.url:
        return FontAwesomeIcons.link;
    }
  }
}
