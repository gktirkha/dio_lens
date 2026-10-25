import 'package:flutter/material.dart';

/// The Dio Lens theme mode (light, dark or system), shared by every Dio Lens
/// page.
class DioLensThemeModeController extends ValueNotifier<ThemeMode> {
  /// Creates the controller, dark by default.
  DioLensThemeModeController([super.value = ThemeMode.dark]);

  /// The mode after [mode] in the toggle cycle light, dark, system.
  static ThemeMode next(ThemeMode mode) => switch (mode) {
    ThemeMode.light => ThemeMode.dark,
    ThemeMode.dark => ThemeMode.system,
    ThemeMode.system => ThemeMode.light,
  };

  /// Moves to the next mode in the cycle.
  void cycle() => value = next(value);
}
