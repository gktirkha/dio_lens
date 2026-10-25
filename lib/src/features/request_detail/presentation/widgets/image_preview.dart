import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../../core/utils/format_utils.dart';
import '../../../../theme/dio_lens_theme.dart';

/// Image response: the decoded image when [bytes] are available, otherwise
/// a striped placeholder. A footer shows the type and size.
class ImagePreview extends StatelessWidget {
  const ImagePreview({
    super.key,
    required this.bytes,
    required this.contentType,
    required this.size,
  });

  final Uint8List? bytes;
  final String? contentType;
  final int? size;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    final bytes = this.bytes;
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
          AspectRatio(
            aspectRatio: 1,
            child: bytes == null
                ? _Placeholder(theme: theme)
                : Image.memory(
                    bytes,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => _Placeholder(
                      theme: theme,
                      label: 'Could not decode image',
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      FormatUtils.shortContentType(contentType),
                      style: theme.monoTextStyle.copyWith(
                        fontSize: 11.5,
                        color: theme.textMuted,
                      ),
                    ),
                  ),
                  Text(
                    FormatUtils.bytes(size),
                    style: theme.monoTextStyle.copyWith(
                      fontSize: 11.5,
                      color: theme.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({
    required this.theme,
    this.label = 'Image body not captured',
  });

  final DioLensTheme theme;
  final String label;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _StripesPainter(a: theme.surface2, b: theme.surface3),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.image_outlined, size: 30, color: theme.textFaint),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(fontSize: 11, color: theme.textFaint)),
          ],
        ),
      ),
    );
  }
}

/// 45° stripes, 10px each, like the design's placeholder.
class _StripesPainter extends CustomPainter {
  const _StripesPainter({required this.a, required this.b});

  final Color a;
  final Color b;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = a);
    final paint = Paint()
      ..color = b
      ..strokeWidth = 10 / 1.4142;
    canvas.clipRect(Offset.zero & size);
    for (var x = -size.height; x < size.width; x += 20) {
      canvas.drawLine(
        Offset(x, size.height),
        Offset(x + size.height, 0),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_StripesPainter old) => old.a != a || old.b != b;
}
