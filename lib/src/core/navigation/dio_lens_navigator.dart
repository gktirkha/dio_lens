import 'package:flutter/material.dart';

import '../../theme/dio_lens_theme_scope.dart';

/// Pushes a Dio Lens page built by [builder]. The page gets its own theme scope
/// sharing the caller's theme mode controller, so theme changes reach it live.
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
        page: true,
        child: Builder(builder: builder),
      ),
    ),
  );
}
