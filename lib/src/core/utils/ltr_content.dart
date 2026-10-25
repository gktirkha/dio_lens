import 'package:flutter/widgets.dart';

/// Keeps technical text (paths, URLs, numbers) left-to-right inside
/// right-to-left layouts.
abstract final class LtrContent {
  /// Direction for technical text.
  static const TextDirection direction = TextDirection.ltr;

  /// Alignment that puts technical text at the start edge of the current layout
  /// direction.
  static TextAlign align(BuildContext context) =>
      Directionality.of(context) == TextDirection.rtl
      ? TextAlign.right
      : TextAlign.left;
}
