import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/form_builder/domain/entities/form_question.dart';
import 'package:frontend/features/form_builder/domain/entities/question_type.dart';
import 'package:frontend/features/form_builder/presentation/controllers/form_builder_controller.dart';
import 'property_builder_utils.dart';

class FieldValidationSettings extends ConsumerStatefulWidget {
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
  ConsumerState<FieldValidationSettings> createState() =>
      _FieldValidationSettingsState();
}

class _FieldValidationSettingsState
    extends ConsumerState<FieldValidationSettings> {
  final _formKey = GlobalKey<FormState>();

  static const Map<String, String> _regexPresets = {
    'None': '',
    'Alphanumeric': r'^[a-zA-Z0-9]*$',
    'Integer': r'^-?[0-9]+$',
    'Decimal': r'^-?[0-9]+(\.[0-9]+)?$',
    'Email': r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    'URL':
        r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)',
  };

  void _updateQuestion(FormQuestion updatedQuestion) {
    ref
        .read(formBuilderControllerProvider(widget.formId).notifier)
        .updateQuestion(updatedQuestion);
  }

  void _updateMetadata(String key, dynamic value) {
    ref
        .read(formBuilderControllerProvider(widget.formId).notifier)
        .updateQuestionMetadata(widget.question.id, {key: value});
  }

  bool get _isTextType =>
      widget.question.type == QuestionType.shortText ||
      widget.question.type == QuestionType.paragraph ||
      widget.question.type == QuestionType.email ||
      widget.question.type == QuestionType.url ||
      widget.question.type == QuestionType.mobile;

  bool get _isSelectionType =>
      widget.question.type == QuestionType.checkboxes ||
      widget.question.type == QuestionType.multipleChoice;

  @override
  Widget build(BuildContext context) {
    if (widget.question.type == QuestionType.divider ||
        widget.question.type == QuestionType.spacer) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            'No validation settings available for this field type.',
            style: TextStyle(color: AppColors.textGrey, fontSize: 13),
          ),
        ),
      );
    }

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 12),
          _buildCommonValidation(),
          const SizedBox(height: 20),
          if (_isTextType) _buildTextValidation(),
          if (widget.question.type == QuestionType.number)
            _buildNumberValidation(),
          if (widget.question.type == QuestionType.date) _buildDateValidation(),
          if (widget.question.type == QuestionType.time) ...[
            _buildTimeConstraints(),
            const SizedBox(height: 12),
          ],
          if (widget.question.type == QuestionType.fileUpload)
            _buildFileValidation(),
          if (_isSelectionType) _buildSelectionValidation(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return const Text(
      'VALIDATION',
      style: TextStyle(
        color: AppColors.textGrey,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      ),
    );
  }

  Widget _buildCommonValidation() {
    return Column(
      children: [
        PropertyBuilderUtils.buildSwitch(
          label: 'Required Field',
          value: widget.question.isRequired,
          onChanged: (val) =>
              _updateQuestion(widget.question.copyWith(isRequired: val)),
        ),
        const SizedBox(height: 12),
        PropertyBuilderUtils.buildTextField(
          label: 'Custom Error Message',
          placeholder: 'Error to show when validation fails',
          controller: widget.customErrorController,
          onChanged: (val) => _updateQuestion(
            widget.question.copyWith(customErrorMessage: val),
          ),
        ),
        const SizedBox(height: 12),
        PropertyBuilderUtils.buildSwitch(
          label: 'Read Only',
          value: widget.question.isReadOnly,
          onChanged: (val) =>
              _updateQuestion(widget.question.copyWith(isReadOnly: val)),
        ),
      ],
    );
  }

  Widget _buildTextValidation() {
    return Column(
      children: [
        if (widget.question.type == QuestionType.shortText ||
            widget.question.type == QuestionType.paragraph) ...[
          Row(
            children: [
              Expanded(
                child: PropertyBuilderUtils.buildTextField(
                  label: 'Min Length',
                  controller: widget.minLengthController,
                  keyboardType: TextInputType.number,
                  onChanged: (val) => _updateQuestion(
                    widget.question.copyWith(minLength: int.tryParse(val)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PropertyBuilderUtils.buildTextField(
                  label: 'Max Length',
                  controller: widget.maxLengthController,
                  keyboardType: TextInputType.number,
                  onChanged: (val) => _updateQuestion(
                    widget.question.copyWith(maxLength: int.tryParse(val)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StableValidationTextField(
                  label: 'Min Words',
                  placeholder: '0',
                  initialValue: widget.question.minWordCount?.toString() ?? '',
                  keyboardType: TextInputType.number,
                  onChanged: (val) => _updateQuestion(
                    widget.question.copyWith(minWordCount: int.tryParse(val)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StableValidationTextField(
                  label: 'Max Words',
                  placeholder: '1000',
                  initialValue: widget.question.maxWordCount?.toString() ?? '',
                  keyboardType: TextInputType.number,
                  onChanged: (val) => _updateQuestion(
                    widget.question.copyWith(maxWordCount: int.tryParse(val)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
        _buildRegexSection(),
        if (widget.question.type == QuestionType.shortText ||
            widget.question.type == QuestionType.mobile) ...[
          _buildInputMaskSection(),
        ],
        if (widget.question.type == QuestionType.shortText ||
            widget.question.type == QuestionType.email ||
            widget.question.type == QuestionType.mobile) ...[
          PropertyBuilderUtils.buildSwitch(
            label: 'Enforce Uniqueness',
            value: widget.question.isUnique ?? false,
            onChanged: (val) =>
                _updateQuestion(widget.question.copyWith(isUnique: val)),
          ),
          const SizedBox(height: 12),
          PropertyBuilderUtils.buildSwitch(
            label: 'Require Confirmation',
            value: widget.question.requiresConfirmation ?? false,
            onChanged: (val) => _updateQuestion(
              widget.question.copyWith(requiresConfirmation: val),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _buildNumberValidation() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: PropertyBuilderUtils.buildTextField(
                label: 'Min Value',
                controller: widget.minValueController,
                keyboardType: TextInputType.number,
                onChanged: (val) => _updateQuestion(
                  widget.question.copyWith(minValue: num.tryParse(val)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: PropertyBuilderUtils.buildTextField(
                label: 'Max Value',
                controller: widget.maxValueController,
                keyboardType: TextInputType.number,
                onChanged: (val) => _updateQuestion(
                  widget.question.copyWith(maxValue: num.tryParse(val)),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildInputMaskSection(),
      ],
    );
  }

  Widget _buildInputMaskSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PropertyBuilderUtils.buildTextField(
          label: 'Input Mask',
          placeholder: 'e.g. (###) ###-####',
          controller: widget.inputMaskController,
          onChanged: (val) =>
              _updateQuestion(widget.question.copyWith(inputMask: val)),
        ),
        const SizedBox(height: 4),
        Text(
          widget.question.inputMask?.isNotEmpty == true
              ? 'Preview: ${widget.question.inputMask}'
              : '',
          style: const TextStyle(color: AppColors.textGrey, fontSize: 11),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildRegexSection() {
    return Column(
      children: [
        PropertyBuilderUtils.buildDropdown<String>(
          label: 'Validation Pattern',
          value: _regexPresets.containsValue(widget.regexController.text)
              ? widget.regexController.text
              : (widget.regexController.text.isEmpty ? '' : null),
          items: _regexPresets.entries
              .map((e) => DropdownMenuItem(value: e.value, child: Text(e.key)))
              .toList(),
          onChanged: (val) {
            if (val != null) {
              widget.regexController.text = val;
              _updateQuestion(widget.question.copyWith(validationRegex: val));
            }
          },
        ),
        const SizedBox(height: 12),
        PropertyBuilderUtils.buildTextField(
          label: 'Regex Validation',
          placeholder: 'e.g. ^[0-9]*\$',
          controller: widget.regexController,
          onChanged: (val) =>
              _updateQuestion(widget.question.copyWith(validationRegex: val)),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildDateValidation() {
    return Column(
      children: [
        _buildDateRow('Min Date', widget.question.dateMin, true),
        const SizedBox(height: 12),
        _buildDateRow('Max Date', widget.question.dateMax, false),
        const SizedBox(height: 12),
        PropertyBuilderUtils.buildSwitch(
          label: 'Disable Past Dates',
          value: widget.question.disablePastDates ?? false,
          onChanged: (val) =>
              _updateQuestion(widget.question.copyWith(disablePastDates: val)),
        ),
        const SizedBox(height: 8),
        PropertyBuilderUtils.buildSwitch(
          label: 'Disable Future Dates',
          value: widget.question.disableFutureDates ?? false,
          onChanged: (val) => _updateQuestion(
            widget.question.copyWith(disableFutureDates: val),
          ),
        ),
        const SizedBox(height: 8),
        PropertyBuilderUtils.buildSwitch(
          label: 'Disable Weekends',
          value: widget.question.disableWeekends ?? false,
          onChanged: (val) =>
              _updateQuestion(widget.question.copyWith(disableWeekends: val)),
        ),
        const SizedBox(height: 12),
        _buildBlackoutDates(),
        _buildInputMaskSection(),
      ],
    );
  }

  Widget _buildDateRow(String label, DateTime? date, bool isMin) {
    return Row(
      children: [
        Expanded(
          child: _StableValidationTextField(
            label: label,
            placeholder: 'Tap to select',
            initialValue: date?.toIso8601String().split('T').first ?? '',
            readOnly: true,
            onChanged: (_) {},
          ),
        ),
        IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () => _pickDate(isMin),
        ),
        if (date != null)
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () => _updateQuestion(
              isMin
                  ? widget.question.copyWith(dateMin: null)
                  : widget.question.copyWith(dateMax: null),
            ),
          ),
      ],
    );
  }

  Widget _buildTimeConstraints() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () async {
              final t = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (t != null) {
                _updateMetadata('minTime', '${t.hour}:${t.minute}');
              }
            },
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Min Time',
                border: OutlineInputBorder(),
              ),
              child: Text(
                widget.question.metadata?['minTime'] ?? 'Select',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () async {
              final t = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (t != null) {
                _updateMetadata('maxTime', '${t.hour}:${t.minute}');
              }
            },
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Max Time',
                border: OutlineInputBorder(),
              ),
              child: Text(
                widget.question.metadata?['maxTime'] ?? 'Select',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBlackoutDates() {
    final blackoutList =
        (widget.question.metadata?['blackoutDates'] as List?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Blackout Dates',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle, color: AppColors.primary),
              onPressed: () async {
                final d = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030),
                );
                if (d != null) {
                  final newList = List<String>.from(blackoutList)
                    ..add(d.toIso8601String().split('T').first);
                  _updateMetadata('blackoutDates', newList);
                }
              },
            ),
          ],
        ),
        if (blackoutList.isNotEmpty)
          Wrap(
            spacing: 8,
            children: blackoutList
                .map(
                  (d) => Chip(
                    label: Text(d),
                    onDeleted: () {
                      final newList = List<String>.from(blackoutList)
                        ..remove(d);
                      _updateMetadata('blackoutDates', newList);
                    },
                  ),
                )
                .toList(),
          ),
      ],
    );
  }

  Widget _buildFileValidation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Allowed File Types',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            _buildFileTypeChip('Images', ['jpg', 'png', 'jpeg', 'webp']),
            _buildFileTypeChip('Documents', ['doc', 'docx', 'txt']),
            _buildFileTypeChip('PDF', ['pdf']),
            _buildFileTypeChip('Spreadsheets', ['xls', 'xlsx', 'csv']),
          ],
        ),
        const SizedBox(height: 12),
        _StableValidationTextField(
          label: 'Custom Extensions',
          placeholder: '.dwg, .stl, .obj',
          initialValue:
              (widget.question.metadata?['customExtensions'] as List?)?.join(
                ', ',
              ) ??
              '',
          onChanged: (val) {
            final extensions = val
                .split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList();
            _updateMetadata('customExtensions', extensions);
          },
        ),
        const SizedBox(height: 16),
        PropertyBuilderUtils.buildNumberSlider(
          label: 'Min File Size (MB)',
          value: (widget.question.metadata?['minFileSize'] ?? 0).toDouble(),
          min: 0,
          max: 10,
          onChanged: (val) => _updateMetadata('minFileSize', val.toInt()),
        ),
        const SizedBox(height: 12),
        PropertyBuilderUtils.buildNumberSlider(
          label: 'Max File Size (MB)',
          value: (widget.question.maxFileSize ?? 5).toDouble(),
          min: 1,
          max: 50,
          onChanged: (val) => _updateQuestion(
            widget.question.copyWith(maxFileSize: val.toInt()),
          ),
        ),
        const SizedBox(height: 12),
        PropertyBuilderUtils.buildNumberSlider(
          label: 'Total Max Size (MB)',
          value: (widget.question.metadata?['totalMaxFileSize'] ?? 20)
              .toDouble(),
          min: 5,
          max: 500,
          onChanged: (val) => _updateMetadata('totalMaxFileSize', val.toInt()),
        ),
        const SizedBox(height: 12),
        PropertyBuilderUtils.buildNumberSlider(
          label: 'Max Files Count',
          value: (widget.question.maxFiles ?? 1).toDouble(),
          min: 1,
          max: 10,
          onChanged: (val) =>
              _updateQuestion(widget.question.copyWith(maxFiles: val.toInt())),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildSelectionValidation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selection Limits',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: PropertyBuilderUtils.buildNumberSlider(
                label: 'Min Selection',
                value: (widget.question.minSelection ?? 0).toDouble(),
                min: 0,
                max: 10,
                onChanged: (val) => _updateQuestion(
                  widget.question.copyWith(minSelection: val.toInt()),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: PropertyBuilderUtils.buildNumberSlider(
                label: 'Max Selection',
                value: (widget.question.maxSelection ?? 0).toDouble(),
                min: 0,
                max: 10,
                onChanged: (val) => _updateQuestion(
                  widget.question.copyWith(maxSelection: val.toInt()),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (widget.question.options != null &&
            widget.question.options!.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Mandatory Selection',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 4),
              DropdownButtonFormField<String>(
                initialValue: widget.question.metadata?['mandatoryOptionId'],
                decoration: const InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                ),
                items: [
                  const DropdownMenuItem(value: null, child: Text('None')),
                  ...widget.question.options!.map(
                    (e) => DropdownMenuItem(value: e.id, child: Text(e.label)),
                  ),
                ],
                onChanged: (val) => _updateMetadata('mandatoryOptionId', val),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildFileTypeChip(String label, List<String> extensions) {
    final currentTypes = widget.question.allowedFileTypes ?? [];
    final isSelected = extensions.every((ext) => currentTypes.contains(ext));

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        final newTypes = List<String>.from(currentTypes);
        if (selected) {
          for (var ext in extensions) {
            if (!newTypes.contains(ext)) newTypes.add(ext);
          }
        } else {
          for (var ext in extensions) {
            newTypes.remove(ext);
          }
        }
        _updateQuestion(widget.question.copyWith(allowedFileTypes: newTypes));
      },
    );
  }

  Future<void> _pickDate(bool isMin) async {
    final initialDate = isMin
        ? widget.question.dateMin ?? DateTime.now()
        : widget.question.dateMax ?? DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      if (isMin) {
        _updateQuestion(widget.question.copyWith(dateMin: picked));
      } else {
        _updateQuestion(widget.question.copyWith(dateMax: picked));
      }
    }
  }
}

class _StableValidationTextField extends StatefulWidget {
  final String label;
  final String? placeholder;
  final String initialValue;
  final TextInputType? keyboardType;
  final bool readOnly;
  final ValueChanged<String> onChanged;

  const _StableValidationTextField({
    required this.label,
    this.placeholder,
    required this.initialValue,
    this.keyboardType,
    this.readOnly = false,
    required this.onChanged,
  });

  @override
  State<_StableValidationTextField> createState() =>
      _StableValidationTextFieldState();
}

class _StableValidationTextFieldState
    extends State<_StableValidationTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant _StableValidationTextField oldWidget) {
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
      placeholder: widget.placeholder,
      controller: _controller,
      keyboardType: widget.keyboardType,
      readOnly: widget.readOnly,
      onChanged: widget.onChanged,
    );
  }
}
