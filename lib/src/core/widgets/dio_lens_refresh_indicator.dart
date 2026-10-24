import 'package:flutter/material.dart';

import '../../theme/dio_lens_theme.dart';

/// Pull-to-refresh styled with the Dio Lens theme.
///
/// The [child] scroll view needs [AlwaysScrollableScrollPhysics] so short or
/// empty content can still be pulled.
class DioLensRefreshIndicator extends StatelessWidget {
  const DioLensRefreshIndicator({
    super.key,
    required this.onRefresh,
    required this.child,
  });

  /// The spinner stays visible until this completes.
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
