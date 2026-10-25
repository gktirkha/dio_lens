import 'package:flutter/material.dart';

import '../../../../core/utils/clipboard_utils.dart';
import '../../../../core/utils/ltr_content.dart';
import '../../../../theme/dio_lens_theme.dart';

/// Small uppercase caption above an overview value.
class OverviewLabel extends StatelessWidget {
  const OverviewLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        letterSpacing: 1.3,
        color: DioLensTheme.of(context).textFaint,
      ),
    );
  }
}

/// Label above a bordered monospace value. Tapping copies the value unless
/// [copyable] is false.
class OverviewField extends StatelessWidget {
  const OverviewField({
    super.key,
    required this.label,
    required this.value,
    this.copyable = true,
    this.valueColor,
  });

  final String label;

  /// Shown as `—` when null or empty.
  final String? value;
  final bool copyable;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    final text = (value == null || value!.isEmpty) ? '—' : value!;
    final canCopy = copyable && text != '—';

    final box = Container(
      width: double.infinity,
      padding: const EdgeInsetsDirectional.fromSTEB(12, 10, 12, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              text,
              textDirection: LtrContent.direction,
              textAlign: LtrContent.align(context),
              style: theme.monoTextStyle.copyWith(
                fontSize: 12.5,
                height: 1.6,
                color: valueColor ?? theme.text,
              ),
            ),
          ),
          if (canCopy) ...[
            const SizedBox(width: 10),
            Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Icon(
                Icons.content_copy_rounded,
                size: 14,
                color: theme.textFaint,
              ),
            ),
          ],
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OverviewLabel(label),
        const SizedBox(height: 6),
        Material(
          color: theme.surface2.withValues(alpha: 0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: theme.border),
          ),
          clipBehavior: Clip.antiAlias,
          child: canCopy
              ? InkWell(
                  onTap: () => copyToClipboard(context, text, label: label),
                  child: box,
                )
              : box,
        ),
      ],
    );
  }
}

/// Bordered box of key/value rows with a titled header and "Copy all".
/// Each row copies its own value on tap.
class OverviewKeyValueBox extends StatelessWidget {
  const OverviewKeyValueBox({
    super.key,
    required this.title,
    required this.entries,
    required this.copyAllText,
    required this.copyAllLabel,
  });

  final String title;
  final List<({String key, String value})> entries;
  final String copyAllText;
  final String copyAllLabel;

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
                    label: copyAllLabel,
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
            Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: () => copyToClipboard(
                  context,
                  entries[i].value,
                  label: entries[i].key,
                ),
                child: Container(
                  padding: const EdgeInsetsDirectional.fromSTEB(12, 10, 12, 10),
                  decoration: BoxDecoration(
                    border: i == 0
                        ? null
                        : Border(top: BorderSide(color: theme.border)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entries[i].key.toUpperCase(),
                        textDirection: LtrContent.direction,
                        style: TextStyle(
                          fontSize: 11,
                          letterSpacing: 1.3,
                          color: theme.textFaint,
                        ),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          entries[i].value.isEmpty ? '—' : entries[i].value,
                          textDirection: LtrContent.direction,
                          textAlign: LtrContent.align(context),
                          style: theme.monoTextStyle.copyWith(
                            fontSize: 12.5,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// The cURL block: caption, horizontally scrollable command, copy button.
class CurlSection extends StatelessWidget {
  const CurlSection({super.key, required this.command});

  final String command;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.surface2.withValues(alpha: 0.5),
        border: Border.all(color: theme.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const OverviewLabel('cURL'),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: theme.surface.withValues(alpha: 0.8),
              border: Border.all(color: theme.border),
              borderRadius: BorderRadius.circular(10),
            ),
            // Commands read LTR and scroll sideways instead of wrapping.
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: SelectableText(
                  command,
                  style: theme.monoTextStyle.copyWith(
                    fontSize: 11.5,
                    height: 1.7,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () => copyToClipboard(context, command, label: 'cURL'),
            icon: const Icon(Icons.content_copy_rounded, size: 14),
            label: const Text('Copy cURL'),
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.text,
              backgroundColor: Colors.transparent,
              side: BorderSide(color: theme.border),
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              minimumSize: const Size(0, 32),
              textStyle: Theme.of(context).textTheme.labelLarge
                  ?.copyWith(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
