import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

const _kHiveBox = 'app_prefs';
const _kThemeModeKey = 'theme_mode';

/// Persisted ThemeMode controller.
/// Usage: `ref.watch(themeControllerProvider)` → current [ThemeMode]
/// Toggle: `ref.read(themeControllerProvider.notifier).toggle()`
class ThemeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    // Start with system default; Hive will override on first load
    _restoreFromHive();
    return ThemeMode.light;
  }

  Future<void> _restoreFromHive() async {
    final box = await Hive.openBox(_kHiveBox);
    final stored = box.get(_kThemeModeKey, defaultValue: 'light') as String;
    final mode = stored == 'dark' ? ThemeMode.dark : ThemeMode.light;
    if (state != mode) state = mode;
  }

  /// Toggle between light and dark.
  Future<void> toggle() async {
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    state = next;
    final box = await Hive.openBox(_kHiveBox);
    await box.put(_kThemeModeKey, next == ThemeMode.dark ? 'dark' : 'light');
  }

  bool get isDark => state == ThemeMode.dark;
}

final themeControllerProvider =
    NotifierProvider<ThemeController, ThemeMode>(ThemeController.new);
