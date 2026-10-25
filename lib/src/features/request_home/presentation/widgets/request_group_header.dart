import 'package:flutter/material.dart';

import '../../../../theme/dio_lens_theme.dart';

/// Sticky header of a group of requests, e.g. "Just now".
class RequestGroupHeader extends StatelessWidget {
  /// Creates the header.
  const RequestGroupHeader({super.key, required this.label});

  /// Group label.
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    return ColoredBox(
      color: theme.background,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 14, 16, 6),
        child: Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.46,
            color: theme.textFaint,
          ),
        ),
      ),
    );
  }
}
