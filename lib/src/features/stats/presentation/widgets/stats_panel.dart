import 'package:flutter/material.dart';

import '../../../../theme/dio_lens_theme.dart';

/// Rounded card with a title, wrapping one chart or list.
///
/// With [onTap], the title row becomes a button with a trailing chevron.
/// Without a [title] only [child] is shown.
class StatsPanel extends StatelessWidget {
  const StatsPanel({super.key, this.title, required this.child, this.onTap});

  final String? title;
  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    final title = this.title;
    if (title == null) return _frame(theme, child);
    final titleText = Text(
      title,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: theme.text,
      ),
    );

    return _frame(
      theme,
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (onTap == null)
            titleText
          else
            Semantics(
              button: true,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(theme.radiusSmall),
                child: Row(
                  children: [
                    Expanded(child: titleText),
                    // chevron_right mirrors automatically in RTL.
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 18,
                      color: theme.textFaint,
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _frame(DioLensTheme theme, Widget content) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: theme.surface,
        border: Border.all(color: theme.border),
        borderRadius: BorderRadius.circular(theme.radiusLarge),
      ),
      child: content,
    );
  }
}
