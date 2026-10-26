import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// The kind of app hosting Dio Lens, which decides what Dio Lens adds around
/// its Material pages.
enum DioLensHostApp {
  /// A [MaterialApp]: it provides everything Dio Lens needs.
  material,

  /// A [CupertinoApp]: it has no Material localizations or
  /// [ScaffoldMessenger].
  cupertino,

  /// Any other app, such as a bare [WidgetsApp]; treated like [cupertino].
  other;

  /// The app above [context].
  static DioLensHostApp of(BuildContext context) {
    if (context.findAncestorWidgetOfExactType<MaterialApp>() != null) {
      return material;
    }
    if (context.findAncestorWidgetOfExactType<CupertinoApp>() != null) {
      return cupertino;
    }
    return other;
  }

  /// Whether the app provides the Material pieces Dio Lens needs.
  bool get isMaterial => this == material;
}

/// [child] with English Material localizations when the app above [context]
/// is not a [MaterialApp] and did not add Material localizations itself.
Widget withMaterialLocalizations(BuildContext context, Widget child) {
  if (DioLensHostApp.of(context).isMaterial) return child;
  final hasLocalizations =
      Localizations.of<MaterialLocalizations>(context, MaterialLocalizations) !=
      null;
  if (hasLocalizations) return child;
  return Localizations.override(
    context: context,
    delegates: const [DefaultMaterialLocalizations.delegate],
    child: child,
  );
}
