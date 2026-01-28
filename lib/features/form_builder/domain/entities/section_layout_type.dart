import 'package:freezed_annotation/freezed_annotation.dart';

enum SectionLayoutType {
  @JsonValue('standard')
  standard,
  @JsonValue('grid')
  grid,
  @JsonValue('accordion')
  accordion,
  @JsonValue('tabbed')
  tabbed,
  @JsonValue('wizard')
  wizard,
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
      case SectionLayoutType.accordion:
        return 'Accordion';
      case SectionLayoutType.tabbed:
        return 'Tabbed';
      case SectionLayoutType.wizard:
        return 'Multi-Step (Wizard)';
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
      case SectionLayoutType.accordion:
        return 'Sections that can be expanded or collapsed by clicking the header.';
      case SectionLayoutType.tabbed:
        return 'Navigation tabs at the top of the section to switch between sub-groups.';
      case SectionLayoutType.wizard:
        return 'Each section acts as a "Step" with Next/Back buttons.';
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
      case SectionLayoutType.accordion:
        return 'Long forms where users only need to see one part at a time.';
      case SectionLayoutType.tabbed:
        return 'Organizing highly distinct categories of information.';
      case SectionLayoutType.wizard:
        return 'Complex workflows or onboarding processes.';
      case SectionLayoutType.card:
        return 'Modern, clean UI that needs clear visual separation.';
    }
  }
}
