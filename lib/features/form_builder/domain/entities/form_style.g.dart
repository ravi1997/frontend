// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_style.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QuestionStyle _$QuestionStyleFromJson(Map<String, dynamic> json) =>
    _QuestionStyle(
      labelFontSize: (json['labelFontSize'] as num?)?.toDouble() ?? 16.0,
      labelColor: json['labelColor'] as String? ?? '#1E293B',
      helperFontSize: (json['helperFontSize'] as num?)?.toDouble() ?? 13.0,
      helperColor: json['helperColor'] as String? ?? '#64748B',
      borderRadius: (json['borderRadius'] as num?)?.toDouble() ?? 8.0,
      backgroundColor: json['backgroundColor'] as String? ?? '#FFFFFF',
      borderColor: json['borderColor'] as String? ?? '#E2E8F0',
      borderWidth: (json['borderWidth'] as num?)?.toDouble() ?? 1.0,
      columnSpan: (json['columnSpan'] as num?)?.toInt() ?? 1,
      labelPosition: json['labelPosition'] as String? ?? 'top',
      widthMode: json['widthMode'] as String? ?? 'auto',
      fixedWidth: json['fixedWidth'] as String? ?? 'medium',
      inputStyle: json['inputStyle'] as String? ?? 'outlined',
      inputFontSize: (json['inputFontSize'] as num?)?.toDouble() ?? 14.0,
      inputFontColor: json['inputFontColor'] as String? ?? '#0F172A',
      labelFontWeight: json['labelFontWeight'] as String? ?? 'medium',
      helperFontWeight: json['helperFontWeight'] as String? ?? 'normal',
      inputFontWeight: json['inputFontWeight'] as String? ?? 'normal',
      focusColor: json['focusColor'] as String? ?? '#3B82F6',
      errorColor: json['errorColor'] as String? ?? '#EF4444',
      hoverColor: json['hoverColor'] as String? ?? '#F1F5F9',
      prefixIcon: json['prefixIcon'] as String?,
      suffixIcon: json['suffixIcon'] as String?,
      verticalMargin: (json['verticalMargin'] as num?)?.toDouble() ?? 16.0,
      labelColumnWidth: (json['labelColumnWidth'] as num?)?.toDouble(),
      containerAlignment: json['containerAlignment'] as String?,
      containerPadding: (json['containerPadding'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$QuestionStyleToJson(_QuestionStyle instance) =>
    <String, dynamic>{
      'labelFontSize': instance.labelFontSize,
      'labelColor': instance.labelColor,
      'helperFontSize': instance.helperFontSize,
      'helperColor': instance.helperColor,
      'borderRadius': instance.borderRadius,
      'backgroundColor': instance.backgroundColor,
      'borderColor': instance.borderColor,
      'borderWidth': instance.borderWidth,
      'columnSpan': instance.columnSpan,
      'labelPosition': instance.labelPosition,
      'widthMode': instance.widthMode,
      'fixedWidth': instance.fixedWidth,
      'inputStyle': instance.inputStyle,
      'inputFontSize': instance.inputFontSize,
      'inputFontColor': instance.inputFontColor,
      'labelFontWeight': instance.labelFontWeight,
      'helperFontWeight': instance.helperFontWeight,
      'inputFontWeight': instance.inputFontWeight,
      'focusColor': instance.focusColor,
      'errorColor': instance.errorColor,
      'hoverColor': instance.hoverColor,
      'prefixIcon': instance.prefixIcon,
      'suffixIcon': instance.suffixIcon,
      'verticalMargin': instance.verticalMargin,
      'labelColumnWidth': instance.labelColumnWidth,
      'containerAlignment': instance.containerAlignment,
      'containerPadding': instance.containerPadding,
      'height': instance.height,
    };

_SectionStyle _$SectionStyleFromJson(Map<String, dynamic> json) =>
    _SectionStyle(
      backgroundColor: json['backgroundColor'] as String? ?? '#FFFFFF',
      borderRadius: (json['borderRadius'] as num?)?.toDouble() ?? 12.0,
      elevation: (json['elevation'] as num?)?.toDouble() ?? 2.0,
      padding: (json['padding'] as num?)?.toDouble() ?? 16.0,
      showHeader: json['showHeader'] as bool? ?? true,
      headerBackgroundColor:
          json['headerBackgroundColor'] as String? ?? '#F8FAFC',
      borderColor: json['borderColor'] as String? ?? '#E2E8F0',
      borderWidth: (json['borderWidth'] as num?)?.toDouble() ?? 1.0,
    );

Map<String, dynamic> _$SectionStyleToJson(_SectionStyle instance) =>
    <String, dynamic>{
      'backgroundColor': instance.backgroundColor,
      'borderRadius': instance.borderRadius,
      'elevation': instance.elevation,
      'padding': instance.padding,
      'showHeader': instance.showHeader,
      'headerBackgroundColor': instance.headerBackgroundColor,
      'borderColor': instance.borderColor,
      'borderWidth': instance.borderWidth,
    };

_FormStyle _$FormStyleFromJson(Map<String, dynamic> json) => _FormStyle(
  backgroundColor: json['backgroundColor'] as String? ?? '#F1F5F9',
  fontFamily: json['fontFamily'] as String? ?? 'Inter',
  primaryColor: json['primaryColor'] as String? ?? '#3B82F6',
  globalBorderRadius: (json['globalBorderRadius'] as num?)?.toDouble() ?? 8.0,
  sectionSpacing: (json['sectionSpacing'] as num?)?.toDouble() ?? 24.0,
  questionSpacing: (json['questionSpacing'] as num?)?.toDouble() ?? 16.0,
  maxWidth: (json['maxWidth'] as num?)?.toDouble() ?? 800.0,
  layoutType: json['layoutType'] as String? ?? 'standard',
);

Map<String, dynamic> _$FormStyleToJson(_FormStyle instance) =>
    <String, dynamic>{
      'backgroundColor': instance.backgroundColor,
      'fontFamily': instance.fontFamily,
      'primaryColor': instance.primaryColor,
      'globalBorderRadius': instance.globalBorderRadius,
      'sectionSpacing': instance.sectionSpacing,
      'questionSpacing': instance.questionSpacing,
      'maxWidth': instance.maxWidth,
      'layoutType': instance.layoutType,
    };
