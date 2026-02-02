import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/form_builder/domain/entities/form_question.dart';
import 'package:frontend/features/form_builder/presentation/controllers/form_builder_controller.dart';
import 'package:frontend/features/form_builder/presentation/widgets/properties/field_general_settings.dart';
import 'package:frontend/features/form_builder/presentation/widgets/properties/field_style_settings.dart';
import 'package:frontend/features/form_builder/presentation/widgets/properties/field_validation_settings.dart';
import 'package:frontend/features/form_builder/presentation/widgets/properties/field_logic_settings.dart';
import 'package:frontend/features/form_builder/presentation/widgets/properties/field_layout_settings.dart';
import 'package:frontend/features/form_builder/presentation/widgets/properties/field_specific_settings.dart';
import 'package:frontend/features/form_builder/presentation/controllers/custom_fields_controller.dart';
import '../../../../core/localization/locale_controller.dart';

class FieldPropertiesWidget extends ConsumerStatefulWidget {
  final String formId;
  final String selectedQuestionId;

  const FieldPropertiesWidget({
    super.key,
    required this.formId,
    required this.selectedQuestionId,
  });

  @override
  ConsumerState<FieldPropertiesWidget> createState() =>
      _FieldPropertiesWidgetState();
}

class _FieldPropertiesWidgetState extends ConsumerState<FieldPropertiesWidget> {
  late TextEditingController _labelController;
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
    _labelController = TextEditingController();
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
    _labelController.dispose();
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
    final translatedLabel = question.label.translate(locale);
    if (_labelController.text != translatedLabel) {
      _labelController.value = _labelController.value.copyWith(
        text: translatedLabel,
        selection: TextSelection.collapsed(offset: translatedLabel.length),
      );
    }
    final translatedHelperText = question.helperText.translate(locale);
    if (_helperTextController.text != translatedHelperText) {
      _helperTextController.text = translatedHelperText;
    }
    final translatedPlaceholder = question.placeholder.translate(locale);
    if (_placeholderController.text != translatedPlaceholder) {
      _placeholderController.text = translatedPlaceholder;
    }
    if (_regexController.text != (question.validationRegex ?? '')) {
      _regexController.text = question.validationRegex ?? '';
    }
    if (_minLengthController.text != (question.minLength?.toString() ?? '')) {
      _minLengthController.text = question.minLength?.toString() ?? '';
    }
    if (_maxLengthController.text != (question.maxLength?.toString() ?? '')) {
      _maxLengthController.text = question.maxLength?.toString() ?? '';
    }
    if (_minValueController.text != (question.minValue?.toString() ?? '')) {
      _minValueController.text = question.minValue?.toString() ?? '';
    }
    if (_maxValueController.text != (question.maxValue?.toString() ?? '')) {
      _maxValueController.text = question.maxValue?.toString() ?? '';
    }
    if (_inputMaskController.text != (question.inputMask ?? '')) {
      _inputMaskController.text = question.inputMask ?? '';
    }
    if (_customErrorController.text != (question.customErrorMessage ?? '')) {
      _customErrorController.text = question.customErrorMessage ?? '';
    }
    if (_prefixIconController.text != (question.style.prefixIcon ?? '')) {
      _prefixIconController.text = question.style.prefixIcon ?? '';
    }
    if (_suffixIconController.text != (question.style.suffixIcon ?? '')) {
      _suffixIconController.text = question.style.suffixIcon ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final builderState = ref.watch(
      formBuilderControllerProvider(widget.formId),
    );

    return builderState.when(
      data: (state) {
        FormQuestion? question;
        for (final section in state.form.sections) {
          final found = section.questions
              .where((q) => q.id == widget.selectedQuestionId)
              .firstOrNull;
          if (found != null) {
            question = found;
            break;
          }
        }

        if (question == null) return const SizedBox();

        _syncControllers(question, state.editingLocale);

        return DefaultTabController(
          length: 6,
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
                        FontAwesomeIcons.sliders,
                        size: 16,
                        color: AppColors.textGrey,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Field Properties',
                        style: TextStyle(
                          color: AppColors.textDark,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () {
                          ref
                              .read(customFieldsProvider.notifier)
                              .saveAsTemplate(
                                question!.label.translate(state.editingLocale),
                                'My Fields',
                                question,
                              );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Field saved as template!'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.star_border, size: 16),
                        label: const Text(
                          'Save Template',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
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
                        child: FieldGeneralSettings(
                          formId: widget.formId,
                          question: question,
                          labelController: _labelController,
                          helperTextController: _helperTextController,
                          placeholderController: _placeholderController,
                        ),
                      ),

                      // Layout Tab
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: FieldLayoutSettings(
                          formId: widget.formId,
                          question: question,
                        ),
                      ),

                      // Validation Tab
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: FieldValidationSettings(
                          formId: widget.formId,
                          question: question,
                          regexController: _regexController,
                          minLengthController: _minLengthController,
                          maxLengthController: _maxLengthController,
                          minValueController: _minValueController,
                          maxValueController: _maxValueController,
                          inputMaskController: _inputMaskController,
                          customErrorController: _customErrorController,
                        ),
                      ),

                      // Specific Tab
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: FieldSpecificSettings(
                          formId: widget.formId,
                          question: question,
                        ),
                      ),

                      // Style Tab
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: FieldStyleSettings(
                          formId: widget.formId,
                          question: question,
                          prefixIconController: _prefixIconController,
                          suffixIconController: _suffixIconController,
                        ),
                      ),

                      // Logic Tab
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: FieldLogicSettings(
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
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => const SizedBox(),
    );
  }
}
