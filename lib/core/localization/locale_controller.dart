import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'locale_controller.g.dart';

@riverpod
class LocaleController extends _$LocaleController {
  @override
  Locale build() {
    // Default to English
    return const Locale('en');
  }

  void setLocale(String languageCode) {
    state = Locale(languageCode);
  }

  String get languageCode => state.languageCode;
}

extension LocalizedMapX on Map<String, dynamic> {
  String getLocalized(String locale, {String fallback = 'en'}) {
    if (isEmpty) return '';
    if (containsKey(locale)) return this[locale].toString();
    if (containsKey(fallback)) return this[fallback].toString();
    return values.first.toString();
  }
}

extension LocalizedStringX on Object? {
  String translate(String locale) {
    if (this is String) return this as String;
    if (this is Map) {
      final map = this as Map;
      if (map.containsKey(locale)) return map[locale].toString();
      if (map.containsKey('en')) return map['en'].toString();
      if (map.isNotEmpty) return map.values.first.toString();
    }
    return '';
  }
}
