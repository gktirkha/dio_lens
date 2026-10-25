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
