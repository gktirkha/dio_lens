import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../../core/utils/clipboard_utils.dart';
import '../../../../theme/dio_lens_theme.dart';
import 'json_tree_view.dart';
import 'key_value_box.dart';

/// A request or response body, rendered by content type: form data as a
/// key/value box, text as raw text, anything else as JSON with a
/// Pretty / Raw toggle.
class BodyView extends StatelessWidget {
  const BodyView({
    super.key,
    required this.body,
    required this.contentType,
    required this.emptyLabel,
  });

  /// Decoded body: map, list, string or null.
  final Object? body;
  final String? contentType;

  /// Shown when [body] is null, e.g. "No request body."
  final String emptyLabel;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    final body = this.body;
    final type = (contentType ?? '').toLowerCase();

    if (body == null) {
      return Text(
        emptyLabel,
        style: TextStyle(fontSize: 12.5, color: theme.textFaint),
      );
    }
    final isForm =
        type.contains('x-www-form-urlencoded') ||
        type.contains('multipart/form-data');
    if (isForm && body is Map) {
      final entries = [
        for (final e in body.entries) KeyValueEntry('${e.key}', '${e.value}'),
      ];
      return KeyValueBox(title: 'Form data', entries: entries);
    }
    if (type.startsWith('text/') || body is String) {
      final text = body is String
          ? body
          : const JsonEncoder.withIndent('  ').convert(body);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Toolbar(
            leading: Text(
              'PLAIN TEXT',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.33,
                color: theme.textFaint,
              ),
            ),
            copyText: text,
          ),
          const SizedBox(height: 10),
          _RawBox(text: text),
        ],
      );
    }
    return _JsonBody(body: body);
  }
}

class _JsonBody extends StatefulWidget {
  const _JsonBody({required this.body});

  final Object body;

  @override
  State<_JsonBody> createState() => _JsonBodyState();
}

class _JsonBodyState extends State<_JsonBody> {
  bool _pretty = true;
  late final String _raw = const JsonEncoder.withIndent('  ')
      .convert(widget.body);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Toolbar(
          leading: _PrettyRawToggle(
            pretty: _pretty,
            onChanged: (pretty) => setState(() => _pretty = pretty),
          ),
          copyText: _raw,
        ),
        const SizedBox(height: 10),
        _pretty ? JsonTreeView(value: widget.body) : _RawBox(text: _raw),
      ],
    );
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar({required this.leading, required this.copyText});

  final Widget leading;
  final String copyText;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    return Row(
      children: [
        leading,
        const Spacer(),
        OutlinedButton.icon(
          onPressed: () => copyToClipboard(context, copyText, label: 'Body'),
          icon: const Icon(Icons.content_copy_rounded, size: 13),
          label: const Text('Copy'),
          style: OutlinedButton.styleFrom(
            foregroundColor: theme.textMuted,
            backgroundColor: theme.surface2,
            side: BorderSide(color: theme.border),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            minimumSize: const Size(0, 28),
            visualDensity: VisualDensity.compact,
            textStyle: Theme.of(context).textTheme.labelMedium
                ?.copyWith(fontSize: 11.5, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class _PrettyRawToggle extends StatelessWidget {
  const _PrettyRawToggle({required this.pretty, required this.onChanged});

  final bool pretty;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    Widget option(String label, bool value) {
      final selected = pretty == value;
      return Semantics(
        button: true,
        selected: selected,
        child: Material(
          color: selected ? theme.accent : theme.surface2,
          child: InkWell(
            onTap: () => onChanged(value),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: selected ? theme.onAccent : theme.textMuted,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: theme.border),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [option('Pretty', true), option('Raw', false)],
      ),
    );
  }
}

class _RawBox extends StatelessWidget {
  const _RawBox({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.surface2.withValues(alpha: 0.4),
        border: Border.all(color: theme.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: SelectableText(
        text,
        textDirection: TextDirection.ltr,
        style: theme.monoTextStyle.copyWith(fontSize: 12, height: 1.6),
      ),
    );
  }
}
