import 'package:flutter/material.dart' show ThemeMode;
import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/dio_lens_bubble_position.dart';
import '../enums/dio_lens_retention.dart';

part 'dio_lens_settings.freezed.dart';
part 'dio_lens_settings.g.dart';

/// User-adjustable Dio Lens settings, persisted through `DioLensStorage`.
///
/// Values passed to `DioLens.init` are only the starting point: once the
/// user changes something in the settings screen, the stored copy wins.
@freezed
abstract class DioLensSettings with _$DioLensSettings {
  const DioLensSettings._();

  @Assert(
    'maxRequests >= DioLensSettings.minRequests && '
        'maxRequests <= DioLensSettings.maxRequestsLimit',
    'maxRequests must be between 10 and 10000',
  )
  @Assert(
    'maxBodyBytes == null || maxBodyBytes > 0',
    'maxBodyBytes must be positive, or null for unlimited',
  )
  const factory DioLensSettings({
    /// Most requests kept; the oldest are removed past this limit.
    @JsonKey(name: 'max_requests') @Default(500) int maxRequests,

    /// Largest body kept, in bytes (see `DioLensSizeUnit`). Bigger text and
    /// JSON bodies are stored truncated, bigger images without a preview;
    /// sizes still report the full body. Null keeps every body whole.
    @JsonKey(name: 'max_body_bytes') int? maxBodyBytes,
    @JsonKey(name: 'retention')
    @Default(DioLensRetention.oneDay)
    DioLensRetention retention,

    /// Show a banner over the host app when a request finishes.
    @JsonKey(name: 'show_notification') @Default(true) bool showNotification,

    /// How long the request-finished banner stays on screen.
    @JsonKey(name: 'notification_duration')
    @Default(Duration(seconds: 4))
    Duration notificationDuration,

    /// Show the tap-to-open bubble over the host app.
    @JsonKey(name: 'show_bubble') @Default(true) bool showBubble,
    @JsonKey(name: 'bubble_position')
    @Default(DioLensBubblePosition.bottomEnd)
    DioLensBubblePosition bubblePosition,

    /// Mask Authorization, Cookie and Set-Cookie values in the UI.
    @JsonKey(name: 'redact_headers') @Default(true) bool redactHeaders,
    @JsonKey(name: 'theme_mode') @Default(ThemeMode.dark) ThemeMode themeMode,
  }) = _DioLensSettings;

  factory DioLensSettings.fromJson(Map<String, dynamic> json) =>
      _$DioLensSettingsFromJson(json);

  static const int minRequests = 10;
  static const int maxRequestsLimit = 10000;

  /// Quick picks offered next to the max requests input.
  static const List<int> maxRequestsPresets = [100, 200, 500, 1000];

  static const Duration minNotificationDuration = Duration(seconds: 2);
  static const Duration maxNotificationDuration = Duration(seconds: 15);
}
