import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

const _kHiveBox = 'app_prefs';
const _kThemeModeKey = 'theme_mode';

/// Persisted ThemeMode controller.
/// Usage: `ref.watch(themeControllerProvider)` → current [ThemeMode]
/// Toggle: `ref.read(themeControllerProvider.notifier).toggle()`
class ThemeController extends Notifier<ThemeMode> {
  Future<void>? _restoreFuture;

  @override
  ThemeMode build() {
    // Hydrate once. If the box is already open, we can return immediately.
    if (Hive.isBoxOpen(_kHiveBox)) {
      final box = Hive.box(_kHiveBox);
      final stored = box.get(_kThemeModeKey, defaultValue: 'light') as String;
      return stored == 'dark' ? ThemeMode.dark : ThemeMode.light;
    }

    _restoreFuture ??= _restoreFromHive();
    return ThemeMode.light;
  }

  Future<void> _restoreFromHive() async {
    try {
      final box = Hive.isBoxOpen(_kHiveBox)
          ? Hive.box(_kHiveBox)
          : await Hive.openBox(_kHiveBox);
      final stored = box.get(_kThemeModeKey, defaultValue: 'light') as String;
      final mode = stored == 'dark' ? ThemeMode.dark : ThemeMode.light;
      if (ref.mounted && state != mode) state = mode;
    } catch (error, stackTrace) {
      debugPrint('Failed to restore theme mode: $error\n$stackTrace');
    }
  }

  /// Toggle between light and dark.
  Future<void> toggle() async {
    await (_restoreFuture ??= _restoreFromHive());

    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    try {
      final box = Hive.isBoxOpen(_kHiveBox)
          ? Hive.box(_kHiveBox)
          : await Hive.openBox(_kHiveBox);
      await box.put(_kThemeModeKey, next == ThemeMode.dark ? 'dark' : 'light');
      if (ref.mounted) state = next;
    } catch (error, stackTrace) {
      debugPrint('Failed to persist theme mode: $error\n$stackTrace');
    }
  }

  bool get isDark => state == ThemeMode.dark;
}

final themeControllerProvider =
    NotifierProvider<ThemeController, ThemeMode>(ThemeController.new);
