import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/form_builder/domain/entities/form_question.dart';
import 'package:frontend/features/form_builder/domain/entities/question_type.dart';
import 'package:frontend/features/form_builder/presentation/controllers/form_builder_controller.dart';
import 'property_builder_utils.dart';

class FieldValidationSettings extends ConsumerWidget {
  final String formId;
  final FormQuestion question;
  final TextEditingController regexController;
  final TextEditingController minLengthController;
  final TextEditingController maxLengthController;
  final TextEditingController minValueController;
  final TextEditingController maxValueController;
  final TextEditingController inputMaskController;
  final TextEditingController customErrorController;

  const FieldValidationSettings({
    super.key,
    required this.formId,
    required this.question,
    required this.regexController,
    required this.minLengthController,
    required this.maxLengthController,
    required this.minValueController,
    required this.maxValueController,
    required this.inputMaskController,
    required this.customErrorController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        PropertyBuilderUtils.buildSwitch(
          label: 'Required Field',
          value: question.isRequired,
          onChanged: (val) {
            ref
                .read(formBuilderControllerProvider(formId).notifier)
                .updateQuestion(question.copyWith(isRequired: val));
          },
        ),
        const SizedBox(height: 12),

        // Min/Max Length (Text/Paragraph)
        if (question.type == QuestionType.shortText ||
            question.type == QuestionType.paragraph) ...[
          Row(
            children: [
              Expanded(
                child: PropertyBuilderUtils.buildTextField(
                  label: 'Min Length',
                  controller: minLengthController,
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    final n = int.tryParse(val);
                    ref
                        .read(formBuilderControllerProvider(formId).notifier)
                        .updateQuestion(question.copyWith(minLength: n));
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PropertyBuilderUtils.buildTextField(
                  label: 'Max Length',
                  controller: maxLengthController,
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    final n = int.tryParse(val);
                    ref
                        .read(formBuilderControllerProvider(formId).notifier)
                        .updateQuestion(question.copyWith(maxLength: n));
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],

        // Min/Max Value (Number)
        if (question.type == QuestionType.number) ...[
          Row(
            children: [
              Expanded(
                child: PropertyBuilderUtils.buildTextField(
                  label: 'Min Value',
                  controller: minValueController,
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    final n = num.tryParse(val);
                    ref
                        .read(formBuilderControllerProvider(formId).notifier)
                        .updateQuestion(question.copyWith(minValue: n));
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PropertyBuilderUtils.buildTextField(
                  label: 'Max Value',
                  controller: maxValueController,
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    final n = num.tryParse(val);
                    ref
                        .read(formBuilderControllerProvider(formId).notifier)
                        .updateQuestion(question.copyWith(maxValue: n));
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],

        // Regex (Text types)
        if (question.type == QuestionType.shortText ||
            question.type == QuestionType.paragraph ||
            question.type == QuestionType.email ||
            question.type == QuestionType.url ||
            question.type == QuestionType.mobile) ...[
          PropertyBuilderUtils.buildTextField(
            label: 'Regex Validation',
            placeholder: 'e.g. ^[0-9]*\$',
            controller: regexController,
            onChanged: (val) {
              ref
                  .read(formBuilderControllerProvider(formId).notifier)
                  .updateQuestion(question.copyWith(validationRegex: val));
            },
          ),
          const SizedBox(height: 12),

          if (question.type == QuestionType.shortText ||
              question.type == QuestionType.mobile)
            PropertyBuilderUtils.buildTextField(
              label: 'Input Mask',
              placeholder: 'e.g. (###) ###-####',
              controller: inputMaskController,
              onChanged: (val) {
                ref
                    .read(formBuilderControllerProvider(formId).notifier)
                    .updateQuestion(question.copyWith(inputMask: val));
              },
            ),
          if (question.type == QuestionType.shortText ||
              question.type == QuestionType.mobile)
            const SizedBox(height: 12),

          PropertyBuilderUtils.buildTextField(
            label: 'Custom Error Message',
            placeholder: 'Error to show when validation fails',
            controller: customErrorController,
            onChanged: (val) {
              ref
                  .read(formBuilderControllerProvider(formId).notifier)
                  .updateQuestion(question.copyWith(customErrorMessage: val));
            },
          ),
          const SizedBox(height: 12),
        ],
        const SizedBox(height: 12),

        // Read Only Toggle
        PropertyBuilderUtils.buildSwitch(
          label: 'Read Only',
          value: question.isReadOnly,
          onChanged: (val) {
            ref
                .read(formBuilderControllerProvider(formId).notifier)
                .updateQuestion(question.copyWith(isReadOnly: val));
          },
        ),
        const SizedBox(height: 12),

        // Hidden Toggle
        PropertyBuilderUtils.buildSwitch(
          label: 'Hidden Field',
          value: question.isHidden,
          onChanged: (val) {
            ref
                .read(formBuilderControllerProvider(formId).notifier)
                .updateQuestion(question.copyWith(isHidden: val));
          },
        ),
      ],
    );
  }
}
