import 'package:flutter/material.dart' show ThemeMode;
import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/dio_lens_bubble_position.dart';
import '../enums/dio_lens_notification_position.dart';
import '../enums/dio_lens_retention.dart';

part 'dio_lens_settings.freezed.dart';
part 'dio_lens_settings.g.dart';

const int _unlimitedBodyBytes = -1;

Object? _readMaxBodyBytes(Map<dynamic, dynamic> json, String key) =>
    json.containsKey(key) ? json[key] ?? _unlimitedBodyBytes : null;

int? _maxBodyBytesFromJson(Object? value) =>
    value == _unlimitedBodyBytes ? null : (value as num?)?.toInt();

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
    @JsonKey(name: 'max_requests') @Default(500) int maxRequests,

    @JsonKey(
      name: 'max_body_bytes',

      readValue: _readMaxBodyBytes,

      fromJson: _maxBodyBytesFromJson,
    )
    @Default(DioLensSettings.defaultMaxBodyBytes)
    int? maxBodyBytes,
    @JsonKey(name: 'retention')
    @Default(DioLensRetention.oneDay)
    DioLensRetention retention,

    @JsonKey(name: 'show_notification') @Default(true) bool showNotification,

    @JsonKey(name: 'notification_position')
    @Default(DioLensNotificationPosition.top)
    DioLensNotificationPosition notificationPosition,

    @JsonKey(name: 'notification_duration')
    @Default(Duration(seconds: 4))
    Duration notificationDuration,

    @JsonKey(name: 'show_bubble') @Default(true) bool showBubble,
    @JsonKey(name: 'bubble_position')
    @Default(DioLensBubblePosition.bottomEnd)
    DioLensBubblePosition bubblePosition,

    @JsonKey(name: 'redact_headers') @Default(true) bool redactHeaders,

    @JsonKey(name: 'redacted_headers')
    @Default(DioLensSettings.defaultRedactedHeaders)
    List<String> redactedHeaders,

    @JsonKey(name: 'redact_query') @Default(true) bool redactQuery,

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

  bool isHeaderRedacted(String name) =>
      redactHeaders && _matches(redactedHeaders, name);

  bool isQueryParamRedacted(String name) =>
      redactQuery && _matches(redactedQueryParams, name);

  static bool _matches(List<String> keys, String name) {
    final lower = name.toLowerCase();
    return keys.any((key) => key.toLowerCase() == lower);
  }

  static const int defaultMaxBodyBytes = 1024 * 1024;

  static const int minRequests = 10;
  static const int maxRequestsLimit = 10000;

  static const List<int> maxRequestsPresets = [100, 200, 500, 1000];

  static const Duration minNotificationDuration = Duration(seconds: 2);
  static const Duration maxNotificationDuration = Duration(seconds: 15);
}
