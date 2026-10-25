import 'package:flutter/material.dart';

import '../../../../core/utils/ltr_content.dart';
import '../../../../theme/dio_lens_theme.dart';

/// One row of a [RankedList]: label, displayed value, score for the bar, and
/// whether to highlight it.
typedef RankedItem = ({String label, String value, double score, bool warn});

/// Rows with a label, a value and a bar proportional to the top score.
class RankedList extends StatelessWidget {
  /// Creates the list.
  const RankedList({super.key, required this.items});

  /// The rows, highest first.
  final List<RankedItem> items;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    final max = items.fold<double>(0, (m, i) => i.score > m ? i.score : m);
    final ltrAlign = LtrContent.align(context);

    return Column(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const SizedBox(height: 11),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      items[i].label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textDirection: LtrContent.direction,
                      textAlign: ltrAlign,
                      style: theme.monoTextStyle.copyWith(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    items[i].value,
                    textDirection: LtrContent.direction,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: theme.textMuted,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: SizedBox(
                  height: 6,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ColoredBox(color: theme.surface3),
                      FractionallySizedBox(
                        alignment: AlignmentDirectional.centerStart,
                        widthFactor: max == 0 ? 0 : items[i].score / max,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: items[i].warn ? theme.warning : theme.accent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
