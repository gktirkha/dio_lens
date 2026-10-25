import 'package:flutter/material.dart';

import '../../../../core/enums/request_status_class.dart';
import '../../../../core/utils/ltr_content.dart';
import '../../../../core/widgets/method_chip.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../theme/dio_lens_theme.dart';
import '../../../request_detail/domain/entities/request_detail_entity.dart';

/// Card announcing that [request] finished: method, status, path and host,
/// with View and dismiss actions.
class RequestFinishedBanner extends StatelessWidget {
  const RequestFinishedBanner({
    super.key,
    required this.request,
    this.onView,
    this.onDismiss,
  });

  final RequestDetailEntity request;
  final VoidCallback? onView;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    final (fg, bg, icon) = switch (request.statusClass) {
      RequestStatusClass.clientError => (
        theme.warning,
        theme.warningBackground,
        Icons.warning_amber_rounded,
      ),
      RequestStatusClass.serverError || RequestStatusClass.error => (
        theme.danger,
        theme.dangerBackground,
        Icons.warning_amber_rounded,
      ),
      _ => (theme.success, theme.successBackground, Icons.check_rounded),
    };

    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(14, 12, 12, 12),
      decoration: BoxDecoration(
        color: theme.surface2,
        border: Border.all(color: theme.borderStrong),
        borderRadius: BorderRadius.circular(theme.radiusLarge),
        boxShadow: [theme.shadow],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            margin: const EdgeInsets.only(top: 1),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, size: 16, color: fg),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    MethodChip(method: request.method),
                    const SizedBox(width: 6),
                    StatusBadge(
                      statusClass: request.statusClass,
                      statusCode: request.statusCode,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'REQUEST FINISHED',
                        textAlign: TextAlign.end,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.33,
                          color: theme.textFaint,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  request.path,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textDirection: LtrContent.direction,
                  textAlign: LtrContent.align(context),
                  style: theme.monoTextStyle.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: theme.text,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  request.host,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textDirection: LtrContent.direction,
                  textAlign: LtrContent.align(context),
                  style: theme.monoTextStyle.copyWith(
                    fontSize: 11,
                    color: theme.textFaint,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FilledButton(
                  onPressed: onView,
                  style: FilledButton.styleFrom(
                    backgroundColor: theme.accent,
                    foregroundColor: theme.onAccent,
                    minimumSize: const Size(0, 28),
                    padding: const EdgeInsets.symmetric(horizontal: 11),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    textStyle: Theme.of(context).textTheme.labelMedium
                        ?.copyWith(fontSize: 11.5, fontWeight: FontWeight.w700),
                  ),
                  child: const Text('View'),
                ),
                const SizedBox(width: 4),
                IconButton(
                  onPressed: onDismiss,
                  tooltip: 'Dismiss notification',
                  icon: const Icon(Icons.close_rounded, size: 14),
                  color: theme.textFaint,
                  constraints: const BoxConstraints.tightFor(
                    width: 28,
                    height: 28,
                  ),
                  padding: EdgeInsets.zero,
                  style: IconButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
