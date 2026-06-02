import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/localization/locale_controller.dart';
import 'package:frontend/core/form_models.dart' hide Form;
import 'package:frontend/features/form_builder/models/question_type.dart';

class WorkflowConfigurationDialog extends StatefulWidget {
  final Map<String, dynamic> initialWorkflows;
  final List<FormSection> sections;
  final String locale;
  final Function(Map<String, dynamic>) onSave;

  const WorkflowConfigurationDialog({
    super.key,
    required this.initialWorkflows,
    required this.sections,
    required this.locale,
    required this.onSave,
  });

  @override
  State<WorkflowConfigurationDialog> createState() =>
      _WorkflowConfigurationDialogState();
}

class _WorkflowConfigurationDialogState
    extends State<WorkflowConfigurationDialog> {
  final _formKey = GlobalKey<FormState>();

  // Integation States
  late bool _emailEnabled;
  late bool _webhookEnabled;

  // Configuration Controllers - Email
  late TextEditingController _emailController;
  late TextEditingController _emailSubjectController;
  late TextEditingController _emailBodyController;
  late bool _includeSummaryEnabled;

  // Configuration Controllers - Webhook
  late TextEditingController _webhookController;
  late bool _haltOnWebhookFailure;
  late List<Map<String, String>> _webhookHeaders;

  // Condition States
  late Map<String, Map<String, dynamic>> _conditions;

  @override
  void initState() {
    super.initState();
    final workflows = widget.initialWorkflows;

    _emailEnabled = workflows['email_notification']?['enabled'] ?? false;
    _webhookEnabled = workflows['webhook']?['enabled'] ?? false;

    _emailController = TextEditingController(
      text: workflows['email_notification']?['recipient'] ?? '',
    );
    _emailSubjectController = TextEditingController(
      text:
          workflows['email_notification']?['subject'] ?? 'New Form Submission',
    );
    _emailBodyController = TextEditingController(
      text: workflows['email_notification']?['body'] ?? '',
    );
    _includeSummaryEnabled =
        workflows['email_notification']?['includeSummary'] ?? true;

    _webhookController = TextEditingController(
      text: workflows['webhook']?['url'] ?? '',
    );
    _haltOnWebhookFailure = workflows['webhook']?['haltOnFailure'] ?? false;

    final rawHeaders = workflows['webhook']?['headers'] as List? ?? [];
    _webhookHeaders = List<Map<String, String>>.from(
      rawHeaders.map((e) => Map<String, String>.from(e as Map)),
    );

    _conditions = {};
    for (var key in ['email_notification', 'webhook']) {
      final conditionGroup =
          workflows[key]?['conditionGroup'] as Map<String, dynamic>? ?? {};
      final oldCondition =
          workflows[key]?['condition'] as Map<String, dynamic>?;

      _conditions[key] = {
        'enabled':
            conditionGroup['enabled'] ?? oldCondition?['enabled'] ?? false,
        'matchType': conditionGroup['matchType'] ?? 'and',
        'rules': List<Map<String, dynamic>>.from(
          (conditionGroup['rules'] as List? ?? []).map(
            (e) => Map<String, dynamic>.from(e),
          ),
        ),
      };

      // If legacy format or empty, populate with at least one rule
      if ((_conditions[key]!['rules'] as List).isEmpty) {
        if (oldCondition != null && oldCondition['field'] != null) {
          _conditions[key]!['rules']!.add({
            'triggerId': oldCondition['field'],
            'operator': oldCondition['operator'] ?? 'equals',
            'value': oldCondition['value'] ?? '',
          });
        } else {
          _conditions[key]!['rules']!.add({
            'triggerId': null,
            'operator': 'equals',
            'value': '',
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailSubjectController.dispose();
    _emailBodyController.dispose();
    _webhookController.dispose();
    super.dispose();
  }

  void _saveLogic() {
    if (!_formKey.currentState!.validate()) return;

    // Prune unconfigured condition rules before saving
    final emailConditions = _conditions['email_notification']!;
    final emailRules = (emailConditions['rules'] as List)
        .where((r) => r['triggerId'] != null)
        .toList();
    emailConditions['rules'] = emailRules;

    final webhookConditions = _conditions['webhook']!;
    final webhookRules = (webhookConditions['rules'] as List)
        .where((r) => r['triggerId'] != null)
        .toList();
    webhookConditions['rules'] = webhookRules;

    final config = {
      'email_notification': {
        'enabled': _emailEnabled,
        'recipient': _emailController.text,
        'subject': _emailSubjectController.text,
        'body': _emailBodyController.text,
        'includeSummary': _includeSummaryEnabled,
        'conditionGroup': emailConditions,
      },
      'webhook': {
        'enabled': _webhookEnabled,
        'url': _webhookController.text,
        'haltOnFailure': _haltOnWebhookFailure,
        'headers': _webhookHeaders,
        'conditionGroup': webhookConditions,
      },
    };

    widget.onSave(config);
    Navigator.of(context).pop();
  }

  List<FormQuestion> _getAvailableTriggers() {
    final triggers = <FormQuestion>[];
    for (final section in widget.sections) {
      triggers.addAll(section.questions);
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

  Widget _buildVariableHelper(TextEditingController controller) {
    return IconButton(
      icon: const Icon(Icons.data_object, size: 20, color: AppColors.primary),
      tooltip: 'Insert Variable',
      onPressed: () {
        _showVariablePicker(controller);
      },
    );
  }

  void _showVariablePicker(TextEditingController controller) {
    final triggers = _getAvailableTriggers();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Insert Variable',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.textDark,
            ),
          ),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Container(
            width: double.maxFinite,
            constraints: const BoxConstraints(maxWidth: 400, maxHeight: 400),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: triggers.length,
              separatorBuilder: (context, index) =>
                  Divider(height: 1, color: Colors.grey.shade200),
              itemBuilder: (context, index) {
                final q = triggers[index];
                return ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.tag,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ),
                  title: Text(
                    q.label.translate(widget.locale),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDark,
                    ),
                  ),
                  subtitle: Text(
                    '{${q.variableName?.isNotEmpty == true ? q.variableName : q.id}}',
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  dense: true,
                  onTap: () {
                    final val =
                        '{${q.variableName?.isNotEmpty == true ? q.variableName : q.id}}';
                    final currentText = controller.text;
                    final selection = controller.selection;
                    if (selection.isValid && selection.start >= 0) {
                      final newText = currentText.replaceRange(
                        selection.start,
                        selection.end,
                        val,
                      );
                      controller.value = controller.value.copyWith(
                        text: newText,
                        selection: TextSelection.collapsed(
                          offset: selection.start + val.length,
                        ),
                      );
                    } else {
                      controller.text = currentText + val;
                      controller.selection = TextSelection.collapsed(
                        offset: controller.text.length,
                      );
                    }
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Close',
                style: TextStyle(color: AppColors.textGrey),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
              Icons.account_tree,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Form Workflows',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      scrollable: true,
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Configure automated actions when a form is submitted.',
                style: TextStyle(color: AppColors.textGrey, fontSize: 13),
              ),
              const SizedBox(height: 24),
              _buildIntegrationItem(
                icon: Icons.email_outlined,
                title: 'Email Notification',
                description: 'Send an email when a response is received',
                isEnabled: _emailEnabled,
                id: 'email_notification',
                onToggle: (val) => setState(() => _emailEnabled = val),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _emailController,
                            style: const TextStyle(color: AppColors.textDark),
                            decoration: InputDecoration(
                              labelText: 'Recipient Email',
                              labelStyle: const TextStyle(
                                color: AppColors.textGrey,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              hintText: 'user@example.com OR {question_id}',
                              hintStyle: const TextStyle(color: Colors.grey),
                              isDense: true,
                            ),
                            validator: (value) {
                              if (_emailEnabled &&
                                  (value == null || value.isEmpty)) {
                                return 'Recipient email is required';
                              }
                              return null;
                            },
                          ),
                        ),
                        _buildVariableHelper(_emailController),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _emailSubjectController,
                            style: const TextStyle(color: AppColors.textDark),
                            decoration: InputDecoration(
                              labelText: 'Email Subject',
                              labelStyle: const TextStyle(
                                color: AppColors.textGrey,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              hintText: 'New Form Submission',
                              hintStyle: const TextStyle(color: Colors.grey),
                              isDense: true,
                            ),
                            validator: (value) {
                              if (_emailEnabled &&
                                  (value == null || value.isEmpty)) {
                                return 'Subject is required';
                              }
                              return null;
                            },
                          ),
                        ),
                        _buildVariableHelper(_emailSubjectController),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _emailBodyController,
                            style: const TextStyle(color: AppColors.textDark),
                            maxLines: 4,
                            decoration: InputDecoration(
                              labelText: 'Email Body (Optional)',
                              alignLabelWithHint: true,
                              labelStyle: const TextStyle(
                                color: AppColors.textGrey,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              hintText: 'Thank you for your submission {name}!',
                              hintStyle: const TextStyle(color: Colors.grey),
                              isDense: true,
                            ),
                          ),
                        ),
                        _buildVariableHelper(_emailBodyController),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: SwitchListTile(
                        title: const Text(
                          'Include form responses summary',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textDark,
                          ),
                        ),
                        subtitle: const Text(
                          'Attaches a table of all submitted answers to the email',
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                        value: _includeSummaryEnabled,
                        onChanged: (v) =>
                            setState(() => _includeSummaryEnabled = v),
                        activeTrackColor: AppColors.primary,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 32,
                color: AppColors.primary.withValues(alpha: 0.1),
              ),
              _buildIntegrationItem(
                icon: Icons.webhook,
                title: 'Webhook',
                description: 'POST submission data to an external URL',
                isEnabled: _webhookEnabled,
                id: 'webhook',
                onToggle: (val) => setState(() => _webhookEnabled = val),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _webhookController,
                            style: const TextStyle(color: AppColors.textDark),
                            decoration: InputDecoration(
                              labelText: 'Webhook URL',
                              labelStyle: const TextStyle(
                                color: AppColors.textGrey,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              hintText:
                                  'https://api.example.com/hooks/{user_id}',
                              hintStyle: const TextStyle(color: Colors.grey),
                              isDense: true,
                            ),
                            validator: (value) {
                              if (_webhookEnabled &&
                                  (value == null || value.isEmpty)) {
                                return 'Webhook URL is required';
                              }
                              return null;
                            },
                          ),
                        ),
                        _buildVariableHelper(_webhookController),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: SwitchListTile(
                        title: const Text(
                          'Halt Submission on Failure',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textDark,
                          ),
                        ),
                        subtitle: const Text(
                          'If the webhook fails (e.g. 500 error), the user sees a "Submission Failed" screen.',
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                        value: _haltOnWebhookFailure,
                        onChanged: (v) =>
                            setState(() => _haltOnWebhookFailure = v),
                        activeTrackColor: Colors.redAccent,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Headers (Optional)',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    ..._webhookHeaders.asMap().entries.map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                initialValue: e.value['key'],
                                onChanged: (v) => e.value['key'] = v,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textDark,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Key (e.g. Authorization)',
                                  hintStyle: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                initialValue: e.value['value'],
                                onChanged: (v) => e.value['value'] = v,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textDark,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Value (e.g. Bearer token)',
                                  hintStyle: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.remove_circle,
                                size: 20,
                                color: Colors.redAccent,
                              ),
                              onPressed: () => setState(
                                () => _webhookHeaders.removeAt(e.key),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        icon: const Icon(Icons.add_circle_outline, size: 14),
                        label: const Text(
                          'Add Header',
                          style: TextStyle(fontSize: 12),
                        ),
                        onPressed: () => setState(
                          () => _webhookHeaders.add({'key': '', 'value': ''}),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Cancel',
            style: TextStyle(color: AppColors.textGrey),
          ),
        ),
        ElevatedButton(
          onPressed: _saveLogic,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Save Logic'),
        ),
      ],
    );
  }

  Widget _buildIntegrationItem({
    required IconData icon,
    required String title,
    required String description,
    required bool isEnabled,
    required String id,
    required ValueChanged<bool> onToggle,
    Widget? child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isEnabled
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isEnabled ? AppColors.primary : Colors.grey,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: AppColors.textDark,
                    ),
                  ),
                  Text(
                    description,
                    style: const TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: isEnabled,
              onChanged: onToggle,
              activeTrackColor: AppColors.primary,
            ),
          ],
        ),
        if (isEnabled && child != null) ...[
          const SizedBox(height: 16),
          Padding(padding: const EdgeInsets.only(left: 44), child: child),
        ],
        if (isEnabled) ...[
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 44),
            child: _buildConditionBuilder(id),
          ),
        ],
      ],
    );
  }

  Widget _buildConditionBuilder(String integrationId) {
    final conditionGroup = _conditions[integrationId]!;
    final isConditional = conditionGroup['enabled'] ?? false;
    final rules = List<Map<String, dynamic>>.from(
      conditionGroup['rules'] ?? [],
    );
    final triggerQuestions = _getAvailableTriggers();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.filter_list, size: 14, color: Colors.grey),
            const SizedBox(width: 8),
            Text(
              'Workflow Logic',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isConditional ? AppColors.primary : Colors.grey,
              ),
            ),
            const Spacer(),
            Text(
              isConditional ? 'Conditional' : 'Run Always',
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
            Switch(
              value: isConditional,
              onChanged: (val) {
                setState(() {
                  _conditions[integrationId]!['enabled'] = val;
                });
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
        if (isConditional) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Match ',
                      style: TextStyle(fontSize: 12, color: AppColors.textGrey),
                    ),
                    DropdownButton<String>(
                      value: conditionGroup['matchType'] ?? 'and',
                      underline: const SizedBox(),
                      dropdownColor: Colors.white,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'and',
                          child: Text('ALL (AND)'),
                        ),
                        DropdownMenuItem(value: 'or', child: Text('ANY (OR)')),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setState(
                            () =>
                                _conditions[integrationId]!['matchType'] = val,
                          );
                        }
                      },
                    ),
                    const Text(
                      ' of the conditions',
                      style: TextStyle(fontSize: 12, color: AppColors.textGrey),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...rules.asMap().entries.map((entry) {
                  return _buildConditionRow(
                    entry.key,
                    entry.value,
                    triggerQuestions,
                    integrationId,
                  );
                }),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      (_conditions[integrationId]!['rules'] as List).add({
                        'triggerId': null,
                        'operator': 'equals',
                        'value': '',
                      });
                    });
                  },
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text(
                    'Add Condition',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildConditionRow(
    int index,
    Map<String, dynamic> condition,
    List<FormQuestion> triggers,
    String integrationId,
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
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
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
                          child: Text(
                            e.value,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (val) =>
                      setState(() => condition['operator'] = val),
                ),
              ),
              if ((_conditions[integrationId]!['rules'] as List).length > 1)
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    size: 16,
                    color: Colors.redAccent,
                  ),
                  onPressed: () => setState(
                    () => (_conditions[integrationId]!['rules'] as List)
                        .removeAt(index),
                  ),
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

    if (trigger.options.isNotEmpty) {
      return _buildDropdown(
        label: 'Select Value',
        value: trigger.options.any((o) => o.value == condition['value'])
            ? condition['value']
            : null,
        items: trigger.options
            .map(
              (o) => DropdownMenuItem(
                value: o.value,
                child: Text(o.label, style: const TextStyle(fontSize: 12)),
              ),
            )
            .toList(),
        onChanged: (val) => setState(() => condition['value'] = val ?? ''),
      );
    }

    if (trigger.type == QuestionType.rating) {
      final max = trigger.maxValue?.toInt() ?? 5;
      return _buildDropdown(
        label: 'Select Rating',
        value: condition['value'],
        items: List.generate(
          max,
          (i) => DropdownMenuItem(
            value: (i + 1).toString(),
            child: Text(
              (i + 1).toString(),
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ),
        onChanged: (val) => setState(() => condition['value'] = val ?? ''),
      );
    }

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
                colorScheme: const ColorScheme.light(
                  primary: AppColors.primary,
                  onPrimary: Colors.white,
                  surface: Colors.white,
                  onSurface: AppColors.textDark,
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
                colorScheme: const ColorScheme.light(
                  primary: AppColors.primary,
                  onPrimary: Colors.white,
                  surface: Colors.white,
                  onSurface: AppColors.textDark,
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

    return TextFormField(
      key: ValueKey('${trigger.id}_${condition['operator']}'),
      initialValue: condition['value'],
      style: const TextStyle(color: AppColors.textDark, fontSize: 12),
      keyboardType: trigger.type == QuestionType.number
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Value',
        labelStyle: const TextStyle(color: Colors.grey, fontSize: 12),
        hintText: trigger.type == QuestionType.number
            ? 'Enter number'
            : 'Enter value',
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: Colors.grey),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                  Text(
                    value.isEmpty ? 'Select...' : value,
                    style: const TextStyle(
                      color: AppColors.textDark,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.grey),
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
        labelStyle: const TextStyle(color: Colors.grey, fontSize: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
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
          dropdownColor: Colors.white,
          style: const TextStyle(color: AppColors.textDark, fontSize: 12),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.grey, size: 20),
        ),
      ),
    );
  }
}
