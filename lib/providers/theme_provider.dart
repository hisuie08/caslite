import 'package:caslite/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class AppTheme {
  final int themeValue;
  final ThemeMode themeMode;
  final String label;
  const AppTheme(
      {required this.themeValue, required this.themeMode, required this.label});
}

final casliteThemeProvider = StateNotifierProvider<AppThemeNotifier, AppTheme>(
    (ref) => AppThemeNotifier());

class AppThemeNotifier extends StateNotifier<AppTheme> {
  static const key = "theme";
  static const AppTheme system =
      AppTheme(themeValue: 0, themeMode: ThemeMode.system, label: "システム");
  static const AppTheme light =
      AppTheme(themeValue: 1, themeMode: ThemeMode.light, label: "ライト");
  static const AppTheme dark =
      AppTheme(themeValue: 2, themeMode: ThemeMode.dark, label: "ダーク");
  static const _themes = [system, light, dark];
  final pref = SharedPreferencesInstance().pref;

  AppThemeNotifier() : super(system) {
    state = _loadTheme() ?? system;
  }

  Future<void> setTheme(int value) async {
    print("changed");
    await pref.setInt(key, value).then((v) {
      if (v) {
        state = _themes[value];
      }
    });
  }

  AppTheme? _loadTheme() {
    final loaded = pref.getInt(key);
    if (loaded != null) {
      return _themes[loaded];
    } else {
      return null;
    }
  }
}
