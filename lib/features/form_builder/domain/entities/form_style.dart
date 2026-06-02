class QuestionStyle {
  final double labelFontSize;
  final String labelColor;
  final double helperFontSize;
  final String helperColor;
  final double borderRadius;
  final String backgroundColor;
  final String borderColor;
  final double borderWidth;
  final int columnSpan;
  final String labelPosition; // top, left, floating, hidden
  final String widthMode; // auto, fixed
  final String fixedWidth; // small, medium, large
  final String inputStyle; // outlined, filled, glass, minimalist, boxed, rounded, underlined
  
  // Typography - Input
  final double inputFontSize;
  final String inputFontColor;
  
  // Typography - Weights
  final String labelFontWeight;
  final String helperFontWeight;
  final String inputFontWeight;
  
  // State Colors
  final String focusColor;
  final String errorColor;
  final String hoverColor;

  // Icons
  final String? prefixIcon;
  final String? suffixIcon;

  // Spacing
  final double verticalMargin;
  final double labelSpacing;
  final double fieldSpacing;
  final double sectionSpacing;
  
  // Borders
  final String focusedBorderColor;
  final double focusedBorderWidth;
  final String errorBorderColor;
  final double errorBorderWidth;
  
  // Shadows
  final String shadowColor;
  final double shadowOpacity;
  final double shadowBlur;
  final double shadowSpread;
  
  // Animations
  final bool enableAnimations;
  final int animationDuration;
  
  // Responsive
  final String responsiveBreakpoint;
  final bool enableResponsive;

  // New Layout Props
  final double? labelColumnWidth;
  final String? containerAlignment; // left, center, right
  final double? containerPadding;
  final double? height;

  const QuestionStyle({
    this.labelFontSize = 16.0,
    this.labelColor = '#1E293B',
    this.helperFontSize = 13.0,
    this.helperColor = '#64748B',
    this.borderRadius = 8.0,
    this.backgroundColor = '#FFFFFF',
    this.borderColor = '#E2E8F0',
    this.borderWidth = 1.0,
    this.columnSpan = 1,
    this.labelPosition = 'top',
    this.widthMode = 'auto',
    this.fixedWidth = 'medium',
    this.inputStyle = 'outlined',
    
    // Typography - Input
    this.inputFontSize = 14.0,
    this.inputFontColor = '#0F172A',
    
    // Typography - Weights
    this.labelFontWeight = 'medium',
    this.helperFontWeight = 'normal',
    this.inputFontWeight = 'normal',
    
    // State Colors
    this.focusColor = '#3B82F6',
    this.errorColor = '#EF4444',
    this.hoverColor = '#F1F5F9',

    // Icons
    this.prefixIcon,
    this.suffixIcon,

    // Spacing
    this.verticalMargin = 16.0,
    this.labelSpacing = 4.0,
    this.fieldSpacing = 16.0,
    this.sectionSpacing = 24.0,
    
    // Borders
    this.focusedBorderColor = '#3B82F6',
    this.focusedBorderWidth = 2.0,
    this.errorBorderColor = '#EF4444',
    this.errorBorderWidth = 1.0,
    
    // Shadows
    this.shadowColor = '#000000',
    this.shadowOpacity = 0.1,
    this.shadowBlur = 4.0,
    this.shadowSpread = 0.0,
    
    // Animations
    this.enableAnimations = true,
    this.animationDuration = 200,
    
    // Responsive
    this.responsiveBreakpoint = 'md',
    this.enableResponsive = true,

    // New Layout Props
    this.labelColumnWidth,
    this.containerAlignment,
    this.containerPadding,
    this.height,
  });

  factory QuestionStyle.fromJson(Map<String, dynamic> json) {
    return QuestionStyle(
      labelFontSize: (json['labelFontSize'] as num?)?.toDouble() ?? 16.0,
      labelColor: json['labelColor'] as String? ?? '#1E293B',
      helperFontSize: (json['helperFontSize'] as num?)?.toDouble() ?? 13.0,
      helperColor: json['helperColor'] as String? ?? '#64748B',
      borderRadius: (json['borderRadius'] as num?)?.toDouble() ?? 8.0,
      backgroundColor: json['backgroundColor'] as String? ?? '#FFFFFF',
      borderColor: json['borderColor'] as String? ?? '#E2E8F0',
      borderWidth: (json['borderWidth'] as num?)?.toDouble() ?? 1.0,
      columnSpan: json['columnSpan'] as int? ?? 1,
      labelPosition: json['labelPosition'] as String? ?? 'top',
      widthMode: json['widthMode'] as String? ?? 'auto',
      fixedWidth: json['fixedWidth'] as String? ?? 'medium',
      inputStyle: json['inputStyle'] as String? ?? 'outlined',
      
      // Typography - Input
      inputFontSize: (json['inputFontSize'] as num?)?.toDouble() ?? 14.0,
      inputFontColor: json['inputFontColor'] as String? ?? '#0F172A',
      
      // Typography - Weights
      labelFontWeight: json['labelFontWeight'] as String? ?? 'medium',
      helperFontWeight: json['helperFontWeight'] as String? ?? 'normal',
      inputFontWeight: json['inputFontWeight'] as String? ?? 'normal',
      
      // State Colors
      focusColor: json['focusColor'] as String? ?? '#3B82F6',
      errorColor: json['errorColor'] as String? ?? '#EF4444',
      hoverColor: json['hoverColor'] as String? ?? '#F1F5F9',

      // Icons
      prefixIcon: json['prefixIcon'] as String?,
      suffixIcon: json['suffixIcon'] as String?,

      // Spacing
      verticalMargin: (json['verticalMargin'] as num?)?.toDouble() ?? 16.0,
      labelSpacing: (json['labelSpacing'] as num?)?.toDouble() ?? 4.0,
      fieldSpacing: (json['fieldSpacing'] as num?)?.toDouble() ?? 16.0,
      sectionSpacing: (json['sectionSpacing'] as num?)?.toDouble() ?? 24.0,
      
      // Borders
      focusedBorderColor: json['focusedBorderColor'] as String? ?? '#3B82F6',
      focusedBorderWidth: (json['focusedBorderWidth'] as num?)?.toDouble() ?? 2.0,
      errorBorderColor: json['errorBorderColor'] as String? ?? '#EF4444',
      errorBorderWidth: (json['errorBorderWidth'] as num?)?.toDouble() ?? 1.0,
      
      // Shadows
      shadowColor: json['shadowColor'] as String? ?? '#000000',
      shadowOpacity: (json['shadowOpacity'] as num?)?.toDouble() ?? 0.1,
      shadowBlur: (json['shadowBlur'] as num?)?.toDouble() ?? 4.0,
      shadowSpread: (json['shadowSpread'] as num?)?.toDouble() ?? 0.0,
      
      // Animations
      enableAnimations: json['enableAnimations'] as bool? ?? true,
      animationDuration: json['animationDuration'] as int? ?? 200,
      
      // Responsive
      responsiveBreakpoint: json['responsiveBreakpoint'] as String? ?? 'md',
      enableResponsive: json['enableResponsive'] as bool? ?? true,

      // New Layout Props
      labelColumnWidth: (json['labelColumnWidth'] as num?)?.toDouble(),
      containerAlignment: json['containerAlignment'] as String?,
      containerPadding: (json['containerPadding'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'labelFontSize': labelFontSize,
      'labelColor': labelColor,
      'helperFontSize': helperFontSize,
      'helperColor': helperColor,
      'borderRadius': borderRadius,
      'backgroundColor': backgroundColor,
      'borderColor': borderColor,
      'borderWidth': borderWidth,
      'columnSpan': columnSpan,
      'labelPosition': labelPosition,
      'widthMode': widthMode,
      'fixedWidth': fixedWidth,
      'inputStyle': inputStyle,
      
      // Typography - Input
      'inputFontSize': inputFontSize,
      'inputFontColor': inputFontColor,
      
      // Typography - Weights
      'labelFontWeight': labelFontWeight,
      'helperFontWeight': helperFontWeight,
      'inputFontWeight': inputFontWeight,
      
      // State Colors
      'focusColor': focusColor,
      'errorColor': errorColor,
      'hoverColor': hoverColor,

      // Icons
      if (prefixIcon != null) 'prefixIcon': prefixIcon,
      if (suffixIcon != null) 'suffixIcon': suffixIcon,

      // Spacing
      'verticalMargin': verticalMargin,
      'labelSpacing': labelSpacing,
      'fieldSpacing': fieldSpacing,
      'sectionSpacing': sectionSpacing,
      
      // Borders
      'focusedBorderColor': focusedBorderColor,
      'focusedBorderWidth': focusedBorderWidth,
      'errorBorderColor': errorBorderColor,
      'errorBorderWidth': errorBorderWidth,
      
      // Shadows
      'shadowColor': shadowColor,
      'shadowOpacity': shadowOpacity,
      'shadowBlur': shadowBlur,
      'shadowSpread': shadowSpread,
      
      // Animations
      'enableAnimations': enableAnimations,
      'animationDuration': animationDuration,
      
      // Responsive
      'responsiveBreakpoint': responsiveBreakpoint,
      'enableResponsive': enableResponsive,

      // New Layout Props
      if (labelColumnWidth != null) 'labelColumnWidth': labelColumnWidth,
      if (containerAlignment != null) 'containerAlignment': containerAlignment,
      if (containerPadding != null) 'containerPadding': containerPadding,
      if (height != null) 'height': height,
    };
  }

  QuestionStyle copyWith({
    double? labelFontSize,
    String? labelColor,
    double? helperFontSize,
    String? helperColor,
    double? borderRadius,
    String? backgroundColor,
    String? borderColor,
    double? borderWidth,
    int? columnSpan,
    String? labelPosition,
    String? widthMode,
    String? fixedWidth,
    String? inputStyle,
    
    // Typography - Input
    double? inputFontSize,
    String? inputFontColor,
    
    // Typography - Weights
    String? labelFontWeight,
    String? helperFontWeight,
    String? inputFontWeight,
    
    // State Colors
    String? focusColor,
    String? errorColor,
    String? hoverColor,

    // Icons
    String? prefixIcon,
    String? suffixIcon,

    // Spacing
    double? verticalMargin,
    double? labelSpacing,
    double? fieldSpacing,
    double? sectionSpacing,
    
    // Borders
    String? focusedBorderColor,
    double? focusedBorderWidth,
    String? errorBorderColor,
    double? errorBorderWidth,
    
    // Shadows
    String? shadowColor,
    double? shadowOpacity,
    double? shadowBlur,
    double? shadowSpread,
    
    // Animations
    bool? enableAnimations,
    int? animationDuration,
    
    // Responsive
    String? responsiveBreakpoint,
    bool? enableResponsive,

    // New Layout Props
    double? labelColumnWidth,
    String? containerAlignment,
    double? containerPadding,
    double? height,
  }) {
    return QuestionStyle(
      labelFontSize: labelFontSize ?? this.labelFontSize,
      labelColor: labelColor ?? this.labelColor,
      helperFontSize: helperFontSize ?? this.helperFontSize,
      helperColor: helperColor ?? this.helperColor,
      borderRadius: borderRadius ?? this.borderRadius,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      columnSpan: columnSpan ?? this.columnSpan,
      labelPosition: labelPosition ?? this.labelPosition,
      widthMode: widthMode ?? this.widthMode,
      fixedWidth: fixedWidth ?? this.fixedWidth,
      inputStyle: inputStyle ?? this.inputStyle,
      
      // Typography - Input
      inputFontSize: inputFontSize ?? this.inputFontSize,
      inputFontColor: inputFontColor ?? this.inputFontColor,
      
      // Typography - Weights
      labelFontWeight: labelFontWeight ?? this.labelFontWeight,
      helperFontWeight: helperFontWeight ?? this.helperFontWeight,
      inputFontWeight: inputFontWeight ?? this.inputFontWeight,
      
      // State Colors
      focusColor: focusColor ?? this.focusColor,
      errorColor: errorColor ?? this.errorColor,
      hoverColor: hoverColor ?? this.hoverColor,

      // Icons
      prefixIcon: prefixIcon ?? this.prefixIcon,
      suffixIcon: suffixIcon ?? this.suffixIcon,

      // Spacing
      verticalMargin: verticalMargin ?? this.verticalMargin,
      labelSpacing: labelSpacing ?? this.labelSpacing,
      fieldSpacing: fieldSpacing ?? this.fieldSpacing,
      sectionSpacing: sectionSpacing ?? this.sectionSpacing,
      
      // Borders
      focusedBorderColor: focusedBorderColor ?? this.focusedBorderColor,
      focusedBorderWidth: focusedBorderWidth ?? this.focusedBorderWidth,
      errorBorderColor: errorBorderColor ?? this.errorBorderColor,
      errorBorderWidth: errorBorderWidth ?? this.errorBorderWidth,
      
      // Shadows
      shadowColor: shadowColor ?? this.shadowColor,
      shadowOpacity: shadowOpacity ?? this.shadowOpacity,
      shadowBlur: shadowBlur ?? this.shadowBlur,
      shadowSpread: shadowSpread ?? this.shadowSpread,
      
      // Animations
      enableAnimations: enableAnimations ?? this.enableAnimations,
      animationDuration: animationDuration ?? this.animationDuration,
      
      // Responsive
      responsiveBreakpoint: responsiveBreakpoint ?? this.responsiveBreakpoint,
      enableResponsive: enableResponsive ?? this.enableResponsive,

      // New Layout Props
      labelColumnWidth: labelColumnWidth ?? this.labelColumnWidth,
      containerAlignment: containerAlignment ?? this.containerAlignment,
      containerPadding: containerPadding ?? this.containerPadding,
      height: height ?? this.height,
    );
  }
}

class SectionStyle {
  final String backgroundColor;
  final double borderRadius;
  final double elevation;
  final double padding;
  final bool showHeader;
  final String headerBackgroundColor;
  final String titleColor;
  final String descriptionColor;
  final String borderColor;
  final double borderWidth;

  const SectionStyle({
    this.backgroundColor = '#FFFFFF',
    this.borderRadius = 12.0,
    this.elevation = 2.0,
    this.padding = 16.0,
    this.showHeader = true,
    this.headerBackgroundColor = '#F8FAFC',
    this.titleColor = '#1E293B',
    this.descriptionColor = '#64748B',
    this.borderColor = '#E2E8F0',
    this.borderWidth = 1.0,
  });

  factory SectionStyle.fromJson(Map<String, dynamic> json) {
    return SectionStyle(
      backgroundColor: json['backgroundColor'] as String? ?? '#FFFFFF',
      borderRadius: (json['borderRadius'] as num?)?.toDouble() ?? 12.0,
      elevation: (json['elevation'] as num?)?.toDouble() ?? 2.0,
      padding: (json['padding'] as num?)?.toDouble() ?? 16.0,
      showHeader: json['showHeader'] as bool? ?? true,
      headerBackgroundColor: json['headerBackgroundColor'] as String? ?? '#F8FAFC',
      titleColor: json['titleColor'] as String? ?? '#1E293B',
      descriptionColor: json['descriptionColor'] as String? ?? '#64748B',
      borderColor: json['borderColor'] as String? ?? '#E2E8F0',
      borderWidth: (json['borderWidth'] as num?)?.toDouble() ?? 1.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'backgroundColor': backgroundColor,
      'borderRadius': borderRadius,
      'elevation': elevation,
      'padding': padding,
      'showHeader': showHeader,
      'headerBackgroundColor': headerBackgroundColor,
      'titleColor': titleColor,
      'descriptionColor': descriptionColor,
      'borderColor': borderColor,
      'borderWidth': borderWidth,
    };
  }

  SectionStyle copyWith({
    String? backgroundColor,
    double? borderRadius,
    double? elevation,
    double? padding,
    bool? showHeader,
    String? headerBackgroundColor,
    String? titleColor,
    String? descriptionColor,
    String? borderColor,
    double? borderWidth,
  }) {
    return SectionStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      elevation: elevation ?? this.elevation,
      padding: padding ?? this.padding,
      showHeader: showHeader ?? this.showHeader,
      headerBackgroundColor: headerBackgroundColor ?? this.headerBackgroundColor,
      titleColor: titleColor ?? this.titleColor,
      descriptionColor: descriptionColor ?? this.descriptionColor,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
    );
  }
}

class FormStyle {
  final String backgroundColor;
  final String fontFamily;
  final String primaryColor;
  final double globalBorderRadius;
  final double sectionSpacing;
  final double questionSpacing;
  final double maxWidth;
  final String layoutType; // standard, card, step

  const FormStyle({
    this.backgroundColor = '#F1F5F9',
    this.fontFamily = 'Inter',
    this.primaryColor = '#3B82F6',
    this.globalBorderRadius = 8.0,
    this.sectionSpacing = 24.0,
    this.questionSpacing = 16.0,
    this.maxWidth = 800.0,
    this.layoutType = 'standard',
  });

  factory FormStyle.fromJson(Map<String, dynamic> json) {
    return FormStyle(
      backgroundColor: json['backgroundColor'] as String? ?? '#F1F5F9',
      fontFamily: json['fontFamily'] as String? ?? 'Inter',
      primaryColor: json['primaryColor'] as String? ?? '#3B82F6',
      globalBorderRadius: (json['globalBorderRadius'] as num?)?.toDouble() ?? 8.0,
      sectionSpacing: (json['sectionSpacing'] as num?)?.toDouble() ?? 24.0,
      questionSpacing: (json['questionSpacing'] as num?)?.toDouble() ?? 16.0,
      maxWidth: (json['maxWidth'] as num?)?.toDouble() ?? 800.0,
      layoutType: json['layoutType'] as String? ?? 'standard',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'backgroundColor': backgroundColor,
      'fontFamily': fontFamily,
      'primaryColor': primaryColor,
      'globalBorderRadius': globalBorderRadius,
      'sectionSpacing': sectionSpacing,
      'questionSpacing': questionSpacing,
      'maxWidth': maxWidth,
      'layoutType': layoutType,
    };
  }

  FormStyle copyWith({
    String? backgroundColor,
    String? fontFamily,
    String? primaryColor,
    double? globalBorderRadius,
    double? sectionSpacing,
    double? questionSpacing,
    double? maxWidth,
    String? layoutType,
  }) {
    return FormStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      fontFamily: fontFamily ?? this.fontFamily,
      primaryColor: primaryColor ?? this.primaryColor,
      globalBorderRadius: globalBorderRadius ?? this.globalBorderRadius,
      sectionSpacing: sectionSpacing ?? this.sectionSpacing,
      questionSpacing: questionSpacing ?? this.questionSpacing,
      maxWidth: maxWidth ?? this.maxWidth,
      layoutType: layoutType ?? this.layoutType,
    );
  }
}