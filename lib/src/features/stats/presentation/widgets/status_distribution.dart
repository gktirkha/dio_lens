import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/enums/request_status_class.dart';
import '../../../../theme/dio_lens_theme.dart';
import '../../domain/entities/status_share_entity.dart';

/// Donut of status classes with a legend; the legend ends with a divider
/// and the total request count.
class StatusDistribution extends StatelessWidget {
  const StatusDistribution({
    super.key,
    required this.shares,
    required this.total,
  });

  final List<StatusShareEntity> shares;
  final int total;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    final segments = [
      for (final s in shares) (share: s, style: _style(theme, s.statusClass)),
    ];

    return Row(
      children: [
        SizedBox.square(
          dimension: 120,
          child: Semantics(
            label: 'Status code distribution donut chart',
            child: CustomPaint(
              painter: _DonutPainter(
                values: [for (final s in segments) s.share.count.toDouble()],
                colors: [for (final s in segments) s.style.color],
                trackColor: theme.surface3,
              ),
            ),
          ),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final s in segments) ...[
                _LegendRow(
                  color: s.style.color,
                  label: s.style.label,
                  value: total == 0
                      ? '0%'
                      : '${(s.share.count / total * 100).round()}%',
                ),
                const SizedBox(height: 8),
              ],
              Divider(height: 1, thickness: 1, color: theme.border),
              const SizedBox(height: 8),
              _LegendRow(
                label: 'Total requests',
                value: '$total',
                emphasis: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  static ({String label, Color color}) _style(
    DioLensTheme theme,
    RequestStatusClass statusClass,
  ) {
    return switch (statusClass) {
      RequestStatusClass.success => (
        label: '2xx success',
        color: theme.success,
      ),
      RequestStatusClass.redirect => (
        label: '3xx redirect',
        color: theme.redirect,
      ),
      RequestStatusClass.clientError => (
        label: '4xx client',
        color: theme.warning,
      ),
      RequestStatusClass.serverError => (
        label: '5xx server',
        color: theme.danger,
      ),
      RequestStatusClass.error => (
        label: 'Network errors',
        color: theme.networkError,
      ),
      RequestStatusClass.pending => (label: 'Pending', color: theme.pending),
      RequestStatusClass.informational => (
        label: '1xx info',
        color: theme.textFaint,
      ),
    };
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({
    required this.label,
    required this.value,
    this.color,
    this.emphasis = false,
  });

  /// Dot color; the total row has no dot but keeps the same indent.
  final Color? color;
  final String label;
  final String value;
  final bool emphasis;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    return Row(
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: emphasis ? theme.text : theme.textMuted,
              fontWeight: emphasis ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: theme.text,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}

class _DonutPainter extends CustomPainter {
  _DonutPainter({
    required this.values,
    required this.colors,
    required this.trackColor,
  });

  final List<double> values;
  final List<Color> colors;
  final Color trackColor;

  static const double _strokeWidth = 16;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = (size.shortestSide - _strokeWidth) / 2;
    final rect = Rect.fromCircle(
      center: size.center(Offset.zero),
      radius: radius,
    );
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth;

    final total = values.fold<double>(0, (a, b) => a + b);
    if (total <= 0) {
      canvas.drawArc(rect, 0, 2 * math.pi, false, paint..color = trackColor);
      return;
    }

    var start = -math.pi / 2;
    for (var i = 0; i < values.length; i++) {
      final sweep = values[i] / total * 2 * math.pi;
      canvas.drawArc(rect, start, sweep, false, paint..color = colors[i]);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(_DonutPainter old) =>
      !listEquals(old.values, values) ||
      !listEquals(old.colors, colors) ||
      old.trackColor != trackColor;
}
