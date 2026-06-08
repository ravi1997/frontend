import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../app/theme/app_colors.dart';
import 'package:frontend/shared/models/form_models.dart';
import 'package:frontend/modules/forms/services/form_builder_controller.dart';
import 'package:frontend/modules/forms/widgets/general_settings_panels.dart';
import 'package:frontend/modules/forms/widgets/section_layout_settings.dart';
import 'package:frontend/modules/forms/widgets/section_style_settings.dart';
import 'package:frontend/modules/forms/widgets/section_logic_settings.dart';
import 'package:frontend/modules/forms/widgets/properties_panel_shell.dart';
import 'package:frontend/modules/forms/widgets/padded_scroll_tab.dart';
import '../../../../app/localization/locale_controller.dart';

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
    final builderState = ref.watch(formBuilderControllerProvider(widget.controllerKey));
    final controller = ref.read(formBuilderControllerProvider(widget.controllerKey).notifier);

    return builderState.when(
      data: (state) {
        final section = _findSectionById(
          state.form.sections,
          widget.selectedSectionId,
        );

        if (section == null) return const SizedBox();

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

        return DefaultTabController(
          length: 4,
          child: PropertiesPanelShell(
            header: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.layerGroup,
                        size: 16,
                        color: AppColors.textGrey,
                      ),
                      const SizedBox(width: 8),
                      const Flexible(
                        child: Text(
                          'Section Properties',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.textDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
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
                  color: Colors.white,
                  child: TabBar(
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
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
              ],
            ),
            body: TabBarView(
              children: [
                PaddedScrollTab(
                  child: 
                  SectionGeneralSettings(
                    section: activeSection.toJson(),
                    onChanged: (updated) => controller.updateSection(
                      activeSection.copyWith(
                        title:
                            updated['title'] as String? ?? activeSection.title,
                        description:
                            updated['description'] as String? ??
                                activeSection.description,
                      ),
                    ),
                  ),
                ),
                PaddedScrollTab(
                  child: 
                  SectionLayoutSettings(
                    section: activeSection.toJson(),
                    onChanged: (updated) => controller.updateSection(
                      activeSection.copyWith(
                        title:
                            updated['title'] as String? ?? activeSection.title,
                      ),
                    ),
                  ),
                ),
                PaddedScrollTab(
                  child: 
                  SectionStyleSettings(
                    section: activeSection.toJson(),
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
                  child: 
                  SectionLogicSettings(
                    section: activeSection.toJson(),
                    onChanged: (_) {},
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
