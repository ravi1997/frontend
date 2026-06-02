import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/models/form_models.dart';
import 'package:frontend/features/form_builder/presentation/controllers/form_builder_controller.dart';
import 'property_builder_utils.dart';

class FormStyleSettings extends ConsumerWidget {
  final String projectId;
  final String formId;
  final BuilderForm form;

  const FormStyleSettings({
    super.key,
    required this.projectId,
    required this.formId,
    required this.form,
  });

  void _applyPreset(String presetKey, WidgetRef ref) {
    late final Map<String, dynamic> styles;
    switch (presetKey) {
      case 'modern_blue':
        styles = {
          'primaryColor': '#3B82F6',
          'globalBorderRadius': 8.0,
          'backgroundColor': '#F1F5F9',
        };
        break;
      case 'dark_elegance':
        styles = {
          'primaryColor': '#FFFFFF',
          'globalBorderRadius': 0.0,
          'backgroundColor': '#0F172A',
        };
        break;
      case 'playful':
        styles = {
          'primaryColor': '#F59E0B',
          'globalBorderRadius': 20.0,
          'backgroundColor': '#FFF7ED',
        };
        break;
      default:
        return;
    }

    final newStyle = {
      ...form.style,
      'primaryColor': styles['primaryColor'],
      'globalBorderRadius': (styles['globalBorderRadius'] as num).toDouble(),
      'backgroundColor': styles['backgroundColor'],
    };

    ref
        .read(formBuilderControllerProvider('$projectId::$formId').notifier)
        .updateForm(form.copyWith(style: newStyle));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'THEME PRESETS',
          style: TextStyle(
            color: AppColors.textGrey,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 16),
        PropertyBuilderUtils.buildDropdown<String>(
          label: 'Select Preset',
          value: '', // Use empty string instead of null if it helps
          items: const [
            DropdownMenuItem(value: '', child: Text('Choose a preset')),
            DropdownMenuItem(value: 'modern_blue', child: Text('Modern Blue')),
            DropdownMenuItem(
              value: 'dark_elegance',
              child: Text('Dark Elegance'),
            ),
            DropdownMenuItem(value: 'playful', child: Text('Playful')),
          ],
          onChanged: (val) {
            if (val != null) {
              _applyPreset(val, ref);
            }
          },
        ),
        const SizedBox(height: 24),
        const Text(
          'GLOBAL COLORS',
          style: TextStyle(
            color: AppColors.textGrey,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 16),
        PropertyBuilderUtils.buildColorPicker(
          label: 'Page Background',
          value: form.style.backgroundColor,
          onChanged: (val) {
            ref
                .read(
                  formBuilderControllerProvider('$projectId::$formId').notifier,
                )
                .updateForm(
                  form.copyWith(style: {...form.style, 'backgroundColor': val}),
                );
          },
        ),
        const SizedBox(height: 12),
        PropertyBuilderUtils.buildColorPicker(
          label: 'Primary Brand Color',
          value: form.style.primaryColor,
          onChanged: (val) {
            ref
                .read(
                  formBuilderControllerProvider('$projectId::$formId').notifier,
                )
                .updateForm(
                  form.copyWith(style: {...form.style, 'primaryColor': val}),
                );
          },
        ),
        const SizedBox(height: 24),
        const Text(
          'TYPOGRAPHY',
          style: TextStyle(
            color: AppColors.textGrey,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 16),
        PropertyBuilderUtils.buildDropdown<String>(
          label: 'Base Font Family',
          value: form.style.fontFamily,
          items: const [
            DropdownMenuItem(value: 'Inter', child: Text('Inter')),
            DropdownMenuItem(value: 'Roboto', child: Text('Roboto')),
            DropdownMenuItem(value: 'Poppins', child: Text('Poppins')),
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
                    form.copyWith(style: {...form.style, 'fontFamily': val}),
                  );
            }
          },
        ),
        const SizedBox(height: 24),
        const Text(
          'GLOBAL SHAPE',
          style: TextStyle(
            color: AppColors.textGrey,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 16),
        PropertyBuilderUtils.buildNumberSlider(
          label: 'Global Corner Radius',
          value: form.style.globalBorderRadius,
          min: 0,
          max: 32,
          onChanged: (val) {
            ref
                .read(
                  formBuilderControllerProvider('$projectId::$formId').notifier,
                )
                .updateForm(
                  form.copyWith(
                    style: {...form.style, 'globalBorderRadius': val},
                  ),
                );
          },
        ),
      ],
    );
  }
}
