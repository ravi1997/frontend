import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/localization/locale_controller.dart';
import '../../domain/entities/form_question.dart';
import '../../domain/entities/form_section.dart';
import '../../domain/entities/question_type.dart';

class LogicRuleDialog extends StatefulWidget {
  final FormQuestion currentQuestion;
  final List<FormSection> sections;
  final Map<String, dynamic>? initialRule;
  final String locale;

  const LogicRuleDialog({
    super.key,
    required this.currentQuestion,
    required this.sections,
    required this.locale,
    this.initialRule,
  });

  @override
  State<LogicRuleDialog> createState() => _LogicRuleDialogState();
}

class _LogicRuleDialogState extends State<LogicRuleDialog> {
  final _formKey = GlobalKey<FormState>(); // Added GlobalKey
  late String _action;
  late String _matchType;
  late TextEditingController _errorMessageController;
  late List<Map<String, dynamic>> _conditions;
  String? _selectedDisableOption;

  @override
  void initState() {
    super.initState();
    final rule = widget.initialRule ?? {};
    _action = rule['action'] ?? 'show';
    _errorMessageController = TextEditingController(
      text: rule['errorMessage'] ?? '',
    );
    _selectedDisableOption = rule['targetOption'];

    // Parse conditions
    // Structure: { matchType: 'and', rules: [...] }
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
        if (question.id != widget.currentQuestion.id) {
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
    } else if (type == QuestionType.date || type == QuestionType.time) {
      return {
        'equals': 'Equals',
        'not_equals': 'Not Equals',
        'before': 'Before',
        'after': 'After',
        'is_empty': 'Is Empty',
        'is_not_empty': 'Is Not Empty',
      };
    } else if (type == QuestionType.dropdown ||
        type == QuestionType.checkboxes ||
        type == QuestionType.multipleChoice) {
      return {
        'equals': 'Equals',
        'not_equals': 'Not Equals',
        'contains': 'Contains',
        'not_contains': 'Does Not Contain',
        'is_empty': 'Is Empty',
        'is_not_empty': 'Is Not Empty',
      };
    }

    // Default (Text, etc)
    return {
      'equals': 'Equals',
      'not_equals': 'Not Equals',
      'contains': 'Contains',
      'not_contains': 'Does Not Contain',
      'starts_with': 'Starts With',
      'ends_with': 'Ends With',
      'is_empty': 'Is Empty',
      'is_not_empty': 'Is Not Empty',
    };
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) { // Validate form
      // If validation action, require error message
      if (_action == 'validate' && _errorMessageController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please enter an error message for the validation rule.',
            ),
          ),
        );
        return;
      }

      final rule = {
        'action': _action,
        'errorMessage': _errorMessageController.text,
        'targetOption': _selectedDisableOption,
        'conditionGroup': {'matchType': _matchType, 'rules': _conditions},
      };

      Navigator.pop(context, rule);
    }
  }

  @override
  Widget build(BuildContext context) {
    final triggerQuestions = _getAvailableTriggers();
    final isOptionType =
        widget.currentQuestion.type == QuestionType.dropdown ||
        widget.currentQuestion.type == QuestionType.checkboxes ||
        widget.currentQuestion.type == QuestionType.multipleChoice;

    return AlertDialog(
      title: const Text('Configure Logic Rule'),
      scrollable: true,
      content: Form( // Added Form widget
        key: _formKey, // Assign key
        child: SizedBox(
          width: 600,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Action Section
              const Text(
                'ACTION',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: AppColors.textGrey,
                ),
              ),
              const SizedBox(height: 8),
              _buildDropdown(
                label: 'Action',
                value: _action,
                items: [
                  const DropdownMenuItem(
                    value: 'show',
                    child: Text('Show Question'),
                  ),
                  const DropdownMenuItem(
                    value: 'hide',
                    child: Text('Hide Question'),
                  ),
                  const DropdownMenuItem(
                    value: 'require',
                    child: Text('Make Required'),
                  ),
                  const DropdownMenuItem(
                    value: 'optional',
                    child: Text('Make Optional'),
                  ),
                  const DropdownMenuItem(
                    value: 'validate',
                    child: Text('Show Validation Error'),
                  ),
                  if (isOptionType)
                    const DropdownMenuItem(
                      value: 'disable_option',
                      child: Text('Disable Option'),
                    ),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _action = val);
                },
              ),

              // Contextual inputs based on Action
              if (_action == 'validate') ...[
                const SizedBox(height: 12),
                TextFormField( // Changed to TextFormField for validation
                  controller: _errorMessageController,
                  decoration: const InputDecoration(
                    labelText: 'Error Message',
                    border: OutlineInputBorder(),
                    hintText: 'e.g. You cannot select this option because...',
                  ),
                  validator: (value) { // Added validator
                    if (value == null || value.isEmpty) {
                      return 'Error message is required for validation rules';
                    }
                    return null;
                  },
                ),
              ],

              if (_action == 'disable_option' && isOptionType) ...[
                const SizedBox(height: 12),
                _buildDropdown(
                  label: 'Select Option to Disable',
                  value: _selectedDisableOption,
                  items: (widget.currentQuestion.options ?? []).map((opt) {
                    return DropdownMenuItem(value: opt, child: Text(opt));
                  }).toList(),
                  onChanged: (val) =>
                      setState(() => _selectedDisableOption = val),
                ),
              ],

              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 12),

              // Conditions Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'CONDITIONS',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: AppColors.textGrey,
                    ),
                  ),
                  DropdownButton<String>(
                    value: _matchType,
                    underline: const SizedBox(),
                    style: const TextStyle(
                      color: AppColors.brandBlue,
                      fontWeight: FontWeight.bold,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'and',
                        child: Text('Match ALL (AND)'),
                      ),
                      DropdownMenuItem(
                        value: 'or',
                        child: Text('Match ANY (OR)'),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _matchType = val);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),

              ..._conditions.asMap().entries.map((entry) {
                final index = entry.key;
                final condition = entry.value;
                return _buildConditionRow(index, condition, triggerQuestions);
              }),

              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _addCondition,
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Condition'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancel',
            style: TextStyle(color: AppColors.textGrey),
          ),
        ),
        ElevatedButton(
          onPressed: _onSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.brandBlue,
            foregroundColor: Colors.white,
          ),
          child: const Text('Save Rule'),
        ),
      ],
    );
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

    // Determine if value input is needed (not needed for is_empty etc)
    final op = condition['operator'];
    final needsValue = op != 'is_empty' && op != 'is_not_empty';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.builderElement,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 4,
                child: _buildDropdown(
                  label: 'Field',
                  value: selectedTriggerId,
                  items: triggers.map((q) {
                    return DropdownMenuItem(
                      value: q.id,
                      child: Text(
                        q.label.translate(widget.locale),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        condition['triggerId'] = val;
                        condition['operator'] = 'equals';
                        condition['value'] = '';
                      });
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 3,
                child: _buildDropdown(
                  label: 'Operator',
                  value: operators.containsKey(condition['operator'])
                      ? condition['operator']
                      : 'equals',
                  items: operators.entries.map((e) {
                    return DropdownMenuItem(
                      value: e.key,
                      child: Text(e.value, overflow: TextOverflow.ellipsis),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => condition['operator'] = val);
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              if (_conditions.length > 1)
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                    size: 20,
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

    // If trigger has options, show dropdown
    if (trigger.options != null && trigger.options!.isNotEmpty) {
      final opts = trigger.options!;
      return _buildDropdown(
        label: 'Value',
        value: opts.contains(condition['value']) ? condition['value'] : null,
        items: opts
            .map((o) => DropdownMenuItem(value: o, child: Text(o)))
            .toList(),
        onChanged: (val) => setState(() => condition['value'] = val ?? ''),
      );
    }

    // Date picker if date
    if (trigger.type == QuestionType.date) {
      return InkWell(
        onTap: () async {
          final d = await showDatePicker(
            context: context,
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            initialDate: DateTime.now(),
          );
          if (d != null) {
            setState(
              () => condition['value'] = d.toIso8601String().split('T').first,
            );
          }
        },
        child: IgnorePointer(
          child: TextFormField( // Changed to TextFormField
            controller: TextEditingController(text: condition['value']),
            decoration: const InputDecoration(
              labelText: 'Date (YYYY-MM-DD)',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.calendar_today),
            ),
            validator: (value) { // Added validator
              if (value == null || value.isEmpty) {
                return 'Date is required';
              }
              return null;
            },
          ),
        ),
      );
    }

    // Default text input
    return TextFormField( // Changed to TextFormField
      controller: TextEditingController(text: condition['value'])
        ..selection = TextSelection.collapsed(
          offset: condition['value']?.length ?? 0,
        ),
      decoration: const InputDecoration(
        labelText: 'Value',
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        border: OutlineInputBorder(),
      ),
      onChanged: (val) => condition['value'] = val,
      validator: (value) { // Added validator
        final op = condition['operator'];
        final needsValue = op != 'is_empty' && op != 'is_not_empty';
        if (needsValue && (value == null || value.isEmpty)) {
          return 'Value is required';
        }
        return null;
      },
    );
  }

  Widget _buildDropdown({
    required String? label,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          items: items,
          onChanged: onChanged,
          isExpanded: true,
          isDense: true,
          style: const TextStyle(color: AppColors.textDark, fontSize: 13),
        ),
      ),
    );
  }
}
