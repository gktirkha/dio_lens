import 'package:freezed_annotation/freezed_annotation.dart';

part 'console_logger_settings.freezed.dart';
part 'console_logger_settings.g.dart';

/// Settings for the console logger.
@freezed
abstract class ConsoleLoggerSettings with _$ConsoleLoggerSettings {
  /// Creates console logger settings.
  const factory ConsoleLoggerSettings({
    /// Print request [Options].
    @Default(true) bool request,

    /// Print request header [Options.headers].
    @Default(true) bool requestHeader,

    /// Print request data [Options.data].
    @Default(true) bool requestBody,

    /// Print [Response.data].
    @Default(true) bool responseBody,

    /// Print [Response.headers].
    @Default(true) bool responseHeader,

    /// Print error message.
    @Default(true) bool error,

    /// Width size per logPrint.
    @Default(90) int maxWidth,

    /// Print compact json response.
    @Default(true) bool compact,

    /// Show state/stage in header.
    @Default(true) bool showStateInHeader,

    /// Enable logging.
    @Default(true) bool enabled,
  }) = _ConsoleLoggerSettings;

  /// Creates console logger settings from JSON.
  factory ConsoleLoggerSettings.fromJson(Map<String, dynamic> json) =>
      _$ConsoleLoggerSettingsFromJson(json);
}
