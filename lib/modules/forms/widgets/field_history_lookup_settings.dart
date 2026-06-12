import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/modules/forms/services/form_builder_controller.dart';
import 'package:frontend/modules/forms/widgets/property_builder_utils.dart';
import 'package:frontend/shared/models/form_models.dart';

class FieldHistoryLookupSettings extends ConsumerStatefulWidget {
  final String formId;
  final FormQuestion question;

  const FieldHistoryLookupSettings({
    super.key,
    required this.formId,
    required this.question,
  });

  @override
  ConsumerState<FieldHistoryLookupSettings> createState() =>
      _FieldHistoryLookupSettingsState();
}

class _FieldHistoryLookupSettingsState
    extends ConsumerState<FieldHistoryLookupSettings> {
  late TextEditingController _buttonLabelController;
  late TextEditingController _resultLimitController;

  Map<String, dynamic> get _actionConfig => Map<String, dynamic>.from(
    widget.question.metadata['actionConfig'] ??
        widget.question.metadata['action_config'] ??
        const {},
  );

  @override
  void initState() {
    super.initState();
    final config = _actionConfig;
    _buttonLabelController = TextEditingController(
      text: config['buttonLabel']?.toString() ?? 'Lookup History',
    );
    _resultLimitController = TextEditingController(
      text: config['resultLimit']?.toString() ?? '10',
    );
  }

  @override
  void didUpdateWidget(covariant FieldHistoryLookupSettings oldWidget) {
    super.didUpdateWidget(oldWidget);
    final config = _actionConfig;
    _sync(
      _buttonLabelController,
      config['buttonLabel']?.toString() ?? 'Lookup History',
    );
    _sync(_resultLimitController, config['resultLimit']?.toString() ?? '10');
  }

  void _sync(TextEditingController controller, String value) {
    if (controller.text == value) return;
    controller.value = controller.value.copyWith(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }

  @override
  void dispose() {
    _buttonLabelController.dispose();
    _resultLimitController.dispose();
    super.dispose();
  }

  void _updateConfig(Map<String, dynamic> config) {
    ref
        .read(formBuilderControllerProvider(widget.formId).notifier)
        .updateQuestionMetadata(widget.question.id, {'actionConfig': config});
  }

  @override
  Widget build(BuildContext context) {
    final config = _actionConfig;
    final enabled = config['hasButton'] == true;
    final displayMode = config['displayMode']?.toString() ?? 'drawer';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(
          'History lookup',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        PropertyBuilderUtils.buildSwitch(
          label: 'Enable searchable lookup',
          value: enabled,
          description: 'Show an action button that searches prior submissions.',
          onChanged: (val) {
            if (!val) {
              _updateConfig(const {});
              return;
            }
            _updateConfig({
              'type': 'history_lookup',
              'hasButton': true,
              'searchable': true,
              'questionId': widget.question.id,
              'buttonLabel': _buttonLabelController.text.trim().isEmpty
                  ? 'Lookup History'
                  : _buttonLabelController.text.trim(),
              'displayMode': displayMode,
              'resultLimit': int.tryParse(_resultLimitController.text) ?? 10,
            });
          },
        ),
        if (enabled) ...[
          const SizedBox(height: 12),
          PropertyBuilderUtils.buildTextField(
            label: 'Button label',
            controller: _buttonLabelController,
            onChanged: (val) {
              _updateConfig({
                ...config,
                'type': 'history_lookup',
                'hasButton': true,
                'searchable': true,
                'questionId': widget.question.id,
                'buttonLabel': val,
                'displayMode': displayMode,
                'resultLimit': int.tryParse(_resultLimitController.text) ?? 10,
              });
            },
          ),
          const SizedBox(height: 12),
          PropertyBuilderUtils.buildDropdown<String>(
            label: 'Result display',
            value: displayMode,
            items: const [
              DropdownMenuItem(value: 'drawer', child: Text('Drawer')),
              DropdownMenuItem(value: 'table', child: Text('Table')),
              DropdownMenuItem(value: 'inline', child: Text('Inline')),
            ],
            onChanged: (val) {
              if (val == null) return;
              _updateConfig({
                ...config,
                'type': 'history_lookup',
                'hasButton': true,
                'searchable': true,
                'questionId': widget.question.id,
                'buttonLabel': _buttonLabelController.text.trim().isEmpty
                    ? 'Lookup History'
                    : _buttonLabelController.text.trim(),
                'displayMode': val,
                'resultLimit': int.tryParse(_resultLimitController.text) ?? 10,
              });
            },
          ),
          const SizedBox(height: 12),
          PropertyBuilderUtils.buildTextField(
            label: 'Result limit',
            controller: _resultLimitController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (val) {
              _updateConfig({
                ...config,
                'type': 'history_lookup',
                'hasButton': true,
                'searchable': true,
                'questionId': widget.question.id,
                'buttonLabel': _buttonLabelController.text.trim().isEmpty
                    ? 'Lookup History'
                    : _buttonLabelController.text.trim(),
                'displayMode': displayMode,
                'resultLimit': int.tryParse(val) ?? 10,
              });
            },
          ),
        ],
      ],
    );
  }
}
