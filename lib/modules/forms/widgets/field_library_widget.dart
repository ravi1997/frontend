import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../app/theme/app_colors.dart';

import 'package:frontend/modules/forms/models/question_type.dart';
import 'package:frontend/modules/forms/models/custom_field_template.dart';
import 'package:frontend/modules/forms/services/custom_fields_controller.dart';
import 'package:frontend/modules/forms/services/form_builder_controller.dart';
import 'package:frontend/modules/forms/services/field_registry.dart';
import 'ai_assistant_dialog.dart';

class FieldLibraryWidget extends ConsumerStatefulWidget {
  /// The controller key used by [FormBuilderController]. This is either just
  /// the formId (when there is no project context) or "projectId::formId".
  final String controllerKey;

  /// The plain formId, used only for the AI Assistant dialog.
  final String formId;

  const FieldLibraryWidget({
    super.key,
    required this.controllerKey,
    required this.formId,
  });

  @override
  ConsumerState<FieldLibraryWidget> createState() => _FieldLibraryWidgetState();
}

class _FieldLibraryWidgetState extends ConsumerState<FieldLibraryWidget> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Map<QuestionType, List<String>> get _searchKeywords => {
    QuestionType.shortText: [
      'text',
      'string',
      'name',
      'title',
      'single line',
      'input',
    ],
    QuestionType.paragraph: [
      'long text',
      'description',
      'textarea',
      'comment',
      'essay',
      'multiline',
    ],
    QuestionType.number: [
      'integer',
      'decimal',
      'count',
      'quantity',
      'amount',
      'numeric',
    ],
    QuestionType.password: ['secret', 'masked', 'login', 'credential'],
    QuestionType.email: ['mail', 'address'],
    QuestionType.mobile: [
      'phone',
      'cell',
      'telephone',
      'number',
      'contact',
      'call',
    ],
    QuestionType.tel: ['telephone', 'landline', 'phone'],
    QuestionType.calculate: ['calc', 'formula', 'computed', 'derived'],
    QuestionType.url: ['link', 'website', 'address', 'http', 'https'],
    QuestionType.dropdown: [
      'select',
      'choice',
      'menu',
      'option',
      'list',
      'picker',
    ],
    QuestionType.checkboxes: [
      'multiple',
      'check',
      'tick',
      'box',
      'multi-select',
    ],
    QuestionType.multiSelect: ['multi select', 'multi-select', 'tags'],
    QuestionType.multipleChoice: ['radio', 'option', 'single selection'],
    QuestionType.date: [
      'calendar',
      'day',
      'month',
      'year',
      'birth',
      'datepicker',
    ],
    QuestionType.time: ['clock', 'hour', 'minute', 'schedule', 'timepicker'],
    QuestionType.fileUpload: [
      'image',
      'photo',
      'document',
      'attachment',
      'media',
      'upload',
      'file',
    ],
    QuestionType.multiFileUpload: ['multiple files', 'attachments', 'bulk upload'],
    QuestionType.filePicker: ['file picker', 'browse files'],
    QuestionType.fileList: ['uploaded files', 'file list'],
    QuestionType.rating: ['star', 'rate', 'score', 'feedback'],
    QuestionType.signature: ['sign', 'draw', 'handwriting', 'approve'],
    QuestionType.signaturePad: ['signature pad', 'draw signature'],
    QuestionType.slider: ['range', 'volume', 'level', 'adjust'],
    QuestionType.image: ['photo', 'picture', 'gallery', 'camera'],
    QuestionType.imageGallery: ['gallery', 'image gallery', 'album'],
    QuestionType.divider: ['line', 'separator', 'break', 'horizontal'],
    QuestionType.spacer: ['empty', 'gap', 'margin', 'padding'],
    QuestionType.matrixChoice: ['grid', 'table', 'multiple', 'rows', 'columns'],
    QuestionType.mapLocation: ['map', 'location', 'geo', 'gps'],
    QuestionType.address: ['address', 'street', 'city', 'zip'],
    QuestionType.addressLookup: ['places', 'autocomplete', 'address search'],
    QuestionType.otp: ['otp', 'code', 'verification'],
    QuestionType.richText: ['rich text', 'formatted text', 'editor'],
    QuestionType.markdownEditor: ['markdown', 'md', 'editor'],
    QuestionType.booleanValue: ['boolean', 'yes no', 'toggle'],
    QuestionType.calculated: ['calculated', 'derived', 'formula'],
    QuestionType.customField: ['custom', 'plugin', 'extension'],
    QuestionType.colorPicker: ['color', 'palette', 'picker'],
    QuestionType.range: ['range', 'interval'],
    QuestionType.dateRange: ['date range', 'period'],
    QuestionType.timeRange: ['time range', 'hours range'],
    QuestionType.stepper: ['stepper', 'wizard', 'steps'],
    QuestionType.countrySelect: ['country', 'nation'],
    QuestionType.stateSelect: ['state', 'province'],
    QuestionType.citySelect: ['city', 'town'],
    QuestionType.socialMediaHandle: ['handle', 'username', 'social'],
    QuestionType.websiteUrl: ['website', 'url', 'web'],
    QuestionType.phoneNumber: ['phone number', 'phone', 'tel'],
    QuestionType.captcha: ['captcha', 'robot', 'verification'],
    QuestionType.unitSelect: ['unit', 'kg', 'lb', 'measure'],
    QuestionType.price: ['price', 'currency', 'cost'],
    QuestionType.age: ['age', 'years'],
    QuestionType.toggle: ['toggle', 'switch', 'on off'],
    QuestionType.multiCheckbox: ['multi checkbox', 'multi check'],
    QuestionType.emailList: ['email list', 'multiple emails'],
    QuestionType.qrCodeScan: ['qr', 'scan', 'barcode'],
    QuestionType.search: ['search', 'find', 'lookup'],
    QuestionType.file: ['generic file', 'attachment'],
  };

  bool _matchesSearch(QuestionType type, String query) {
    if (query.isEmpty) return true;
    final q = query.toLowerCase();

    // Check label
    if (type.label.toLowerCase().contains(q)) return true;

    // Check Enum name (technically 'type')
    if (type.name.toLowerCase().contains(q)) return true;

    // Check keywords
    final keywords = _searchKeywords[type] ?? [];
    return keywords.any((k) => k.contains(q));
  }

  @override
  Widget build(BuildContext context) {
    final customFields = ref.watch(customFieldsProvider).state;

    // Reorganized categories based on user requirements
    final categories = {
      'Basic Fields': [
        QuestionType.shortText,
        QuestionType.paragraph,
        QuestionType.number,
        QuestionType.password,
        QuestionType.email,
        QuestionType.mobile,
        QuestionType.tel,
        QuestionType.url,
        QuestionType.phoneNumber,
      ],
      'Advanced Fields': [
        QuestionType.dropdown,
        QuestionType.checkboxes,
        QuestionType.multiSelect,
        QuestionType.multipleChoice,
        QuestionType.date,
        QuestionType.time,
        QuestionType.dateRange,
        QuestionType.timeRange,
        QuestionType.rating,
        QuestionType.matrixChoice,
        QuestionType.slider,
        QuestionType.calculate,
        QuestionType.calculated,
        QuestionType.otp,
        QuestionType.richText,
        QuestionType.markdownEditor,
        QuestionType.booleanValue,
      ],
      'Media & Input': [
        QuestionType.fileUpload,
        QuestionType.multiFileUpload,
        QuestionType.filePicker,
        QuestionType.fileList,
        QuestionType.image,
        QuestionType.imageGallery,
        QuestionType.signature,
        QuestionType.signaturePad,
        QuestionType.mapLocation,
        QuestionType.address,
        QuestionType.addressLookup,
      ],
      'Layout Elements': [
        QuestionType.divider,
        QuestionType.spacer,
        QuestionType.customField,
        QuestionType.colorPicker,
        QuestionType.range,
        QuestionType.stepper,
        QuestionType.countrySelect,
        QuestionType.stateSelect,
        QuestionType.citySelect,
        QuestionType.socialMediaHandle,
        QuestionType.websiteUrl,
        QuestionType.captcha,
        QuestionType.unitSelect,
        QuestionType.price,
        QuestionType.age,
        QuestionType.toggle,
        QuestionType.multiCheckbox,
        QuestionType.emailList,
        QuestionType.qrCodeScan,
        QuestionType.search,
        QuestionType.file,
      ],
    };

    final systemTemplates = customFields
        .where((f) => f.category != 'My Fields')
        .toList();
    final savedTemplates = customFields
        .where((f) => f.category == 'My Fields')
        .toList();

    final hasResults = categories.values.any(
      (types) => types.any((t) => _matchesSearch(t, _searchQuery)),
    );

    return DefaultTabController(
      length: 3,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.builderSidebar,
          border: Border(
            right: BorderSide(color: AppColors.borderLight, width: 1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Sticky Header Section
            Container(
              padding: const EdgeInsets.only(
                top: 16,
                left: 16,
                right: 16,
                bottom: 12,
              ),
              decoration: BoxDecoration(
                color: AppColors.builderSidebar.withValues(alpha: 0.9),
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.borderLight.withValues(alpha: 0.5),
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(
                        FontAwesomeIcons.cubes,
                        size: 16,
                        color: AppColors.textGrey,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Elements',
                        style: TextStyle(
                          color: AppColors.textDark,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Search Bar with glass/subtle effect
                  TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() => _searchQuery = val),
                    decoration: InputDecoration(
                      hintText: 'Search fields (e.g., "Phone")',
                      hintStyle: TextStyle(
                        color: AppColors.textGrey.withValues(alpha: 0.7),
                        fontSize: 13,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        size: 18,
                        color: AppColors.textGrey,
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                      filled: true,
                      fillColor: AppColors.builderBackground,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            Material(
              color: AppColors.builderSidebar,
              child: const TabBar(
                isScrollable: true,
                tabs: [
                  Tab(text: 'Fields'),
                  Tab(text: 'Templates'),
                  Tab(text: 'Saved'),
                ],
                labelColor: AppColors.brandBlue,
                unselectedLabelColor: AppColors.textGrey,
                indicatorColor: AppColors.brandBlue,
                indicatorWeight: 3,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            const Divider(color: AppColors.borderLight, height: 1),

            Expanded(
              child: TabBarView(
                children: [
                  !hasResults && _searchQuery.isNotEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 40,
                                color: AppColors.textGrey.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'No fields found',
                                style: TextStyle(
                                  color: AppColors.textGrey,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Theme(
                          data: Theme.of(
                            context,
                          ).copyWith(dividerColor: Colors.transparent),
                          child: ListView(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                width: double.infinity,
                                height: 40,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.primary.withValues(alpha: 0.08),
                                      AppColors.primary.withValues(alpha: 0.02),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.2,
                                    ),
                                  ),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    showDialog(
                                      // Modified onTap
                                      context: context,
                                      builder: (context) => AiAssistantDialog(
                                        formId: widget.formId,
                                      ),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        FontAwesomeIcons.wandMagicSparkles,
                                        color: AppColors.primary,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'AI Assistant',
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              ...categories.entries.map((entry) {
                                final categoryName = entry.key;
                                final categoryTypes = entry.value;

                                final filteredCategoryTypes = categoryTypes
                                    .where((type) {
                                      return _matchesSearch(type, _searchQuery);
                                    })
                                    .toList();

                                if (filteredCategoryTypes.isEmpty) {
                                  return const SizedBox.shrink();
                                }

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: ExpansionTile(
                                    title: Text(
                                      categoryName,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textGrey,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    initiallyExpanded: true,
                                    shape:
                                        const Border(), // Remove default borders
                                    dense: true,
                                    tilePadding: EdgeInsets.zero,
                                    childrenPadding: const EdgeInsets.only(
                                      bottom: 8,
                                      left: 4,
                                      right: 4,
                                    ),
                                    children: [
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: filteredCategoryTypes.map((
                                          type,
                                        ) {
                                          return _buildFieldButton(
                                            context,
                                            type,
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                  // Templates Tab
                  _buildTemplatesList(
                    context,
                    systemTemplates,
                    'No templates found',
                  ),
                  // Saved Templates Tab
                  _buildTemplatesList(
                    context,
                    savedTemplates,
                    'No saved templates found',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemplatesList(
    BuildContext context,
    List<CustomFieldTemplate> templates,
    String emptyMessage,
  ) {
    if (templates.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: const TextStyle(color: AppColors.textGrey),
        ),
      );
    }

    final Map<String, List<CustomFieldTemplate>> byCategory = {};
    for (var t in templates) {
      byCategory.putIfAbsent(t.category, () => []).add(t);
    }

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ListView(
        padding: const EdgeInsets.all(10),
        children: byCategory.entries.map((entry) {
          final filtered = entry.value.where((f) {
            if (_searchQuery.isEmpty) return true;
            return f.name.toLowerCase().contains(_searchQuery.toLowerCase());
          }).toList();

          if (filtered.isEmpty) return const SizedBox.shrink();

          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ExpansionTile(
              title: Text(
                entry.key,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textGrey,
                ),
              ),
              initiallyExpanded: true,
              childrenPadding: const EdgeInsets.only(
                bottom: 8,
                left: 4,
                right: 4,
              ),
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: filtered
                      .map((t) => _buildCustomFieldButton(context, t))
                      .toList(),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFieldButton(BuildContext context, QuestionType type) {
    final card = _FieldButtonCard(type: type, width: 105);
    return Draggable<Object>(
      data: type,
      feedback: Material(
        color: Colors.transparent,
        child: Opacity(
          opacity: 0.8,
          child: _FieldButtonCard(type: type, width: 110),
        ),
      ),
      // InkWell on the child (non-dragging) triggers the insert action.
      // Dragging still works — the drag starts before the tap gesture fires.
      child: InkWell(
        onTap: () {
          ref
              .read(
                formBuilderControllerProvider(widget.controllerKey).notifier,
              )
              .addQuestionToActiveSection(type);
        },
        borderRadius: BorderRadius.circular(12),
        child: card,
      ),
    );
  }

  Widget _buildCustomFieldButton(
    BuildContext context,
    CustomFieldTemplate template,
  ) {
    QuestionType type = QuestionType.shortText;
    if (template.template_type == 'question') {
      final typeStr = template.data['type'];
      if (typeStr != null) {
        final rawTypeStr = typeStr.toString();
        type = QuestionType.values.firstWhere(
          (e) =>
              e.toString() == rawTypeStr ||
              e.toString() == 'QuestionType.$rawTypeStr',
          orElse: () => QuestionType.shortText,
        );
      }
    }

    final iconOverride = template.template_type == 'workflow'
        ? Icons.account_tree_outlined
        : (template.template_type == 'section'
              ? Icons.dashboard_customize
              : null);

    final card = _FieldButtonCard(
      type: type,
      label: template.name,
      width: 105,
      isCustom: true,
      iconOverride: iconOverride,
    );

    return Draggable<Object>(
      data: template,
      feedback: Material(
        color: Colors.transparent,
        child: Opacity(
          opacity: 0.8,
          child: _FieldButtonCard(
            type: type,
            label: template.name,
            width: 110,
            isCustom: true,
            iconOverride: iconOverride,
          ),
        ),
      ),
      // InkWell on the child triggers the insert action on tap.
      child: InkWell(
        onTap: () {
          ref
              .read(
                formBuilderControllerProvider(widget.controllerKey).notifier,
              )
              .addTemplateToActiveSection(template);
        },
        borderRadius: BorderRadius.circular(12),
        child: card,
      ),
    );
  }
}

class _FieldButtonCard extends StatelessWidget {
  final QuestionType type;
  final String? label;
  final double width;
  final bool isCustom;
  final IconData? iconOverride;

  const _FieldButtonCard({
    required this.type,
    this.label,
    required this.width,
    this.isCustom = false,
    this.iconOverride,
  });

  @override
  Widget build(BuildContext context) {
    final color = isCustom
        ? AppColors.primary
        : FieldRegistry.getColorForType(type);

    return Container(
      width: width,
      height: 85,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCustom
              ? AppColors.primary.withValues(alpha: 0.3)
              : AppColors.borderLight,
          width: isCustom ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              iconOverride ?? FieldRegistry.getIconForType(type),
              color: color,
              size: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label ?? type.label,
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 11,
              fontWeight: isCustom ? FontWeight.bold : FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
