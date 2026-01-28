import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/form_section.dart';
import '../../domain/entities/form_question.dart';
import '../../domain/entities/question_type.dart';

import '../../domain/entities/section_layout_type.dart';
import '../controllers/form_builder_controller.dart';

class SectionPropertiesWidget extends ConsumerStatefulWidget {
  final String formId;
  final String selectedSectionId;

  const SectionPropertiesWidget({
    super.key,
    required this.formId,
    required this.selectedSectionId,
  });

  @override
  ConsumerState<SectionPropertiesWidget> createState() =>
      _SectionPropertiesWidgetState();
}

class _SectionPropertiesWidgetState
    extends ConsumerState<SectionPropertiesWidget> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final builderState = ref.watch(
      formBuilderControllerProvider(widget.formId),
    );

    return builderState.when(
      data: (state) {
        // Find the section
        final section = state.form.sections
            .where((s) => s.id == widget.selectedSectionId)
            .firstOrNull;

        if (section == null) return const SizedBox();

        // Sync main controllers
        if (_titleController.text != section.title) {
          _titleController.value = _titleController.value.copyWith(
            text: section.title,
            selection: TextSelection.collapsed(offset: section.title.length),
          );
        }
        if (_descriptionController.text != (section.description ?? '')) {
          _descriptionController.text = section.description ?? '';
        }

        return DefaultTabController(
          length: 2,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                left: BorderSide(color: AppColors.borderLight, width: 1),
              ),
            ),
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(
                        FontAwesomeIcons.layerGroup,
                        size: 16,
                        color: AppColors.textGrey,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Section Properties',
                        style: TextStyle(
                          color: AppColors.textDark,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.textGrey,
                          size: 20,
                        ),
                        onPressed: () => ref
                            .read(
                              formBuilderControllerProvider(
                                widget.formId,
                              ).notifier,
                            )
                            .selectQuestion(null, null),
                      ),
                    ],
                  ),
                ),
                const Divider(color: AppColors.borderLight, height: 1),

                // Tab Bar
                Material(
                  color: Colors.white,
                  child: TabBar(
                    tabs: const [
                      Tab(text: 'General'),
                      Tab(text: 'Style'),
                    ],
                    labelColor: AppColors.brandBlue,
                    unselectedLabelColor: AppColors.textGrey,
                    indicatorColor: AppColors.brandBlue,
                    indicatorWeight: 3,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
                const Divider(color: AppColors.borderLight, height: 1),

                // Properties Content
                Expanded(
                  child: TabBarView(
                    children: [
                      // General Tab
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            _buildTextField(
                              label: 'Section Title',
                              controller: _titleController,
                              onChanged: (val) {
                                ref
                                    .read(
                                      formBuilderControllerProvider(
                                        widget.formId,
                                      ).notifier,
                                    )
                                    .updateSection(
                                      section.copyWith(title: val),
                                    );
                              },
                            ),
                            const SizedBox(height: 20),

                            // Description
                            _buildTextField(
                              label: 'Description',
                              placeholder: 'Section description (optional)',
                              controller: _descriptionController,
                              onChanged: (val) {
                                ref
                                    .read(
                                      formBuilderControllerProvider(
                                        widget.formId,
                                      ).notifier,
                                    )
                                    .updateSection(
                                      section.copyWith(description: val),
                                    );
                              },
                            ),
                            const SizedBox(height: 24),

                            // Question Layout
                            _buildLayoutDropdown(section.layout, (val) {
                              if (val != null) {
                                ref
                                    .read(
                                      formBuilderControllerProvider(
                                        widget.formId,
                                      ).notifier,
                                    )
                                    .updateSection(
                                      section.copyWith(layout: val),
                                    );
                              }
                            }),

                            if (section.layout == SectionLayoutType.grid) ...[
                              const SizedBox(height: 12),
                              _buildNumberSlider(
                                label: 'Grid Columns',
                                value: section.gridColumns.toDouble(),
                                min: 2,
                                max: 4,
                                onChanged: (val) {
                                  ref
                                      .read(
                                        formBuilderControllerProvider(
                                          widget.formId,
                                        ).notifier,
                                      )
                                      .updateSection(
                                        section.copyWith(
                                          gridColumns: val.toInt(),
                                        ),
                                      );
                                },
                              ),
                            ],
                            const SizedBox(height: 24),

                            // Visibility Toggle
                            _buildSwitch(
                              label: 'Hidden Section',
                              value: section.isHidden,
                              onChanged: (val) {
                                ref
                                    .read(
                                      formBuilderControllerProvider(
                                        widget.formId,
                                      ).notifier,
                                    )
                                    .updateSection(
                                      section.copyWith(isHidden: val),
                                    );
                              },
                            ),

                            // Conditional Logic
                            const SizedBox(height: 24),
                            const Text(
                              'CONDITIONAL LOGIC',
                              style: TextStyle(
                                color: AppColors.textGrey,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.borderLight,
                                  style: BorderStyle.solid,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.builderElement,
                              ),
                              child: Column(
                                children: [
                                  _buildComplexLogicEditor(
                                    section,
                                    state.form.sections,
                                  ),
                                  const SizedBox(height: 12),
                                  OutlinedButton.icon(
                                    onPressed: () => _showRuleDialog(
                                      context,
                                      section,
                                      state.form.sections,
                                    ),
                                    icon: const Icon(Icons.add, size: 16),
                                    label: const Text('Add Rule'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppColors.primary,
                                      side: const BorderSide(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Delete Section
                            const Divider(height: 32),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  // Confirm delete
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Delete Section?'),
                                      content: const Text(
                                        'Are you sure you want to delete this section and all its questions? This action cannot be undone.',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('Cancel'),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            foregroundColor: Colors.white,
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            ref
                                                .read(
                                                  formBuilderControllerProvider(
                                                    widget.formId,
                                                  ).notifier,
                                                )
                                                .removeSection(section.id);
                                          },
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.delete_outline,
                                  size: 18,
                                ),
                                label: const Text('Delete Section'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  side: const BorderSide(color: Colors.red),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Style Tab
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'APPEARANCE',
                              style: TextStyle(
                                color: AppColors.textGrey,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildColorPicker(
                              label: 'Background Color',
                              value: section.style.backgroundColor,
                              onChanged: (val) {
                                ref
                                    .read(
                                      formBuilderControllerProvider(
                                        widget.formId,
                                      ).notifier,
                                    )
                                    .updateSection(
                                      section.copyWith(
                                        style: section.style.copyWith(
                                          backgroundColor: val,
                                        ),
                                      ),
                                    );
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildNumberSlider(
                              label: 'Border Radius',
                              value: section.style.borderRadius,
                              min: 0,
                              max: 40,
                              onChanged: (val) {
                                ref
                                    .read(
                                      formBuilderControllerProvider(
                                        widget.formId,
                                      ).notifier,
                                    )
                                    .updateSection(
                                      section.copyWith(
                                        style: section.style.copyWith(
                                          borderRadius: val,
                                        ),
                                      ),
                                    );
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildNumberSlider(
                              label: 'Elevation',
                              value: section.style.elevation,
                              min: 0,
                              max: 12,
                              onChanged: (val) {
                                ref
                                    .read(
                                      formBuilderControllerProvider(
                                        widget.formId,
                                      ).notifier,
                                    )
                                    .updateSection(
                                      section.copyWith(
                                        style: section.style.copyWith(
                                          elevation: val,
                                        ),
                                      ),
                                    );
                              },
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'HEADER',
                              style: TextStyle(
                                color: AppColors.textGrey,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildSwitch(
                              label: 'Show Header',
                              value: section.style.showHeader,
                              onChanged: (val) {
                                ref
                                    .read(
                                      formBuilderControllerProvider(
                                        widget.formId,
                                      ).notifier,
                                    )
                                    .updateSection(
                                      section.copyWith(
                                        style: section.style.copyWith(
                                          showHeader: val,
                                        ),
                                      ),
                                    );
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildColorPicker(
                              label: 'Header Color',
                              value: section.style.headerBackgroundColor,
                              onChanged: (val) {
                                ref
                                    .read(
                                      formBuilderControllerProvider(
                                        widget.formId,
                                      ).notifier,
                                    )
                                    .updateSection(
                                      section.copyWith(
                                        style: section.style.copyWith(
                                          headerBackgroundColor: val,
                                        ),
                                      ),
                                    );
                              },
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'SPACING',
                              style: TextStyle(
                                color: AppColors.textGrey,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildNumberSlider(
                              label: 'Padding',
                              value: section.style.padding,
                              min: 0,
                              max: 48,
                              onChanged: (val) {
                                ref
                                    .read(
                                      formBuilderControllerProvider(
                                        widget.formId,
                                      ).notifier,
                                    )
                                    .updateSection(
                                      section.copyWith(
                                        style: section.style.copyWith(
                                          padding: val,
                                        ),
                                      ),
                                    );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => const SizedBox(),
    );
  }

  Widget _buildTextField({
    required String label,
    String? placeholder,
    required TextEditingController controller,
    required Function(String) onChanged,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textDark,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: const TextStyle(color: Colors.black26),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            filled: true,
            fillColor: AppColors.builderElement,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
          style: const TextStyle(color: AppColors.textDark),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildLayoutDropdown(
    SectionLayoutType currentLayout,
    Function(SectionLayoutType?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Section Layout',
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.builderElement,
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<SectionLayoutType>(
              value: currentLayout,
              isExpanded: true,
              items: SectionLayoutType.values.map((type) {
                return DropdownMenuItem(value: type, child: Text(type.label));
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.builderElement.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Description",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textGrey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                currentLayout.description,
                style: const TextStyle(fontSize: 13, color: AppColors.textDark),
              ),
              const SizedBox(height: 12),
              const Text(
                "Best For...",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textGrey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                currentLayout.bestFor,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textDark,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSwitch({
    required String label,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.textDark,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: AppColors.primary,
        ),
      ],
    );
  }

  Map<String, dynamic> _getLogicState(FormSection section) {
    final logic = section.conditionalLogic ?? {};
    if (logic['rules'] is List) return logic;
    if (logic['triggerId'] != null) {
      return {
        'matchType': 'and',
        'rules': [logic],
      };
    }
    return {'matchType': 'and', 'rules': []};
  }

  Widget _buildComplexLogicEditor(
    FormSection section,
    List<FormSection> sections,
  ) {
    final logicState = _getLogicState(section);
    final rules = (logicState['rules'] as List? ?? [])
        .cast<Map<String, dynamic>>();

    if (rules.isEmpty) {
      return const Text(
        'Add logic to show/hide this section.',
        style: TextStyle(color: AppColors.textGrey, fontSize: 13),
        textAlign: TextAlign.center,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (rules.length > 1)
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              children: [
                const Text('Match: ', style: TextStyle(fontSize: 13)),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: logicState['matchType'] ?? 'and',
                  isDense: true,
                  underline: const SizedBox(),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'and',
                      child: Text('All Rules (AND)'),
                    ),
                    DropdownMenuItem(value: 'or', child: Text('Any Rule (OR)')),
                  ],
                  onChanged: (val) {
                    if (val == null) return;
                    final newLogic = Map<String, dynamic>.from(logicState);
                    newLogic['matchType'] = val;
                    ref
                        .read(
                          formBuilderControllerProvider(widget.formId).notifier,
                        )
                        .updateSection(
                          section.copyWith(conditionalLogic: newLogic),
                        );
                  },
                ),
              ],
            ),
          ),
        ...rules.asMap().entries.map((entry) {
          final index = entry.key;
          final rule = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: _buildSingleRuleItem(section, sections, rule, index),
          );
        }),
      ],
    );
  }

  Widget _buildSingleRuleItem(
    FormSection section,
    List<FormSection> sections,
    Map<String, dynamic> rule,
    int index,
  ) {
    final triggerId = rule['triggerId'] as String?;
    final condition = rule['condition'] as String?;
    final value = rule['value'] as String?;

    FormQuestion? triggerQuestion;
    for (final s in sections) {
      triggerQuestion = s.questions.where((q) => q.id == triggerId).firstOrNull;
      if (triggerQuestion != null) break;
    }

    final triggerLabel = triggerQuestion?.label ?? 'Unknown Question';
    final conditionLabel = condition == 'equals'
        ? 'Is Equal To'
        : condition == 'not_equals'
        ? 'Is Not Equal To'
        : 'Contains';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Rule ${index + 1}",
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              InkWell(
                onTap: () {
                  final logicState = _getLogicState(section);
                  final rules = (logicState['rules'] as List)
                      .cast<Map<String, dynamic>>();
                  final newRules = List<Map<String, dynamic>>.from(rules);
                  newRules.removeAt(index);

                  final newLogic = {...logicState, 'rules': newRules};

                  ref
                      .read(
                        formBuilderControllerProvider(widget.formId).notifier,
                      )
                      .updateSection(
                        section.copyWith(conditionalLogic: newLogic),
                      );
                },
                child: const Icon(
                  Icons.delete_outline,
                  size: 16,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            "$triggerLabel $conditionLabel \"$value\"",
            style: const TextStyle(fontSize: 13),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _showRuleDialog(
    BuildContext context,
    FormSection section,
    List<FormSection> sections,
  ) {
    final eligibleQuestions = <FormQuestion>[];
    for (final s in sections) {
      for (final q in s.questions) {
        if (q.type == QuestionType.dropdown ||
            q.type == QuestionType.multipleChoice ||
            q.type == QuestionType.checkboxes) {
          eligibleQuestions.add(q);
        }
      }
    }

    if (eligibleQuestions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No eligible trigger questions (Dropdown/Radio) found.',
          ),
        ),
      );
      return;
    }

    String? selectedTriggerId = eligibleQuestions.first.id;
    String selectedCondition = 'equals';
    String value = '';

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final triggerQ = eligibleQuestions.firstWhere(
              (q) => q.id == selectedTriggerId,
            );
            final triggerOptions = triggerQ.options ?? [];

            return AlertDialog(
              title: const Text('Add Logic'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Show this section when:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Trigger Question
                  const Text(
                    "Question:",
                    style: TextStyle(fontSize: 12, color: AppColors.textGrey),
                  ),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<String>(
                    initialValue: selectedTriggerId,
                    isExpanded: true,
                    items: eligibleQuestions.map((q) {
                      return DropdownMenuItem(
                        value: q.id,
                        child: Text(q.label, overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setDialogState(() {
                        selectedTriggerId = val;
                        value = '';
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Condition
                  const Text(
                    "Condition:",
                    style: TextStyle(fontSize: 12, color: AppColors.textGrey),
                  ),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<String>(
                    initialValue: selectedCondition,
                    items: const [
                      DropdownMenuItem(
                        value: 'equals',
                        child: Text('Is Equal To'),
                      ),
                      DropdownMenuItem(
                        value: 'not_equals',
                        child: Text('Is Not Equal To'),
                      ),
                    ],
                    onChanged: (val) =>
                        setDialogState(() => selectedCondition = val!),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Value
                  const Text(
                    "Value:",
                    style: TextStyle(fontSize: 12, color: AppColors.textGrey),
                  ),
                  const SizedBox(height: 4),
                  if (triggerOptions.isNotEmpty)
                    DropdownButtonFormField<String>(
                      initialValue:
                          value.isNotEmpty && triggerOptions.contains(value)
                          ? value
                          : null,
                      hint: const Text("Select Option"),
                      items: triggerOptions.map((opt) {
                        return DropdownMenuItem(value: opt, child: Text(opt));
                      }).toList(),
                      onChanged: (val) => setDialogState(() => value = val!),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    )
                  else
                    TextField(
                      onChanged: (val) => value = val,
                      decoration: const InputDecoration(
                        hintText: "Enter value",
                        border: OutlineInputBorder(),
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (selectedTriggerId != null && value.isNotEmpty) {
                      final logicState = _getLogicState(section);
                      final rules = (logicState['rules'] as List)
                          .cast<Map<String, dynamic>>();
                      final newRules = List<Map<String, dynamic>>.from(rules);

                      newRules.add({
                        'triggerId': selectedTriggerId,
                        'condition': selectedCondition,
                        'value': value,
                      });

                      final newLogic = {...logicState, 'rules': newRules};

                      ref
                          .read(
                            formBuilderControllerProvider(
                              widget.formId,
                            ).notifier,
                          )
                          .updateSection(
                            section.copyWith(conditionalLogic: newLogic),
                          );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Add Rule'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildNumberSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required Function(double) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textDark,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              value.toStringAsFixed(0),
              style: const TextStyle(
                color: AppColors.brandBlue,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          onChanged: onChanged,
          activeColor: AppColors.brandBlue,
        ),
      ],
    );
  }

  Widget _buildColorPicker({
    required String label,
    required String value,
    required Function(String) onChanged,
  }) {
    Color displayColor;
    try {
      displayColor = Color(int.parse(value.replaceAll('#', '0xFF')));
    } catch (_) {
      displayColor = Colors.transparent;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textDark,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: displayColor,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppColors.borderLight),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: TextEditingController(text: value)
                  ..selection = TextSelection.fromPosition(
                    TextPosition(offset: value.length),
                  ),
                onChanged: onChanged,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  fillColor: AppColors.builderElement,
                  filled: true,
                  hintText: '#HEXCODE',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
