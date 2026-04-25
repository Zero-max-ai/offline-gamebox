import 'package:flutter/material.dart';
import 'package:offline_gamebox/theme/app_theme.dart';
import 'package:offline_gamebox/theme/theme_notifier.dart';
import 'theme/theme_toggle.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, mode, __) {
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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My App'),
        actions: const [ThemeToggleButton(), SizedBox(width: 8)],
      ),
    );
  }
}
