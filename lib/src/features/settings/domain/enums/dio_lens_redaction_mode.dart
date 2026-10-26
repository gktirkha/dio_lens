import 'package:freezed_annotation/freezed_annotation.dart';

/// Where Dio Lens masks the values of redacted headers and query parameters.
@JsonEnum(fieldRename: FieldRename.snake)
enum DioLensRedactionMode {
  /// Masked everywhere: the UI, exports, shares and console logs.
  redact(inUi: true, inConsole: true),

  /// Masked in console logs only.
  console(inUi: false, inConsole: true),

  /// Masked in the UI, exports and shares only.
  ui(inUi: true, inConsole: false),

  /// Never masked.
  off(inUi: false, inConsole: false);

  const DioLensRedactionMode({required this.inUi, required this.inConsole});

  /// Whether values are masked in the UI, exports and shares.
  final bool inUi;

  /// Whether values are masked in console logs.
  final bool inConsole;
}
