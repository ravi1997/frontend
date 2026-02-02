import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/form_builder/domain/entities/builder_form.dart';
import 'package:frontend/features/form_builder/presentation/controllers/form_builder_controller.dart';
import 'property_builder_utils.dart';

class FormGeneralSettings extends ConsumerWidget {
  final String formId;
  final BuilderForm form;
  final TextEditingController titleController;

  const FormGeneralSettings({
    super.key,
    required this.formId,
    required this.form,
    required this.titleController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PropertyBuilderUtils.buildTextField(
          label: 'Form Title',
          controller: titleController,
          onChanged: (val) {
            ref
                .read(formBuilderControllerProvider(formId).notifier)
                .updateFormTitle(val);
          },
        ),
      ],
    );
  }
}
