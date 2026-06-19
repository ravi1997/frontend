"""
lib/modules/analysis_coder/theme/analysis_theme.dart
Theme configuration for the analysis coder module.
"""

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class AnalysisTheme extends StatelessWidget {
  final Widget child;
  final AnalysisThemeData? data;

  const AnalysisTheme({
    super.key,
    required this.child,
    this.data,
  });

  static AnalysisThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<_AnalysisThemeInherited>();
    return theme?.data ?? AnalysisThemeData.fallback();
  }

  @override
  Widget build(BuildContext context) {
    return _AnalysisThemeInherited(
      data: data ?? AnalysisThemeData.fallback(),
      child: child,
    );
  }
}

class _AnalysisThemeInherited extends InheritedWidget {
  final AnalysisThemeData data;

  const _AnalysisThemeInherited({
    required this.data,
    required super.child,
  });

  @override
  bool updateShouldNotify(_AnalysisThemeInherited oldWidget) {
    return data != oldWidget.data;
  }
}

@immutable
class AnalysisThemeData {
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final Color canvasBackgroundColor;
  final Color gridColor;
  final Color nodeBackgroundColor;
  final Color nodeBorderColor;
  final Color selectedBorderColor;
  final Color nodeShadowColor;
  final Color edgeColor;
  final Color portColor;
  final Color paletteBackgroundColor;
  final Color paletteBorderColor;
  final Color paletteHeaderColor;
  final Color dataSourceColor;
  final Color transformColor;
  final Color aggregationColor;
  final Color outputColor;
  final Color deleteButtonColor;

  final TextStyle nodeTitleStyle;
  final TextStyle nodeDescriptionStyle;
  final TextStyle portLabelStyle;
  final TextStyle paletteTitleStyle;
  final TextStyle categoryTitleStyle;
  final TextStyle nodeNameStyle;
  final TextStyle dialogTitleStyle;
  final TextStyle sectionTitleStyle;
  final TextStyle searchHintStyle;
  final TextStyle searchTextStyle;

  final BorderRadius nodeBorderRadius;

  const AnalysisThemeData({
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
    required this.canvasBackgroundColor,
    required this.gridColor,
    required this.nodeBackgroundColor,
    required this.nodeBorderColor,
    required this.selectedBorderColor,
    required this.nodeShadowColor,
    required this.edgeColor,
    required this.portColor,
    required this.paletteBackgroundColor,
    required this.paletteBorderColor,
    required this.paletteHeaderColor,
    required this.dataSourceColor,
    required this.transformColor,
    required this.aggregationColor,
    required this.outputColor,
    required this.deleteButtonColor,
    required this.nodeTitleStyle,
    required this.nodeDescriptionStyle,
    required this.portLabelStyle,
    required this.paletteTitleStyle,
    required this.categoryTitleStyle,
    required this.nodeNameStyle,
    required this.dialogTitleStyle,
    required this.sectionTitleStyle,
    required this.searchHintStyle,
    required this.searchTextStyle,
    required this.nodeBorderRadius,
  });

  factory AnalysisThemeData.fallback() {
    return const AnalysisThemeData(
      primaryColor: Color(0xFF2196F3),
      secondaryColor: Color(0xFF1976D2),
      backgroundColor: Color(0xFFFFFFFF),
      canvasBackgroundColor: Color(0xFFF5F5F5),
      gridColor: Color(0xFFE0E0E0),
      nodeBackgroundColor: Color(0xFFFFFFFF),
      nodeBorderColor: Color(0xFFE0E0E0),
      selectedBorderColor: Color(0xFF2196F3),
      nodeShadowColor: Color(0x1A000000),
      edgeColor: Color(0xFF757575),
      portColor: Color(0xFF2196F3),
      paletteBackgroundColor: Color(0xFFFFFFFF),
      paletteBorderColor: Color(0xFFE0E0E0),
      paletteHeaderColor: Color(0xFFF5F5F5),
      dataSourceColor: Color(0xFF4CAF50),
      transformColor: Color(0xFF2196F3),
      aggregationColor: Color(0xFFFF9800),
      outputColor: Color(0xFF9C27B0),
      deleteButtonColor: Color(0xFFE53935),
      nodeTitleStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF212121),
      ),
      nodeDescriptionStyle: TextStyle(
        fontSize: 12,
        color: Color(0xFF757575),
      ),
      portLabelStyle: TextStyle(
        fontSize: 12,
        color: Color(0xFF616161),
      ),
      paletteTitleStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFF212121),
      ),
      categoryTitleStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF424242),
      ),
      nodeNameStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color(0xFF212121),
      ),
      dialogTitleStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xFF212121),
      ),
      sectionTitleStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFF424242),
      ),
      searchHintStyle: TextStyle(
        fontSize: 14,
        color: Color(0xFF9E9E9E),
      ),
      searchTextStyle: TextStyle(
        fontSize: 14,
        color: Color(0xFF212121),
      ),
      nodeBorderRadius: BorderRadius.all(Radius.circular(8)),
    );
  }

  AnalysisThemeData copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    Color? backgroundColor,
    Color? canvasBackgroundColor,
    Color? gridColor,
    Color? nodeBackgroundColor,
    Color? nodeBorderColor,
    Color? selectedBorderColor,
    Color? nodeShadowColor,
    Color? edgeColor,
    Color? portColor,
    Color? paletteBackgroundColor,
    Color? paletteBorderColor,
    Color? paletteHeaderColor,
    Color? dataSourceColor,
    Color? transformColor,
    Color? aggregationColor,
    Color? outputColor,
    Color? deleteButtonColor,
    TextStyle? nodeTitleStyle,
    TextStyle? nodeDescriptionStyle,
    TextStyle? portLabelStyle,
    TextStyle? paletteTitleStyle,
    TextStyle? categoryTitleStyle,
    TextStyle? nodeNameStyle,
    TextStyle? dialogTitleStyle,
    TextStyle? sectionTitleStyle,
    TextStyle? searchHintStyle,
    TextStyle? searchTextStyle,
    BorderRadius? nodeBorderRadius,
  }) {
    return AnalysisThemeData(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      canvasBackgroundColor: canvasBackgroundColor ?? this.canvasBackgroundColor,
      gridColor: gridColor ?? this.gridColor,
      nodeBackgroundColor: nodeBackgroundColor ?? this.nodeBackgroundColor,
      nodeBorderColor: nodeBorderColor ?? this.nodeBorderColor,
      selectedBorderColor: selectedBorderColor ?? this.selectedBorderColor,
      nodeShadowColor: nodeShadowColor ?? this.nodeShadowColor,
      edgeColor: edgeColor ?? this.edgeColor,
      portColor: portColor ?? this.portColor,
      paletteBackgroundColor: paletteBackgroundColor ?? this.paletteBackgroundColor,
      paletteBorderColor: paletteBorderColor ?? this.paletteBorderColor,
      paletteHeaderColor: paletteHeaderColor ?? this.paletteHeaderColor,
      dataSourceColor: dataSourceColor ?? this.dataSourceColor,
      transformColor: transformColor ?? this.transformColor,
      aggregationColor: aggregationColor ?? this.aggregationColor,
      outputColor: outputColor ?? this.outputColor,
      deleteButtonColor: deleteButtonColor ?? this.deleteButtonColor,
      nodeTitleStyle: nodeTitleStyle ?? this.nodeTitleStyle,
      nodeDescriptionStyle: nodeDescriptionStyle ?? this.nodeDescriptionStyle,
      portLabelStyle: portLabelStyle ?? this.portLabelStyle,
      paletteTitleStyle: paletteTitleStyle ?? this.paletteTitleStyle,
      categoryTitleStyle: categoryTitleStyle ?? this.categoryTitleStyle,
      nodeNameStyle: nodeNameStyle ?? this.nodeNameStyle,
      dialogTitleStyle: dialogTitleStyle ?? this.dialogTitleStyle,
      sectionTitleStyle: sectionTitleStyle ?? this.sectionTitleStyle,
      searchHintStyle: searchHintStyle ?? this.searchHintStyle,
      searchTextStyle: searchTextStyle ?? this.searchTextStyle,
      nodeBorderRadius: nodeBorderRadius ?? this.nodeBorderRadius,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AnalysisThemeData &&
        other.primaryColor == primaryColor &&
        other.secondaryColor == secondaryColor &&
        other.backgroundColor == backgroundColor &&
        other.canvasBackgroundColor == canvasBackgroundColor &&
        other.gridColor == gridColor &&
        other.nodeBackgroundColor == nodeBackgroundColor &&
        other.nodeBorderColor == nodeBorderColor &&
        other.selectedBorderColor == selectedBorderColor &&
        other.nodeShadowColor == nodeShadowColor &&
        other.edgeColor == edgeColor &&
        other.portColor == portColor &&
        other.paletteBackgroundColor == paletteBackgroundColor &&
        other.paletteBorderColor == paletteBorderColor &&
        other.paletteHeaderColor == paletteHeaderColor &&
        other.dataSourceColor == dataSourceColor &&
        other.transformColor == transformColor &&
        other.aggregationColor == aggregationColor &&
        other.outputColor == outputColor &&
        other.deleteButtonColor == deleteButtonColor &&
        other.nodeTitleStyle == nodeTitleStyle &&
        other.nodeDescriptionStyle == nodeDescriptionStyle &&
        other.portLabelStyle == portLabelStyle &&
        other.paletteTitleStyle == paletteTitleStyle &&
        other.categoryTitleStyle == categoryTitleStyle &&
        other.nodeNameStyle == nodeNameStyle &&
        other.dialogTitleStyle == dialogTitleStyle &&
        other.sectionTitleStyle == sectionTitleStyle &&
        other.searchHintStyle == searchHintStyle &&
        other.searchTextStyle == searchTextStyle &&
        other.nodeBorderRadius == nodeBorderRadius;
  }

  @override
  int get hashCode {
    return hashList([
      primaryColor,
      secondaryColor,
      backgroundColor,
      canvasBackgroundColor,
      gridColor,
      nodeBackgroundColor,
      nodeBorderColor,
      selectedBorderColor,
      nodeShadowColor,
      edgeColor,
      portColor,
      paletteBackgroundColor,
      paletteBorderColor,
      paletteHeaderColor,
      dataSourceColor,
      transformColor,
      aggregationColor,
      outputColor,
      deleteButtonColor,
      nodeTitleStyle,
      nodeDescriptionStyle,
      portLabelStyle,
      paletteTitleStyle,
      categoryTitleStyle,
      nodeNameStyle,
      dialogTitleStyle,
      sectionTitleStyle,
      searchHintStyle,
      searchTextStyle,
      nodeBorderRadius,
    ]);
  }
}