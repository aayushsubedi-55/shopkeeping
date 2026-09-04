import 'package:flutter/material.dart';
import 'package:shopnepal/common/theme/app_spacing.dart';
import 'package:shopnepal/common/theme/theme_manager.dart';

/// Simple theme switcher icon button
class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(ThemeManager().isDark ? Icons.light_mode : Icons.dark_mode),
      onPressed: () {
        ThemeManager().toggleTheme();
      },
      tooltip: 'Toggle theme',
    );
  }
}

/// Theme switcher with text (for settings page)
class ThemeSwitcherWithText extends StatelessWidget {
  const ThemeSwitcherWithText({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(ThemeManager().isDark ? Icons.dark_mode : Icons.light_mode),
      title: const Text('Dark Mode'),
      trailing: Switch(
        value: ThemeManager().isDark,
        onChanged: (value) {
          ThemeManager().toggleTheme();
        },
      ),
      onTap: () {
        ThemeManager().toggleTheme();
      },
    );
  }
}

/// Theme mode selector (Light/Dark/System)
class ThemeModeSelector extends StatelessWidget {
  const ThemeModeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: AppInsets.all16,
          child: Text(
            'Theme Mode',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        RadioListTile<ThemeMode>(
          title: const Text('Light'),
          value: ThemeMode.light,
          groupValue: ThemeManager().themeMode,
          onChanged: (value) {
            if (value != null) {
              ThemeManager().setThemeMode(value);
            }
          },
        ),
        RadioListTile<ThemeMode>(
          title: const Text('Dark'),
          value: ThemeMode.dark,
          groupValue: ThemeManager().themeMode,
          onChanged: (value) {
            if (value != null) {
              ThemeManager().setThemeMode(value);
            }
          },
        ),
        RadioListTile<ThemeMode>(
          title: const Text('System'),
          value: ThemeMode.system,
          groupValue: ThemeManager().themeMode,
          onChanged: (value) {
            if (value != null) {
              ThemeManager().setThemeMode(value);
            }
          },
        ),
      ],
    );
  }
}
