import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import 'package:frontend/core/widgets/error_state_widget.dart';
import 'package:frontend/modules/forms/services/form_builder_controller.dart';
import 'package:frontend/modules/forms/widgets/general_settings_panels.dart';
import 'package:frontend/modules/forms/widgets/form_layout_settings.dart';
import 'package:frontend/modules/forms/widgets/form_style_settings.dart';
import 'package:frontend/modules/forms/widgets/form_logic_settings.dart';
import 'package:frontend/modules/forms/widgets/form_access_settings.dart';
import 'package:frontend/modules/forms/widgets/form_submission_settings.dart';
import 'package:frontend/modules/forms/widgets/form_quick_responses_settings.dart';
import 'package:frontend/modules/forms/widgets/form_data_export_settings.dart';
import 'package:frontend/modules/forms/widgets/form_advanced_settings.dart';
import 'package:frontend/modules/forms/widgets/properties_panel_shell.dart';
import 'package:frontend/modules/forms/widgets/padded_scroll_tab.dart';
import 'package:frontend/app/localization/locale_controller.dart';

class FormPropertiesWidget extends ConsumerStatefulWidget {
  final String controllerKey;
  final String projectId;
  final String formId;

  const FormPropertiesWidget({
    super.key,
    required this.projectId,
    required this.controllerKey,
    required this.formId,
  });

  @override
  ConsumerState<FormPropertiesWidget> createState() =>
      _FormPropertiesWidgetState();
}

class _FormPropertiesWidgetState extends ConsumerState<FormPropertiesWidget> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 9, vsync: this);
    _titleController = TextEditingController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final builderState = ref.watch(
      formBuilderControllerProvider(widget.controllerKey),
    );
    final controller = ref.read(
      formBuilderControllerProvider(widget.controllerKey).notifier,
    );

    return builderState.when(
      data: (state) {
        final form = state.form;
        final currentLocale = state.editingLocale;

        final translatedTitle = form.title.translate(currentLocale);
        if (_titleController.text != translatedTitle) {
          _titleController.text = translatedTitle;
        }

        return PropertiesPanelShell(
          header: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(DesignTokens.spaceL),
                child: Row(
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.fileLines,
                      size: 16,
                      color: AppColors.textGrey,
                    ),
                    const SizedBox(width: DesignTokens.spaceS),
                    const Text(
                      'Form Properties',
                      style: TextStyle(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.bold,
                        fontSize: DesignTokens.fontM,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.textGrey,
                        size: 20,
                      ),
                      onPressed: controller.clearSelection,
                    ),
                  ],
                ),
              ),
              const Divider(color: AppColors.borderLight, height: 1),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.spaceL,
                  vertical: DesignTokens.spaceS,
                ),
                color: AppColors.builderBackground.withValues(alpha: 0.5),
                child: Row(
                  children: [
                    const Icon(
                      Icons.translate,
                      size: 14,
                      color: AppColors.textGrey,
                    ),
                    const SizedBox(width: DesignTokens.spaceS),
                    const Text(
                      'Editing Language:',
                      style: TextStyle(
                        fontSize: DesignTokens.fontS,
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
                          fontSize: DesignTokens.fontS,
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
                            controller.setEditingLocale(val);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: AppColors.borderLight, height: 1),
              Material(
                color: Theme.of(context).colorScheme.surface,
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabs: const [
                    Tab(text: 'General'),
                    Tab(text: 'Layout'),
                    Tab(text: 'Style'),
                    Tab(text: 'Logic'),
                    Tab(text: 'Access / Privacy'),
                    Tab(text: 'Submission'),
                    Tab(text: 'Quick Responses'),
                    Tab(text: 'Data / Export'),
                    Tab(text: 'Advanced'),
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
            ],
          ),
          body: TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
                PaddedScrollTab(
                  child: FormGeneralSettings(
                    form: form.toJson(),
                    onChanged: (updated) => controller.updateForm(
                      form.copyWith(
                        title: updated['title'] as String? ?? form.title,
                        description:
                            updated['description'] as String? ??
                            form.description,
                        uiType: updated['ui_type'] as String? ?? form.uiType,
                        isPublic: updated['isPublic'] as bool? ?? form.isPublic,
                        style: Map<String, dynamic>.from(
                          updated['style'] ?? form.style,
                        ),
                        accessPolicy: Map<String, dynamic>.from(
                          updated['access_policy'] ?? form.accessPolicy,
                        ),
                      ),
                    ),
                  ),
                ),
                PaddedScrollTab(
                  child: FormLayoutSettings(
                    form: form.toJson(),
                    onChanged: (updated) => controller.updateForm(
                      form.copyWith(
                        style: Map<String, dynamic>.from(
                          updated['style'] ?? form.style,
                        ),
                      ),
                    ),
                  ),
                ),
                PaddedScrollTab(
                  child: FormStyleSettings(
                    form: form.toJson(),
                    onChanged: (updated) => controller.updateForm(
                      form.copyWith(
                        style: Map<String, dynamic>.from(
                          updated['style'] ?? form.style,
                        ),
                      ),
                    ),
                  ),
                ),
                PaddedScrollTab(
                  child: FormLogicSettings(
                    form: form.toJson(),
                    onChanged: (updated) => controller.updateForm(
                      form.copyWith(
                        workflows: Map<String, dynamic>.from(updated),
                      ),
                    ),
                  ),
                ),
                PaddedScrollTab(
                  child: FormAccessSettings(
                    form: form.toJson(),
                    onChanged: (policy) =>
                        controller.updateAccessPolicy(policy),
                  ),
                ),
                PaddedScrollTab(
                  child: FormSubmissionSettings(
                    form: form.toJson(),
                    onChanged: (updated) => controller.updateForm(
                      form.copyWith(
                        submissionSettings: Map<String, dynamic>.from(
                          updated['submission_settings'] ?? form.submissionSettings,
                        ),
                      ),
                    ),
                  ),
                ),
                PaddedScrollTab(
                  child: FormQuickResponsesSettings(
                    form: form.toJson(),
                    onChanged: (updated) => controller.updateForm(
                      form.copyWith(
                        quickResponses: (() {
                          final raw =
                              updated['quick_responses'] ?? form.quickResponses;
                          if (raw is List) {
                            return raw
                                .whereType<Map>()
                                .map((item) => Map<String, dynamic>.from(item))
                                .toList();
                          }
                          return const <Map<String, dynamic>>[];
                        })(),
                      ),
                    ),
                  ),
                ),
                PaddedScrollTab(
                  child: FormDataExportSettings(
                    form: form.toJson(),
                    onChanged: (updated) => controller.updateForm(
                      form.copyWith(
                        dataExportSettings: Map<String, dynamic>.from(
                          updated['data_export_settings'] ??
                              form.dataExportSettings,
                        ),
                        advancedSettings: Map<String, dynamic>.from(
                          updated['advanced_settings'] ?? form.advancedSettings,
                        ),
                      ),
                    ),
                  ),
                ),
                PaddedScrollTab(
                  child: FormAdvancedSettings(
                    form: form.toJson(),
                    onChanged: (updated) => controller.updateForm(
                      form.copyWith(
                        slug: updated['slug']?.toString() ?? form.slug,
                        advancedSettings: Map<String, dynamic>.from(
                          updated['advanced_settings'] ?? form.advancedSettings,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => ErrorStateWidget(
        title: 'Unable to load form properties',
        message: e.toString(),
        onRetry: controller.reload,
      ),
    );
  }
}
