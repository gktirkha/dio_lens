import 'package:flutter/material.dart' show ThemeMode;
import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/dio_lens_bubble_position.dart';
import '../enums/dio_lens_notification_position.dart';
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

    @JsonKey(name: 'notification_position')
    @Default(DioLensNotificationPosition.top)
    DioLensNotificationPosition notificationPosition,

    /// How long the request-finished banner stays on screen.
    @JsonKey(name: 'notification_duration')
    @Default(Duration(seconds: 4))
    Duration notificationDuration,

    /// Show the tap-to-open bubble over the host app.
    @JsonKey(name: 'show_bubble') @Default(true) bool showBubble,
    @JsonKey(name: 'bubble_position')
    @Default(DioLensBubblePosition.bottomEnd)
    DioLensBubblePosition bubblePosition,

    /// Mask the values of [redactedHeaders] in the UI.
    @JsonKey(name: 'redact_headers') @Default(true) bool redactHeaders,

    /// Header names masked while [redactHeaders] is on, in requests and
    /// responses; matched case-insensitively.
    @JsonKey(name: 'redacted_headers')
    @Default(DioLensSettings.defaultRedactedHeaders)
    List<String> redactedHeaders,

    /// Mask the values of [redactedQueryParams] in the UI.
    @JsonKey(name: 'redact_query') @Default(true) bool redactQuery,

    /// Query parameter names masked while [redactQuery] is on; matched
    /// case-insensitively.
    @JsonKey(name: 'redacted_query_params')
    @Default(DioLensSettings.defaultRedactedQueryParams)
    List<String> redactedQueryParams,
    @JsonKey(name: 'theme_mode') @Default(ThemeMode.dark) ThemeMode themeMode,
  }) = _DioLensSettings;

  factory DioLensSettings.fromJson(Map<String, dynamic> json) =>
      _$DioLensSettingsFromJson(json);

  static const List<String> defaultRedactedHeaders = [
    'authorization',
    'cookie',
    'set-cookie',
    'x-api-key',
  ];

  static const List<String> defaultRedactedQueryParams = [
    'token',
    'apikey',
    'password',
  ];

  /// Whether the header [name] is masked under these settings. Case
  /// insensitive, whatever case the keys were given in.
  bool isHeaderRedacted(String name) =>
      redactHeaders && _matches(redactedHeaders, name);

  /// Whether the query parameter [name] is masked under these settings.
  /// Case insensitive, whatever case the keys were given in.
  bool isQueryParamRedacted(String name) =>
      redactQuery && _matches(redactedQueryParams, name);

  static bool _matches(List<String> keys, String name) {
    final lower = name.toLowerCase();
    return keys.any((key) => key.toLowerCase() == lower);
  }

  static const int minRequests = 10;
  static const int maxRequestsLimit = 10000;

  /// Quick picks offered next to the max requests input.
  static const List<int> maxRequestsPresets = [100, 200, 500, 1000];

  static const Duration minNotificationDuration = Duration(seconds: 2);
  static const Duration maxNotificationDuration = Duration(seconds: 15);
}
