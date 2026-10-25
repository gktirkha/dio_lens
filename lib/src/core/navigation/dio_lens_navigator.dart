import 'package:flutter/material.dart';

import '../../theme/dio_lens_theme_scope.dart';

/// Pushes a Dio Lens page.
///
/// Pushed routes are built under the host's [Navigator], outside the
/// caller's [DioLensThemeScope], so the page gets its own scope sharing the
/// caller's theme mode controller: theme changes reach it live.
Future<T?> pushDioLensPage<T>(
  BuildContext context, {
  required WidgetBuilder builder,
}) {
  final controller = DioLensThemeScope.controllerOf(context);
  final mode = DioLensThemeScope.modeOf(context);
  return Navigator.of(context).push<T>(
    MaterialPageRoute(
      builder: (context) => DioLensThemeScope(
        controller: controller,
        mode: mode,
        child: Builder(builder: builder),
      ),
    ),
  );
}
