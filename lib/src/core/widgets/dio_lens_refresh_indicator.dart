import 'package:flutter/material.dart';

import '../../theme/dio_lens_theme.dart';

/// Pull-to-refresh styled for Dio Lens.
class DioLensRefreshIndicator extends StatelessWidget {
  /// Creates a refresh indicator around [child].
  const DioLensRefreshIndicator({
    super.key,
    required this.onRefresh,
    required this.child,
  });

  /// Called on pull; the indicator spins until it completes.
  final RefreshCallback onRefresh;

  /// The scrollable content.
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
