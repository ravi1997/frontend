import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/form_builder/domain/entities/form_section.dart';
import 'package:frontend/features/form_builder/domain/entities/section_layout_type.dart';
import 'property_builder_utils.dart';

// Layouts that are real visual/interactive and worth exposing to users.
// 'custom' and 'fixed' are omitted — they are stubs with no distinct behaviour.
const _exposedLayouts = [
  SectionLayoutType.standard,
  SectionLayoutType.fullWidth,
  SectionLayoutType.list,
  SectionLayoutType.grid,
  SectionLayoutType.threeColumns,
  SectionLayoutType.card,
  SectionLayoutType.centered,
  SectionLayoutType.accordion,
  SectionLayoutType.tabbed,
  SectionLayoutType.sidebar,
  SectionLayoutType.wizard,
  SectionLayoutType.masonry,
  SectionLayoutType.dashboard,
  SectionLayoutType.overlay,
];

// Layouts that need sub-sections to be useful.
const _needsSubSections = {
  SectionLayoutType.tabbed,
  SectionLayoutType.sidebar,
  SectionLayoutType.wizard,
};

// Layouts that need ≥2 sub-sections.
const _needsTwoSubSections = {SectionLayoutType.masonry};

class SectionLayoutSettings extends ConsumerWidget {
  final String projectId;
  final String formId;
  final FormSection section;
  final ValueChanged<FormSection> onSectionChanged;

  const SectionLayoutSettings({
    super.key,
    required this.projectId,
    required this.formId,
    required this.section,
    required this.onSectionChanged,
  });

  void _updateSection(FormSection updatedSection) {
    onSectionChanged(updatedSection);
  }

  void _updateMetadata(String key, dynamic value) {
    onSectionChanged(
      section.copyWith(metaData: {...section.metaData, key: value}),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metadata = section.metaData;
    final layout = section.layout;
    final subCount = section.sections.length;

    // Determine readiness of condition-dependent layouts
    final needsSub = _needsSubSections.contains(layout);
    final needsTwo = _needsTwoSubSections.contains(layout);
    final isReady = needsSub
        ? subCount >= 1
        : needsTwo
        ? subCount >= 2
        : true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section Layout Picker ─────────────────────────────────────────
        const Text(
          'Section Layout',
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<SectionLayoutType>(
          value: _exposedLayouts.contains(layout)
              ? layout
              : SectionLayoutType.standard,
          isExpanded: true,
          itemHeight: null,
          menuMaxHeight: 380,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.builderElement,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),
          dropdownColor: Colors.white,
          iconEnabledColor: AppColors.textDark,
          style: const TextStyle(color: AppColors.textDark),
          items: _exposedLayouts.map((type) {
            return DropdownMenuItem(
              value: type,
              child: Row(
                children: [
                  Icon(_layoutIcon(type), size: 16, color: AppColors.textGrey),
                  const SizedBox(width: 8),
                  Text(
                    type.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.textDark),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              _updateSection(section.copyWith(layout: val));
            }
          },
        ),
        const SizedBox(height: 12),

        // ── Layout Info Card ─────────────────────────────────────────────
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.06),
                AppColors.builderElement.withValues(alpha: 0.5),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(_layoutIcon(layout), size: 16, color: AppColors.primary),
                  const SizedBox(width: 6),
                  const Text(
                    'About this layout',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                layout.description,
                style: const TextStyle(fontSize: 13, color: AppColors.textDark),
              ),
              const SizedBox(height: 6),
              Text(
                'Best for: ${layout.bestFor}',
                style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
              ),
            ],
          ),
        ),

        // ── Condition warning for sub-section-dependent layouts ──────────
        if (!isReady) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFFBBF24)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 16,
                  color: Color(0xFFD97706),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    needsTwo
                        ? 'This layout needs at least 2 sub-sections. Add sub-sections via the canvas.'
                        : 'This layout needs at least 1 sub-section. Add sub-sections via the canvas.',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF92400E),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

        // ── Grid Column Picker (grid / threeColumns only) ──────────────
        if (layout == SectionLayoutType.grid) ...[
          const SizedBox(height: 20),
          PropertyBuilderUtils.buildSectionHeader(title: 'GRID OPTIONS'),
          PropertyBuilderUtils.buildNumberSlider(
            label: 'Grid Columns',
            value: section.gridColumns.toDouble().clamp(2, 4),
            min: 2,
            max: 4,
            onChanged: (val) {
              _updateSection(section.copyWith(gridColumns: val.toInt()));
            },
          ),
        ],

        // ── threeColumns info (fixed, no slider) ──────────────────────
        if (layout == SectionLayoutType.threeColumns) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.builderElement,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, size: 14, color: AppColors.textGrey),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Fixed at 3 columns. Use "Grid (Multi-Column)" for 2 or 4 columns.',
                    style: TextStyle(fontSize: 12, color: AppColors.textGrey),
                  ),
                ),
              ],
            ),
          ),
        ],

        // ── Layout-specific options ─────────────────────────────────────
        ..._buildLayoutSpecificOptions(layout, metadata),

        // ── Spacing & Alignment ─────────────────────────────────────────
        const SizedBox(height: 20),
        PropertyBuilderUtils.buildSectionHeader(title: 'SPACING & ALIGNMENT'),
        PropertyBuilderUtils.buildNumberSlider(
          label: 'Field Gap (px)',
          value: (metadata['fieldGap'] as num?)?.toDouble() ?? 16.0,
          min: 0,
          max: 48,
          onChanged: (val) => _updateMetadata('fieldGap', val),
        ),
        const SizedBox(height: 12),
        PropertyBuilderUtils.buildNumberSlider(
          label: 'Vertical Padding',
          value:
              (metadata['verticalPadding'] as num?)?.toDouble() ??
              section.style.padding,
          min: 0,
          max: 64,
          onChanged: (val) => _updateMetadata('verticalPadding', val),
        ),
        const SizedBox(height: 12),
        PropertyBuilderUtils.buildNumberSlider(
          label: 'Horizontal Padding',
          value:
              (metadata['horizontalPadding'] as num?)?.toDouble() ??
              section.style.padding,
          min: 0,
          max: 64,
          onChanged: (val) => _updateMetadata('horizontalPadding', val),
        ),
        const SizedBox(height: 12),

        // Alignment only makes sense for centered/fullWidth/dashboard
        if (layout == SectionLayoutType.centered ||
            layout == SectionLayoutType.fullWidth ||
            layout == SectionLayoutType.dashboard) ...[
          PropertyBuilderUtils.buildDropdown<String>(
            label: 'Content Alignment',
            value: metadata['alignment']?.toString() ?? 'left',
            items: const [
              DropdownMenuItem(value: 'left', child: Text('Left')),
              DropdownMenuItem(value: 'center', child: Text('Center')),
              DropdownMenuItem(value: 'right', child: Text('Right')),
            ],
            onChanged: (val) => _updateMetadata('alignment', val),
          ),
          const SizedBox(height: 12),
        ],

        // Max-width only for layouts that constrain width
        if (layout == SectionLayoutType.centered ||
            layout == SectionLayoutType.fullWidth) ...[
          PropertyBuilderUtils.buildNumberSlider(
            label: 'Max Width (px)',
            value: (metadata['maxWidth'] as num?)?.toDouble() ?? 1200.0,
            min: 400,
            max: 2000,
            onChanged: (val) => _updateMetadata('maxWidth', val),
          ),
        ],
      ],
    );
  }

  List<Widget> _buildLayoutSpecificOptions(
    SectionLayoutType layout,
    Map<String, dynamic> metadata,
  ) {
    switch (layout) {
      case SectionLayoutType.accordion:
        return [
          const SizedBox(height: 20),
          PropertyBuilderUtils.buildSectionHeader(title: 'ACCORDION OPTIONS'),
          PropertyBuilderUtils.buildSwitch(
            label: 'Start Expanded',
            description: 'Section is open by default when the form loads.',
            value: metadata['accordionStartExpanded'] as bool? ?? false,
            onChanged: (val) => _updateMetadata('accordionStartExpanded', val),
          ),
          const SizedBox(height: 8),
          PropertyBuilderUtils.buildSwitch(
            label: 'Allow Multiple Open',
            description:
                'When disabled, opening one sub-section closes others.',
            value: metadata['accordionMultiOpen'] as bool? ?? true,
            onChanged: (val) => _updateMetadata('accordionMultiOpen', val),
          ),
        ];

      case SectionLayoutType.wizard:
        return [
          const SizedBox(height: 20),
          PropertyBuilderUtils.buildSectionHeader(title: 'WIZARD OPTIONS'),
          PropertyBuilderUtils.buildSwitch(
            label: 'Show Step Progress Bar',
            description: 'Displays a progress bar above each step.',
            value: metadata['wizardShowProgress'] as bool? ?? true,
            onChanged: (val) => _updateMetadata('wizardShowProgress', val),
          ),
          const SizedBox(height: 8),
          PropertyBuilderUtils.buildSwitch(
            label: 'Allow Back Navigation',
            description: 'User can go back to previous steps.',
            value: metadata['wizardAllowBack'] as bool? ?? true,
            onChanged: (val) => _updateMetadata('wizardAllowBack', val),
          ),
        ];

      case SectionLayoutType.tabbed:
        return [
          const SizedBox(height: 20),
          PropertyBuilderUtils.buildSectionHeader(title: 'TAB OPTIONS'),
          PropertyBuilderUtils.buildDropdown<String>(
            label: 'Tab Position',
            value: metadata['tabPosition']?.toString() ?? 'top',
            items: const [
              DropdownMenuItem(value: 'top', child: Text('Top')),
              DropdownMenuItem(value: 'bottom', child: Text('Bottom')),
            ],
            onChanged: (val) => _updateMetadata('tabPosition', val),
          ),
          const SizedBox(height: 8),
          PropertyBuilderUtils.buildSwitch(
            label: 'Scrollable Tabs',
            description: 'Scroll tabs horizontally when there are many.',
            value: metadata['tabScrollable'] as bool? ?? true,
            onChanged: (val) => _updateMetadata('tabScrollable', val),
          ),
        ];

      case SectionLayoutType.sidebar:
        return [
          const SizedBox(height: 20),
          PropertyBuilderUtils.buildSectionHeader(title: 'SIDEBAR OPTIONS'),
          PropertyBuilderUtils.buildNumberSlider(
            label: 'Sidebar Width (px)',
            value: (metadata['sidebarWidth'] as num?)?.toDouble() ?? 180.0,
            min: 120,
            max: 320,
            onChanged: (val) => _updateMetadata('sidebarWidth', val),
          ),
          const SizedBox(height: 8),
          PropertyBuilderUtils.buildDropdown<String>(
            label: 'Sidebar Position',
            value: metadata['sidebarPosition']?.toString() ?? 'left',
            items: const [
              DropdownMenuItem(value: 'left', child: Text('Left')),
              DropdownMenuItem(value: 'right', child: Text('Right')),
            ],
            onChanged: (val) => _updateMetadata('sidebarPosition', val),
          ),
        ];

      case SectionLayoutType.masonry:
        return [
          const SizedBox(height: 20),
          PropertyBuilderUtils.buildSectionHeader(title: 'MASONRY OPTIONS'),
          PropertyBuilderUtils.buildNumberSlider(
            label: 'Column Gap (px)',
            value: (metadata['masonryGap'] as num?)?.toDouble() ?? 16.0,
            min: 0,
            max: 48,
            onChanged: (val) => _updateMetadata('masonryGap', val),
          ),
        ];

      default:
        return [];
    }
  }

  IconData _layoutIcon(SectionLayoutType type) {
    switch (type) {
      case SectionLayoutType.standard:
        return Icons.view_agenda_outlined;
      case SectionLayoutType.grid:
        return Icons.grid_view_outlined;
      case SectionLayoutType.threeColumns:
        return Icons.view_column_outlined;
      case SectionLayoutType.fullWidth:
        return Icons.swap_horiz;
      case SectionLayoutType.list:
        return Icons.format_list_bulleted;
      case SectionLayoutType.card:
        return Icons.credit_card_outlined;
      case SectionLayoutType.centered:
        return Icons.align_horizontal_center;
      case SectionLayoutType.accordion:
        return Icons.expand_more;
      case SectionLayoutType.tabbed:
        return Icons.tab_outlined;
      case SectionLayoutType.sidebar:
        return Icons.view_sidebar_outlined;
      case SectionLayoutType.wizard:
        return Icons.linear_scale;
      case SectionLayoutType.masonry:
        return Icons.dashboard_outlined;
      case SectionLayoutType.dashboard:
        return Icons.bar_chart;
      case SectionLayoutType.overlay:
        return Icons.layers_outlined;
      default:
        return Icons.space_dashboard_outlined;
    }
  }
}
