import 'package:flutter/material.dart';

import '../../theme/dio_lens_theme.dart';

class DioLensTag extends StatelessWidget {
  const DioLensTag({
    super.key,
    required this.label,
    required this.foreground,
    required this.background,
    this.leading,
    this.fontSize = 11.5,
    this.fontWeight = FontWeight.w700,
    this.letterSpacing,
  });

  final String label;
  final Color foreground;
  final Color background;

  final Widget? leading;

  final double fontSize;
  final FontWeight fontWeight;
  final double? letterSpacing;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    return Container(
      height: 21,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 4)],
          Text(
            label,
            style: theme.monoTextStyle.copyWith(
              color: foreground,
              fontSize: fontSize,
              fontWeight: fontWeight,
              letterSpacing: letterSpacing,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
