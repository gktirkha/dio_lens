import 'package:flutter/material.dart';

import '../../theme/dio_lens_theme.dart';

/// Compact 36×36 icon button used in Dio Lens top bars.
class DioLensIconButton extends StatelessWidget {
  const DioLensIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.active = false,
    this.showDot = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  /// Highlighted, e.g. while its menu or panel is open.
  final bool active;

  /// Small accent dot, e.g. when a filter is applied.
  final bool showDot;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      visualDensity: VisualDensity.compact,
      constraints: const BoxConstraints.tightFor(width: 36, height: 36),
      padding: EdgeInsets.zero,
      style: IconButton.styleFrom(
        foregroundColor: active ? theme.accent : theme.textMuted,
        backgroundColor: active ? theme.surface3 : Colors.transparent,
      ),
      icon: Badge(
        isLabelVisible: showDot,
        smallSize: 7,
        backgroundColor: theme.accent,
        child: Icon(icon, size: 19),
      ),
    );
  }
}

/// Cycles the theme light → dark → system; the icon shows the current mode.
class DioLensThemeToggleButton extends StatelessWidget {
  const DioLensThemeToggleButton({
    super.key,
    required this.mode,
    required this.onChanged,
  });

  final ThemeMode mode;

  /// Called with the next mode in the cycle.
  final ValueChanged<ThemeMode> onChanged;

  /// Mode that follows [mode] when the button is pressed.
  static ThemeMode next(ThemeMode mode) => switch (mode) {
    ThemeMode.light => ThemeMode.dark,
    ThemeMode.dark => ThemeMode.system,
    ThemeMode.system => ThemeMode.light,
  };

  static String _label(ThemeMode mode) => switch (mode) {
    ThemeMode.light => 'Light',
    ThemeMode.dark => 'Dark',
    ThemeMode.system => 'System',
  };

  @override
  Widget build(BuildContext context) {
    final next = DioLensThemeToggleButton.next(mode);
    return DioLensIconButton(
      icon: switch (mode) {
        ThemeMode.light => Icons.light_mode_outlined,
        ThemeMode.dark => Icons.dark_mode_outlined,
        ThemeMode.system => Icons.brightness_auto_outlined,
      },
      tooltip: 'Theme: ${_label(mode)}. Switch to ${_label(next)}',
      onPressed: () => onChanged(next),
    );
  }
}
