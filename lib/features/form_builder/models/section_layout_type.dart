import 'package:json_annotation/json_annotation.dart';

enum SectionLayoutType {
  @JsonValue('flex')
  standard,
  @JsonValue('grid-cols-2')
  grid,
  @JsonValue('grid-cols-3')
  threeColumns,
  @JsonValue('full-width')
  fullWidth,
  @JsonValue('list')
  list,
  @JsonValue('sidebar')
  sidebar,
  @JsonValue('accordion')
  accordion,
  @JsonValue('tabbed')
  tabbed,
  @JsonValue('custom')
  custom,
  @JsonValue('overlay')
  overlay,
  @JsonValue('dashboard')
  dashboard,
  @JsonValue('centered')
  centered,
  @JsonValue('wizard')
  wizard,
  @JsonValue('masonry')
  masonry,
  @JsonValue('fixed')
  fixed,
  @JsonValue('card')
  card,
}

extension SectionLayoutTypeExtension on SectionLayoutType {
  String get label {
    switch (this) {
      case SectionLayoutType.standard:
        return 'Standard Vertical';
      case SectionLayoutType.grid:
        return 'Grid (Multi-Column)';
      case SectionLayoutType.threeColumns:
        return 'Grid (3 Columns)';
      case SectionLayoutType.fullWidth:
        return 'Full Width';
      case SectionLayoutType.list:
        return 'List';
      case SectionLayoutType.sidebar:
        return 'Sidebar';
      case SectionLayoutType.accordion:
        return 'Accordion';
      case SectionLayoutType.tabbed:
        return 'Tabbed';
      case SectionLayoutType.custom:
        return 'Custom';
      case SectionLayoutType.overlay:
        return 'Overlay';
      case SectionLayoutType.dashboard:
        return 'Dashboard';
      case SectionLayoutType.centered:
        return 'Centered';
      case SectionLayoutType.wizard:
        return 'Multi-Step (Wizard)';
      case SectionLayoutType.masonry:
        return 'Masonry';
      case SectionLayoutType.fixed:
        return 'Fixed';
      case SectionLayoutType.card:
        return 'Card-Based';
    }
  }

  String get description {
    switch (this) {
      case SectionLayoutType.standard:
        return 'Questions stacked in a single column (Current default).';
      case SectionLayoutType.grid:
        return 'Questions arranged in 2, 3, or 4 columns side-by-side.';
      case SectionLayoutType.threeColumns:
        return 'Questions arranged in three columns.';
      case SectionLayoutType.fullWidth:
        return 'Questions span the full available width.';
      case SectionLayoutType.list:
        return 'Questions rendered in a simple vertical list.';
      case SectionLayoutType.sidebar:
        return 'Layout with a main content area and side navigation.';
      case SectionLayoutType.accordion:
        return 'Sections that can be expanded or collapsed by clicking the header.';
      case SectionLayoutType.tabbed:
        return 'Navigation tabs at the top of the section to switch between sub-groups.';
      case SectionLayoutType.custom:
        return 'Custom builder layout for advanced canvas arrangements.';
      case SectionLayoutType.overlay:
        return 'Overlay-style presentation for modal-like flows.';
      case SectionLayoutType.dashboard:
        return 'Dashboard-style layout for dense widgets and cards.';
      case SectionLayoutType.centered:
        return 'Centered content for focused single-panel experiences.';
      case SectionLayoutType.wizard:
        return 'Each section acts as a "Step" with Next/Back buttons.';
      case SectionLayoutType.masonry:
        return 'Masonry layout for staggered card grids.';
      case SectionLayoutType.fixed:
        return 'Fixed-size section rendering.';
      case SectionLayoutType.card:
        return 'Each section is visually housed in a distinct "floating" card with shadows.';
    }
  }

  String get bestFor {
    switch (this) {
      case SectionLayoutType.standard:
        return 'Mobile-first designs and simple forms.';
      case SectionLayoutType.grid:
        return 'Desktop views and densley packed data entry.';
      case SectionLayoutType.threeColumns:
        return 'Wide desktop layouts needing three columns.';
      case SectionLayoutType.fullWidth:
        return 'Forms or sections that need extra horizontal space.';
      case SectionLayoutType.list:
        return 'Simple content listings and low-density forms.';
      case SectionLayoutType.sidebar:
        return 'Complex flows where supporting navigation should stay visible.';
      case SectionLayoutType.accordion:
        return 'Long forms where users only need to see one part at a time.';
      case SectionLayoutType.tabbed:
        return 'Organizing highly distinct categories of information.';
      case SectionLayoutType.custom:
        return 'Advanced layouts with builder-defined placement rules.';
      case SectionLayoutType.overlay:
        return 'Temporary content or modal-like flows.';
      case SectionLayoutType.dashboard:
        return 'Analytics, summary cards, or multi-panel admin experiences.';
      case SectionLayoutType.centered:
        return 'Single-purpose layouts with strong visual focus.';
      case SectionLayoutType.wizard:
        return 'Complex workflows or onboarding processes.';
      case SectionLayoutType.masonry:
        return 'Uneven card collections or gallery-like displays.';
      case SectionLayoutType.fixed:
        return 'Static section sizes where flexibility is not needed.';
      case SectionLayoutType.card:
        return 'Modern, clean UI that needs clear visual separation.';
    }
  }
}
