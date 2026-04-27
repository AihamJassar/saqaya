import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

class ThemeModeButton extends StatelessWidget {
  const ThemeModeButton({super.key});

  IconData _iconForMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.brightness_auto;
    }
  }

  String _labelForMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'الوضع الفاتح';
      case ThemeMode.dark:
        return 'الوضع الداكن';
      case ThemeMode.system:
        return 'وضع النظام';
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final selectedMode = themeProvider.themeMode;

    return PopupMenuButton<ThemeMode>(
      tooltip: 'تغيير المظهر',
      icon: Icon(_iconForMode(selectedMode)),
      onSelected: themeProvider.setThemeMode,
      itemBuilder: (context) => ThemeMode.values.map((mode) {
        final isSelected = mode == selectedMode;
        return PopupMenuItem<ThemeMode>(
          value: mode,
          child: Row(
            children: [
              Icon(_iconForMode(mode)),
              const SizedBox(width: 12),
              Expanded(child: Text(_labelForMode(mode))),
              if (isSelected) ...[
                const SizedBox(width: 12),
                Icon(
                  Icons.check,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }
}
