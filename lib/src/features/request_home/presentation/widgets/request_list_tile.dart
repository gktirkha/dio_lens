import 'package:flutter/material.dart';

import '../../../../core/enums/request_state.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../core/utils/ltr_content.dart';
import '../../../../core/widgets/method_chip.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../theme/dio_lens_theme.dart';
import '../../../settings/domain/entities/dio_lens_settings.dart';
import '../../../settings/domain/utils/request_redactor.dart';
import '../../domain/entities/request_list_item_entity.dart';

/// One row of the request list: method, status, path, host and timing, with
/// Share, cURL and Replay buttons (hidden without a callback). Swipe to
/// delete.
class RequestListTile extends StatelessWidget {
  /// Creates the row.
  const RequestListTile({
    super.key,
    required this.item,
    this.settings = const DioLensSettings(),
    this.onTap,
    this.onShare,
    this.onCopyCurl,
    this.onReplay,
    this.onDelete,
  });

  /// The request shown.
  final RequestListItemEntity item;

  /// Decides which query values are masked (the UI redaction target).
  final DioLensSettings settings;

  /// Opens the request's detail page.
  final VoidCallback? onTap;

  /// Shares the request; null hides Share.
  final VoidCallback? onShare;

  /// Copies the request's cURL command; null hides the cURL button.
  final VoidCallback? onCopyCurl;

  /// Re-sends the request; null hides Replay (e.g. when it can't be replayed).
  final VoidCallback? onReplay;

  /// Deletes the request; null disables swipe to delete.
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    final mono = theme.monoTextStyle;
    final query = _maskedQuery(item.query, settings);
    final ltrAlign = LtrContent.align(context);

    final content = Material(
      color: theme.background,
      child: InkWell(
        onTap: onTap,
        hoverColor: theme.surface2,
        highlightColor: theme.surface2,
        splashColor: theme.surface3,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  MethodChip(method: item.method),
                  const SizedBox(width: 8),
                  StatusBadge(
                    statusClass: item.statusClass,
                    statusCode: item.statusCode,
                  ),
                  const Spacer(),
                  Text(
                    FormatUtils.relativeTime(item.startedAt),
                    style: TextStyle(
                      fontSize: 11.5,
                      color: theme.textFaint,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text.rich(
                TextSpan(
                  text: item.path,
                  children: [
                    if (query != null)
                      TextSpan(
                        text: '?$query',
                        style: TextStyle(
                          color: theme.textFaint,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                  ],
                ),
                textDirection: LtrContent.direction,
                textAlign: ltrAlign,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: mono.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 2),
              Text(
                item.host,
                textDirection: LtrContent.direction,
                textAlign: ltrAlign,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: mono.copyWith(fontSize: 12, color: theme.textMuted),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(child: _Meta(item: item)),
                  if (onShare case final onShare?)
                    _RowAction(
                      icon: Icons.ios_share_rounded,
                      tooltip: 'Share request',
                      onTap: onShare,
                    ),
                  if (onCopyCurl case final onCopyCurl?) ...[
                    const SizedBox(width: 6),
                    _RowAction(
                      icon: Icons.content_copy_rounded,
                      tooltip: 'Copy cURL',
                      onTap: onCopyCurl,
                    ),
                  ],
                  if (onReplay case final onReplay?) ...[
                    const SizedBox(width: 6),
                    _RowAction(
                      icon: Icons.replay_rounded,
                      tooltip: 'Replay request',
                      onTap: onReplay,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (onDelete == null) return content;

    return Dismissible(
      key: ValueKey('request-${item.id}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete!(),
      background: Container(
        color: theme.danger,
        alignment: AlignmentDirectional.centerEnd,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.delete_outline_rounded, size: 18, color: Colors.white),
            SizedBox(height: 4),
            Text(
              'Delete',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      child: content,
    );
  }
}

/// Small bordered icon button at the end of a row's bottom line.
class _RowAction extends StatelessWidget {
  const _RowAction({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    return Tooltip(
      message: tooltip,
      child: Material(
        color: theme.surface2,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: theme.border),
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox.square(
            dimension: 30,
            child: Icon(icon, size: 15, color: theme.textMuted),
          ),
        ),
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.item});

  final RequestListItemEntity item;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    final base = TextStyle(
      fontSize: 11.5,
      color: theme.textFaint,
      fontFeatures: const [FontFeature.tabularFigures()],
    );

    final parts = <InlineSpan>[];
    void add(String text, [TextStyle? style]) {
      if (parts.isNotEmpty) parts.add(const TextSpan(text: '  ·  '));
      parts.add(TextSpan(text: text, style: style));
    }

    final requestType = item.requestContentType;
    final responseType = item.responseContentType;
    String type(String? mime) => FormatUtils.shortContentType(mime);

    switch (item.state) {
      case RequestState.pending:
        add('Waiting…');
        if (requestType != null) add('${type(requestType)} → …');
      case RequestState.failed:
        add(
          item.errorType?.name ?? 'error',
          TextStyle(color: theme.danger, fontWeight: FontWeight.w600),
        );
        add(FormatUtils.duration(item.duration));
      case RequestState.completed:
        add(FormatUtils.duration(item.duration));
        add(FormatUtils.bytes(item.responseSize));
        if (requestType != null || responseType != null) {
          add('${type(requestType)} → ${type(responseType)}');
        }
    }

    return Text.rich(
      TextSpan(children: parts),
      style: base,
      textDirection: LtrContent.direction,
      textAlign: LtrContent.align(context),
    );
  }
}

/// [query] with the values of redacted parameters shown as `[REDACTED]`.
String? _maskedQuery(String? query, DioLensSettings settings) {
  if (query == null) return null;
  return query
      .split('&')
      .map((pair) {
        final i = pair.indexOf('=');
        final rawKey = i < 0 ? pair : pair.substring(0, i);
        String key;
        try {
          key = Uri.decodeQueryComponent(rawKey);
        } on FormatException {
          key = rawKey;
        }
        return settings.isQueryParamRedacted(key)
            ? '$rawKey=${RequestRedactor.mask}'
            : pair;
      })
      .join('&');
}
