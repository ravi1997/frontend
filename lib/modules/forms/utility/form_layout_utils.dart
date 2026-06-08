import 'package:flutter/material.dart';
import 'package:frontend/modules/forms/models/section_layout_type.dart';

String sectionLayoutValue(SectionLayoutType layout) {
  return switch (layout) {
    SectionLayoutType.standard => 'flex',
    SectionLayoutType.grid => 'grid-cols-2',
    SectionLayoutType.threeColumns => 'grid-cols-3',
    SectionLayoutType.fullWidth => 'full-width',
    SectionLayoutType.list => 'list',
    SectionLayoutType.sidebar => 'sidebar',
    SectionLayoutType.accordion => 'accordion',
    SectionLayoutType.tabbed => 'tabbed',
    SectionLayoutType.custom => 'custom',
    SectionLayoutType.overlay => 'overlay',
    SectionLayoutType.dashboard => 'dashboard',
    SectionLayoutType.centered => 'centered',
    SectionLayoutType.wizard => 'wizard',
    SectionLayoutType.masonry => 'masonry',
    SectionLayoutType.fixed => 'fixed',
    SectionLayoutType.card => 'card',
  };
}

bool isWideSectionLayout(String layout) {
  return layout == sectionLayoutValue(SectionLayoutType.fullWidth) ||
      layout == sectionLayoutValue(SectionLayoutType.dashboard) ||
      layout == sectionLayoutValue(SectionLayoutType.centered);
}

double sectionMaxWidth(String layout, Map<String, dynamic> metadata) {
  return (metadata['maxWidth'] as num?)?.toDouble() ??
      (layout == sectionLayoutValue(SectionLayoutType.centered)
          ? 760.0
          : 1200.0);
}

double fixedFieldWidth(double fixedWidth, {double fallback = 200.0}) {
  if (fixedWidth <= 240) return 200.0;
  if (fixedWidth <= 480) return 400.0;
  if (fixedWidth > 480) return 600.0;
  return fallback;
}

TextFormField buildSpecialTextField({
  required TextEditingController controller,
  required TextStyle textStyle,
  required InputDecoration decoration,
  required ValueChanged<String> onChanged,
  int? maxLines,
  int? minLines,
}) {
  return TextFormField(
    controller: controller,
    style: textStyle,
    decoration: decoration,
    maxLines: maxLines,
    minLines: minLines,
    onChanged: onChanged,
  );
}
