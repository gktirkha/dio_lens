import 'package:flutter/material.dart';

/// The inspector's appearance setting (light / dark / system), shared by
/// every Dio Lens page through `DioLensThemeScope`.
///
/// Pages pushed on top (detail screens) read the same controller, so a
/// change made anywhere re-themes every open Dio Lens page at once.
class DioLensThemeModeController extends ValueNotifier<ThemeMode> {
  DioLensThemeModeController([super.value = ThemeMode.dark]);

  /// Mode that follows [mode] in the toggle cycle light → dark → system.
  static ThemeMode next(ThemeMode mode) => switch (mode) {
    ThemeMode.light => ThemeMode.dark,
    ThemeMode.dark => ThemeMode.system,
    ThemeMode.system => ThemeMode.light,
  };

  /// Moves to the next mode in the cycle.
  void cycle() => value = next(value);
}
