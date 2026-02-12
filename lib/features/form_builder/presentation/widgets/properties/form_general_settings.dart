import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/form_builder/domain/entities/builder_form.dart';
import 'package:frontend/features/form_builder/presentation/controllers/form_builder_controller.dart';
import 'property_builder_utils.dart';

class FormGeneralSettings extends ConsumerStatefulWidget { // Changed to ConsumerStatefulWidget
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
  ConsumerState<FormGeneralSettings> createState() => _FormGeneralSettingsState();
}

class _FormGeneralSettingsState extends ConsumerState<FormGeneralSettings> {
  final _formKey = GlobalKey<FormState>(); // Added GlobalKey

  @override
  Widget build(BuildContext context) { // Removed WidgetRef ref, now accessed via ref
    return Form( // Added Form widget
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PropertyBuilderUtils.buildTextField(
            label: 'Form Title',
            controller: widget.titleController, // Access via widget
            validator: (value) { // Added validator
              if (value == null || value.isEmpty) {
                return 'Form title cannot be empty';
              }
              return null;
            },
            onChanged: (val) {
              // Trigger validation. If valid, update the title.
              if (_formKey.currentState!.validate()) {
                ref
                    .read(formBuilderControllerProvider(widget.formId).notifier)
                    .updateFormTitle(val);
              }
            },
          ),
        ],
      ),
    );
  }
}
