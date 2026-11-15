import 'package:material_ui/material_ui.dart' show ThemeMode;
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/dio_lens_mode.dart';
import '../enums/dio_lens_bubble_position.dart';
import '../enums/dio_lens_notification_position.dart';
import '../enums/dio_lens_redaction_target.dart';
import '../enums/dio_lens_retention.dart';

part 'dio_lens_settings.freezed.dart';
part 'dio_lens_settings.g.dart';

const int _unlimitedBodyBytes = -1;

Object? _readMaxBodyBytes(Map<dynamic, dynamic> json, String key) =>
    json.containsKey(key) ? json[key] ?? _unlimitedBodyBytes : null;

int? _maxBodyBytesFromJson(Object? value) =>
    value == _unlimitedBodyBytes ? null : (value as num?)?.toInt();

/// Stored targets, or those of a `redaction_mode` stored before 2.0.0, e.g.
/// `ui_clipboard`, `all` or `none`.
Object? _readRedactionTargets(Map<dynamic, dynamic> json, String key) {
  if (json.containsKey(key)) return json[key];
  final mode = json['redaction_mode'];
  if (mode is! String) return null;
  return switch (mode) {
    'all' ||
    'redact' => [for (final t in DioLensRedactionTarget.values) t.name],
    'none' || 'off' => const <String>[],
    _ => [
      for (final t in DioLensRedactionTarget.values)
        if (mode.split('_').contains(t.name)) t.name,
    ],
  };
}

/// User-adjustable Dio Lens settings, persisted through `DioLensStorage`.
/// Values passed to `DioLens.init` are only the starting point: once the user
/// changes something in the settings screen, the stored copy wins.
@freezed
abstract class DioLensSettings with _$DioLensSettings {
  const DioLensSettings._();

  /// Creates settings; every value has a default.
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
    /// Most requests kept; the oldest are removed past this limit (10 to
    /// 10,000).
    @JsonKey(name: 'max_requests') @Default(500) int maxRequests,

    /// Largest body kept, in bytes (see `DioLensSizeUnit`). Bigger text and
    /// JSON bodies are stored truncated, bigger images without a preview; sizes
    /// still report the full body. Null keeps every body whole.
    @JsonKey(
      name: 'max_body_bytes',
      readValue: _readMaxBodyBytes,
      fromJson: _maxBodyBytesFromJson,
    )
    @Default(DioLensSettings.defaultMaxBodyBytes)
    int? maxBodyBytes,

    /// How long captured requests are kept on the device.
    @JsonKey(name: 'retention')
    @Default(DioLensRetention.oneDay)
    DioLensRetention retention,

    /// Show a banner over the host app when a request finishes.
    @JsonKey(name: 'show_notification') @Default(true) bool showNotification,

    /// Where the request-finished banner appears.
    @JsonKey(name: 'notification_position')
    @Default(DioLensNotificationPosition.top)
    DioLensNotificationPosition notificationPosition,

    /// How long the request-finished banner stays on screen (2 to 15 seconds).
    @JsonKey(name: 'notification_duration')
    @Default(Duration(seconds: 4))
    Duration notificationDuration,

    /// Show the floating bubble that opens Dio Lens.
    @JsonKey(name: 'show_bubble') @Default(true) bool showBubble,

    /// Corner where the floating bubble starts.
    @JsonKey(name: 'bubble_position')
    @Default(DioLensBubblePosition.bottomEnd)
    DioLensBubblePosition bubblePosition,

    /// Code only: the build modes in which [redactionTargets], [redactedHeaders]
    /// and [redactedQueryParams] stay as given to `DioLens.init`; stored
    /// settings, the settings sheet and `DioLens.updateSettings` can't change
    /// them there. Never locked by default. Never stored.
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(DioLensMode.none)
    DioLensMode lockRedaction,

    /// Where the values of [redactedHeaders] and [redactedQueryParams] are
    /// masked: any of the UI, the clipboard, console logs and external
    /// (exports and shared reports). Empty turns redaction off.
    @JsonKey(name: 'redaction_targets', readValue: _readRedactionTargets)
    @Default(DioLensSettings.allRedactionTargets)
    Set<DioLensRedactionTarget> redactionTargets,

    /// Header names masked for [redactionTargets], in requests and
    /// responses; matched case-insensitively.
    @JsonKey(name: 'redacted_headers')
    @Default(DioLensSettings.defaultRedactedHeaders)
    List<String> redactedHeaders,

    /// Query parameter names masked for [redactionTargets]; matched
    /// case-insensitively.
    @JsonKey(name: 'redacted_query_params')
    @Default(DioLensSettings.defaultRedactedQueryParams)
    List<String> redactedQueryParams,

    /// Theme of the Dio Lens UI: light, dark or system.
    @JsonKey(name: 'theme_mode') @Default(ThemeMode.dark) ThemeMode themeMode,
  }) = _DioLensSettings;

  /// Reads settings stored by `toJson`.
  factory DioLensSettings.fromJson(Map<String, dynamic> json) =>
      _$DioLensSettingsFromJson(json);

  /// Every redaction target; the default.
  static const Set<DioLensRedactionTarget> allRedactionTargets = {
    DioLensRedactionTarget.ui,
    DioLensRedactionTarget.clipboard,
    DioLensRedactionTarget.console,
    DioLensRedactionTarget.external,
  };

  /// Header names masked by default.
  static const List<String> defaultRedactedHeaders = [
    'authorization',
    'cookie',
    'set-cookie',
    'x-api-key',
  ];

  /// Query parameter names masked by default.
  static const List<String> defaultRedactedQueryParams = [
    'token',
    'apikey',
    'password',
  ];

  /// Whether the header [name] is masked for [target] (the UI by default).
  /// Case-insensitive.
  bool isHeaderRedacted(
    String name, {
    DioLensRedactionTarget target = DioLensRedactionTarget.ui,
  }) => redactionTargets.contains(target) && _matches(redactedHeaders, name);

  /// Whether the query parameter [name] is masked for [target] (the UI by
  /// default). Case-insensitive.
  bool isQueryParamRedacted(
    String name, {
    DioLensRedactionTarget target = DioLensRedactionTarget.ui,
  }) =>
      redactionTargets.contains(target) && _matches(redactedQueryParams, name);

  /// Whether redaction is locked by code in this build (see
  /// [lockRedaction]).
  bool get isRedactionLocked => lockRedaction.isEnabled;

  static bool _matches(List<String> keys, String name) {
    final lower = name.toLowerCase();
    return keys.any((key) => key.toLowerCase() == lower);
  }

  /// Default largest body kept: 1 MB.
  static const int defaultMaxBodyBytes = 1024 * 1024;

  /// Lowest allowed max requests.
  static const int minRequests = 10;

  /// Highest allowed max requests.
  static const int maxRequestsLimit = 10000;

  /// Quick picks offered next to the max requests input.
  static const List<int> maxRequestsPresets = [100, 200, 500, 1000];

  /// Shortest allowed banner duration.
  static const Duration minNotificationDuration = Duration(seconds: 2);

  /// Longest allowed banner duration.
  static const Duration maxNotificationDuration = Duration(seconds: 15);
}
