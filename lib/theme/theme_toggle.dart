import 'package:flutter/material.dart';
import 'theme_notifier.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, mode, _) {
        return IconButton(
          tooltip: _label(mode),
          icon: Icon(_icon(mode)),
          onPressed: cycleTheme,
        );
      },
    );
  }
}

IconData _icon(ThemeMode mode) => switch (mode) {
  ThemeMode.light => Icons.light_mode_rounded,
  ThemeMode.dark => Icons.dark_mode_rounded,
  _ => Icons.brightness_auto_rounded,
};

String _label(ThemeMode mode) => switch (mode) {
  ThemeMode.light => 'Light mode',
  ThemeMode.dark => 'Dark mode',
  _ => 'System default',
};
