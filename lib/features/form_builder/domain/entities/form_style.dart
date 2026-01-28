import 'package:freezed_annotation/freezed_annotation.dart';

part 'form_style.freezed.dart';
part 'form_style.g.dart';

@freezed
abstract class QuestionStyle with _$QuestionStyle {
  const factory QuestionStyle({
    @Default(16.0) double labelFontSize,
    @Default('#1E293B') String labelColor,
    @Default(13.0) double helperFontSize,
    @Default('#64748B') String helperColor,
    @Default(8.0) double borderRadius,
    @Default('#FFFFFF') String backgroundColor,
    @Default('#E2E8F0') String borderColor,
    @Default(1.0) double borderWidth,
    @Default(1) int columnSpan,
    @Default('top') String labelPosition, // top, left, floating, hidden
    @Default('auto') String widthMode, // auto, fixed
    @Default('medium') String fixedWidth, // small, medium, large
    @Default('outlined')
    String
    inputStyle, // outlined, filled, glass, minimalist, boxed, rounded, underlined
    // Typography - Input
    @Default(14.0) double inputFontSize,
    @Default('#0F172A') String inputFontColor,

    // Typography - Weights
    @Default('medium') String labelFontWeight,
    @Default('normal') String helperFontWeight,
    @Default('normal') String inputFontWeight,

    // State Colors
    @Default('#3B82F6') String focusColor,
    @Default('#EF4444') String errorColor,
    @Default('#F1F5F9') String hoverColor,

    // Icons
    String? prefixIcon,
    String? suffixIcon,

    // Spacing
    @Default(16.0) double verticalMargin,
  }) = _QuestionStyle;

  factory QuestionStyle.fromJson(Map<String, dynamic> json) =>
      _$QuestionStyleFromJson(json);
}

@freezed
abstract class SectionStyle with _$SectionStyle {
  const factory SectionStyle({
    @Default('#FFFFFF') String backgroundColor,
    @Default(12.0) double borderRadius,
    @Default(2.0) double elevation,
    @Default(16.0) double padding,
    @Default(true) bool showHeader,
    @Default('#F8FAFC') String headerBackgroundColor,
    @Default('#E2E8F0') String borderColor,
    @Default(1.0) double borderWidth,
  }) = _SectionStyle;

  factory SectionStyle.fromJson(Map<String, dynamic> json) =>
      _$SectionStyleFromJson(json);
}

@freezed
abstract class FormStyle with _$FormStyle {
  const factory FormStyle({
    @Default('#F1F5F9') String backgroundColor,
    @Default('Inter') String fontFamily,
    @Default('#3B82F6') String primaryColor,
    @Default(8.0) double globalBorderRadius,
    @Default(24.0) double sectionSpacing,
    @Default(16.0) double questionSpacing,
    @Default(800.0) double maxWidth,
    @Default('standard') String layoutType, // standard, card, step
  }) = _FormStyle;

  factory FormStyle.fromJson(Map<String, dynamic> json) =>
      _$FormStyleFromJson(json);
}
