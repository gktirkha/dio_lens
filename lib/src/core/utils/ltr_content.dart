import 'package:flutter/widgets.dart';

abstract final class LtrContent {
  static const TextDirection direction = TextDirection.ltr;

  static TextAlign align(BuildContext context) =>
      Directionality.of(context) == TextDirection.rtl
      ? TextAlign.right
      : TextAlign.left;
}
