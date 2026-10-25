import 'package:flutter/material.dart';

import 'dio_lens_theme_mode_controller.dart';
import 'theme_data/dio_lens_dark_theme.dart';
import 'theme_data/dio_lens_light_theme.dart';

class DioLensThemeScope extends StatelessWidget {
  const DioLensThemeScope({
    super.key,
    this.controller,
    this.mode = ThemeMode.dark,
    required this.child,
  });

  final DioLensThemeModeController? controller;

  final ThemeMode mode;

  final Widget child;

  static final ThemeData _dark = dioLensDarkTheme.toFlutterTheme();
  static final ThemeData _light = dioLensLightTheme.toFlutterTheme();

  static DioLensThemeModeController? controllerOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_ModeScope>()?.controller;

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
