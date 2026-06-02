import 'package:flutter/material.dart';

class AppDesignSystem {
  static const Color primaryColor = Color(0xFF1976D2);
  static const Color secondaryColor = Color(0xFF2196F3);
  static const Color accentColor = Color(0xFF03A9F4);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color textColor = Color(0xFF212121);
  static const Color secondaryTextColor = Color(0xFF757575);
  static const Color dividerColor = Color(0xFFE0E0E0);

  static const TextStyle heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textColor,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textColor,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: textColor,
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: 16,
    color: textColor,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: secondaryTextColor,
  );

  static const EdgeInsets padding = EdgeInsets.all(16.0);
  static const EdgeInsets margin = EdgeInsets.all(8.0);
  static const BorderRadius borderRadius = BorderRadius.all(Radius.circular(8.0));
  static const double elevation = 2.0;

  static ThemeData get lightTheme => ThemeData(
    primarySwatch: Colors.blue,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    cardColor: surfaceColor,
    dividerColor: dividerColor,
    textTheme: const TextTheme(
      headlineLarge: heading1,
      headlineMedium: heading2,
      headlineSmall: heading3,
      bodyLarge: bodyText,
      bodyMedium: bodyText,
      bodySmall: caption,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: padding,
        shape: const RoundedRectangleBorder(
          borderRadius: borderRadius,
        ),
      ),
    ),
    cardTheme: CardThemeData(
      color: surfaceColor,
      elevation: elevation,
      shape: const RoundedRectangleBorder(
        borderRadius: borderRadius,
      ),
      margin: margin,
    ),
  );

  static ThemeData get enterpriseDarkTheme => ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: const Color(0xFF121212),
    cardColor: const Color(0xFF1E1E1E),
    dividerColor: const Color(0xFF424242),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
      headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
      headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 16, color: Colors.white),
      bodySmall: TextStyle(fontSize: 12, color: Colors.grey),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: padding,
        shape: const RoundedRectangleBorder(
          borderRadius: borderRadius,
        ),
      ),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF1E1E1E),
      elevation: elevation,
      shape: const RoundedRectangleBorder(
        borderRadius: borderRadius,
      ),
      margin: margin,
    ),
  );
}