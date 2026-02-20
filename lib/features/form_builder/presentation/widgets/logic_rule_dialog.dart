import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/localization/locale_controller.dart';
import '../../domain/entities/form_question.dart';
import '../../domain/entities/form_section.dart';
import '../../domain/entities/question_type.dart';

enum LogicActionCategory {
  visibility,
  requirement,
  logicalValues,
  navigation,
  automation,
}

class LogicRuleDialog extends StatefulWidget {
  final FormQuestion? currentQuestion;
  final FormSection? currentSection;
  final List<FormSection> sections;
  final Map<String, dynamic>? initialRule;
  final String locale;
  final Function(Map<String, dynamic>)? onRuleSaved;

  const LogicRuleDialog({
    super.key,
    this.currentQuestion,
    this.currentSection,
    required this.sections,
    required this.locale,
    this.initialRule,
    this.onRuleSaved,
  });

  @override
  State<LogicRuleDialog> createState() => _LogicRuleDialogState();
}

class _LogicRuleDialogState extends State<LogicRuleDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _action;
  late String _matchType;
  late TextEditingController _errorMessageController;
  late TextEditingController _valueController;
  late TextEditingController _formulaController;
  late TextEditingController _webhookUrlController;
  late List<Map<String, dynamic>> _webhookMappings;
  late List<Map<String, dynamic>> _conditions;
  String? _selectedDisableOption;
  String? _targetSectionId;
  String? _selectedDepartment;
  String _webhookMethod = 'GET';
  List<Map<String, dynamic>> _dynamicOptions = [];

  @override
  void initState() {
    super.initState();
    final rule = widget.initialRule ?? {};
    _action = rule['action'] ?? 'show';
    _errorMessageController = TextEditingController(
      text: rule['errorMessage'] ?? '',
    );
    _valueController = TextEditingController(text: rule['value'] ?? '');
    _formulaController = TextEditingController(text: rule['formula'] ?? '');
    _webhookUrlController = TextEditingController(
      text: rule['webhookUrl'] ?? '',
    );
    _webhookMethod = rule['webhookMethod'] ?? 'GET';
    _webhookMappings = List<Map<String, dynamic>>.from(
      rule['webhookMappings'] ?? [],
    );
    _dynamicOptions = List<Map<String, dynamic>>.from(
      rule['dynamicOptions'] ?? [],
    );
    _selectedDisableOption = rule['targetOption'];
    _targetSectionId = rule['targetSectionId'];
    _selectedDepartment = rule['department'];

    final conditionGroup =
        rule['conditionGroup'] as Map<String, dynamic>? ?? {};
    _matchType = conditionGroup['matchType'] ?? 'and';
    _conditions = List<Map<String, dynamic>>.from(
      (conditionGroup['rules'] as List? ?? []).map(
        (e) => Map<String, dynamic>.from(e),
      ),
    );

    if (_conditions.isEmpty) {
      _addCondition();
    }
  }

  @override
  void dispose() {
    _errorMessageController.dispose();
    _valueController.dispose();
    _formulaController.dispose();
    _webhookUrlController.dispose();
    super.dispose();
  }

  void _addCondition() {
    setState(() {
      _conditions.add({'triggerId': null, 'operator': 'equals', 'value': ''});
    });
  }

  List<FormQuestion> _getAvailableTriggers() {
    final triggers = <FormQuestion>[];
    for (final section in widget.sections) {
      for (final question in section.questions) {
        if (widget.currentQuestion == null ||
            question.id != widget.currentQuestion!.id) {
          triggers.add(question);
        }
      }
    }
    return triggers;
  }

  Map<String, String> _getOperators(QuestionType type) {
    if (type == QuestionType.number) {
      return {
        'equals': 'Equals (=)',
        'not_equals': 'Not Equals (!=)',
        'greater_than': 'Greater Than (>)',
        'less_than': 'Less Than (<)',
        'greater_than_equals': 'Greater Than or Equal (>=)',
        'less_than_equals': 'Less Than or Equal (<=)',
        'is_empty': 'Is Empty',
        'is_not_empty': 'Is Not Empty',
      };
    }
    if (type == QuestionType.date || type == QuestionType.time) {
      return {
        'equals': 'Equals',
        'not_equals': 'Not Equals',
        'before': 'Before',
        'after': 'After',
        'is_empty': 'Is Empty',
        'is_not_empty': 'Is Not Empty',
      };
    }
    return {
      'equals': 'Equals',
      'not_equals': 'Not Equals',
      'contains': 'Contains',
      'not_contains': 'Does Not Contain',
      'is_empty': 'Is Empty',
      'is_not_empty': 'Is Not Empty',
    };
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      final rule = {
        'action': _action,
        'errorMessage': _errorMessageController.text,
        'value': _valueController.text,
        'formula': _formulaController.text,
        'webhookUrl': _webhookUrlController.text,
        'webhookMethod': _webhookMethod,
        'webhookMappings': _webhookMappings,
        'dynamicOptions': _dynamicOptions,
        'targetOption': _selectedDisableOption,
        'targetSectionId': _targetSectionId,
        'department': _selectedDepartment,
        'conditionGroup': {'matchType': _matchType, 'rules': _conditions},
      };

      if (widget.onRuleSaved != null) {
        widget.onRuleSaved!(rule);
      }
      Navigator.pop(context, rule);
    }
  }

  @override
  Widget build(BuildContext context) {
    final triggerQuestions = _getAvailableTriggers();
    final isFieldLogic = widget.currentQuestion != null;

    return AlertDialog(
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.psychology,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            widget.initialRule == null ? 'New Logic Rule' : 'Edit Logic Rule',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.surfaceDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      scrollable: true,
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 600,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSectionHeader('IF THE FOLLOWING CONDITIONS ARE MET:'),
              const SizedBox(height: 12),
              _buildMatchToggle(),
              const SizedBox(height: 12),
              ..._conditions.asMap().entries.map((entry) {
                return _buildConditionRow(
                  entry.key,
                  entry.value,
                  triggerQuestions,
                );
              }),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: _addCondition,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Condition'),
              ),
              Divider(
                height: 40,
                color: AppColors.primary.withValues(alpha: 0.1),
              ),
              _buildSectionHeader('THEN DO THIS ACTION:'),
              const SizedBox(height: 16),
              _buildActionSelector(isFieldLogic),
              const SizedBox(height: 16),
              _buildContextualInputs(isFieldLogic),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancel',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        ElevatedButton(
          onPressed: _onSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Save Rule'),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.only(left: 8, bottom: 4),
      decoration: const BoxDecoration(
        border: Border(left: BorderSide(color: AppColors.primary, width: 3)),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 11,
          color: AppColors.textSecondary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildMatchToggle() {
    return Row(
      children: [
        const Text(
          'Match ',
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        DropdownButton<String>(
          value: _matchType,
          underline: const SizedBox(),
          dropdownColor: AppColors.surfaceDark,
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
          items: const [
            DropdownMenuItem(value: 'and', child: Text('ALL (AND)')),
            DropdownMenuItem(value: 'or', child: Text('ANY (OR)')),
          ],
          onChanged: (val) {
            if (val != null) setState(() => _matchType = val);
          },
        ),
        const Text(
          ' of the conditions',
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildActionSelector(bool isFieldLogic) {
    final List<Map<String, dynamic>> actions = [
      if (isFieldLogic) ...[
        {'value': 'show', 'label': 'Show Field', 'icon': Icons.visibility},
        {'value': 'hide', 'label': 'Hide Field', 'icon': Icons.visibility_off},
        {'value': 'require', 'label': 'Make Required', 'icon': Icons.star},
        {
          'value': 'optional',
          'label': 'Make Optional',
          'icon': Icons.star_border,
        },
        {'value': 'set_value', 'label': 'Set Field Value', 'icon': Icons.edit},
        {
          'value': 'validate',
          'label': 'Show Error',
          'icon': Icons.error_outline,
        },
      ],
      if (!isFieldLogic) ...[
        {
          'value': 'jump_to_section',
          'label': 'Jump to Section',
          'icon': Icons.redo,
        },
        {
          'value': 'end_form',
          'label': 'End Form / Submit',
          'icon': Icons.exit_to_app,
        },
        {
          'value': 'set_department',
          'label': 'Route to Department',
          'icon': Icons.business,
        },
      ],
      {'value': 'webhook', 'label': 'Trigger Webhook', 'icon': Icons.webhook},
      {
        'value': 'update_options',
        'label': 'Update Options',
        'icon': Icons.list_alt,
      },
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: actions.map((a) {
        final isSelected = _action == a['value'];
        return ChoiceChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                a['icon'],
                size: 14,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(a['label']),
            ],
          ),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) setState(() => _action = a['value']);
          },
          selectedColor: AppColors.primary,
          backgroundColor: AppColors.surfaceDark,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontSize: 12,
          ),
          side: BorderSide(
            color: isSelected
                ? Colors.transparent
                : AppColors.primary.withValues(alpha: 0.3),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildContextualInputs(bool isFieldLogic) {
    if (_action == 'validate') {
      return TextFormField(
        controller: _errorMessageController,
        style: const TextStyle(color: AppColors.textPrimary),
        decoration: InputDecoration(
          labelText: 'Error Message',
          labelStyle: const TextStyle(color: AppColors.textSecondary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: AppColors.primary.withValues(alpha: 0.3),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: AppColors.primary.withValues(alpha: 0.3),
            ),
          ),
          hintText: 'Enter message to show when conditions met',
          hintStyle: const TextStyle(color: AppColors.textTertiary),
        ),
        validator: (v) => v?.isEmpty == true ? 'Required' : null,
      );
    }
    if (_action == 'set_value') {
      return TextFormField(
        controller: _valueController,
        style: const TextStyle(color: AppColors.textPrimary),
        decoration: InputDecoration(
          labelText: 'New Value',
          labelStyle: const TextStyle(color: AppColors.textSecondary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: AppColors.primary.withValues(alpha: 0.3),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: AppColors.primary.withValues(alpha: 0.3),
            ),
          ),
          hintText: 'Value to set in this field',
          hintStyle: const TextStyle(color: AppColors.textTertiary),
        ),
      );
    }
    if (_action == 'jump_to_section') {
      return _buildDropdown(
        label: 'Select Target Section',
        value: _targetSectionId,
        items: widget.sections
            .where(
              (s) =>
                  widget.currentSection == null ||
                  s.id != widget.currentSection!.id,
            )
            .map(
              (s) => DropdownMenuItem(
                value: s.id,
                child: Text(s.title.translate(widget.locale)),
              ),
            )
            .toList(),
        onChanged: (val) => setState(() => _targetSectionId = val),
      );
    }
    if (_action == 'set_department') {
      return _buildDropdown(
        label: 'Route to Department',
        value: _selectedDepartment,
        items: const [
          DropdownMenuItem(value: 'finance', child: Text('Finance')),
          DropdownMenuItem(value: 'technical', child: Text('Technical')),
          DropdownMenuItem(value: 'hr', child: Text('Human Resources')),
          DropdownMenuItem(value: 'ai', child: Text('Aetheris AI')),
        ],
        onChanged: (val) => setState(() => _selectedDepartment = val),
      );
    }
    if (_action == 'webhook') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildDropdown(
                  label: 'Method',
                  value: _webhookMethod,
                  items: const [
                    DropdownMenuItem(value: 'GET', child: Text('GET')),
                    DropdownMenuItem(value: 'POST', child: Text('POST')),
                  ],
                  onChanged: (v) => setState(() => _webhookMethod = v!),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 5,
                child: TextFormField(
                  controller: _webhookUrlController,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(
                    labelText: 'Webhook URL',
                    hintText: 'https://api.example.com/data',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'RESPONSE MAPPING',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          ..._webhookMappings.asMap().entries.map((e) {
            final i = e.key;
            final m = e.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: m['responseKey'],
                      onChanged: (v) => m['responseKey'] = v,
                      decoration: const InputDecoration(
                        hintText: 'JSON Key (e.g. data.name)',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(Icons.arrow_forward, size: 14),
                  ),
                  Expanded(
                    child: _buildDropdown(
                      label: 'Target Field',
                      value: m['targetFieldId'],
                      items: _getAvailableTriggers()
                          .map(
                            (q) => DropdownMenuItem(
                              value: q.id,
                              child: Text(
                                '${q.label.translate(widget.locale)} (${q.variableName?.isNotEmpty == true ? q.variableName : q.id})',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => m['targetFieldId'] = v),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, size: 20),
                    onPressed: () =>
                        setState(() => _webhookMappings.removeAt(i)),
                  ),
                ],
              ),
            );
          }),
          TextButton.icon(
            onPressed: () => setState(() {
              _webhookMappings.add({'responseKey': '', 'targetFieldId': null});
            }),
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Add Mapping'),
          ),
        ],
      );
    }
    if (_action == 'update_options') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'DEFINE NEW OPTIONS',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          ..._dynamicOptions.asMap().entries.map((e) {
            final i = e.key;
            final o = e.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: o['label'],
                      onChanged: (v) => o['label'] = v,
                      decoration: const InputDecoration(
                        hintText: 'Label',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      initialValue: o['value'],
                      onChanged: (v) => o['value'] = v,
                      decoration: const InputDecoration(
                        hintText: 'Value',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, size: 20),
                    onPressed: () =>
                        setState(() => _dynamicOptions.removeAt(i)),
                  ),
                ],
              ),
            );
          }),
          TextButton.icon(
            onPressed: () => setState(() {
              _dynamicOptions.add({'label': '', 'value': ''});
            }),
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Add Option'),
          ),
        ],
      );
    }
    return const SizedBox();
  }

  Widget _buildConditionRow(
    int index,
    Map<String, dynamic> condition,
    List<FormQuestion> triggers,
  ) {
    final selectedTriggerId = condition['triggerId'];
    final selectedTrigger = triggers
        .where((t) => t.id == selectedTriggerId)
        .firstOrNull;
    final operators = selectedTrigger != null
        ? _getOperators(selectedTrigger.type)
        : {'equals': 'Equals'};
    final op = condition['operator'];
    final needsValue = op != 'is_empty' && op != 'is_not_empty';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 4,
                child: _buildDropdown(
                  label: 'If Field',
                  value: selectedTriggerId,
                  items: triggers
                      .map(
                        (q) => DropdownMenuItem(
                          value: q.id,
                          child: Text(
                            '${q.label.translate(widget.locale)} (${q.variableName?.isNotEmpty == true ? q.variableName : q.id})',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      condition['triggerId'] = val;
                      condition['operator'] = 'equals';
                      condition['value'] = '';
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 3,
                child: _buildDropdown(
                  label: 'Condition',
                  value: operators.containsKey(condition['operator'])
                      ? condition['operator']
                      : 'equals',
                  items: operators.entries
                      .map(
                        (e) => DropdownMenuItem(
                          value: e.key,
                          child: Text(e.value, overflow: TextOverflow.ellipsis),
                        ),
                      )
                      .toList(),
                  onChanged: (val) =>
                      setState(() => condition['operator'] = val),
                ),
              ),
              if (_conditions.length > 1)
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    size: 20,
                    color: Colors.redAccent,
                  ),
                  onPressed: () => setState(() => _conditions.removeAt(index)),
                ),
            ],
          ),
          if (needsValue) ...[
            const SizedBox(height: 8),
            _buildValueInput(condition, selectedTrigger),
          ],
        ],
      ),
    );
  }

  Widget _buildValueInput(
    Map<String, dynamic> condition,
    FormQuestion? trigger,
  ) {
    if (trigger == null) return const SizedBox();

    // 1. Handle types with predefined options (Dropdown, Multiple Choice, Checkboxes)
    if (trigger.options != null && trigger.options!.isNotEmpty) {
      return _buildDropdown(
        label: 'Select Value',
        value: trigger.options!.any((o) => o.value == condition['value'])
            ? condition['value']
            : null,
        items: trigger.options!
            .map((o) => DropdownMenuItem(value: o.value, child: Text(o.label)))
            .toList(),
        onChanged: (val) => setState(() => condition['value'] = val ?? ''),
      );
    }

    // 2. Handle Rating (usually 1-5 if not specified)
    if (trigger.type == QuestionType.rating) {
      final max = trigger.maxValue?.toInt() ?? 5;
      return _buildDropdown(
        label: 'Select Rating',
        value: condition['value'],
        items: List.generate(
          max,
          (i) => DropdownMenuItem(
            value: (i + 1).toString(),
            child: Text((i + 1).toString()),
          ),
        ),
        onChanged: (val) => setState(() => condition['value'] = val ?? ''),
      );
    }

    // 3. Handle Boolean-like types (not explicitly in enum but often requested)
    // if (trigger.type == QuestionType.boolean) ...

    // 4. Handle Date
    if (trigger.type == QuestionType.date) {
      return _buildGenericPicker(
        label: 'Pick Date',
        value: condition['value'],
        icon: Icons.calendar_today,
        onTap: () async {
          final current =
              DateTime.tryParse(condition['value']) ?? DateTime.now();
          final date = await showDatePicker(
            context: context,
            initialDate: current,
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
            builder: (context, child) => Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.dark(
                  primary: AppColors.primary,
                  onPrimary: Colors.white,
                  surface: AppColors.surfaceDark,
                  onSurface: Colors.white,
                ),
              ),
              child: child!,
            ),
          );
          if (date != null) {
            setState(() {
              condition['value'] = date.toIso8601String().split('T')[0];
            });
          }
        },
      );
    }

    // 5. Handle Time
    if (trigger.type == QuestionType.time) {
      return _buildGenericPicker(
        label: 'Pick Time',
        value: condition['value'],
        icon: Icons.access_time,
        onTap: () async {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
            builder: (context, child) => Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.dark(
                  primary: AppColors.primary,
                  onPrimary: Colors.white,
                  surface: AppColors.surfaceDark,
                  onSurface: Colors.white,
                ),
              ),
              child: child!,
            ),
          );
          if (time != null) {
            setState(() {
              condition['value'] =
                  '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
            });
          }
        },
      );
    }

    // 6. Default: Text input (Number or Text)
    return TextFormField(
      key: ValueKey('${trigger.id}_${condition['operator']}'),
      initialValue: condition['value'],
      style: const TextStyle(color: AppColors.textPrimary),
      keyboardType: trigger.type == QuestionType.number
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Value',
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        hintText: trigger.type == QuestionType.number
            ? 'Enter number'
            : 'Enter value',
        hintStyle: const TextStyle(color: AppColors.textTertiary, fontSize: 13),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.3),
          ),
        ),
        isDense: true,
      ),
      onChanged: (val) => condition['value'] = val,
      validator: (v) => v?.isEmpty == true ? 'Required' : null,
    );
  }

  Widget _buildGenericPicker({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    value.isEmpty ? 'Select...' : value,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.3),
          ),
        ),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          items: items,
          onChanged: onChanged,
          isExpanded: true,
          dropdownColor: AppColors.surfaceDark,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
        ),
      ),
    );
  }
}
