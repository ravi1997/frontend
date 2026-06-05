import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localeControllerProvider = NotifierProvider<LocaleController, Locale>(
  LocaleController.new,
);

class LocaleController extends Notifier<Locale> {
  @override
  Locale build() => const Locale('en');

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
