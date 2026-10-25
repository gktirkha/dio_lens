import 'package:flutter/material.dart';

import '../../../../theme/dio_lens_theme.dart';

/// Shown when the list is empty, either because nothing was captured yet or
/// because the active filters hide everything.
class RequestEmptyState extends StatelessWidget {
  const RequestEmptyState({super.key, required this.filtered});

  /// True when requests exist but the filters exclude all of them.
  final bool filtered;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    final (icon, title, message) = filtered
        ? (
            Icons.search_rounded,
            'No requests match this filter',
            'Try a different status, method, or search term.',
          )
        : (
            Icons.bolt_rounded,
            'No requests captured yet',
            'Dio Lens is listening. Traffic from your Dio client will '
                'appear here as it happens.',
          );

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(36, 70, 36, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        // Full width, so short messages center instead of hugging the start
        // edge inside the scroll view.
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(icon, size: 40, color: theme.textFaint),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: theme.text,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.5,
              height: 1.5,
              color: theme.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
