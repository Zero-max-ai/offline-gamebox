import 'package:flutter/material.dart';

final themeNotifier = ValueNotifier<ThemeMode>(ThemeMode.system);

void cycleTheme() {
  themeNotifier.value = themeNotifier.value == ThemeMode.light
      ? ThemeMode.dark
      : ThemeMode.light;
  // themeNotifier.value = switch (themeNotifier.value) {
  //   ThemeMode.system => ThemeMode.light,
  //   ThemeMode.light => ThemeMode.dark,
  //   ThemeMode.dark => ThemeMode.system,
  // };
}
