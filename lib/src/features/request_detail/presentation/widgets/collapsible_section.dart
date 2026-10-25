import 'package:flutter/material.dart';

import '../../../../theme/dio_lens_theme.dart';

/// Bordered section with a tappable header that shows or hides [child].
class CollapsibleSection extends StatefulWidget {
  const CollapsibleSection({
    super.key,
    required this.title,
    required this.child,
    this.trailingLabel,
    this.initiallyExpanded = false,
  });

  final String title;
  final Widget child;

  /// Small figure before the chevron, e.g. a line count.
  final String? trailingLabel;
  final bool initiallyExpanded;

  @override
  State<CollapsibleSection> createState() => _CollapsibleSectionState();
}

class _CollapsibleSectionState extends State<CollapsibleSection> {
  late bool _expanded = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    final trailing = widget.trailingLabel;
    return Container(
      decoration: BoxDecoration(
        color: theme.surface,
        border: Border.all(color: theme.border),
        borderRadius: BorderRadius.circular(theme.radiusMedium),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            button: true,
            expanded: _expanded,
            child: Material(
              color: theme.surface2,
              child: InkWell(
                onTap: () => setState(() => _expanded = !_expanded),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 11,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: theme.text,
                          ),
                        ),
                      ),
                      if (trailing != null) ...[
                        Text(
                          trailing,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: theme.textFaint,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      AnimatedRotation(
                        turns: _expanded ? 0.25 : 0,
                        duration: const Duration(milliseconds: 180),
                        // chevron_right mirrors automatically in RTL.
                        child: Icon(
                          Icons.chevron_right_rounded,
                          size: 18,
                          color: theme.textFaint,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(13, 10, 13, 13),
              child: widget.child,
            ),
        ],
      ),
    );
  }
}
