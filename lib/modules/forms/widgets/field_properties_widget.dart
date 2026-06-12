import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/app/theme/app_colors.dart';
import 'package:frontend/app/theme/tokens.dart';
import 'package:frontend/core/widgets/app_states.dart';
import 'package:frontend/core/widgets/error_state_widget.dart';
import 'package:frontend/shared/models/form_models.dart';
import 'package:frontend/modules/forms/services/form_builder_controller.dart';
import 'package:frontend/modules/forms/widgets/field_general_settings.dart';
import 'package:frontend/modules/forms/widgets/field_style_settings.dart';
import 'package:frontend/modules/forms/widgets/dynamic_properties_panel.dart';
import 'package:frontend/modules/forms/widgets/field_logic_settings.dart';
import 'package:frontend/modules/forms/widgets/field_layout_settings.dart';
import 'package:frontend/modules/forms/widgets/field_specific_settings.dart';
import 'package:frontend/modules/forms/services/custom_fields_controller.dart';
import 'package:frontend/core/services/snackbar_service.dart';
import '../../../../app/localization/locale_controller.dart';
import 'package:frontend/modules/forms/widgets/properties_panel_shell.dart';

class FieldPropertiesWidget extends ConsumerStatefulWidget {
  final String controllerKey;
  final String projectId;
  final String formId;
  final String selectedQuestionId;

  const FieldPropertiesWidget({
    super.key,
    required this.projectId,
    required this.controllerKey,
    required this.formId,
    required this.selectedQuestionId,
  });

  @override
  ConsumerState<FieldPropertiesWidget> createState() =>
      _FieldPropertiesWidgetState();
}

class _FieldPropertiesWidgetState extends ConsumerState<FieldPropertiesWidget> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _labelController;
  late TextEditingController _variableNameController;
  late TextEditingController _helperTextController;
  late TextEditingController _placeholderController;
  late TextEditingController _regexController;
  late TextEditingController _minLengthController;
  late TextEditingController _maxLengthController;
  late TextEditingController _minValueController;
  late TextEditingController _maxValueController;
  late TextEditingController _inputMaskController;
  late TextEditingController _customErrorController;
  late TextEditingController _prefixIconController;
  late TextEditingController _suffixIconController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _labelController = TextEditingController();
    _variableNameController = TextEditingController();
    _helperTextController = TextEditingController();
    _placeholderController = TextEditingController();
    _regexController = TextEditingController();
    _minLengthController = TextEditingController();
    _maxLengthController = TextEditingController();
    _minValueController = TextEditingController();
    _maxValueController = TextEditingController();
    _inputMaskController = TextEditingController();
    _customErrorController = TextEditingController();
    _prefixIconController = TextEditingController();
    _suffixIconController = TextEditingController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _labelController.dispose();
    _variableNameController.dispose();
    _helperTextController.dispose();
    _placeholderController.dispose();
    _regexController.dispose();
    _minLengthController.dispose();
    _maxLengthController.dispose();
    _minValueController.dispose();
    _maxValueController.dispose();
    _inputMaskController.dispose();
    _customErrorController.dispose();
    _prefixIconController.dispose();
    _suffixIconController.dispose();
    super.dispose();
  }

  void _syncControllers(FormQuestion question, String locale) {
    _syncController(_labelController, question.label.translate(locale));
    _syncController(_variableNameController, question.variableName ?? '');
    _syncController(_helperTextController, question.helperText.translate(locale));
    _syncController(
      _placeholderController,
      question.placeholder.translate(locale),
    );
    _syncController(_regexController, question.validationRegex ?? '');
    _syncController(_minLengthController, question.minLength?.toString() ?? '');
    _syncController(_maxLengthController, question.maxLength?.toString() ?? '');
    _syncController(_minValueController, question.minValue?.toString() ?? '');
    _syncController(_maxValueController, question.maxValue?.toString() ?? '');
    _syncController(_inputMaskController, question.inputMask ?? '');
    _syncController(
      _customErrorController,
      question.customErrorMessage ?? '',
    );
    _syncController(_prefixIconController, question.style.prefixIcon);
    _syncController(_suffixIconController, question.style.suffixIcon);
  }

  void _syncController(TextEditingController controller, String value) {
    if (controller.text == value) return;
    controller.value = controller.value.copyWith(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }

  FormQuestion? _findQuestionById(List<FormSection> sections, String id) {
    for (final section in sections) {
      final found = section.questions.where((q) => q.id == id).firstOrNull;
      if (found != null) return found;
      if (section.sections.isNotEmpty) {
        final nested = _findQuestionById(section.sections, id);
        if (nested != null) return nested;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final builderState = ref.watch(
      formBuilderControllerProvider(widget.controllerKey),
    );

    return builderState.when(
      data: (state) {
        final question = _findQuestionById(
          state.form.sections,
          widget.selectedQuestionId,
        );

        if (question == null) {
          return AppStates.empty(
            title: 'Field no longer available',
            subtitle:
                'The selected question could not be found. Clear the selection and choose another field.',
            icon: Icons.settings_outlined,
            actionLabel: 'Clear selection',
            onAction: () => ref
                .read(
                  formBuilderControllerProvider(widget.controllerKey).notifier,
                )
                .selectQuestion(null, null),
          );
        }

        _syncControllers(question, state.editingLocale);

        return PropertiesPanelShell(
          header: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(DesignTokens.spaceL),
                child: Wrap(
                  spacing: DesignTokens.spaceS,
                  runSpacing: DesignTokens.spaceS,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.sliders,
                          size: 16,
                          color: AppColors.textGrey,
                        ),
                        const SizedBox(width: DesignTokens.spaceS),
                        const Text(
                          'Field Properties',
                          style: TextStyle(
                            color: AppColors.textDark,
                            fontWeight: FontWeight.bold,
                            fontSize: DesignTokens.fontM,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            ref
                                .read(customFieldsProvider)
                                .saveAsTemplate(
                                  question.label.translate(
                                    state.editingLocale,
                                  ),
                                  'My Fields',
                                  question,
                                );
                            ref
                                .read(snackbarServiceProvider)
                                .showSuccess('Field saved as template!');
                          },
                          icon: const Icon(Icons.star_border, size: 16),
                          label: const Text(
                            'Save Template',
                            style: TextStyle(fontSize: DesignTokens.fontS),
                          ),
                        ),
                        const SizedBox(width: DesignTokens.spaceXS),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: AppColors.textGrey,
                            size: 20,
                          ),
                          onPressed: () => ref
                              .read(
                                formBuilderControllerProvider(
                                  widget.controllerKey,
                                ).notifier,
                              )
                              .selectQuestion(null, null),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              // Tab Bar
              Material(
                color: Theme.of(context).colorScheme.surface,
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabs: const [
                    Tab(text: 'General'),
                    Tab(text: 'Layout'),
                    Tab(text: 'Validation'),
                    Tab(text: 'Specific'),
                    Tab(text: 'Style'),
                    Tab(text: 'Logic'),
                  ],
                  labelColor: AppColors.brandBlue,
                  unselectedLabelColor: AppColors.textGrey,
                  indicatorColor: AppColors.brandBlue,
                  indicatorWeight: 3,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: DesignTokens.fontS,
                  ),
                ),
              ),
              const Divider(color: AppColors.borderLight, height: 1),

              // Properties Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    // General Tab
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(DesignTokens.spaceL),
                      child: FieldGeneralSettings(
                        controllerKey: widget.controllerKey,
                        projectId: widget.projectId,
                        formId: widget.formId,
                        question: question,
                        labelController: _labelController,
                        variableNameController: _variableNameController,
                        helperTextController: _helperTextController,
                        placeholderController: _placeholderController,
                      ),
                    ),

                    // Layout Tab
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(DesignTokens.spaceL),
                      child: FieldLayoutSettings(
                        projectId: widget.projectId,
                        formId: widget.formId,
                        question: question,
                      ),
                    ),

                    // Validation Tab
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(DesignTokens.spaceL),
                      child: DynamicPropertiesPanel(
                        question: question,
                        onQuestionChanged: (updatedQuestion) {
                          ref
                              .read(
                                formBuilderControllerProvider(
                                  widget.controllerKey,
                                ).notifier,
                              )
                              .updateQuestion(updatedQuestion);
                        },
                      ),
                    ),

                    // Specific Tab
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(DesignTokens.spaceL),
                      child: FieldSpecificSettings(
                        formId: widget.formId,
                        question: question,
                      ),
                    ),

                    // Style Tab
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(DesignTokens.spaceL),
                      child: FieldStyleSettings(
                        formId: widget.formId,
                        question: question,
                        prefixIconController: _prefixIconController,
                        suffixIconController: _suffixIconController,
                      ),
                    ),

                    // Logic Tab
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(DesignTokens.spaceL),
                      child: FieldLogicSettings(
                        projectId: widget.projectId,
                        formId: widget.formId,
                        question: question,
                        sections: state.form.sections,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => ErrorStateWidget(
        title: 'Failed to load field properties',
        message:
            'We could not load the selected field settings. Try reopening the selection or reloading the builder.',
        error: e.toString(),
        onRetry: () => ref.refresh(
          formBuilderControllerProvider(widget.controllerKey),
        ),
      ),
    );
  }
}
