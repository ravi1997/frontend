import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/models/form_models.dart';
import 'package:frontend/features/form_builder/domain/entities/form_layout_type.dart';
import 'package:frontend/features/form_builder/presentation/controllers/form_builder_controller.dart';
import 'property_builder_utils.dart';

class FormLayoutSettings extends ConsumerWidget {
  final String projectId;
  final String formId;
  final BuilderForm form;

  const FormLayoutSettings({
    super.key,
    required this.projectId,
    required this.formId,
    required this.form,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PropertyBuilderUtils.buildDropdown<FormLayoutType>(
          label: 'Form layout',
          value: form.layout,
          items: FormLayoutType.values.map((type) {
            return DropdownMenuItem(value: type, child: Text(type.label));
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              ref
                  .read(
                    formBuilderControllerProvider(
                      '$projectId::$formId',
                    ).notifier,
                  )
                  .updateForm(form.copyWith(uiType: val.name));
            }
          },
        ),
        const SizedBox(height: 24),
        const Text(
          'WHOLE-FORM SECTION ARRANGEMENT',
          style: TextStyle(
            color: AppColors.textGrey,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 16),
        PropertyBuilderUtils.buildDropdown<String>(
          label: 'Form Type',
          value: form.style.layoutType,
          items: const [
            DropdownMenuItem(
              value: 'standard',
              child: Text('Standard (Scrolling)'),
            ),
            DropdownMenuItem(value: 'card', child: Text('Card Presentation')),
            DropdownMenuItem(value: 'step', child: Text('Step-by-Step')),
          ],
          onChanged: (val) {
            if (val != null) {
              ref
                  .read(
                    formBuilderControllerProvider(
                      '$projectId::$formId',
                    ).notifier,
                  )
                  .updateForm(
                    form.copyWith(style: {...form.style, 'layoutType': val}),
                  );
            }
          },
        ),
        const SizedBox(height: 12),
        PropertyBuilderUtils.buildNumberSlider(
          label: 'Max Content Width',
          value: form.style.maxWidth,
          min: 400,
          max: 1600,
          onChanged: (val) {
            ref
                .read(
                  formBuilderControllerProvider('$projectId::$formId').notifier,
                )
                .updateForm(
                  form.copyWith(style: {...form.style, 'maxWidth': val}),
                );
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
          label: 'Between Sections',
          value: form.style.sectionSpacing,
          min: 0,
          max: 100,
          onChanged: (val) {
            ref
                .read(
                  formBuilderControllerProvider('$projectId::$formId').notifier,
                )
                .updateForm(
                  form.copyWith(
                    style: {...form.style, 'sectionSpacing': val},
                  ),
                );
          },
        ),
        const SizedBox(height: 12),
        PropertyBuilderUtils.buildNumberSlider(
          label: 'Between Questions',
          value: form.style.questionSpacing,
          min: 0,
          max: 100,
          onChanged: (val) {
            ref
                .read(
                  formBuilderControllerProvider('$projectId::$formId').notifier,
                )
                .updateForm(
                  form.copyWith(
                    style: {...form.style, 'questionSpacing': val},
                  ),
                );
          },
        ),
      ],
    );
  }
}
