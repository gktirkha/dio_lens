// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dio_lens_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DioLensSettings {

/// Most requests kept; the oldest are removed past this limit (10 to
/// 10,000).
@JsonKey(name: 'max_requests') int get maxRequests;/// Largest body kept, in bytes (see `DioLensSizeUnit`). Bigger text and
/// JSON bodies are stored truncated, bigger images without a preview; sizes
/// still report the full body. Null keeps every body whole.
@JsonKey(name: 'max_body_bytes', readValue: _readMaxBodyBytes, fromJson: _maxBodyBytesFromJson) int? get maxBodyBytes;/// How long captured requests are kept on the device.
@JsonKey(name: 'retention') DioLensRetention get retention;/// Show a banner over the host app when a request finishes.
@JsonKey(name: 'show_notification') bool get showNotification;/// Where the request-finished banner appears.
@JsonKey(name: 'notification_position') DioLensNotificationPosition get notificationPosition;/// How long the request-finished banner stays on screen (2 to 15 seconds).
@JsonKey(name: 'notification_duration') Duration get notificationDuration;/// Show the floating bubble that opens Dio Lens.
@JsonKey(name: 'show_bubble') bool get showBubble;/// Corner where the floating bubble starts.
@JsonKey(name: 'bubble_position') DioLensBubblePosition get bubblePosition;/// Code only: the build modes in which [redactionTargets], [redactedHeaders]
/// and [redactedQueryParams] stay as given to `DioLens.init`; stored
/// settings, the settings sheet and `DioLens.updateSettings` can't change
/// them there. Never locked by default. Never stored.
@JsonKey(includeFromJson: false, includeToJson: false) DioLensMode get lockRedaction;/// Code only: the build modes in which captured requests can be deleted
/// from the UI, one by one or all at once. Elsewhere the Delete and Clear
/// all buttons are hidden; `DioLens.clear` and retention still remove
/// requests. Always allowed by default. Never stored, and stored settings,
/// the settings sheet and `DioLens.updateSettings` can't change it.
@JsonKey(includeFromJson: false, includeToJson: false) DioLensMode get allowDelete;/// The kinds of delete that ask first: deleting one request, clearing
/// all of them, both or neither. Clearing all asks by default.
@JsonKey(name: 'delete_confirmation') Set<DioLensDeleteConfirmation> get deleteConfirmation;/// Where the values of [redactedHeaders] and [redactedQueryParams] are
/// masked: any of the UI, the clipboard, console logs and external
/// (exports and shared reports). Empty turns redaction off.
@JsonKey(name: 'redaction_targets', readValue: _readRedactionTargets) Set<DioLensRedactionTarget> get redactionTargets;/// Header names masked for [redactionTargets], in requests and
/// responses; matched case-insensitively.
@JsonKey(name: 'redacted_headers') List<String> get redactedHeaders;/// Query parameter names masked for [redactionTargets]; matched
/// case-insensitively.
@JsonKey(name: 'redacted_query_params') List<String> get redactedQueryParams;/// Theme of the Dio Lens UI: light, dark or system.
@JsonKey(name: 'theme_mode') ThemeMode get themeMode;
/// Create a copy of DioLensSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DioLensSettingsCopyWith<DioLensSettings> get copyWith => _$DioLensSettingsCopyWithImpl<DioLensSettings>(this as DioLensSettings, _$identity);

  /// Serializes this DioLensSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DioLensSettings;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DioLensSettings&&(identical(other.maxRequests, _this.maxRequests) || other.maxRequests == _this.maxRequests)&&(identical(other.maxBodyBytes, _this.maxBodyBytes) || other.maxBodyBytes == _this.maxBodyBytes)&&(identical(other.retention, _this.retention) || other.retention == _this.retention)&&(identical(other.showNotification, _this.showNotification) || other.showNotification == _this.showNotification)&&(identical(other.notificationPosition, _this.notificationPosition) || other.notificationPosition == _this.notificationPosition)&&(identical(other.notificationDuration, _this.notificationDuration) || other.notificationDuration == _this.notificationDuration)&&(identical(other.showBubble, _this.showBubble) || other.showBubble == _this.showBubble)&&(identical(other.bubblePosition, _this.bubblePosition) || other.bubblePosition == _this.bubblePosition)&&(identical(other.lockRedaction, _this.lockRedaction) || other.lockRedaction == _this.lockRedaction)&&(identical(other.allowDelete, _this.allowDelete) || other.allowDelete == _this.allowDelete)&&const DeepCollectionEquality().equals(other.deleteConfirmation, _this.deleteConfirmation)&&const DeepCollectionEquality().equals(other.redactionTargets, _this.redactionTargets)&&const DeepCollectionEquality().equals(other.redactedHeaders, _this.redactedHeaders)&&const DeepCollectionEquality().equals(other.redactedQueryParams, _this.redactedQueryParams)&&(identical(other.themeMode, _this.themeMode) || other.themeMode == _this.themeMode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DioLensSettings;
  return Object.hash(runtimeType,_this.maxRequests,_this.maxBodyBytes,_this.retention,_this.showNotification,_this.notificationPosition,_this.notificationDuration,_this.showBubble,_this.bubblePosition,_this.lockRedaction,_this.allowDelete,const DeepCollectionEquality().hash(_this.deleteConfirmation),const DeepCollectionEquality().hash(_this.redactionTargets),const DeepCollectionEquality().hash(_this.redactedHeaders),const DeepCollectionEquality().hash(_this.redactedQueryParams),_this.themeMode);
}

@override
String toString() {
  final _this = this as DioLensSettings;
  return 'DioLensSettings(maxRequests: ${_this.maxRequests}, maxBodyBytes: ${_this.maxBodyBytes}, retention: ${_this.retention}, showNotification: ${_this.showNotification}, notificationPosition: ${_this.notificationPosition}, notificationDuration: ${_this.notificationDuration}, showBubble: ${_this.showBubble}, bubblePosition: ${_this.bubblePosition}, lockRedaction: ${_this.lockRedaction}, allowDelete: ${_this.allowDelete}, deleteConfirmation: ${_this.deleteConfirmation}, redactionTargets: ${_this.redactionTargets}, redactedHeaders: ${_this.redactedHeaders}, redactedQueryParams: ${_this.redactedQueryParams}, themeMode: ${_this.themeMode})';
}


}

/// @nodoc
abstract mixin class $DioLensSettingsCopyWith<$Res>  {
  factory $DioLensSettingsCopyWith(DioLensSettings value, $Res Function(DioLensSettings) _then) = _$DioLensSettingsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'max_requests') int maxRequests,@JsonKey(name: 'max_body_bytes', readValue: _readMaxBodyBytes, fromJson: _maxBodyBytesFromJson) int? maxBodyBytes,@JsonKey(name: 'retention') DioLensRetention retention,@JsonKey(name: 'show_notification') bool showNotification,@JsonKey(name: 'notification_position') DioLensNotificationPosition notificationPosition,@JsonKey(name: 'notification_duration') Duration notificationDuration,@JsonKey(name: 'show_bubble') bool showBubble,@JsonKey(name: 'bubble_position') DioLensBubblePosition bubblePosition,@JsonKey(includeFromJson: false, includeToJson: false) DioLensMode lockRedaction,@JsonKey(includeFromJson: false, includeToJson: false) DioLensMode allowDelete,@JsonKey(name: 'delete_confirmation') Set<DioLensDeleteConfirmation> deleteConfirmation,@JsonKey(name: 'redaction_targets', readValue: _readRedactionTargets) Set<DioLensRedactionTarget> redactionTargets,@JsonKey(name: 'redacted_headers') List<String> redactedHeaders,@JsonKey(name: 'redacted_query_params') List<String> redactedQueryParams,@JsonKey(name: 'theme_mode') ThemeMode themeMode
});




}
/// @nodoc
class _$DioLensSettingsCopyWithImpl<$Res>
    implements $DioLensSettingsCopyWith<$Res> {
  _$DioLensSettingsCopyWithImpl(this._self, this._then);

  final DioLensSettings _self;
  final $Res Function(DioLensSettings) _then;

/// Create a copy of DioLensSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? maxRequests = null,Object? maxBodyBytes = freezed,Object? retention = null,Object? showNotification = null,Object? notificationPosition = null,Object? notificationDuration = null,Object? showBubble = null,Object? bubblePosition = null,Object? lockRedaction = null,Object? allowDelete = null,Object? deleteConfirmation = null,Object? redactionTargets = null,Object? redactedHeaders = null,Object? redactedQueryParams = null,Object? themeMode = null,}) {
  return _then(DioLensSettings(
maxRequests: null == maxRequests ? _self.maxRequests : maxRequests // ignore: cast_nullable_to_non_nullable
as int,maxBodyBytes: freezed == maxBodyBytes ? _self.maxBodyBytes : maxBodyBytes // ignore: cast_nullable_to_non_nullable
as int?,retention: null == retention ? _self.retention : retention // ignore: cast_nullable_to_non_nullable
as DioLensRetention,showNotification: null == showNotification ? _self.showNotification : showNotification // ignore: cast_nullable_to_non_nullable
as bool,notificationPosition: null == notificationPosition ? _self.notificationPosition : notificationPosition // ignore: cast_nullable_to_non_nullable
as DioLensNotificationPosition,notificationDuration: null == notificationDuration ? _self.notificationDuration : notificationDuration // ignore: cast_nullable_to_non_nullable
as Duration,showBubble: null == showBubble ? _self.showBubble : showBubble // ignore: cast_nullable_to_non_nullable
as bool,bubblePosition: null == bubblePosition ? _self.bubblePosition : bubblePosition // ignore: cast_nullable_to_non_nullable
as DioLensBubblePosition,lockRedaction: null == lockRedaction ? _self.lockRedaction : lockRedaction // ignore: cast_nullable_to_non_nullable
as DioLensMode,allowDelete: null == allowDelete ? _self.allowDelete : allowDelete // ignore: cast_nullable_to_non_nullable
as DioLensMode,deleteConfirmation: null == deleteConfirmation ? _self.deleteConfirmation : deleteConfirmation // ignore: cast_nullable_to_non_nullable
as Set<DioLensDeleteConfirmation>,redactionTargets: null == redactionTargets ? _self.redactionTargets : redactionTargets // ignore: cast_nullable_to_non_nullable
as Set<DioLensRedactionTarget>,redactedHeaders: null == redactedHeaders ? _self.redactedHeaders : redactedHeaders // ignore: cast_nullable_to_non_nullable
as List<String>,redactedQueryParams: null == redactedQueryParams ? _self.redactedQueryParams : redactedQueryParams // ignore: cast_nullable_to_non_nullable
as List<String>,themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as ThemeMode,
  ));
}

}


/// Adds pattern-matching-related methods to [DioLensSettings].
extension DioLensSettingsPatterns on DioLensSettings {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DioLensSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DioLensSettings() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DioLensSettings value)  $default,){
final _that = this;
switch (_that) {
case _DioLensSettings():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DioLensSettings value)?  $default,){
final _that = this;
switch (_that) {
case _DioLensSettings() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'max_requests')  int maxRequests, @JsonKey(name: 'max_body_bytes', readValue: _readMaxBodyBytes, fromJson: _maxBodyBytesFromJson)  int? maxBodyBytes, @JsonKey(name: 'retention')  DioLensRetention retention, @JsonKey(name: 'show_notification')  bool showNotification, @JsonKey(name: 'notification_position')  DioLensNotificationPosition notificationPosition, @JsonKey(name: 'notification_duration')  Duration notificationDuration, @JsonKey(name: 'show_bubble')  bool showBubble, @JsonKey(name: 'bubble_position')  DioLensBubblePosition bubblePosition, @JsonKey(includeFromJson: false, includeToJson: false)  DioLensMode lockRedaction, @JsonKey(includeFromJson: false, includeToJson: false)  DioLensMode allowDelete, @JsonKey(name: 'delete_confirmation')  Set<DioLensDeleteConfirmation> deleteConfirmation, @JsonKey(name: 'redaction_targets', readValue: _readRedactionTargets)  Set<DioLensRedactionTarget> redactionTargets, @JsonKey(name: 'redacted_headers')  List<String> redactedHeaders, @JsonKey(name: 'redacted_query_params')  List<String> redactedQueryParams, @JsonKey(name: 'theme_mode')  ThemeMode themeMode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DioLensSettings() when $default != null:
return $default(_that.maxRequests,_that.maxBodyBytes,_that.retention,_that.showNotification,_that.notificationPosition,_that.notificationDuration,_that.showBubble,_that.bubblePosition,_that.lockRedaction,_that.allowDelete,_that.deleteConfirmation,_that.redactionTargets,_that.redactedHeaders,_that.redactedQueryParams,_that.themeMode);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'max_requests')  int maxRequests, @JsonKey(name: 'max_body_bytes', readValue: _readMaxBodyBytes, fromJson: _maxBodyBytesFromJson)  int? maxBodyBytes, @JsonKey(name: 'retention')  DioLensRetention retention, @JsonKey(name: 'show_notification')  bool showNotification, @JsonKey(name: 'notification_position')  DioLensNotificationPosition notificationPosition, @JsonKey(name: 'notification_duration')  Duration notificationDuration, @JsonKey(name: 'show_bubble')  bool showBubble, @JsonKey(name: 'bubble_position')  DioLensBubblePosition bubblePosition, @JsonKey(includeFromJson: false, includeToJson: false)  DioLensMode lockRedaction, @JsonKey(includeFromJson: false, includeToJson: false)  DioLensMode allowDelete, @JsonKey(name: 'delete_confirmation')  Set<DioLensDeleteConfirmation> deleteConfirmation, @JsonKey(name: 'redaction_targets', readValue: _readRedactionTargets)  Set<DioLensRedactionTarget> redactionTargets, @JsonKey(name: 'redacted_headers')  List<String> redactedHeaders, @JsonKey(name: 'redacted_query_params')  List<String> redactedQueryParams, @JsonKey(name: 'theme_mode')  ThemeMode themeMode)  $default,) {final _that = this;
switch (_that) {
case _DioLensSettings():
return $default(_that.maxRequests,_that.maxBodyBytes,_that.retention,_that.showNotification,_that.notificationPosition,_that.notificationDuration,_that.showBubble,_that.bubblePosition,_that.lockRedaction,_that.allowDelete,_that.deleteConfirmation,_that.redactionTargets,_that.redactedHeaders,_that.redactedQueryParams,_that.themeMode);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'max_requests')  int maxRequests, @JsonKey(name: 'max_body_bytes', readValue: _readMaxBodyBytes, fromJson: _maxBodyBytesFromJson)  int? maxBodyBytes, @JsonKey(name: 'retention')  DioLensRetention retention, @JsonKey(name: 'show_notification')  bool showNotification, @JsonKey(name: 'notification_position')  DioLensNotificationPosition notificationPosition, @JsonKey(name: 'notification_duration')  Duration notificationDuration, @JsonKey(name: 'show_bubble')  bool showBubble, @JsonKey(name: 'bubble_position')  DioLensBubblePosition bubblePosition, @JsonKey(includeFromJson: false, includeToJson: false)  DioLensMode lockRedaction, @JsonKey(includeFromJson: false, includeToJson: false)  DioLensMode allowDelete, @JsonKey(name: 'delete_confirmation')  Set<DioLensDeleteConfirmation> deleteConfirmation, @JsonKey(name: 'redaction_targets', readValue: _readRedactionTargets)  Set<DioLensRedactionTarget> redactionTargets, @JsonKey(name: 'redacted_headers')  List<String> redactedHeaders, @JsonKey(name: 'redacted_query_params')  List<String> redactedQueryParams, @JsonKey(name: 'theme_mode')  ThemeMode themeMode)?  $default,) {final _that = this;
switch (_that) {
case _DioLensSettings() when $default != null:
return $default(_that.maxRequests,_that.maxBodyBytes,_that.retention,_that.showNotification,_that.notificationPosition,_that.notificationDuration,_that.showBubble,_that.bubblePosition,_that.lockRedaction,_that.allowDelete,_that.deleteConfirmation,_that.redactionTargets,_that.redactedHeaders,_that.redactedQueryParams,_that.themeMode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DioLensSettings extends DioLensSettings {
  const _DioLensSettings({@JsonKey(name: 'max_requests') this.maxRequests = 500, @JsonKey(name: 'max_body_bytes', readValue: _readMaxBodyBytes, fromJson: _maxBodyBytesFromJson) this.maxBodyBytes = DioLensSettings.defaultMaxBodyBytes, @JsonKey(name: 'retention') this.retention = DioLensRetention.oneDay, @JsonKey(name: 'show_notification') this.showNotification = true, @JsonKey(name: 'notification_position') this.notificationPosition = DioLensNotificationPosition.top, @JsonKey(name: 'notification_duration') this.notificationDuration = const Duration(seconds: 4), @JsonKey(name: 'show_bubble') this.showBubble = true, @JsonKey(name: 'bubble_position') this.bubblePosition = DioLensBubblePosition.bottomEnd, @JsonKey(includeFromJson: false, includeToJson: false) this.lockRedaction = DioLensMode.disabled, @JsonKey(includeFromJson: false, includeToJson: false) this.allowDelete = DioLensMode.enabled, @JsonKey(name: 'delete_confirmation')  Set<DioLensDeleteConfirmation> deleteConfirmation = DioLensSettings.defaultDeleteConfirmation, @JsonKey(name: 'redaction_targets', readValue: _readRedactionTargets)  Set<DioLensRedactionTarget> redactionTargets = DioLensSettings.allRedactionTargets, @JsonKey(name: 'redacted_headers')  List<String> redactedHeaders = DioLensSettings.defaultRedactedHeaders, @JsonKey(name: 'redacted_query_params')  List<String> redactedQueryParams = DioLensSettings.defaultRedactedQueryParams, @JsonKey(name: 'theme_mode') this.themeMode = ThemeMode.dark}): assert(maxRequests >= DioLensSettings.minRequests && maxRequests <= DioLensSettings.maxRequestsLimit, 'maxRequests must be between 10 and 10000'),assert(maxBodyBytes == null || maxBodyBytes > 0, 'maxBodyBytes must be positive, or null for unlimited'),_deleteConfirmation = deleteConfirmation,_redactionTargets = redactionTargets,_redactedHeaders = redactedHeaders,_redactedQueryParams = redactedQueryParams,super._();
  factory _DioLensSettings.fromJson(Map<String, dynamic> json) => _$DioLensSettingsFromJson(json);

/// Most requests kept; the oldest are removed past this limit (10 to
/// 10,000).
@override@JsonKey(name: 'max_requests') final  int maxRequests;
/// Largest body kept, in bytes (see `DioLensSizeUnit`). Bigger text and
/// JSON bodies are stored truncated, bigger images without a preview; sizes
/// still report the full body. Null keeps every body whole.
@override@JsonKey(name: 'max_body_bytes', readValue: _readMaxBodyBytes, fromJson: _maxBodyBytesFromJson) final  int? maxBodyBytes;
/// How long captured requests are kept on the device.
@override@JsonKey(name: 'retention') final  DioLensRetention retention;
/// Show a banner over the host app when a request finishes.
@override@JsonKey(name: 'show_notification') final  bool showNotification;
/// Where the request-finished banner appears.
@override@JsonKey(name: 'notification_position') final  DioLensNotificationPosition notificationPosition;
/// How long the request-finished banner stays on screen (2 to 15 seconds).
@override@JsonKey(name: 'notification_duration') final  Duration notificationDuration;
/// Show the floating bubble that opens Dio Lens.
@override@JsonKey(name: 'show_bubble') final  bool showBubble;
/// Corner where the floating bubble starts.
@override@JsonKey(name: 'bubble_position') final  DioLensBubblePosition bubblePosition;
/// Code only: the build modes in which [redactionTargets], [redactedHeaders]
/// and [redactedQueryParams] stay as given to `DioLens.init`; stored
/// settings, the settings sheet and `DioLens.updateSettings` can't change
/// them there. Never locked by default. Never stored.
@override@JsonKey(includeFromJson: false, includeToJson: false) final  DioLensMode lockRedaction;
/// Code only: the build modes in which captured requests can be deleted
/// from the UI, one by one or all at once. Elsewhere the Delete and Clear
/// all buttons are hidden; `DioLens.clear` and retention still remove
/// requests. Always allowed by default. Never stored, and stored settings,
/// the settings sheet and `DioLens.updateSettings` can't change it.
@override@JsonKey(includeFromJson: false, includeToJson: false) final  DioLensMode allowDelete;
/// The kinds of delete that ask first: deleting one request, clearing
/// all of them, both or neither. Clearing all asks by default.
 final  Set<DioLensDeleteConfirmation> _deleteConfirmation;
/// The kinds of delete that ask first: deleting one request, clearing
/// all of them, both or neither. Clearing all asks by default.
@override@JsonKey(name: 'delete_confirmation') Set<DioLensDeleteConfirmation> get deleteConfirmation {
  if (_deleteConfirmation is EqualUnmodifiableSetView) return _deleteConfirmation;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_deleteConfirmation);
}

/// Where the values of [redactedHeaders] and [redactedQueryParams] are
/// masked: any of the UI, the clipboard, console logs and external
/// (exports and shared reports). Empty turns redaction off.
 final  Set<DioLensRedactionTarget> _redactionTargets;
/// Where the values of [redactedHeaders] and [redactedQueryParams] are
/// masked: any of the UI, the clipboard, console logs and external
/// (exports and shared reports). Empty turns redaction off.
@override@JsonKey(name: 'redaction_targets', readValue: _readRedactionTargets) Set<DioLensRedactionTarget> get redactionTargets {
  if (_redactionTargets is EqualUnmodifiableSetView) return _redactionTargets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_redactionTargets);
}

/// Header names masked for [redactionTargets], in requests and
/// responses; matched case-insensitively.
 final  List<String> _redactedHeaders;
/// Header names masked for [redactionTargets], in requests and
/// responses; matched case-insensitively.
@override@JsonKey(name: 'redacted_headers') List<String> get redactedHeaders {
  if (_redactedHeaders is EqualUnmodifiableListView) return _redactedHeaders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_redactedHeaders);
}

/// Query parameter names masked for [redactionTargets]; matched
/// case-insensitively.
 final  List<String> _redactedQueryParams;
/// Query parameter names masked for [redactionTargets]; matched
/// case-insensitively.
@override@JsonKey(name: 'redacted_query_params') List<String> get redactedQueryParams {
  if (_redactedQueryParams is EqualUnmodifiableListView) return _redactedQueryParams;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_redactedQueryParams);
}

/// Theme of the Dio Lens UI: light, dark or system.
@override@JsonKey(name: 'theme_mode') final  ThemeMode themeMode;

/// Create a copy of DioLensSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DioLensSettingsCopyWith<_DioLensSettings> get copyWith => __$DioLensSettingsCopyWithImpl<_DioLensSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DioLensSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DioLensSettings&&(identical(other.maxRequests, maxRequests) || other.maxRequests == maxRequests)&&(identical(other.maxBodyBytes, maxBodyBytes) || other.maxBodyBytes == maxBodyBytes)&&(identical(other.retention, retention) || other.retention == retention)&&(identical(other.showNotification, showNotification) || other.showNotification == showNotification)&&(identical(other.notificationPosition, notificationPosition) || other.notificationPosition == notificationPosition)&&(identical(other.notificationDuration, notificationDuration) || other.notificationDuration == notificationDuration)&&(identical(other.showBubble, showBubble) || other.showBubble == showBubble)&&(identical(other.bubblePosition, bubblePosition) || other.bubblePosition == bubblePosition)&&(identical(other.lockRedaction, lockRedaction) || other.lockRedaction == lockRedaction)&&(identical(other.allowDelete, allowDelete) || other.allowDelete == allowDelete)&&const DeepCollectionEquality().equals(other.deleteConfirmation, _deleteConfirmation)&&const DeepCollectionEquality().equals(other.redactionTargets, _redactionTargets)&&const DeepCollectionEquality().equals(other.redactedHeaders, _redactedHeaders)&&const DeepCollectionEquality().equals(other.redactedQueryParams, _redactedQueryParams)&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,maxRequests,maxBodyBytes,retention,showNotification,notificationPosition,notificationDuration,showBubble,bubblePosition,lockRedaction,allowDelete,const DeepCollectionEquality().hash(_deleteConfirmation),const DeepCollectionEquality().hash(_redactionTargets),const DeepCollectionEquality().hash(_redactedHeaders),const DeepCollectionEquality().hash(_redactedQueryParams),themeMode);
}

@override
String toString() {
    return 'DioLensSettings(maxRequests: $maxRequests, maxBodyBytes: $maxBodyBytes, retention: $retention, showNotification: $showNotification, notificationPosition: $notificationPosition, notificationDuration: $notificationDuration, showBubble: $showBubble, bubblePosition: $bubblePosition, lockRedaction: $lockRedaction, allowDelete: $allowDelete, deleteConfirmation: $deleteConfirmation, redactionTargets: $redactionTargets, redactedHeaders: $redactedHeaders, redactedQueryParams: $redactedQueryParams, themeMode: $themeMode)';
}


}

/// @nodoc
abstract mixin class _$DioLensSettingsCopyWith<$Res> implements $DioLensSettingsCopyWith<$Res> {
  factory _$DioLensSettingsCopyWith(_DioLensSettings value, $Res Function(_DioLensSettings) _then) = __$DioLensSettingsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'max_requests') int maxRequests,@JsonKey(name: 'max_body_bytes', readValue: _readMaxBodyBytes, fromJson: _maxBodyBytesFromJson) int? maxBodyBytes,@JsonKey(name: 'retention') DioLensRetention retention,@JsonKey(name: 'show_notification') bool showNotification,@JsonKey(name: 'notification_position') DioLensNotificationPosition notificationPosition,@JsonKey(name: 'notification_duration') Duration notificationDuration,@JsonKey(name: 'show_bubble') bool showBubble,@JsonKey(name: 'bubble_position') DioLensBubblePosition bubblePosition,@JsonKey(includeFromJson: false, includeToJson: false) DioLensMode lockRedaction,@JsonKey(includeFromJson: false, includeToJson: false) DioLensMode allowDelete,@JsonKey(name: 'delete_confirmation') Set<DioLensDeleteConfirmation> deleteConfirmation,@JsonKey(name: 'redaction_targets', readValue: _readRedactionTargets) Set<DioLensRedactionTarget> redactionTargets,@JsonKey(name: 'redacted_headers') List<String> redactedHeaders,@JsonKey(name: 'redacted_query_params') List<String> redactedQueryParams,@JsonKey(name: 'theme_mode') ThemeMode themeMode
});




}
/// @nodoc
class __$DioLensSettingsCopyWithImpl<$Res>
    implements _$DioLensSettingsCopyWith<$Res> {
  __$DioLensSettingsCopyWithImpl(this._self, this._then);

  final _DioLensSettings _self;
  final $Res Function(_DioLensSettings) _then;

/// Create a copy of DioLensSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? maxRequests = null,Object? maxBodyBytes = freezed,Object? retention = null,Object? showNotification = null,Object? notificationPosition = null,Object? notificationDuration = null,Object? showBubble = null,Object? bubblePosition = null,Object? lockRedaction = null,Object? allowDelete = null,Object? deleteConfirmation = null,Object? redactionTargets = null,Object? redactedHeaders = null,Object? redactedQueryParams = null,Object? themeMode = null,}) {
  return _then(_DioLensSettings(
maxRequests: null == maxRequests ? _self.maxRequests : maxRequests // ignore: cast_nullable_to_non_nullable
as int,maxBodyBytes: freezed == maxBodyBytes ? _self.maxBodyBytes : maxBodyBytes // ignore: cast_nullable_to_non_nullable
as int?,retention: null == retention ? _self.retention : retention // ignore: cast_nullable_to_non_nullable
as DioLensRetention,showNotification: null == showNotification ? _self.showNotification : showNotification // ignore: cast_nullable_to_non_nullable
as bool,notificationPosition: null == notificationPosition ? _self.notificationPosition : notificationPosition // ignore: cast_nullable_to_non_nullable
as DioLensNotificationPosition,notificationDuration: null == notificationDuration ? _self.notificationDuration : notificationDuration // ignore: cast_nullable_to_non_nullable
as Duration,showBubble: null == showBubble ? _self.showBubble : showBubble // ignore: cast_nullable_to_non_nullable
as bool,bubblePosition: null == bubblePosition ? _self.bubblePosition : bubblePosition // ignore: cast_nullable_to_non_nullable
as DioLensBubblePosition,lockRedaction: null == lockRedaction ? _self.lockRedaction : lockRedaction // ignore: cast_nullable_to_non_nullable
as DioLensMode,allowDelete: null == allowDelete ? _self.allowDelete : allowDelete // ignore: cast_nullable_to_non_nullable
as DioLensMode,deleteConfirmation: null == deleteConfirmation ? _self._deleteConfirmation : deleteConfirmation // ignore: cast_nullable_to_non_nullable
as Set<DioLensDeleteConfirmation>,redactionTargets: null == redactionTargets ? _self._redactionTargets : redactionTargets // ignore: cast_nullable_to_non_nullable
as Set<DioLensRedactionTarget>,redactedHeaders: null == redactedHeaders ? _self._redactedHeaders : redactedHeaders // ignore: cast_nullable_to_non_nullable
as List<String>,redactedQueryParams: null == redactedQueryParams ? _self._redactedQueryParams : redactedQueryParams // ignore: cast_nullable_to_non_nullable
as List<String>,themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as ThemeMode,
  ));
}


}

// dart format on
