import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../../core/utils/clipboard_utils.dart';
import '../../../../core/utils/ltr_content.dart';
import '../../../../theme/dio_lens_theme.dart';
import '../../../settings/domain/utils/request_redactor.dart';
import 'overview_widgets.dart';

/// One row of a [KeyValueBox].
class KeyValueEntry {
  /// Creates a row, optionally [redacted] on screen and [copyRedacted] when
  /// copied; [copyRedacted] defaults to [redacted].
  const KeyValueEntry(
    this.key,
    this.value, {
    this.redacted = false,
    bool? copyRedacted,
  }) : copyRedacted = copyRedacted ?? redacted;

  /// The row's key, e.g. a header name.
  final String key;

  /// The row's value.
  final String value;

  /// Whether the value is shown as [mask].
  final bool redacted;

  /// Whether the value is copied as [mask].
  final bool copyRedacted;

  /// Shown and copied instead of redacted values.
  static const String mask = RequestRedactor.mask;

  /// What is shown for this row.
  String get displayValue => redacted ? mask : value;

  /// What is copied for this row.
  String get copyValue => copyRedacted ? mask : value;
}

/// Bordered box of key/value rows with a title and "Copy all". Rows copy their
/// value on tap; "Copy all" copies every row as a JSON object.
class KeyValueBox extends StatelessWidget {
  /// Creates the box.
  const KeyValueBox({
    super.key,
    required this.title,
    required this.entries,
    this._copyAllLabel,
  });

  /// Title shown in the header.
  final String title;

  /// The rows, in order.
  final List<KeyValueEntry> entries;

  final String? _copyAllLabel;

  /// Every row as a pretty-printed JSON object; a repeated key becomes an array
  /// of its values.
  String get copyAllText {
    final map = <String, Object>{};
    for (final e in entries) {
      final existing = map[e.key];
      map[e.key] = switch (existing) {
        null => e.copyValue,
        final List<Object> values => [...values, e.copyValue],
        _ => [existing, e.copyValue],
      };
    }
    return const JsonEncoder.withIndent('  ').convert(map);
  }

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.surface2.withValues(alpha: 0.5),
        border: Border.all(color: theme.border),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsetsDirectional.fromSTEB(12, 4, 6, 4),
            decoration: BoxDecoration(
              color: theme.surface2.withValues(alpha: 0.7),
              border: Border(bottom: BorderSide(color: theme.border)),
            ),
            child: Row(
              children: [
                Expanded(child: OverviewLabel(title)),
                TextButton.icon(
                  onPressed: () => copyToClipboard(
                    context,
                    copyAllText,
                    label: _copyAllLabel ?? title,
                  ),
                  icon: const Icon(Icons.content_copy_rounded, size: 13),
                  label: const Text('Copy all'),
                  style: TextButton.styleFrom(
                    foregroundColor: theme.textFaint,
                    textStyle: Theme.of(context).textTheme.labelSmall
                        ?.copyWith(fontSize: 11),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
            ),
          ),
          for (var i = 0; i < entries.length; i++)
            _Row(entry: entries[i], showDivider: i > 0),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.entry, required this.showDivider});

  final KeyValueEntry entry;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    final value = entry.displayValue;
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () =>
            copyToClipboard(context, entry.copyValue, label: entry.key),
        child: Container(
          padding: const EdgeInsetsDirectional.fromSTEB(12, 10, 12, 10),
          decoration: BoxDecoration(
            border: showDivider
                ? Border(top: BorderSide(color: theme.border))
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                entry.key.toUpperCase(),
                textDirection: LtrContent.direction,
                textAlign: LtrContent.align(context),
                style: TextStyle(
                  fontSize: 11,
                  letterSpacing: 1.3,
                  color: theme.textFaint,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value.isEmpty ? '—' : value,
                textDirection: LtrContent.direction,
                textAlign: LtrContent.align(context),
                style: theme.monoTextStyle.copyWith(
                  fontSize: 12.5,
                  height: 1.6,
                  color: entry.redacted ? theme.textFaint : theme.text,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
