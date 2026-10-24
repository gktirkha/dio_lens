import 'package:flutter/material.dart';

import 'dio_lens_theme.dart';
import 'theme_data/dio_lens_dark_theme.dart';
import 'theme_data/dio_lens_light_theme.dart';

/// Applies the Dio Lens theme to [child] without touching the host app.
///
/// Every Dio Lens route (inspector, detail, settings sheet, bubble) wraps its
/// root in this widget. The [Theme] it installs fully replaces the host's
/// [ThemeData] for that subtree only, so the host's theme neither leaks into
/// the inspector nor gets changed by it.
class DioLensThemeScope extends StatelessWidget {
  const DioLensThemeScope({
    super.key,
    this.mode = ThemeMode.dark,
    required this.child,
  });

  /// The inspector's own appearance setting (Settings → Appearance).
  /// [ThemeMode.system] follows the device brightness, not the host theme.
  final ThemeMode mode;

  final Widget child;

  static final ThemeData _dark = dioLensDarkTheme.toFlutterTheme();
  static final ThemeData _light = dioLensLightTheme.toFlutterTheme();

  DioLensTheme _resolve(BuildContext context) {
    switch (mode) {
      case ThemeMode.dark:
        return dioLensDarkTheme;
      case ThemeMode.light:
        return dioLensLightTheme;
      case ThemeMode.system:
        return MediaQuery.platformBrightnessOf(context) == Brightness.dark
            ? dioLensDarkTheme
            : dioLensLightTheme;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = _resolve(context);
    return Theme(
      data: identical(theme, dioLensDarkTheme) ? _dark : _light,
      child: child,
    );
  }
}
