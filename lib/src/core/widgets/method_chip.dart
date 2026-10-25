import 'package:flutter/material.dart';

import '../../theme/dio_lens_theme.dart';
import 'dio_lens_tag.dart';

class MethodChip extends StatelessWidget {
  const MethodChip({super.key, required this.method});

  final String method;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    final label = method.toUpperCase();
    final (fg, bg) = switch (label) {
      'GET' => (theme.methodGet, theme.methodGetBackground),
      'POST' => (theme.methodPost, theme.methodPostBackground),
      'PUT' => (theme.methodPut, theme.methodPutBackground),
      'PATCH' => (theme.methodPatch, theme.methodPatchBackground),
      'DELETE' => (theme.methodDelete, theme.methodDeleteBackground),
      'QUERY' => (theme.methodQuery, theme.methodQueryBackground),
      _ => (theme.pending, theme.pendingBackground),
    };

    return DioLensTag(
      label: label,
      foreground: fg,
      background: bg,
      fontSize: 11,
      fontWeight: FontWeight.w800,
      letterSpacing: 0.22,
    );
  }
}
