import 'package:flutter/material.dart';

class DioLensThemeModeController extends ValueNotifier<ThemeMode> {
  DioLensThemeModeController([super.value = ThemeMode.dark]);

  static ThemeMode next(ThemeMode mode) => switch (mode) {
    ThemeMode.light => ThemeMode.dark,
    ThemeMode.dark => ThemeMode.system,
    ThemeMode.system => ThemeMode.light,
  };

  void cycle() => value = next(value);
}
