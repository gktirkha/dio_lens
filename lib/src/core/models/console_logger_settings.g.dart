// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'console_logger_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConsoleLoggerSettings _$ConsoleLoggerSettingsFromJson(
  Map<String, dynamic> json,
) => _ConsoleLoggerSettings(
  request: json['request'] as bool? ?? true,
  requestHeader: json['requestHeader'] as bool? ?? true,
  requestBody: json['requestBody'] as bool? ?? true,
  responseBody: json['responseBody'] as bool? ?? true,
  responseHeader: json['responseHeader'] as bool? ?? true,
  error: json['error'] as bool? ?? true,
  maxWidth: (json['maxWidth'] as num?)?.toInt() ?? 90,
  compact: json['compact'] as bool? ?? true,
  showStateInHeader: json['showStateInHeader'] as bool? ?? true,
  enabled: json['enabled'] as bool? ?? true,
);

Map<String, dynamic> _$ConsoleLoggerSettingsToJson(
  _ConsoleLoggerSettings instance,
) => <String, dynamic>{
  'request': instance.request,
  'requestHeader': instance.requestHeader,
  'requestBody': instance.requestBody,
  'responseBody': instance.responseBody,
  'responseHeader': instance.responseHeader,
  'error': instance.error,
  'maxWidth': instance.maxWidth,
  'compact': instance.compact,
  'showStateInHeader': instance.showStateInHeader,
  'enabled': instance.enabled,
};
