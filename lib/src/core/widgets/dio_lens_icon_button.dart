import 'package:flutter/material.dart';

import '../../theme/dio_lens_theme.dart';
import '../../theme/dio_lens_theme_mode_controller.dart';
import '../../theme/dio_lens_theme_scope.dart';

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

  final bool active;

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

class DioLensThemeToggleButton extends StatelessWidget {
  const DioLensThemeToggleButton({super.key});

  static String _label(ThemeMode mode) => switch (mode) {
    ThemeMode.light => 'Light',
    ThemeMode.dark => 'Dark',
    ThemeMode.system => 'System',
  };

  @override
  Widget build(BuildContext context) {
    final controller = DioLensThemeScope.controllerOf(context);
    if (controller == null) return const SizedBox.shrink();
    final mode = DioLensThemeScope.modeOf(context);
    final next = DioLensThemeModeController.next(mode);
    return DioLensIconButton(
      icon: switch (mode) {
        ThemeMode.light => Icons.light_mode_outlined,
        ThemeMode.dark => Icons.dark_mode_outlined,
        ThemeMode.system => Icons.brightness_auto_outlined,
      },
      tooltip: 'Theme: ${_label(mode)}. Switch to ${_label(next)}',
      onPressed: controller.cycle,
    );
  }
}
