import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../../core/utils/clipboard_utils.dart';
import '../../../../core/utils/ltr_content.dart';
import '../../../../theme/dio_lens_theme.dart';
import 'overview_widgets.dart';

class KeyValueEntry {
  const KeyValueEntry(this.key, this.value, {this.redacted = false});

  final String key;
  final String value;

  final bool redacted;

  static const String mask = '••••••• (redacted)';

  String get displayValue => redacted ? mask : value;
}

class KeyValueBox extends StatelessWidget {
  const KeyValueBox({
    super.key,
    required this.title,
    required this.entries,
    this._copyAllLabel,
  });

  final String title;
  final List<KeyValueEntry> entries;

  final String? _copyAllLabel;

  String get copyAllText {
    final map = <String, Object>{};
    for (final e in entries) {
      final existing = map[e.key];
      map[e.key] = switch (existing) {
        null => e.displayValue,
        final List<Object> values => [...values, e.displayValue],
        _ => [existing, e.displayValue],
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
        onTap: () => copyToClipboard(context, value, label: entry.key),
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
                  letterSpacing: entry.redacted ? 2 : null,
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
