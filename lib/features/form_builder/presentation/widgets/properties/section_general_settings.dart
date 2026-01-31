import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/form_builder/domain/entities/form_section.dart';
import 'package:frontend/features/form_builder/presentation/controllers/form_builder_controller.dart';
import 'property_builder_utils.dart';

class SectionGeneralSettings extends ConsumerWidget {
  final String formId;
  final FormSection section;
  final TextEditingController titleController;
  final TextEditingController descriptionController;

  const SectionGeneralSettings({
    super.key,
    required this.formId,
    required this.section,
    required this.titleController,
    required this.descriptionController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PropertyBuilderUtils.buildTextField(
          label: 'Section Title',
          controller: titleController,
          onChanged: (val) {
            ref
                .read(formBuilderControllerProvider(formId).notifier)
                .updateSection(section.copyWith(title: val));
          },
        ),
        const SizedBox(height: 20),
        PropertyBuilderUtils.buildTextField(
          label: 'Description',
          placeholder: 'Section description (optional)',
          controller: descriptionController,
          onChanged: (val) {
            ref
                .read(formBuilderControllerProvider(formId).notifier)
                .updateSection(section.copyWith(description: val));
          },
        ),
        const SizedBox(height: 24),
        PropertyBuilderUtils.buildSwitch(
          label: 'Hidden Section',
          value: section.isHidden,
          onChanged: (val) {
            ref
                .read(formBuilderControllerProvider(formId).notifier)
                .updateSection(section.copyWith(isHidden: val));
          },
        ),
      ],
    );
  }
}
