import 'package:flutter/material.dart';
import 'package:offline_gamebox/theme/app_theme.dart';
import 'package:offline_gamebox/theme/theme_notifier.dart';
import 'package:offline_gamebox/pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, mode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: HomePage(),
          themeMode: mode,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
        );
      },
    );
  }
}
