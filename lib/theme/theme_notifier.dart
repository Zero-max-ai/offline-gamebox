import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _themeKey = 'theme_mode';

final themeNotifier = ValueNotifier<ThemeMode>(ThemeMode.system);

Future<void> loadTheme() async {
  final prefs = await SharedPreferences.getInstance();
  final saved = prefs.getString(_themeKey);
  themeNotifier.value = switch (saved) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };
}

Future<void> cycleTheme() async {
  themeNotifier.value = themeNotifier.value == ThemeMode.light
      ? ThemeMode.dark
      : ThemeMode.light;

  final prefs = await SharedPreferences.getInstance();
  final toSave = switch (themeNotifier.value) {
    ThemeMode.light => 'light',
    ThemeMode.dark => 'dark',
    _ => 'system',
  };
  await prefs.setString(_themeKey, toSave);
}
