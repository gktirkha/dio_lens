import 'package:flutter/material.dart';

import '../../../../theme/dio_lens_theme.dart';

/// Section label in the request list, e.g. `JUST NOW`, `EARLIER`.
class RequestGroupHeader extends StatelessWidget {
  const RequestGroupHeader({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    return Padding(
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
    );
  }
}
