import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/shared/models/form_models.dart';
import 'package:frontend/modules/forms/models/question_type.dart';
import 'package:frontend/modules/forms/services/form_builder_controller.dart';
import 'package:frontend/app/theme/app_colors.dart';
import 'package:frontend/app/theme/tokens.dart';
import 'property_builder_utils.dart';

class FieldSpecificSettings extends ConsumerStatefulWidget {
  final String formId;
  final FormQuestion question;

  const FieldSpecificSettings({
    super.key,
    required this.formId,
    required this.question,
  });

  @override
  ConsumerState<FieldSpecificSettings> createState() =>
      _FieldSpecificSettingsState();
}

class _FieldSpecificSettingsState extends ConsumerState<FieldSpecificSettings> {
  void _updateMetadata(String key, dynamic value) {
    ref
        .read(formBuilderControllerProvider(widget.formId).notifier)
        .updateQuestionMetadata(widget.question.id, {key: value});
  }

  @override
  Widget build(BuildContext context) {
    final metadata = widget.question.metadata;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Specific Settings for ${widget.question.type.label}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textGrey,
            fontSize: DesignTokens.fontS,
          ),
        ),
        const SizedBox(height: DesignTokens.spaceL),
        if (widget.question.type == QuestionType.image)
          _buildImageSettings(metadata),
        if (widget.question.type == QuestionType.rating)
          _buildRatingSettings(metadata),
        if (widget.question.type == QuestionType.slider)
          _buildSliderSettings(metadata),
        if (widget.question.type == QuestionType.matrixChoice)
          _buildMatrixSettings(metadata),
        if (widget.question.type == QuestionType.date)
          _buildDateSettings(metadata),
        if (widget.question.type == QuestionType.signature)
          _buildSignatureSettings(metadata),
        if (widget.question.type == QuestionType.shortText)
          _buildShortTextSettings(metadata),
        if (widget.question.type == QuestionType.multiSelect ||
            widget.question.type == QuestionType.multiCheckbox)
          _buildMultiSelectSettings(metadata),
        if (widget.question.type == QuestionType.otp)
          _buildOtpSettings(metadata),
        if (widget.question.type == QuestionType.richText ||
            widget.question.type == QuestionType.markdownEditor)
          _buildRichTextSettings(metadata),
        if (widget.question.type == QuestionType.address ||
            widget.question.type == QuestionType.addressLookup ||
            widget.question.type == QuestionType.mapLocation)
          _buildLocationSettings(metadata),
        if (widget.question.type == QuestionType.fileUpload ||
            widget.question.type == QuestionType.multiFileUpload ||
            widget.question.type == QuestionType.filePicker ||
            widget.question.type == QuestionType.fileList)
          _buildFileSettings(metadata),
        if (widget.question.type == QuestionType.booleanValue ||
            widget.question.type == QuestionType.toggle)
          _buildToggleSettings(metadata),
        if (![
          QuestionType.image,
          QuestionType.rating,
          QuestionType.slider,
          QuestionType.matrixChoice,
          QuestionType.date,
          QuestionType.signature,
          QuestionType.shortText,
          QuestionType.multiSelect,
          QuestionType.multiCheckbox,
          QuestionType.otp,
          QuestionType.richText,
          QuestionType.markdownEditor,
          QuestionType.address,
          QuestionType.addressLookup,
          QuestionType.mapLocation,
          QuestionType.fileUpload,
          QuestionType.multiFileUpload,
          QuestionType.filePicker,
          QuestionType.fileList,
          QuestionType.booleanValue,
          QuestionType.toggle,
        ].contains(widget.question.type))
          const Center(
            child: Padding(
              padding: EdgeInsets.all(DesignTokens.spaceL),
              child: Text(
                'No specific settings for this field type.',
                style: TextStyle(
                  color: AppColors.textGrey,
                  fontSize: DesignTokens.fontS,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildImageSettings(Map<String, dynamic> metadata) {
    return Column(
      children: [
        PropertyBuilderUtils.buildSwitch(
          label: 'Use Upload (vs URL)',
          value: metadata['useUpload'] ?? false,
          onChanged: (val) => _updateMetadata('useUpload', val),
        ),
        const SizedBox(height: 12),
        if (metadata['useUpload'] != true)
          Column(
            children: [
              _MetadataTextField(
                label: 'Image URL',
                initialValue: metadata['imageUrl']?.toString() ?? '',
                onChanged: (val) => _updateMetadata('imageUrl', val),
              ),
              const SizedBox(height: 12),
            ],
          ),
        PropertyBuilderUtils.buildDropdown<String>(
          label: 'Aspect Ratio',
          value: metadata['aspectRatio'] ?? 'original',
          items: const [
            DropdownMenuItem(value: 'original', child: Text('Original')),
            DropdownMenuItem(value: '1:1', child: Text('1:1 (Square)')),
            DropdownMenuItem(value: '16:9', child: Text('16:9 (Widescreen)')),
            DropdownMenuItem(value: '4:3', child: Text('4:3 (Standard)')),
          ],
          onChanged: (val) => _updateMetadata('aspectRatio', val),
        ),
        const SizedBox(height: 12),
        PropertyBuilderUtils.buildDropdown<String>(
          label: 'Fit Mode',
          value: metadata['fit'] ?? 'cover',
          items: const [
            DropdownMenuItem(value: 'cover', child: Text('Cover')),
            DropdownMenuItem(value: 'contain', child: Text('Contain')),
            DropdownMenuItem(value: 'fill', child: Text('Fill')),
          ],
          onChanged: (val) => _updateMetadata('fit', val),
        ),
      ],
    );
  }

  Widget _buildShortTextSettings(Map<String, dynamic> metadata) {
    return Column(
      children: [
        PropertyBuilderUtils.buildDropdown<String>(
          label: 'Keyboard Type',
          value: metadata['keyboardType'] ?? 'text',
          items: const [
            DropdownMenuItem(value: 'text', child: Text('Text')),
            DropdownMenuItem(value: 'number', child: Text('Number')),
            DropdownMenuItem(value: 'phone', child: Text('Phone')),
            DropdownMenuItem(value: 'email', child: Text('Email')),
            DropdownMenuItem(value: 'multiline', child: Text('Multiline')),
            DropdownMenuItem(value: 'url', child: Text('URL')),
          ],
          onChanged: (val) => _updateMetadata('keyboardType', val),
        ),
        const SizedBox(height: 12),
        PropertyBuilderUtils.buildSwitch(
          label: 'Obscure Text (Password)',
          value: metadata['obscureText'] ?? false,
          onChanged: (val) => _updateMetadata('obscureText', val),
        ),
      ],
    );
  }

  Widget _buildMultiSelectSettings(Map<String, dynamic> metadata) {
    return Column(
      children: [
        PropertyBuilderUtils.buildNumberSlider(
          label: 'Maximum Selections',
          value: (metadata['maxSelections'] ?? 0).toDouble(),
          min: 0,
          max: 20,
          onChanged: (val) => _updateMetadata('maxSelections', val.toInt()),
        ),
        const SizedBox(height: 12),
        PropertyBuilderUtils.buildSwitch(
          label: 'Allow Other Option',
          value: metadata['allowOther'] ?? false,
          onChanged: (val) => _updateMetadata('allowOther', val),
        ),
      ],
    );
  }

  Widget _buildOtpSettings(Map<String, dynamic> metadata) {
    return Column(
      children: [
        _MetadataNumberField(
          label: 'Code Length',
          initialValue: metadata['codeLength'] ?? 6,
          onChanged: (val) => _updateMetadata('codeLength', val),
        ),
        const SizedBox(height: 12),
        _MetadataNumberField(
          label: 'Resend Delay (sec)',
          initialValue: metadata['resendDelay'] ?? 30,
          onChanged: (val) => _updateMetadata('resendDelay', val),
        ),
        const SizedBox(height: 12),
        PropertyBuilderUtils.buildSwitch(
          label: 'Auto Submit',
          value: metadata['autoSubmit'] ?? true,
          onChanged: (val) => _updateMetadata('autoSubmit', val),
        ),
      ],
    );
  }

  Widget _buildRichTextSettings(Map<String, dynamic> metadata) {
    return Column(
      children: [
        PropertyBuilderUtils.buildDropdown<String>(
          label: 'Editor Toolbar',
          value: metadata['toolbar'] ?? 'full',
          items: const [
            DropdownMenuItem(value: 'minimal', child: Text('Minimal')),
            DropdownMenuItem(value: 'full', child: Text('Full')),
          ],
          onChanged: (val) => _updateMetadata('toolbar', val),
        ),
        const SizedBox(height: 12),
        PropertyBuilderUtils.buildSwitch(
          label: 'Allow Markdown',
          value: metadata['allowMarkdown'] ?? true,
          onChanged: (val) => _updateMetadata('allowMarkdown', val),
        ),
      ],
    );
  }

  Widget _buildLocationSettings(Map<String, dynamic> metadata) {
    return Column(
      children: [
        _MetadataTextField(
          label: 'Default Country',
          initialValue: metadata['defaultCountry']?.toString() ?? '',
          onChanged: (val) => _updateMetadata('defaultCountry', val),
        ),
        const SizedBox(height: 12),
        PropertyBuilderUtils.buildSwitch(
          label: 'Use Current Location',
          value: metadata['useCurrentLocation'] ?? false,
          onChanged: (val) => _updateMetadata('useCurrentLocation', val),
        ),
      ],
    );
  }

  Widget _buildFileSettings(Map<String, dynamic> metadata) {
    final allowedTypes =
        (metadata['allowedTypes'] as List?)
            ?.map((e) => e.toString())
            .toList() ??
        const ['pdf', 'jpg', 'png'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PropertyBuilderUtils.buildNumberSlider(
          label: 'Maximum Files',
          value: (metadata['maxFiles'] ?? 1).toDouble(),
          min: 1,
          max: 20,
          onChanged: (val) => _updateMetadata('maxFiles', val.toInt()),
        ),
        const SizedBox(height: 12),
        const Text(
          'Allowed Types',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: allowedTypes
              .map(
                (type) => Chip(
                  label: Text(type),
                  onDeleted: () {
                    final next = List<String>.from(allowedTypes)..remove(type);
                    _updateMetadata('allowedTypes', next);
                  },
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 8),
        _MetadataTextField(
          label: 'Add File Type',
          initialValue: '',
          onChanged: (val) {
            final trimmed = val.trim();
            if (trimmed.isEmpty) return;
            final next = List<String>.from(allowedTypes)..add(trimmed);
            _updateMetadata('allowedTypes', next);
          },
        ),
      ],
    );
  }

  Widget _buildToggleSettings(Map<String, dynamic> metadata) {
    return Column(
      children: [
        _MetadataTextField(
          label: 'On Label',
          initialValue: metadata['onLabel']?.toString() ?? 'Yes',
          onChanged: (val) => _updateMetadata('onLabel', val),
        ),
        const SizedBox(height: 12),
        _MetadataTextField(
          label: 'Off Label',
          initialValue: metadata['offLabel']?.toString() ?? 'No',
          onChanged: (val) => _updateMetadata('offLabel', val),
        ),
      ],
    );
  }

  Widget _buildDateSettings(Map<String, dynamic> metadata) {
    return Column(
      children: [
        PropertyBuilderUtils.buildDropdown<String>(
          label: 'Date Format',
          value: metadata['dateFormat'] ?? 'dd/MM/yyyy',
          items: const [
            DropdownMenuItem(value: 'dd/MM/yyyy', child: Text('DD/MM/YYYY')),
            DropdownMenuItem(value: 'MM/dd/yyyy', child: Text('MM/DD/YYYY')),
            DropdownMenuItem(value: 'yyyy-MM-dd', child: Text('YYYY-MM-DD')),
          ],
          onChanged: (val) {
            if (val != null) _updateMetadata('dateFormat', val);
          },
        ),
        const SizedBox(height: 12),
        PropertyBuilderUtils.buildDropdown<String>(
          label: 'Time Format',
          value: metadata['timeFormat'] ?? '24h',
          items: const [
            DropdownMenuItem(value: '12h', child: Text('12 Hour (AM/PM)')),
            DropdownMenuItem(value: '24h', child: Text('24 Hour')),
          ],
          onChanged: (val) {
            if (val != null) _updateMetadata('timeFormat', val);
          },
        ),
        const SizedBox(height: 12),
        PropertyBuilderUtils.buildDropdown<String>(
          label: 'Mode',
          value: metadata['mode'] ?? 'date',
          items: const [
            DropdownMenuItem(value: 'date', child: Text('Date Only')),
            DropdownMenuItem(value: 'time', child: Text('Time Only')),
            DropdownMenuItem(value: 'datetime', child: Text('Date & Time')),
          ],
          onChanged: (val) {
            if (val != null) _updateMetadata('mode', val);
          },
        ),
      ],
    );
  }

  Widget _buildSignatureSettings(Map<String, dynamic> metadata) {
    return Column(
      children: [
        PropertyBuilderUtils.buildColorPicker(
          label: 'Pen Color',
          value: metadata['penColor'] ?? '#000000',
          onChanged: (val) => _updateMetadata('penColor', val),
        ),
        const SizedBox(height: 12),
        _MetadataNumberField(
          label: 'Stroke Width',
          initialValue: metadata['strokeWidth'] ?? 2.0,
          onChanged: (val) => _updateMetadata('strokeWidth', val),
        ),
      ],
    );
  }

  Widget _buildRatingSettings(Map<String, dynamic> metadata) {
    return Column(
      children: [
        _MetadataNumberField(
          label: 'Number of Stars',
          initialValue: metadata['maxStars'] ?? 5,
          onChanged: (val) => _updateMetadata('maxStars', val),
        ),
        const SizedBox(height: 12),
        PropertyBuilderUtils.buildSwitch(
          label: 'Allow Half Stars',
          value: metadata['allowHalfRating'] ?? false,
          onChanged: (val) => _updateMetadata('allowHalfRating', val),
        ),
        const SizedBox(height: 12),
        PropertyBuilderUtils.buildDropdown<String>(
          label: 'Icon Style',
          value: metadata['iconStyle'] ?? 'star',
          items: const [
            DropdownMenuItem(value: 'star', child: Text('Star')),
            DropdownMenuItem(value: 'heart', child: Text('Heart')),
            DropdownMenuItem(value: 'thumb_up', child: Text('Thumb Up')),
            DropdownMenuItem(value: 'sentiment', child: Text('Face')),
            DropdownMenuItem(value: 'circle', child: Text('Circle')),
            DropdownMenuItem(value: 'square', child: Text('Square')),
          ],
          onChanged: (val) {
            if (val != null) _updateMetadata('iconStyle', val);
          },
        ),
      ],
    );
  }

  Widget _buildSliderSettings(Map<String, dynamic> metadata) {
    return Column(
      children: [
        _MetadataNumberField(
          label: 'Minimum Value',
          initialValue: metadata['min'] ?? 0,
          onChanged: (val) => _updateMetadata('min', val),
        ),
        const SizedBox(height: 12),
        _MetadataNumberField(
          label: 'Maximum Value',
          initialValue: metadata['max'] ?? 100,
          onChanged: (val) => _updateMetadata('max', val),
        ),
        const SizedBox(height: 12),
        _MetadataNumberField(
          label: 'Step Size',
          initialValue: metadata['step'] ?? 1,
          onChanged: (val) => _updateMetadata('step', val),
        ),
        const SizedBox(height: 12),
        PropertyBuilderUtils.buildSwitch(
          label: 'Range Slider',
          value: metadata['isRange'] ?? false,
          onChanged: (val) => _updateMetadata('isRange', val),
        ),
        const SizedBox(height: 12),
        PropertyBuilderUtils.buildSwitch(
          label: 'Show Labels',
          value: metadata['showLabels'] ?? true,
          onChanged: (val) => _updateMetadata('showLabels', val),
        ),
      ],
    );
  }

  Widget _buildMatrixSettings(Map<String, dynamic> metadata) {
    final rows =
        (metadata['rows'] as List?)?.cast<String>() ?? ['Row 1', 'Row 2'];
    final cols =
        (metadata['columns'] as List?)?.cast<String>() ??
        ['Col 1', 'Col 2', 'Col 3'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PropertyBuilderUtils.buildDropdown<String>(
          label: 'Cell Input Type',
          value: metadata['cellType'] ?? 'radio',
          items: const [
            DropdownMenuItem(
              value: 'radio',
              child: Text('Radio Buttons (Single)'),
            ),
            DropdownMenuItem(
              value: 'checkbox',
              child: Text('Checkboxes (Multi)'),
            ),
            DropdownMenuItem(value: 'text', child: Text('Text Inputs')),
          ],
          onChanged: (val) => _updateMetadata('cellType', val),
        ),
        const SizedBox(height: 24),
        const Text(
          'Rows',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        const SizedBox(height: 8),
        _buildListEditor(
          rows,
          (newRows) => _updateMetadata('rows', newRows),
          'Row',
        ),
        const SizedBox(height: 24),
        const Text(
          'Columns',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        const SizedBox(height: 8),
        _buildListEditor(
          cols,
          (newCols) => _updateMetadata('columns', newCols),
          'Column',
        ),
      ],
    );
  }

  Widget _buildListEditor(
    List<String> items,
    Function(List<String>) onChanged,
    String itemLabel,
  ) {
    final trimmedItems = items.map((e) => e.trim().toLowerCase()).toList();
    final duplicateItems = trimmedItems
        .where((e) => trimmedItems.indexOf(e) != trimmedItems.lastIndexOf(e))
        .toSet();

    return Column(
      children: [
        ...items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isDuplicate = duplicateItems.contains(
            item.trim().toLowerCase(),
          );

          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _StatefulListItemValue(
                    key: ValueKey('$itemLabel-$index'),
                    initialValue: item,
                    errorText: isDuplicate ? 'Duplicate $itemLabel' : null,
                    onChanged: (val) {
                      final newItems = List<String>.from(items);
                      newItems[index] = val;
                      onChanged(newItems);
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    size: 18,
                    color: AppColors.textGrey,
                  ),
                  onPressed: () {
                    final newItems = List<String>.from(items);
                    newItems.removeAt(index);
                    onChanged(newItems);
                  },
                ),
              ],
            ),
          );
        }),
        OutlinedButton.icon(
          onPressed: () {
            final newItems = List<String>.from(items);
            newItems.add('$itemLabel ${newItems.length + 1}');
            onChanged(newItems);
          },
          icon: const Icon(Icons.add, size: 16),
          label: Text('Add $itemLabel'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 36),
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}

class _MetadataTextField extends StatefulWidget {
  final String label;
  final String initialValue;
  final ValueChanged<String> onChanged;

  const _MetadataTextField({
    required this.label,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<_MetadataTextField> createState() => _MetadataTextFieldState();
}

class _MetadataTextFieldState extends State<_MetadataTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant _MetadataTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != _controller.text) {
      if (!FocusScope.of(context).hasFocus) {
        _controller.text = widget.initialValue;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PropertyBuilderUtils.buildTextField(
      label: widget.label,
      controller: _controller,
      onChanged: widget.onChanged,
    );
  }
}

class _MetadataNumberField extends StatefulWidget {
  final String label;
  final num initialValue;
  final ValueChanged<num> onChanged;

  const _MetadataNumberField({
    required this.label,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<_MetadataNumberField> createState() => _MetadataNumberFieldState();
}

class _MetadataNumberFieldState extends State<_MetadataNumberField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue.toString());
  }

  @override
  void didUpdateWidget(covariant _MetadataNumberField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue.toString() != _controller.text) {
      if (!FocusScope.of(context).hasFocus) {
        _controller.text = widget.initialValue.toString();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            widget.label,
            style: const TextStyle(fontSize: 13, color: AppColors.textDark),
          ),
        ),
        Expanded(
          child: SizedBox(
            height: 36,
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                isDense: true,
              ),
              keyboardType: TextInputType.number,
              onChanged: (val) {
                final n = num.tryParse(val);
                if (n != null) widget.onChanged(n);
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _StatefulListItemValue extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;
  final String? errorText;

  const _StatefulListItemValue({
    super.key,
    required this.initialValue,
    required this.onChanged,
    this.errorText,
  });

  @override
  State<_StatefulListItemValue> createState() => _StatefulListItemValueState();
}

class _StatefulListItemValueState extends State<_StatefulListItemValue> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _controller,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            fillColor: AppColors.builderElement,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: widget.errorText != null
                  ? const BorderSide(color: Colors.red, width: 1)
                  : BorderSide.none,
            ),
          ),
          style: const TextStyle(fontSize: 14),
          onChanged: widget.onChanged,
        ),
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 4),
            child: Text(
              widget.errorText!,
              style: const TextStyle(color: Colors.red, fontSize: 11),
            ),
          ),
      ],
    );
  }
}
