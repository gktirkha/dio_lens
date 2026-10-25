import 'package:flutter/material.dart';

import '../../theme/dio_lens_theme.dart';
import '../../theme/dio_lens_theme_mode_controller.dart';
import '../../theme/dio_lens_theme_scope.dart';

/// Round icon button used in Dio Lens headers.
class DioLensIconButton extends StatelessWidget {
  /// Creates an icon button.
  const DioLensIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.active = false,
    this.showDot = false,
  });

  /// The icon shown.
  final IconData icon;

  /// Tooltip and screen reader label.
  final String tooltip;

  /// Called on tap; null disables the button.
  final VoidCallback? onPressed;

  /// Highlights the button, e.g. while a filter is active.
  final bool active;

  /// Shows a small dot, e.g. when filters are applied.
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

/// Button cycling the Dio Lens theme mode (light, dark, system). Hidden when
/// the surrounding theme scope has no controller.
class DioLensThemeToggleButton extends StatelessWidget {
  /// Creates the theme toggle.
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
