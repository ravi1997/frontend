import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/form_builder/domain/entities/form_section.dart';
import 'package:frontend/features/form_builder/presentation/controllers/form_builder_controller.dart';
import 'property_builder_utils.dart';

class SectionGeneralSettings extends ConsumerStatefulWidget {
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
  ConsumerState<SectionGeneralSettings> createState() =>
      _SectionGeneralSettingsState();
}

class _SectionGeneralSettingsState
    extends ConsumerState<SectionGeneralSettings> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.titleController.text);
    _descriptionController = TextEditingController(
      text: widget.descriptionController.text,
    );
  }

  @override
  void didUpdateWidget(covariant SectionGeneralSettings oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!FocusScope.of(context).hasFocus) {
      if (_titleController.text != widget.titleController.text) {
        _titleController.text = widget.titleController.text;
      }
      if (_descriptionController.text != widget.descriptionController.text) {
        _descriptionController.text = widget.descriptionController.text;
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _updateSection(FormSection updatedSection) {
    ref
        .read(formBuilderControllerProvider(widget.formId).notifier)
        .updateSection(updatedSection);
  }

  void _updateMetadata(String key, dynamic value) {
    ref
        .read(formBuilderControllerProvider(widget.formId).notifier)
        .updateSectionMetadata(widget.section.id, {key: value});
  }

  @override
  Widget build(BuildContext context) {
    final metadata = widget.section.metadata;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PropertyBuilderUtils.buildTextField(
          label: 'Section Title',
          controller: _titleController,
          onChanged: (val) {
            ref
                .read(formBuilderControllerProvider(widget.formId).notifier)
                .updateSectionTitle(widget.section.id, val);
          },
        ),
        const SizedBox(height: 20),
        PropertyBuilderUtils.buildTextField(
          label: 'Description',
          placeholder: 'Section description (optional)',
          controller: _descriptionController,
          onChanged: (val) {
            ref
                .read(formBuilderControllerProvider(widget.formId).notifier)
                .updateSectionDescription(widget.section.id, val);
          },
        ),
        const SizedBox(height: 24),
        const Text(
          'BEHAVIOR',
          style: TextStyle(
            color: AppColors.textGrey,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        PropertyBuilderUtils.buildSwitch(
          label: 'Hidden Section',
          value: widget.section.isHidden,
          onChanged: (val) {
            _updateSection(widget.section.copyWith(isHidden: val));
          },
        ),
        const SizedBox(height: 12),
        PropertyBuilderUtils.buildSwitch(
          label: 'Allow Collapsing',
          value: metadata['allowCollapsing'] ?? true,
          onChanged: (val) => _updateMetadata('allowCollapsing', val),
        ),
        if (metadata['allowCollapsing'] != false) ...[
          const SizedBox(height: 12),
          PropertyBuilderUtils.buildSwitch(
            label: 'Start Collapsed',
            value: metadata['startCollapsed'] ?? false,
            onChanged: (val) => _updateMetadata('startCollapsed', val),
          ),
        ],
        const SizedBox(height: 20),
        _buildIconPicker(metadata),
      ],
    );
  }

  Widget _buildIconPicker(Map<String, dynamic> metadata) {
    final currentIcon = metadata['icon'] as String?;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Section Icon',
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showIconPickerDialog(currentIcon),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderLight),
              borderRadius: BorderRadius.circular(8),
              color: AppColors.builderElement,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (currentIcon != null && currentIcon.isNotEmpty)
                  _getIconWidget(currentIcon)
                else
                  const Text(
                    'Select Icon',
                    style: TextStyle(color: AppColors.textGrey),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _getIconWidget(String iconName) {
    // Map string names to IconData
    final IconData iconData;
    switch (iconName) {
      case 'info':
        iconData = Icons.info_outline;
        break;
      case 'person':
        iconData = Icons.person_outline;
        break;
      case 'location':
        iconData = Icons.location_on_outlined;
        break;
      case 'payment':
        iconData = Icons.payment;
        break;
      case 'contact':
        iconData = Icons.contact_mail_outlined;
        break;
      case 'settings':
        iconData = Icons.settings_outlined;
        break;
      case 'list':
        iconData = Icons.list_alt;
        break;
      default:
        iconData = Icons.help_outline;
    }
    return Icon(iconData, color: AppColors.primary);
  }

  void _showIconPickerDialog(String? currentIcon) {
    final Map<String, IconData> icons = {
      'info': Icons.info_outline,
      'person': Icons.person_outline,
      'location': Icons.location_on_outlined,
      'payment': Icons.payment,
      'contact': Icons.contact_mail_outlined,
      'settings': Icons.settings_outlined,
      'list': Icons.list_alt,
      'star': Icons.star_outline,
      'home': Icons.home_outlined,
      'work': Icons.work_outline,
    };

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Section Icon'),
        content: SizedBox(
          width: double.maxFinite,
          child: GridView.count(
            crossAxisCount: 5,
            shrinkWrap: true,
            children: icons.entries
                .map(
                  (e) => IconButton(
                    icon: Icon(e.value),
                    onPressed: () {
                      _updateMetadata('icon', e.key);
                      Navigator.pop(context);
                    },
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
