import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../app/localization/locale_controller.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import 'package:frontend/core/widgets/app_states.dart';
import 'package:frontend/core/widgets/error_state_widget.dart';
import 'package:frontend/modules/forms/services/form_builder_controller.dart';
import 'package:frontend/modules/forms/widgets/general_settings_panels.dart';
import 'package:frontend/modules/forms/widgets/padded_scroll_tab.dart';
import 'package:frontend/modules/forms/widgets/properties_panel_shell.dart';
import 'package:frontend/modules/forms/widgets/section_extra_settings.dart';
import 'package:frontend/modules/forms/widgets/section_layout_settings.dart';
import 'package:frontend/modules/forms/widgets/section_logic_settings.dart';
import 'package:frontend/modules/forms/widgets/section_style_settings.dart';
import 'package:frontend/modules/forms/widgets/section_visibility_settings.dart';
import 'package:frontend/shared/models/form_models.dart';

class SectionPropertiesWidget extends ConsumerStatefulWidget {
  final String controllerKey;
  final String projectId;
  final String formId;
  final String selectedSectionId;

  const SectionPropertiesWidget({
    super.key,
    required this.projectId,
    required this.controllerKey,
    required this.formId,
    required this.selectedSectionId,
  });

  @override
  ConsumerState<SectionPropertiesWidget> createState() =>
      _SectionPropertiesWidgetState();
}

class _SectionPropertiesWidgetState extends ConsumerState<SectionPropertiesWidget> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 9, vsync: this);
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final builderState =
        ref.watch(formBuilderControllerProvider(widget.controllerKey));
    final controller =
        ref.read(formBuilderControllerProvider(widget.controllerKey).notifier);

    return builderState.when(
      data: (state) {
        final section = _findSectionById(
          state.form.sections,
          widget.selectedSectionId,
        );
        if (section == null) {
          return AppStates.empty(
            title: 'Section no longer available',
            subtitle:
                'The selected section could not be found. Clear the selection and choose another section.',
            icon: Icons.view_day_outlined,
            actionLabel: 'Clear selection',
            onAction: () => controller.selectForm(),
          );
        }

        final activeSection = section;
        final locale = state.editingLocale;

        final translatedTitle = activeSection.title.translate(locale);
        if (_titleController.text != translatedTitle) {
          _titleController.text = translatedTitle;
        }
        final translatedDescription = activeSection.description.translate(locale);
        if (_descriptionController.text != translatedDescription) {
          _descriptionController.text = translatedDescription;
        }

        final sectionJson = activeSection.toJson();

        return PropertiesPanelShell(
          header: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(DesignTokens.spaceL),
                child: Row(
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.layerGroup,
                      size: 16,
                      color: AppColors.textGrey,
                    ),
                    const SizedBox(width: DesignTokens.spaceS),
                    const Flexible(
                      child: Text(
                        'Section Properties',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.textDark,
                          fontWeight: FontWeight.bold,
                          fontSize: DesignTokens.fontM,
                        ),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.textGrey,
                        size: 20,
                      ),
                      onPressed: controller.selectForm,
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
                  tabAlignment: TabAlignment.start,
                  tabs: const [
                    Tab(text: 'General'),
                    Tab(text: 'Layout'),
                    Tab(text: 'Style'),
                    Tab(text: 'Logic'),
                    Tab(text: 'Visibility'),
                    Tab(text: 'Behavior'),
                    Tab(text: 'A11y'),
                    Tab(text: 'Analytics'),
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
                  child: SectionGeneralSettings(
                    section: sectionJson,
                    onChanged: (updated) => controller.updateSection(
                      activeSection.copyWith(
                        id: updated['id'] as String? ?? activeSection.id,
                        title: updated['title'] as String? ?? activeSection.title,
                        description:
                            updated['description'] as String? ?? activeSection.description,
                        helpText:
                            updated['help_text'] as String? ?? activeSection.helpText,
                        order: updated['order'] as int? ?? activeSection.order,
                        tags: (updated['tags'] as List?)
                                ?.map((e) => e.toString())
                                .toList() ??
                            activeSection.tags,
                      ),
                    ),
                  ),
                ),
                PaddedScrollTab(
                  child: SectionLayoutSettings(
                    section: sectionJson,
                    onChanged: (updated) => controller.updateSection(
                      activeSection.copyWith(
                        layout: updated['layout'] as String? ?? activeSection.layout,
                        gridColumns:
                            updated['grid_columns'] as int? ?? activeSection.gridColumns,
                        isHidden:
                            updated['is_hidden'] as bool? ?? activeSection.isHidden,
                        isRepeatable:
                            updated['is_repeatable'] as bool? ?? activeSection.isRepeatable,
                        repeatMin:
                            updated['repeat_min'] as int? ?? activeSection.repeatMin,
                        repeatMax:
                            updated['repeat_max'] as int? ?? activeSection.repeatMax,
                      ),
                    ),
                  ),
                ),
                PaddedScrollTab(
                  child: SectionStyleSettings(
                    section: sectionJson,
                    onChanged: (updated) => controller.updateSection(
                      activeSection.copyWith(
                        style: Map<String, dynamic>.from(updated['style'] ?? activeSection.style),
                      ),
                    ),
                  ),
                ),
                PaddedScrollTab(
                  child: SectionLogicSettings(
                    section: sectionJson,
                    sections: state.form.sections,
                    locale: locale,
                    onChanged: (updated) => controller.updateSection(
                      activeSection.copyWith(
                        conditionalLogic: updated['conditional_logic'] is Map
                            ? Map<String, dynamic>.from(updated['conditional_logic'])
                            : activeSection.conditionalLogic,
                        logic: updated['logic'] is Map
                            ? Map<String, dynamic>.from(updated['logic'])
                            : activeSection.logic,
                        metadata: Map<String, dynamic>.from(
                          updated['metadata'] ?? activeSection.metadata,
                        ),
                      ),
                    ),
                  ),
                ),
                PaddedScrollTab(
                  child: SectionVisibilitySettings(
                    section: sectionJson,
                    onChanged: (updated) => controller.updateSection(
                      activeSection.copyWith(
                        metadata: Map<String, dynamic>.from(
                          updated['metadata'] ?? activeSection.metadata,
                        ),
                      ),
                    ),
                  ),
                ),
                PaddedScrollTab(
                  child: SectionExtraSettings(
                    title: 'Behavior',
                    section: sectionJson,
                    fields: const [
                      SectionExtraField.toggle('stickyHeader', 'Sticky header'),
                      SectionExtraField.toggle('collapsible', 'Collapsible section'),
                      SectionExtraField.toggle('startCollapsed', 'Start collapsed'),
                      SectionExtraField.toggle('requiredToContinue', 'Required to continue'),
                      SectionExtraField.toggle('preventSkipping', 'Prevent skipping'),
                      SectionExtraField.toggle('allowBack', 'Allow back navigation', fallback: true),
                      SectionExtraField.toggle('allowEditAfterSubmit', 'Allow edit after submit'),
                    ],
                    onChanged: (updated) => controller.updateSection(
                      activeSection.copyWith(
                        metadata: Map<String, dynamic>.from(updated['metadata'] ?? activeSection.metadata),
                      ),
                    ),
                  ),
                ),
                PaddedScrollTab(
                  child: SectionExtraSettings(
                    title: 'A11y',
                    section: sectionJson,
                    fields: const [
                      SectionExtraField.text('accessibleLabel', 'Accessible label'),
                      SectionExtraField.text('tooltipText', 'Tooltip text'),
                    ],
                    onChanged: (updated) => controller.updateSection(
                      activeSection.copyWith(
                        metadata: Map<String, dynamic>.from(updated['metadata'] ?? activeSection.metadata),
                      ),
                    ),
                  ),
                ),
                PaddedScrollTab(
                  child: SectionExtraSettings(
                    title: 'Analytics',
                    section: sectionJson,
                    fields: const [
                      SectionExtraField.toggle('trackView', 'Track section view', fallback: true),
                      SectionExtraField.toggle('trackCompletion', 'Track completion', fallback: true),
                      SectionExtraField.toggle('trackDwellTime', 'Track dwell time'),
                      SectionExtraField.text('analyticsEvent', 'Analytics event name'),
                    ],
                    onChanged: (updated) => controller.updateSection(
                      activeSection.copyWith(
                        metadata: Map<String, dynamic>.from(updated['metadata'] ?? activeSection.metadata),
                      ),
                    ),
                  ),
                ),
                PaddedScrollTab(
                  child: SectionExtraSettings(
                    title: 'Advanced',
                    section: sectionJson,
                    fields: const [
                      SectionExtraField.dropdown('widthMode', 'Width mode', ['full', 'contained', 'custom']),
                      SectionExtraField.numeric('maxWidth', 'Max width', min: 0, max: 1200, defaultValue: 0),
                      SectionExtraField.numeric('minWidth', 'Min width', min: 0, max: 800, defaultValue: 0),
                      SectionExtraField.numeric('fieldGap', 'Field gap', min: 0, max: 64, defaultValue: 16),
                      SectionExtraField.numeric('verticalPadding', 'Vertical padding', min: 0, max: 120, defaultValue: 0),
                      SectionExtraField.numeric('horizontalPadding', 'Horizontal padding', min: 0, max: 120, defaultValue: 0),
                      SectionExtraField.text('template', 'Template / preset name'),
                      SectionExtraField.text('owner', 'Owner / reviewer'),
                      SectionExtraField.text('authorNotes', 'Author notes', lines: 2),
                      SectionExtraField.text('workflowAction', 'Workflow action'),
                      SectionExtraField.chips(
                        'permissions',
                        'Permissions',
                        hintText: 'Add a role and press Enter',
                      ),
                      SectionExtraField.text('sectionAnchor', 'Section anchor'),
                    ],
                    onChanged: (updated) => controller.updateSection(
                      activeSection.copyWith(
                        metadata: Map<String, dynamic>.from(updated['metadata'] ?? activeSection.metadata),
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
        title: 'Failed to load section properties',
        message:
            'We could not load the selected section settings. Try reopening the section or reloading the form builder.',
        error: e.toString(),
        onRetry: () => ref.refresh(
          formBuilderControllerProvider(widget.controllerKey),
        ),
      ),
    );
  }

  FormSection? _findSectionById(List<FormSection> sections, String id) {
    for (final section in sections) {
      if (section.id == id) return section;
      if (section.sections.isEmpty) continue;
      final nested = _findSectionById(section.sections, id);
      if (nested != null) return nested;
    }
    return null;
  }
}
