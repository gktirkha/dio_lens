import 'package:flutter/material.dart';

import 'dio_lens_theme_mode_controller.dart';
import 'theme_data/dio_lens_dark_theme.dart';
import 'theme_data/dio_lens_light_theme.dart';

/// Applies the Dio Lens theme to [child] without touching the host app.
///
/// Every Dio Lens route (inspector, detail, settings sheet, bubble) wraps its
/// root in this widget. The [Theme] it installs fully replaces the host's
/// [ThemeData] for that subtree only, so the host's theme neither leaks into
/// the inspector nor gets changed by it.
///
/// With a [controller], the scope follows its mode live and exposes it to
/// descendants (see [controllerOf]); the theme toggle only shows then.
class DioLensThemeScope extends StatelessWidget {
  const DioLensThemeScope({
    super.key,
    this.controller,
    this.mode = ThemeMode.dark,
    required this.child,
  });

  /// Shared appearance setting; takes precedence over [mode].
  final DioLensThemeModeController? controller;

  /// Fixed mode used when there is no [controller].
  /// [ThemeMode.system] follows the device brightness, not the host theme.
  final ThemeMode mode;

  final Widget child;

  static final ThemeData _dark = dioLensDarkTheme.toFlutterTheme();
  static final ThemeData _light = dioLensLightTheme.toFlutterTheme();

  /// The controller of the nearest scope, if it has one.
  static DioLensThemeModeController? controllerOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_ModeScope>()?.controller;

  /// The mode of the nearest scope.
  static ThemeMode modeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_ModeScope>()?.mode ??
      ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    final controller = this.controller;
    if (controller == null) return _build(context, mode);
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: controller,
      builder: (context, mode, _) => _build(context, mode),
    );
  }

  Widget _build(BuildContext context, ThemeMode mode) {
    final dark = switch (mode) {
      ThemeMode.dark => true,
      ThemeMode.light => false,
      ThemeMode.system =>
        MediaQuery.platformBrightnessOf(context) == Brightness.dark,
    };
    return _ModeScope(
      controller: controller,
      mode: mode,
      child: Theme(data: dark ? _dark : _light, child: child),
    );
  }
}

class _ModeScope extends InheritedWidget {
  const _ModeScope({
    required this.controller,
    required this.mode,
    required super.child,
  });

  final DioLensThemeModeController? controller;
  final ThemeMode mode;

  @override
  bool updateShouldNotify(_ModeScope old) =>
      old.controller != controller || old.mode != mode;
}
