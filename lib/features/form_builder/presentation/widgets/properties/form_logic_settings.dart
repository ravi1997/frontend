import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/form_builder/domain/entities/builder_form.dart';

class FormLogicSettings extends ConsumerWidget {
  final String formId;
  final BuilderForm form;

  const FormLogicSettings({
    super.key,
    required this.formId,
    required this.form,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'GLOBAL FORM LOGIC',
          style: TextStyle(
            color: AppColors.textGrey,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 16),
        const Center(
          child: Padding(
            padding: EdgeInsets.all(40.0),
            child: Column(
              children: [
                Icon(Icons.alt_route, size: 48, color: AppColors.borderLight),
                SizedBox(height: 16),
                Text(
                  'Section-level logic and workflows are currently supported. Global form logic (e.g., dynamic redirects) is coming soon.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textGrey, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
