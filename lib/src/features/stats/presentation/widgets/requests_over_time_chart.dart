import 'package:flutter/material.dart';

import '../../../../theme/dio_lens_theme.dart';
import '../../domain/entities/time_bucket_entity.dart';

/// Vertical bar per time bucket, labelled with its hour.
class RequestsOverTimeChart extends StatelessWidget {
  const RequestsOverTimeChart({super.key, required this.buckets});

  /// Oldest first.
  final List<TimeBucketEntity> buckets;

  static const double _chartHeight = 92;
  static const double _labelHeight = 16;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    final max = buckets.fold<int>(0, (m, b) => b.count > m ? b.count : m);

    return Semantics(
      label: 'Requests over time, hourly',
      child: SizedBox(
        height: _chartHeight,
        // Time always runs left to right, also in RTL layouts.
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (var i = 0; i < buckets.length; i++) ...[
                if (i > 0) const SizedBox(width: 6),
                Expanded(
                  child: Tooltip(
                    message: '${buckets[i].count} requests',
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: FractionallySizedBox(
                            heightFactor: max == 0
                                ? 0.06
                                : (buckets[i].count / max).clamp(0.06, 1.0),
                            child: Container(
                              constraints: const BoxConstraints(maxWidth: 16),
                              decoration: BoxDecoration(
                                color: theme.accent,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4),
                                  bottom: Radius.circular(2),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: _labelHeight,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              buckets[i].start.hour.toString().padLeft(2, '0'),
                              style: TextStyle(
                                fontSize: 9,
                                color: theme.textFaint,
                                fontFeatures: const [
                                  FontFeature.tabularFigures(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
