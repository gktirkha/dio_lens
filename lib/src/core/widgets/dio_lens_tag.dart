import 'package:flutter/material.dart';

import '../../theme/dio_lens_theme.dart';

/// Small rounded label, the base of method chips and status badges.
class DioLensTag extends StatelessWidget {
  /// Creates a tag.
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

  /// The text shown.
  final String label;

  /// Text and icon color.
  final Color foreground;

  /// Fill color.
  final Color background;

  /// Optional widget before the label, e.g. a spinner.
  final Widget? leading;

  /// Label font size.
  final double fontSize;

  /// Label font weight.
  final FontWeight fontWeight;

  /// Label letter spacing.
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
