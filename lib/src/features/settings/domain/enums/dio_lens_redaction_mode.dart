import 'package:freezed_annotation/freezed_annotation.dart';

/// Where a value can end up.
enum DioLensRedactionTarget {
  /// On screen: the request list and every detail tab.
  ui,

  /// What is copied: fields, "Copy all" and cURL commands.
  clipboard,

  /// Console logs.
  console,

  /// What leaves the app: exports and reports handed to `onShare`.
  external,
}

/// Where Dio Lens masks the values of redacted headers and query parameters:
/// every combination of the UI, the clipboard, console logs and external
/// (exports and shared reports).
@JsonEnum(fieldRename: FieldRename.snake)
enum DioLensRedactionMode {
  /// Masked everywhere: the UI, the clipboard, console logs, exports and
  /// shared reports.
  all(inUi: true, inClipboard: true, inConsole: true, inExternal: true),

  /// Masked in the UI.
  ui(inUi: true, inClipboard: false, inConsole: false, inExternal: false),

  /// Masked on the clipboard.
  clipboard(
    inUi: false,
    inClipboard: true,
    inConsole: false,
    inExternal: false,
  ),

  /// Masked in console logs.
  console(inUi: false, inClipboard: false, inConsole: true, inExternal: false),

  /// Masked in exports and shared reports.
  external(inUi: false, inClipboard: false, inConsole: false, inExternal: true),

  /// Masked in the UI and on the clipboard.
  uiClipboard(
    inUi: true,
    inClipboard: true,
    inConsole: false,
    inExternal: false,
  ),

  /// Masked in the UI and in console logs.
  uiConsole(inUi: true, inClipboard: false, inConsole: true, inExternal: false),

  /// Masked in the UI and in exports and shared reports.
  uiExternal(
    inUi: true,
    inClipboard: false,
    inConsole: false,
    inExternal: true,
  ),

  /// Masked on the clipboard and in console logs.
  clipboardConsole(
    inUi: false,
    inClipboard: true,
    inConsole: true,
    inExternal: false,
  ),

  /// Masked on the clipboard and in exports and shared reports.
  clipboardExternal(
    inUi: false,
    inClipboard: true,
    inConsole: false,
    inExternal: true,
  ),

  /// Masked in console logs and in exports and shared reports.
  consoleExternal(
    inUi: false,
    inClipboard: false,
    inConsole: true,
    inExternal: true,
  ),

  /// Masked in the UI, on the clipboard and in console logs.
  uiClipboardConsole(
    inUi: true,
    inClipboard: true,
    inConsole: true,
    inExternal: false,
  ),

  /// Masked in the UI, on the clipboard and in exports and shared reports.
  uiClipboardExternal(
    inUi: true,
    inClipboard: true,
    inConsole: false,
    inExternal: true,
  ),

  /// Masked in the UI, in console logs and in exports and shared reports.
  uiConsoleExternal(
    inUi: true,
    inClipboard: false,
    inConsole: true,
    inExternal: true,
  ),

  /// Masked on the clipboard, in console logs and in exports and shared reports.
  clipboardConsoleExternal(
    inUi: false,
    inClipboard: true,
    inConsole: true,
    inExternal: true,
  ),

  /// Never masked.
  none(inUi: false, inClipboard: false, inConsole: false, inExternal: false);

  const DioLensRedactionMode({
    required this.inUi,
    required this.inClipboard,
    required this.inConsole,
    required this.inExternal,
  });

  /// Whether values are masked on screen.
  final bool inUi;

  /// Whether values are masked when copied.
  final bool inClipboard;

  /// Whether values are masked in console logs.
  final bool inConsole;

  /// Whether values are masked in exports and reports handed to `onShare`.
  final bool inExternal;

  /// Whether values are masked for [target].
  bool masks(DioLensRedactionTarget target) => switch (target) {
    DioLensRedactionTarget.ui => inUi,
    DioLensRedactionTarget.clipboard => inClipboard,
    DioLensRedactionTarget.console => inConsole,
    DioLensRedactionTarget.external => inExternal,
  };
}
