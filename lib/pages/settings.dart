import 'package:flutter/material.dart';
import 'package:offline_gamebox/theme/theme_notifier.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(),
            const SizedBox(height: 20),
            const _ThemeToggleTile(),
          ],
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 30, 10, 5),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text('Settings', style: Theme.of(context).textTheme.bodyLarge),
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeToggleTile extends StatelessWidget {
  const _ThemeToggleTile();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, mode, __) {
        final isDark =
            mode == ThemeMode.dark ||
            (mode == ThemeMode.system &&
                MediaQuery.platformBrightnessOf(context) == Brightness.dark);

        return SwitchListTile(
          title: const Text('Dark Mode'),
          subtitle: Text(
            mode == ThemeMode.dark ? 'On' : 'Off',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          secondary: Icon(
            mode == ThemeMode.dark
                ? Icons.dark_mode_rounded
                : Icons.light_mode_rounded,
          ),
          value: isDark,
          onChanged: (_) => cycleTheme(),
        );
      },
    );
  }
}
