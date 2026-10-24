import 'package:flutter/material.dart';

import '../../theme/dio_lens_theme.dart';
import '../enums/request_state.dart';
import '../enums/request_status_class.dart';
import 'dio_lens_tag.dart';

/// Status code badge colored by status class; shows a spinner while pending
/// and `ERR` when the request failed without a response.
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.statusClass, this.statusCode});

  /// Badge for a request in [state] with an optional HTTP [statusCode].
  StatusBadge.fromState({
    Key? key,
    required RequestState state,
    int? statusCode,
  }) : this(
         key: key,
         statusClass: RequestStatusClass.resolve(state, statusCode),
         statusCode: statusCode,
       );

  final RequestStatusClass statusClass;
  final int? statusCode;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    final (fg, bg) = switch (statusClass) {
      RequestStatusClass.success => (theme.success, theme.successBackground),
      RequestStatusClass.redirect => (theme.redirect, theme.redirectBackground),
      RequestStatusClass.clientError => (
        theme.warning,
        theme.warningBackground,
      ),
      RequestStatusClass.serverError ||
      RequestStatusClass.error => (theme.danger, theme.dangerBackground),
      RequestStatusClass.pending || RequestStatusClass.informational => (
        theme.pending,
        theme.pendingBackground,
      ),
    };

    final Widget? leading = switch (statusClass) {
      RequestStatusClass.pending => SizedBox.square(
        dimension: 10,
        child: CircularProgressIndicator(
          strokeWidth: 1.6,
          color: theme.accent,
          backgroundColor: theme.borderStrong,
        ),
      ),
      RequestStatusClass.error => Icon(
        Icons.error_outline_rounded,
        size: 12,
        color: fg,
      ),
      _ => null,
    };

    final label = switch (statusClass) {
      RequestStatusClass.pending => 'PENDING',
      RequestStatusClass.error => 'ERR',
      _ => statusCode?.toString() ?? 'ERR',
    };

    return DioLensTag(
      label: label,
      foreground: fg,
      background: bg,
      leading: leading,
    );
  }
}
