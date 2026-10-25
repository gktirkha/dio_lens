import 'package:flutter/material.dart';

import '../../theme/dio_lens_theme.dart';

class DioLensRefreshIndicator extends StatelessWidget {
  const DioLensRefreshIndicator({
    super.key,
    required this.onRefresh,
    required this.child,
  });

  final RefreshCallback onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: theme.accent,
      backgroundColor: theme.surface2,
      child: child,
    );
  }
}
