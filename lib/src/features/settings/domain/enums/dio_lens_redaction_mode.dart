import 'package:freezed_annotation/freezed_annotation.dart';

/// Where a value can be shown: the UI (with exports and shares), the
/// clipboard (the Overview tab and cURL commands), or console logs.
enum DioLensRedactionTarget {
  /// The detail tabs, exports and shared reports.
  ui,

  /// What can be copied out: the Overview tab and every cURL command, from
  /// the cURL buttons to the cURL section of shared reports.
  clipboard,

  /// Console logs.
  console,
}

/// Where Dio Lens masks the values of redacted headers and query parameters:
/// every combination of the UI, the clipboard and console logs.
@JsonEnum(fieldRename: FieldRename.snake)
enum DioLensRedactionMode {
  /// Masked everywhere: the UI, the clipboard and console logs.
  all(inUi: true, inClipboard: true, inConsole: true),

  /// Masked in the UI only.
  ui(inUi: true, inClipboard: false, inConsole: false),

  /// Masked on the clipboard only (the Overview tab and cURL commands).
  clipboard(inUi: false, inClipboard: true, inConsole: false),

  /// Masked in console logs only.
  console(inUi: false, inClipboard: false, inConsole: true),

  /// Masked in the UI and on the clipboard.
  uiClipboard(inUi: true, inClipboard: true, inConsole: false),

  /// Masked in the UI and console logs.
  uiConsole(inUi: true, inClipboard: false, inConsole: true),

  /// Masked on the clipboard and in console logs.
  clipboardConsole(inUi: false, inClipboard: true, inConsole: true),

  /// Never masked.
  none(inUi: false, inClipboard: false, inConsole: false);

  const DioLensRedactionMode({
    required this.inUi,
    required this.inClipboard,
    required this.inConsole,
  });

  /// Whether values are masked in the UI, exports and shares.
  final bool inUi;

  /// Whether values are masked on the clipboard (the Overview tab and cURL
  /// commands).
  final bool inClipboard;

  /// Whether values are masked in console logs.
  final bool inConsole;

  /// Whether values are masked for [target].
  bool masks(DioLensRedactionTarget target) => switch (target) {
    DioLensRedactionTarget.ui => inUi,
    DioLensRedactionTarget.clipboard => inClipboard,
    DioLensRedactionTarget.console => inConsole,
  };
}
