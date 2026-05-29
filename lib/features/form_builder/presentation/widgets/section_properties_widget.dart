import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:frontend/models/form_models.dart';
import '../controllers/form_builder_controller.dart';
import 'properties/general_settings_panels.dart';
import 'properties/section_layout_settings.dart';
import 'properties/section_style_settings.dart';
import 'properties/section_logic_settings.dart';
import '../../../../core/localization/locale_controller.dart';

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
    final builderState = ref.watch(
      formBuilderControllerProvider(widget.controllerKey),
    );

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
                const Divider(color: AppColors.borderLight, height: 1),
                Expanded(
                  child: TabBarView(
                    children: [
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: SectionGeneralSettings(
                          projectId: widget.projectId,
                          formId: widget.formId,
                          section: activeSection,
                          titleController: _titleController,
                          descriptionController: _descriptionController,
                          onSectionChanged: (updatedSection) => ref
                              .read(
                                formBuilderControllerProvider(
                                  widget.controllerKey,
                                ).notifier,
                              )
                              .updateSection(updatedSection),
                        ),
                      ),
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: SectionLayoutSettings(
                          projectId: widget.projectId,
                          formId: widget.formId,
                          section: activeSection,
                          onSectionChanged: (updatedSection) => ref
                              .read(
                                formBuilderControllerProvider(
                                  widget.controllerKey,
                                ).notifier,
                              )
                              .updateSection(updatedSection),
                        ),
                      ),
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: SectionStyleSettings(
                          projectId: widget.projectId,
                          formId: widget.formId,
                          section: activeSection,
                          onSectionChanged: (updatedSection) => ref
                              .read(
                                formBuilderControllerProvider(
                                  widget.controllerKey,
                                ).notifier,
                              )
                              .updateSection(updatedSection),
                        ),
                      ),
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: SectionLogicSettings(
                          projectId: widget.projectId,
                          formId: widget.formId,
                          section: activeSection,
                          allSections: state.form.sections,
                          onSectionChanged: (updatedSection) => ref
                              .read(
                                formBuilderControllerProvider(
                                  widget.controllerKey,
                                ).notifier,
                              )
                              .updateSection(updatedSection),
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
