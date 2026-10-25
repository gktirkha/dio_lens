import 'package:freezed_annotation/freezed_annotation.dart';

/// Where the request-finished banner appears on screen.
@JsonEnum(fieldRename: FieldRename.snake)
enum DioLensNotificationPosition {
  /// Below the top safe area.
  top,

  /// Centered vertically.
  center,

  /// Above the bottom of the screen, clear of bottom bars.
  bottom,
}
