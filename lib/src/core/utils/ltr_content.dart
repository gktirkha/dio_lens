import 'package:flutter/widgets.dart';

/// Helpers for technical content (URLs, hosts, headers, sizes, durations)
/// that must always read left-to-right, even inside an RTL layout.
///
/// Render such text with `textDirection: TextDirection.ltr` so the bidi
/// algorithm doesn't reorder `/v1/orders?page=2` or `96 ms · 1.8 KB`, and
/// align it with [LtrContent.align] so it still sits at the reading start of
/// the surrounding layout.
abstract final class LtrContent {
  static const TextDirection direction = TextDirection.ltr;

  /// Left in LTR layouts, right in RTL layouts.
  static TextAlign align(BuildContext context) =>
      Directionality.of(context) == TextDirection.rtl
      ? TextAlign.right
      : TextAlign.left;
}
