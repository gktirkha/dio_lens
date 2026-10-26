import 'package:freezed_annotation/freezed_annotation.dart';

part 'dio_lens_console_settings.freezed.dart';

/// What the console logs show. Whether they print at all is decided by the
/// `consoleMode` passed to `DioLens.init`, and masking by the redaction mode
/// setting.
@freezed
abstract class DioLensConsoleSettings with _$DioLensConsoleSettings {
  /// Creates console settings; everything is printed by default.
  const factory DioLensConsoleSettings({
    /// Print the request method and URL.
    @Default(true) bool request,

    /// Print query parameters, request headers, options and extras.
    @Default(true) bool requestHeader,

    /// Print the request body.
    @Default(true) bool requestBody,

    /// Print the response body.
    @Default(true) bool responseBody,

    /// Print response headers.
    @Default(true) bool responseHeader,

    /// Print errors.
    @Default(true) bool error,

    /// Line width before wrapping.
    @Default(90) int maxWidth,

    /// Print short maps and lists on one line.
    @Default(true) bool compact,

    /// Prefix section headers with `[REQUEST]`, `[RESPONSE]` or `[ERROR]`.
    @Default(true) bool showStateInHeader,
  }) = _DioLensConsoleSettings;
}
