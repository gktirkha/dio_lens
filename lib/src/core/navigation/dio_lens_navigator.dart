import 'package:flutter/material.dart';

import '../../theme/dio_lens_theme_scope.dart';

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
