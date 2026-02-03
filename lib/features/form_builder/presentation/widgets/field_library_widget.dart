import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/theme/app_colors.dart';

import '../../domain/entities/question_type.dart';
import '../../domain/entities/custom_field_template.dart';
import '../controllers/custom_fields_controller.dart';
import '../../domain/services/field_registry.dart';

class FieldLibraryWidget extends ConsumerStatefulWidget {
  const FieldLibraryWidget({super.key});

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
    QuestionType.email: ['mail', 'address'],
    QuestionType.mobile: [
      'phone',
      'cell',
      'telephone',
      'number',
      'contact',
      'call',
    ],
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
    QuestionType.rating: ['star', 'rate', 'score', 'feedback'],
    QuestionType.signature: ['sign', 'draw', 'handwriting', 'approve'],
    QuestionType.slider: ['range', 'volume', 'level', 'adjust'],
    QuestionType.image: ['photo', 'picture', 'gallery', 'camera'],
    QuestionType.divider: ['line', 'separator', 'break', 'horizontal'],
    QuestionType.spacer: ['empty', 'gap', 'margin', 'padding'],
    QuestionType.matrixChoice: ['grid', 'table', 'multiple', 'rows', 'columns'],
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
    final customFields = ref.watch(customFieldsProvider);

    // Reorganized categories based on user requirements
    final categories = {
      'Basic Fields': [
        QuestionType.shortText,
        QuestionType.paragraph,
        QuestionType.number,
        QuestionType.email,
        QuestionType.mobile,
        QuestionType.url,
      ],
      'Advanced Fields': [
        QuestionType.dropdown,
        QuestionType.checkboxes,
        QuestionType.multipleChoice,
        QuestionType.date,
        QuestionType.time,
        QuestionType.rating,
        QuestionType.matrixChoice,
        QuestionType.slider,
      ],
      'Media & Input': [
        QuestionType.fileUpload,
        QuestionType.image,
        QuestionType.signature,
      ],
      'Layout Elements': [QuestionType.divider, QuestionType.spacer],
    };

    final hasResults =
        categories.values.any(
          (types) => types.any((t) => _matchesSearch(t, _searchQuery)),
        ) ||
        customFields.any(
          (f) => f.name.toLowerCase().contains(_searchQuery.toLowerCase()),
        );

    return Container(
      decoration: BoxDecoration(
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
            padding: const EdgeInsets.all(20.0),
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
                const Text(
                  'Field Library',
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Click or drag to add fields',
                  style: TextStyle(color: AppColors.textGrey, fontSize: 12),
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
                    prefixIcon: Icon(
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
                      borderSide: BorderSide(color: Colors.transparent),
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

          Expanded(
            child: !hasResults && _searchQuery.isNotEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 40,
                          color: AppColors.textGrey.withValues(alpha: 0.3),
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
                              color: AppColors.primary.withValues(alpha: 0.2),
                            ),
                          ),
                          child: InkWell(
                            onTap: () {},
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

                          final filteredCategoryTypes = categoryTypes.where((
                            type,
                          ) {
                            return _matchesSearch(type, _searchQuery);
                          }).toList();

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
                              shape: const Border(), // Remove default borders
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
                                  children: filteredCategoryTypes.map((type) {
                                    return _buildFieldButton(context, type);
                                  }).toList(),
                                ),
                              ],
                            ),
                          );
                        }),

                        if (customFields.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: ExpansionTile(
                              title: const Text(
                                'Custom Fields',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textGrey,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              initiallyExpanded: true,
                              shape: const Border(),
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
                                  children: customFields
                                      .where((f) {
                                        if (_searchQuery.isEmpty) return true;
                                        return f.name.toLowerCase().contains(
                                          _searchQuery.toLowerCase(),
                                        );
                                      })
                                      .map((template) {
                                        return _buildCustomFieldButton(
                                          context,
                                          template,
                                        );
                                      })
                                      .toList(),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldButton(BuildContext context, QuestionType type) {
    return Draggable<Object>(
      data: type,
      feedback: Material(
        color: Colors.transparent,
        child: Opacity(
          opacity: 0.8,
          child: _FieldButtonCard(type: type, width: 110),
        ),
      ),
      child: _FieldButtonCard(type: type, width: 105),
    );
  }

  Widget _buildCustomFieldButton(
    BuildContext context,
    CustomFieldTemplate template,
  ) {
    return Draggable<Object>(
      data: template,
      feedback: Material(
        color: Colors.transparent,
        child: Opacity(
          opacity: 0.8,
          child: _FieldButtonCard(
            type: template.question.type,
            label: template.name,
            width: 110,
            isCustom: true,
          ),
        ),
      ),
      child: _FieldButtonCard(
        type: template.question.type,
        label: template.name,
        width: 105,
        isCustom: true,
      ),
    );
  }
}

class _FieldButtonCard extends StatelessWidget {
  final QuestionType type;
  final String? label;
  final double width;
  final bool isCustom;

  const _FieldButtonCard({
    required this.type,
    this.label,
    required this.width,
    this.isCustom = false,
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
              FieldRegistry.getIconForType(type),
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
