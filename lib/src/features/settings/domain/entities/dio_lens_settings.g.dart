// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dio_lens_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DioLensSettings _$DioLensSettingsFromJson(Map<String, dynamic> json) =>
    _DioLensSettings(
      maxRequests: (json['max_requests'] as num?)?.toInt() ?? 500,
      maxBodyBytes: (json['max_body_bytes'] as num?)?.toInt(),
      retention:
          $enumDecodeNullable(_$DioLensRetentionEnumMap, json['retention']) ??
          DioLensRetention.oneDay,
      showNotification: json['show_notification'] as bool? ?? true,
      notificationPosition:
          $enumDecodeNullable(
            _$DioLensNotificationPositionEnumMap,
            json['notification_position'],
          ) ??
          DioLensNotificationPosition.top,
      notificationDuration: json['notification_duration'] == null
          ? const Duration(seconds: 4)
          : Duration(
              microseconds: (json['notification_duration'] as num).toInt(),
            ),
      showBubble: json['show_bubble'] as bool? ?? true,
      bubblePosition:
          $enumDecodeNullable(
            _$DioLensBubblePositionEnumMap,
            json['bubble_position'],
          ) ??
          DioLensBubblePosition.bottomEnd,
      redactHeaders: json['redact_headers'] as bool? ?? true,
      redactedHeaders:
          (json['redacted_headers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          DioLensSettings.defaultRedactedHeaders,
      redactQuery: json['redact_query'] as bool? ?? true,
      redactedQueryParams:
          (json['redacted_query_params'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          DioLensSettings.defaultRedactedQueryParams,
      themeMode:
          $enumDecodeNullable(_$ThemeModeEnumMap, json['theme_mode']) ??
          ThemeMode.dark,
    );

Map<String, dynamic> _$DioLensSettingsToJson(
  _DioLensSettings instance,
) => <String, dynamic>{
  'max_requests': instance.maxRequests,
  'max_body_bytes': instance.maxBodyBytes,
  'retention': _$DioLensRetentionEnumMap[instance.retention]!,
  'show_notification': instance.showNotification,
  'notification_position':
      _$DioLensNotificationPositionEnumMap[instance.notificationPosition]!,
  'notification_duration': instance.notificationDuration.inMicroseconds,
  'show_bubble': instance.showBubble,
  'bubble_position': _$DioLensBubblePositionEnumMap[instance.bubblePosition]!,
  'redact_headers': instance.redactHeaders,
  'redacted_headers': instance.redactedHeaders,
  'redact_query': instance.redactQuery,
  'redacted_query_params': instance.redactedQueryParams,
  'theme_mode': _$ThemeModeEnumMap[instance.themeMode]!,
};

const _$DioLensRetentionEnumMap = {
  DioLensRetention.session: 'session',
  DioLensRetention.oneHour: 'one_hour',
  DioLensRetention.oneDay: 'one_day',
  DioLensRetention.sevenDays: 'seven_days',
  DioLensRetention.always: 'always',
};

const _$DioLensNotificationPositionEnumMap = {
  DioLensNotificationPosition.top: 'top',
  DioLensNotificationPosition.bottom: 'bottom',
};

const _$DioLensBubblePositionEnumMap = {
  DioLensBubblePosition.topStart: 'top_start',
  DioLensBubblePosition.topEnd: 'top_end',
  DioLensBubblePosition.bottomStart: 'bottom_start',
  DioLensBubblePosition.bottomEnd: 'bottom_end',
};

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};
