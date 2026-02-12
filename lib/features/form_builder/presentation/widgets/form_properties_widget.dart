import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/form_builder_controller.dart';
import 'properties/form_general_settings.dart';
import 'properties/form_layout_settings.dart';
import 'properties/form_style_settings.dart';
import 'properties/form_logic_settings.dart';
import 'package:frontend/core/localization/locale_controller.dart';

class FormPropertiesWidget extends ConsumerStatefulWidget {
  final String formId;

  const FormPropertiesWidget({super.key, required this.formId});

  @override
  ConsumerState<FormPropertiesWidget> createState() =>
      _FormPropertiesWidgetState();
}

class _FormPropertiesWidgetState extends ConsumerState<FormPropertiesWidget> {
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final builderState = ref.watch(
      formBuilderControllerProvider(widget.formId),
    );

    return builderState.when(
      data: (state) {
        final form = state.form;
        final currentLocale = state.editingLocale;

        final translatedTitle = form.title.translate(currentLocale);
        if (_titleController.text != translatedTitle) {
          _titleController.text = translatedTitle;
        }

        return DefaultTabController(
          length: 4,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                left: BorderSide(color: AppColors.borderLight, width: 1),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(
                        FontAwesomeIcons.fileLines,
                        size: 16,
                        color: AppColors.textGrey,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Form Properties',
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
                // Language Selector
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  color: AppColors.builderBackground.withOpacity(0.5),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.translate,
                        size: 14,
                        color: AppColors.textGrey,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Editing Language:',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textGrey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: currentLocale,
                          isDense: true,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'en',
                              child: Text('English (EN)'),
                            ),
                            DropdownMenuItem(
                              value: 'es',
                              child: Text('Spanish (ES)'),
                            ),
                            DropdownMenuItem(
                              value: 'fr',
                              child: Text('French (FR)'),
                            ),
                            DropdownMenuItem(
                              value: 'hi',
                              child: Text('Hindi (HI)'),
                            ),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              ref
                                  .read(
                                    formBuilderControllerProvider(
                                      widget.formId,
                                    ).notifier,
                                  )
                                  .setEditingLocale(val);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: AppColors.borderLight, height: 1),
                Material(
                  color: Colors.white,
                  child: TabBar(
                    tabs: const [
                      Tab(text: 'General'),
                      Tab(text: 'Layout'),
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
                Expanded(
                  child: TabBarView(
                    children: [
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: FormGeneralSettings(
                          formId: widget.formId,
                          form: form,
                          titleController: _titleController,
                        ),
                      ),
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: FormLayoutSettings(
                          formId: widget.formId,
                          form: form,
                        ),
                      ),
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: FormStyleSettings(
                          formId: widget.formId,
                          form: form,
                        ),
                      ),
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: FormLogicSettings(
                          formId: widget.formId,
                          form: form,
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
