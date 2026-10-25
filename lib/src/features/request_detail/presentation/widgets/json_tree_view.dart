import 'package:flutter/material.dart';

import '../../../../theme/dio_lens_theme.dart';

/// Collapsible, syntax-colored view of a decoded JSON value.
class JsonTreeView extends StatefulWidget {
  /// Creates the tree view.
  const JsonTreeView({super.key, required this.value});

  /// Decoded JSON: maps, lists, strings, numbers, booleans and null.
  final Object? value;

  @override
  State<JsonTreeView> createState() => _JsonTreeViewState();
}

class _JsonTreeViewState extends State<JsonTreeView> {
  late final Set<String> _open = {
    r'$',
    if (widget.value case final Map<Object?, Object?> map)
      for (final k in map.keys) '\$.$k',
    if (widget.value case final List<Object?> list)
      for (var i = 0; i < list.length; i++) '\$[$i]',
  };

  void _toggle(String path) => setState(() {
    if (!_open.remove(path)) _open.add(path);
  });

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.surface2.withValues(alpha: 0.4),
        border: Border.all(color: theme.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(12),
          child: DefaultTextStyle.merge(
            style: theme.monoTextStyle.copyWith(fontSize: 12, height: 1.7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _node(theme, widget.value, r'$', null),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _node(
    DioLensTheme theme,
    Object? value,
    String path,
    String? key,
  ) {
    final keySpans = <InlineSpan>[
      if (key != null) ...[
        TextSpan(
          text: '"$key"',
          style: TextStyle(color: theme.jsonKey),
        ),
        TextSpan(
          text: ': ',
          style: TextStyle(color: theme.jsonPunctuation),
        ),
      ],
    ];
    TextSpan punct(String s) => TextSpan(
      text: s,
      style: TextStyle(color: theme.jsonPunctuation),
    );

    if (value is Map || value is List) {
      final entries = value is Map
          ? [
              for (final e in value.entries)
                (path: '$path.${e.key}', key: '${e.key}', value: e.value),
            ]
          : [
              for (var i = 0; i < (value as List).length; i++)
                (path: '$path[$i]', key: null, value: value[i]),
            ];
      final (open, close) = value is Map ? ('{', '}') : ('[', ']');
      if (entries.isEmpty) {
        return [
          _row(null, [...keySpans, punct('$open$close')]),
        ];
      }
      final expanded = _open.contains(path);
      final noun = value is Map ? 'key' : 'item';
      final count = '${entries.length} $noun${entries.length == 1 ? '' : 's'}';
      return [
        _row(
          _ExpandIcon(expanded: expanded),
          [
            ...keySpans,
            punct(open),
            TextSpan(
              text: ' $count ',
              style: TextStyle(fontSize: 11, color: theme.jsonPunctuation),
            ),
            punct(close),
          ],
          onTap: () => _toggle(path),
          expanded: expanded,
        ),
        if (expanded)
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final e in entries)
                  ..._node(theme, e.value, e.path, e.key),
              ],
            ),
          ),
      ];
    }

    final TextSpan rendered = switch (value) {
      String s => TextSpan(
        text: '"$s"',
        style: TextStyle(color: theme.jsonString),
      ),
      num n => TextSpan(
        text: '$n',
        style: TextStyle(color: theme.jsonNumber),
      ),
      bool b => TextSpan(
        text: '$b',
        style: TextStyle(color: theme.jsonBoolNull),
      ),
      _ => TextSpan(
        text: 'null',
        style: TextStyle(color: theme.jsonBoolNull),
      ),
    };
    return [
      _row(const SizedBox(width: 16), [...keySpans, rendered]),
    ];
  }

  Widget _row(
    Widget? leading,
    List<InlineSpan> spans, {
    VoidCallback? onTap,
    bool? expanded,
  }) {
    final line = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 22),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          leading ?? const SizedBox(width: 16),
          const SizedBox(width: 6),
          Text.rich(TextSpan(children: spans), softWrap: false),
        ],
      ),
    );
    if (onTap == null) return line;
    return Semantics(
      button: true,
      expanded: expanded,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsetsDirectional.only(end: 4),
          child: line,
        ),
      ),
    );
  }
}

class _ExpandIcon extends StatelessWidget {
  const _ExpandIcon({required this.expanded});

  final bool expanded;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 16,
      child: Icon(
        expanded
            ? Icons.keyboard_arrow_down_rounded
            : Icons.keyboard_arrow_right_rounded,
        size: 14,
        color: DioLensTheme.of(context).textFaint,
      ),
    );
  }
}
