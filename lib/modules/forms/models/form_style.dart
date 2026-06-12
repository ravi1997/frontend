class FormStyle {
  final String backgroundColor;
  final String fontFamily;
  final String primaryColor;
  final String accentColor;
  final String logoUrl;
  final String coverImageUrl;
  final String faviconUrl;
  final String headerStyle;
  final String thankYouTheme;
  final double globalBorderRadius;
  final double sectionSpacing;
  final double questionSpacing;
  final double maxWidth;
  final String layoutType;

  const FormStyle({
    this.backgroundColor = '#FFFFFF',
    this.fontFamily = 'Roboto',
    this.primaryColor = '#1976D2',
    this.accentColor = '#1976D2',
    this.logoUrl = '',
    this.coverImageUrl = '',
    this.faviconUrl = '',
    this.headerStyle = 'default',
    this.thankYouTheme = 'default',
    this.globalBorderRadius = 8.0,
    this.sectionSpacing = 16.0,
    this.questionSpacing = 12.0,
    this.maxWidth = 1200.0,
    this.layoutType = 'singleColumn',
  });

  factory FormStyle.fromJson(Map<String, dynamic> json) {
    return FormStyle(
      backgroundColor: json['backgroundColor'] ?? '#FFFFFF',
      fontFamily: json['fontFamily'] ?? 'Roboto',
      primaryColor: json['primaryColor'] ?? '#1976D2',
      accentColor: json['accentColor'] ?? json['primaryColor'] ?? '#1976D2',
      logoUrl: json['logoUrl'] ?? json['logo_url'] ?? '',
      coverImageUrl: json['coverImageUrl'] ?? json['cover_image_url'] ?? '',
      faviconUrl: json['faviconUrl'] ?? json['favicon_url'] ?? '',
      headerStyle: json['headerStyle'] ?? json['header_style'] ?? 'default',
      thankYouTheme:
          json['thankYouTheme'] ?? json['thank_you_theme'] ?? 'default',
      globalBorderRadius: (json['globalBorderRadius'] ?? 8.0).toDouble(),
      sectionSpacing: (json['sectionSpacing'] ?? 16.0).toDouble(),
      questionSpacing: (json['questionSpacing'] ?? 12.0).toDouble(),
      maxWidth: (json['maxWidth'] ?? 1200.0).toDouble(),
      layoutType: json['layoutType'] ?? 'singleColumn',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'backgroundColor': backgroundColor,
      'fontFamily': fontFamily,
      'primaryColor': primaryColor,
      'accentColor': accentColor,
      'logoUrl': logoUrl,
      'coverImageUrl': coverImageUrl,
      'faviconUrl': faviconUrl,
      'headerStyle': headerStyle,
      'thankYouTheme': thankYouTheme,
      'globalBorderRadius': globalBorderRadius,
      'sectionSpacing': sectionSpacing,
      'questionSpacing': questionSpacing,
      'maxWidth': maxWidth,
      'layoutType': layoutType,
    };
  }
}

class QuestionStyle {
  final String backgroundColor;
  final String textColor;
  final String borderColor;
  final double borderRadius;
  final double padding;
  final double borderWidth;
  final String widthMode;
  final double fixedWidth;
  final String labelPosition;
  final double labelFontSize;
  final String labelColor;
  final String labelFontWeight;
  final double helperFontSize;
  final String helperColor;
  final String helperFontWeight;
  final double inputFontSize;
  final String inputFontColor;
  final String inputFontWeight;
  final String inputStyle;
  final double height;
  final String prefixIcon;
  final String suffixIcon;
  final String focusColor;
  final String errorColor;
  final double verticalMargin;
  final double containerPadding;
  final double labelColumnWidth;

  const QuestionStyle({
    this.backgroundColor = '#FFFFFF',
    this.textColor = '#212121',
    this.borderColor = '#E0E0E0',
    this.borderRadius = 4.0,
    this.padding = 8.0,
    this.borderWidth = 1.0,
    this.widthMode = 'auto',
    this.fixedWidth = 200.0,
    this.labelPosition = 'top',
    this.labelFontSize = 14.0,
    this.labelColor = '#212121',
    this.labelFontWeight = 'normal',
    this.helperFontSize = 12.0,
    this.helperColor = '#757575',
    this.helperFontWeight = 'normal',
    this.inputFontSize = 14.0,
    this.inputFontColor = '#212121',
    this.inputFontWeight = 'normal',
    this.inputStyle = 'filled',
    this.height = 40.0,
    this.prefixIcon = '',
    this.suffixIcon = '',
    this.focusColor = '#1976D2',
    this.errorColor = '#D32F2F',
    this.verticalMargin = 8.0,
    this.containerPadding = 16.0,
    this.labelColumnWidth = 150.0,
  });

  factory QuestionStyle.fromJson(Map<String, dynamic> json) {
    return QuestionStyle(
      backgroundColor: json['backgroundColor'] ?? '#FFFFFF',
      textColor: json['textColor'] ?? '#212121',
      borderColor: json['borderColor'] ?? '#E0E0E0',
      borderRadius: (json['borderRadius'] ?? 4.0).toDouble(),
      padding: (json['padding'] ?? 8.0).toDouble(),
      borderWidth: (json['borderWidth'] ?? 1.0).toDouble(),
      widthMode: json['widthMode'] ?? 'auto',
      fixedWidth: (json['fixedWidth'] ?? 200.0).toDouble(),
      labelPosition: json['labelPosition'] ?? 'top',
      labelFontSize: (json['labelFontSize'] ?? 14.0).toDouble(),
      labelColor: json['labelColor'] ?? '#212121',
      labelFontWeight: json['labelFontWeight'] ?? 'normal',
      helperFontSize: (json['helperFontSize'] ?? 12.0).toDouble(),
      helperColor: json['helperColor'] ?? '#757575',
      helperFontWeight: json['helperFontWeight'] ?? 'normal',
      inputFontSize: (json['inputFontSize'] ?? 14.0).toDouble(),
      inputFontColor: json['inputFontColor'] ?? '#212121',
      inputFontWeight: json['inputFontWeight'] ?? 'normal',
      inputStyle: json['inputStyle'] ?? 'filled',
      height: (json['height'] ?? 40.0).toDouble(),
      prefixIcon: json['prefixIcon'] ?? '',
      suffixIcon: json['suffixIcon'] ?? '',
      focusColor: json['focusColor'] ?? '#1976D2',
      errorColor: json['errorColor'] ?? '#D32F2F',
      verticalMargin: (json['verticalMargin'] ?? 8.0).toDouble(),
      containerPadding: (json['containerPadding'] ?? 16.0).toDouble(),
      labelColumnWidth: (json['labelColumnWidth'] ?? 150.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'backgroundColor': backgroundColor,
      'textColor': textColor,
      'borderColor': borderColor,
      'borderRadius': borderRadius,
      'padding': padding,
      'borderWidth': borderWidth,
      'widthMode': widthMode,
      'fixedWidth': fixedWidth,
      'labelPosition': labelPosition,
      'labelFontSize': labelFontSize,
      'labelColor': labelColor,
      'labelFontWeight': labelFontWeight,
      'helperFontSize': helperFontSize,
      'helperColor': helperColor,
      'helperFontWeight': helperFontWeight,
      'inputFontSize': inputFontSize,
      'inputFontColor': inputFontColor,
      'inputFontWeight': inputFontWeight,
      'inputStyle': inputStyle,
      'height': height,
      'prefixIcon': prefixIcon,
      'suffixIcon': suffixIcon,
      'focusColor': focusColor,
      'errorColor': errorColor,
      'verticalMargin': verticalMargin,
      'containerPadding': containerPadding,
      'labelColumnWidth': labelColumnWidth,
    };
  }

  QuestionStyle copyWith({
    String? backgroundColor,
    String? textColor,
    String? borderColor,
    double? borderRadius,
    double? padding,
    double? borderWidth,
    String? widthMode,
    double? fixedWidth,
    String? labelPosition,
    double? labelFontSize,
    String? labelColor,
    String? labelFontWeight,
    double? helperFontSize,
    String? helperColor,
    String? helperFontWeight,
    double? inputFontSize,
    String? inputFontColor,
    String? inputFontWeight,
    String? inputStyle,
    double? height,
    String? prefixIcon,
    String? suffixIcon,
    String? focusColor,
    String? errorColor,
    double? verticalMargin,
    double? containerPadding,
    double? labelColumnWidth,
  }) {
    return QuestionStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      borderColor: borderColor ?? this.borderColor,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      borderWidth: borderWidth ?? this.borderWidth,
      widthMode: widthMode ?? this.widthMode,
      fixedWidth: fixedWidth ?? this.fixedWidth,
      labelPosition: labelPosition ?? this.labelPosition,
      labelFontSize: labelFontSize ?? this.labelFontSize,
      labelColor: labelColor ?? this.labelColor,
      labelFontWeight: labelFontWeight ?? this.labelFontWeight,
      helperFontSize: helperFontSize ?? this.helperFontSize,
      helperColor: helperColor ?? this.helperColor,
      helperFontWeight: helperFontWeight ?? this.helperFontWeight,
      inputFontSize: inputFontSize ?? this.inputFontSize,
      inputFontColor: inputFontColor ?? this.inputFontColor,
      inputFontWeight: inputFontWeight ?? this.inputFontWeight,
      inputStyle: inputStyle ?? this.inputStyle,
      height: height ?? this.height,
      prefixIcon: prefixIcon ?? this.prefixIcon,
      suffixIcon: suffixIcon ?? this.suffixIcon,
      focusColor: focusColor ?? this.focusColor,
      errorColor: errorColor ?? this.errorColor,
      verticalMargin: verticalMargin ?? this.verticalMargin,
      containerPadding: containerPadding ?? this.containerPadding,
      labelColumnWidth: labelColumnWidth ?? this.labelColumnWidth,
    );
  }
}

class SectionStyle {
  final String backgroundColor;
  final String borderColor;
  final double borderRadius;
  final double padding;
  final double margin;
  final double borderWidth;
  final double elevation;
  final bool showHeader;
  final String headerBackgroundColor;
  final String titleColor;
  final String descriptionColor;

  const SectionStyle({
    this.backgroundColor = '#FFFFFF',
    this.borderColor = '#E0E0E0',
    this.borderRadius = 4.0,
    this.padding = 16.0,
    this.margin = 8.0,
    this.borderWidth = 1.0,
    this.elevation = 0.0,
    this.showHeader = true,
    this.headerBackgroundColor = '#F5F5F5',
    this.titleColor = '#212121',
    this.descriptionColor = '#757575',
  });

  factory SectionStyle.fromJson(Map<String, dynamic> json) {
    return SectionStyle(
      backgroundColor: json['backgroundColor'] ?? '#FFFFFF',
      borderColor: json['borderColor'] ?? '#E0E0E0',
      borderRadius: (json['borderRadius'] ?? 4.0).toDouble(),
      padding: (json['padding'] ?? 16.0).toDouble(),
      margin: (json['margin'] ?? 8.0).toDouble(),
      borderWidth: (json['borderWidth'] ?? 1.0).toDouble(),
      elevation: (json['elevation'] ?? 0.0).toDouble(),
      showHeader: json['showHeader'] ?? true,
      headerBackgroundColor: json['headerBackgroundColor'] ?? '#F5F5F5',
      titleColor: json['titleColor'] ?? '#212121',
      descriptionColor: json['descriptionColor'] ?? '#757575',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'backgroundColor': backgroundColor,
      'borderColor': borderColor,
      'borderRadius': borderRadius,
      'padding': padding,
      'margin': margin,
      'borderWidth': borderWidth,
      'elevation': elevation,
      'showHeader': showHeader,
      'headerBackgroundColor': headerBackgroundColor,
      'titleColor': titleColor,
      'descriptionColor': descriptionColor,
    };
  }

  SectionStyle copyWith({
    String? backgroundColor,
    String? borderColor,
    double? borderRadius,
    double? padding,
    double? margin,
    double? borderWidth,
    double? elevation,
    bool? showHeader,
    String? headerBackgroundColor,
    String? titleColor,
    String? descriptionColor,
  }) {
    return SectionStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      borderWidth: borderWidth ?? this.borderWidth,
      elevation: elevation ?? this.elevation,
      showHeader: showHeader ?? this.showHeader,
      headerBackgroundColor:
          headerBackgroundColor ?? this.headerBackgroundColor,
      titleColor: titleColor ?? this.titleColor,
      descriptionColor: descriptionColor ?? this.descriptionColor,
    );
  }
}
