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

@JsonKey(name: 'max_requests') int get maxRequests;@JsonKey(name: 'max_body_bytes', readValue: _readMaxBodyBytes, fromJson: _maxBodyBytesFromJson) int? get maxBodyBytes;@JsonKey(name: 'retention') DioLensRetention get retention;@JsonKey(name: 'show_notification') bool get showNotification;@JsonKey(name: 'notification_position') DioLensNotificationPosition get notificationPosition;@JsonKey(name: 'notification_duration') Duration get notificationDuration;@JsonKey(name: 'show_bubble') bool get showBubble;@JsonKey(name: 'bubble_position') DioLensBubblePosition get bubblePosition;@JsonKey(name: 'redact_headers') bool get redactHeaders;@JsonKey(name: 'redacted_headers') List<String> get redactedHeaders;@JsonKey(name: 'redact_query') bool get redactQuery;@JsonKey(name: 'redacted_query_params') List<String> get redactedQueryParams;@JsonKey(name: 'theme_mode') ThemeMode get themeMode;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DioLensSettings&&(identical(other.maxRequests, _this.maxRequests) || other.maxRequests == _this.maxRequests)&&(identical(other.maxBodyBytes, _this.maxBodyBytes) || other.maxBodyBytes == _this.maxBodyBytes)&&(identical(other.retention, _this.retention) || other.retention == _this.retention)&&(identical(other.showNotification, _this.showNotification) || other.showNotification == _this.showNotification)&&(identical(other.notificationPosition, _this.notificationPosition) || other.notificationPosition == _this.notificationPosition)&&(identical(other.notificationDuration, _this.notificationDuration) || other.notificationDuration == _this.notificationDuration)&&(identical(other.showBubble, _this.showBubble) || other.showBubble == _this.showBubble)&&(identical(other.bubblePosition, _this.bubblePosition) || other.bubblePosition == _this.bubblePosition)&&(identical(other.redactHeaders, _this.redactHeaders) || other.redactHeaders == _this.redactHeaders)&&const DeepCollectionEquality().equals(other.redactedHeaders, _this.redactedHeaders)&&(identical(other.redactQuery, _this.redactQuery) || other.redactQuery == _this.redactQuery)&&const DeepCollectionEquality().equals(other.redactedQueryParams, _this.redactedQueryParams)&&(identical(other.themeMode, _this.themeMode) || other.themeMode == _this.themeMode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DioLensSettings;
  return Object.hash(runtimeType,_this.maxRequests,_this.maxBodyBytes,_this.retention,_this.showNotification,_this.notificationPosition,_this.notificationDuration,_this.showBubble,_this.bubblePosition,_this.redactHeaders,const DeepCollectionEquality().hash(_this.redactedHeaders),_this.redactQuery,const DeepCollectionEquality().hash(_this.redactedQueryParams),_this.themeMode);
}

@override
String toString() {
  final _this = this as DioLensSettings;
  return 'DioLensSettings(maxRequests: ${_this.maxRequests}, maxBodyBytes: ${_this.maxBodyBytes}, retention: ${_this.retention}, showNotification: ${_this.showNotification}, notificationPosition: ${_this.notificationPosition}, notificationDuration: ${_this.notificationDuration}, showBubble: ${_this.showBubble}, bubblePosition: ${_this.bubblePosition}, redactHeaders: ${_this.redactHeaders}, redactedHeaders: ${_this.redactedHeaders}, redactQuery: ${_this.redactQuery}, redactedQueryParams: ${_this.redactedQueryParams}, themeMode: ${_this.themeMode})';
}


}

/// @nodoc
abstract mixin class $DioLensSettingsCopyWith<$Res>  {
  factory $DioLensSettingsCopyWith(DioLensSettings value, $Res Function(DioLensSettings) _then) = _$DioLensSettingsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'max_requests') int maxRequests,@JsonKey(name: 'max_body_bytes', readValue: _readMaxBodyBytes, fromJson: _maxBodyBytesFromJson) int? maxBodyBytes,@JsonKey(name: 'retention') DioLensRetention retention,@JsonKey(name: 'show_notification') bool showNotification,@JsonKey(name: 'notification_position') DioLensNotificationPosition notificationPosition,@JsonKey(name: 'notification_duration') Duration notificationDuration,@JsonKey(name: 'show_bubble') bool showBubble,@JsonKey(name: 'bubble_position') DioLensBubblePosition bubblePosition,@JsonKey(name: 'redact_headers') bool redactHeaders,@JsonKey(name: 'redacted_headers') List<String> redactedHeaders,@JsonKey(name: 'redact_query') bool redactQuery,@JsonKey(name: 'redacted_query_params') List<String> redactedQueryParams,@JsonKey(name: 'theme_mode') ThemeMode themeMode
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
@pragma('vm:prefer-inline') @override $Res call({Object? maxRequests = null,Object? maxBodyBytes = freezed,Object? retention = null,Object? showNotification = null,Object? notificationPosition = null,Object? notificationDuration = null,Object? showBubble = null,Object? bubblePosition = null,Object? redactHeaders = null,Object? redactedHeaders = null,Object? redactQuery = null,Object? redactedQueryParams = null,Object? themeMode = null,}) {
  return _then(DioLensSettings(
maxRequests: null == maxRequests ? _self.maxRequests : maxRequests // ignore: cast_nullable_to_non_nullable
as int,maxBodyBytes: freezed == maxBodyBytes ? _self.maxBodyBytes : maxBodyBytes // ignore: cast_nullable_to_non_nullable
as int?,retention: null == retention ? _self.retention : retention // ignore: cast_nullable_to_non_nullable
as DioLensRetention,showNotification: null == showNotification ? _self.showNotification : showNotification // ignore: cast_nullable_to_non_nullable
as bool,notificationPosition: null == notificationPosition ? _self.notificationPosition : notificationPosition // ignore: cast_nullable_to_non_nullable
as DioLensNotificationPosition,notificationDuration: null == notificationDuration ? _self.notificationDuration : notificationDuration // ignore: cast_nullable_to_non_nullable
as Duration,showBubble: null == showBubble ? _self.showBubble : showBubble // ignore: cast_nullable_to_non_nullable
as bool,bubblePosition: null == bubblePosition ? _self.bubblePosition : bubblePosition // ignore: cast_nullable_to_non_nullable
as DioLensBubblePosition,redactHeaders: null == redactHeaders ? _self.redactHeaders : redactHeaders // ignore: cast_nullable_to_non_nullable
as bool,redactedHeaders: null == redactedHeaders ? _self.redactedHeaders : redactedHeaders // ignore: cast_nullable_to_non_nullable
as List<String>,redactQuery: null == redactQuery ? _self.redactQuery : redactQuery // ignore: cast_nullable_to_non_nullable
as bool,redactedQueryParams: null == redactedQueryParams ? _self.redactedQueryParams : redactedQueryParams // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'max_requests')  int maxRequests, @JsonKey(name: 'max_body_bytes', readValue: _readMaxBodyBytes, fromJson: _maxBodyBytesFromJson)  int? maxBodyBytes, @JsonKey(name: 'retention')  DioLensRetention retention, @JsonKey(name: 'show_notification')  bool showNotification, @JsonKey(name: 'notification_position')  DioLensNotificationPosition notificationPosition, @JsonKey(name: 'notification_duration')  Duration notificationDuration, @JsonKey(name: 'show_bubble')  bool showBubble, @JsonKey(name: 'bubble_position')  DioLensBubblePosition bubblePosition, @JsonKey(name: 'redact_headers')  bool redactHeaders, @JsonKey(name: 'redacted_headers')  List<String> redactedHeaders, @JsonKey(name: 'redact_query')  bool redactQuery, @JsonKey(name: 'redacted_query_params')  List<String> redactedQueryParams, @JsonKey(name: 'theme_mode')  ThemeMode themeMode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DioLensSettings() when $default != null:
return $default(_that.maxRequests,_that.maxBodyBytes,_that.retention,_that.showNotification,_that.notificationPosition,_that.notificationDuration,_that.showBubble,_that.bubblePosition,_that.redactHeaders,_that.redactedHeaders,_that.redactQuery,_that.redactedQueryParams,_that.themeMode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'max_requests')  int maxRequests, @JsonKey(name: 'max_body_bytes', readValue: _readMaxBodyBytes, fromJson: _maxBodyBytesFromJson)  int? maxBodyBytes, @JsonKey(name: 'retention')  DioLensRetention retention, @JsonKey(name: 'show_notification')  bool showNotification, @JsonKey(name: 'notification_position')  DioLensNotificationPosition notificationPosition, @JsonKey(name: 'notification_duration')  Duration notificationDuration, @JsonKey(name: 'show_bubble')  bool showBubble, @JsonKey(name: 'bubble_position')  DioLensBubblePosition bubblePosition, @JsonKey(name: 'redact_headers')  bool redactHeaders, @JsonKey(name: 'redacted_headers')  List<String> redactedHeaders, @JsonKey(name: 'redact_query')  bool redactQuery, @JsonKey(name: 'redacted_query_params')  List<String> redactedQueryParams, @JsonKey(name: 'theme_mode')  ThemeMode themeMode)  $default,) {final _that = this;
switch (_that) {
case _DioLensSettings():
return $default(_that.maxRequests,_that.maxBodyBytes,_that.retention,_that.showNotification,_that.notificationPosition,_that.notificationDuration,_that.showBubble,_that.bubblePosition,_that.redactHeaders,_that.redactedHeaders,_that.redactQuery,_that.redactedQueryParams,_that.themeMode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'max_requests')  int maxRequests, @JsonKey(name: 'max_body_bytes', readValue: _readMaxBodyBytes, fromJson: _maxBodyBytesFromJson)  int? maxBodyBytes, @JsonKey(name: 'retention')  DioLensRetention retention, @JsonKey(name: 'show_notification')  bool showNotification, @JsonKey(name: 'notification_position')  DioLensNotificationPosition notificationPosition, @JsonKey(name: 'notification_duration')  Duration notificationDuration, @JsonKey(name: 'show_bubble')  bool showBubble, @JsonKey(name: 'bubble_position')  DioLensBubblePosition bubblePosition, @JsonKey(name: 'redact_headers')  bool redactHeaders, @JsonKey(name: 'redacted_headers')  List<String> redactedHeaders, @JsonKey(name: 'redact_query')  bool redactQuery, @JsonKey(name: 'redacted_query_params')  List<String> redactedQueryParams, @JsonKey(name: 'theme_mode')  ThemeMode themeMode)?  $default,) {final _that = this;
switch (_that) {
case _DioLensSettings() when $default != null:
return $default(_that.maxRequests,_that.maxBodyBytes,_that.retention,_that.showNotification,_that.notificationPosition,_that.notificationDuration,_that.showBubble,_that.bubblePosition,_that.redactHeaders,_that.redactedHeaders,_that.redactQuery,_that.redactedQueryParams,_that.themeMode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DioLensSettings extends DioLensSettings {
  const _DioLensSettings({@JsonKey(name: 'max_requests') this.maxRequests = 500, @JsonKey(name: 'max_body_bytes', readValue: _readMaxBodyBytes, fromJson: _maxBodyBytesFromJson) this.maxBodyBytes = DioLensSettings.defaultMaxBodyBytes, @JsonKey(name: 'retention') this.retention = DioLensRetention.oneDay, @JsonKey(name: 'show_notification') this.showNotification = true, @JsonKey(name: 'notification_position') this.notificationPosition = DioLensNotificationPosition.top, @JsonKey(name: 'notification_duration') this.notificationDuration = const Duration(seconds: 4), @JsonKey(name: 'show_bubble') this.showBubble = true, @JsonKey(name: 'bubble_position') this.bubblePosition = DioLensBubblePosition.bottomEnd, @JsonKey(name: 'redact_headers') this.redactHeaders = true, @JsonKey(name: 'redacted_headers')  List<String> redactedHeaders = DioLensSettings.defaultRedactedHeaders, @JsonKey(name: 'redact_query') this.redactQuery = true, @JsonKey(name: 'redacted_query_params')  List<String> redactedQueryParams = DioLensSettings.defaultRedactedQueryParams, @JsonKey(name: 'theme_mode') this.themeMode = ThemeMode.dark}): assert(maxRequests >= DioLensSettings.minRequests && maxRequests <= DioLensSettings.maxRequestsLimit, 'maxRequests must be between 10 and 10000'),assert(maxBodyBytes == null || maxBodyBytes > 0, 'maxBodyBytes must be positive, or null for unlimited'),_redactedHeaders = redactedHeaders,_redactedQueryParams = redactedQueryParams,super._();
  factory _DioLensSettings.fromJson(Map<String, dynamic> json) => _$DioLensSettingsFromJson(json);

@override@JsonKey(name: 'max_requests') final  int maxRequests;
@override@JsonKey(name: 'max_body_bytes', readValue: _readMaxBodyBytes, fromJson: _maxBodyBytesFromJson) final  int? maxBodyBytes;
@override@JsonKey(name: 'retention') final  DioLensRetention retention;
@override@JsonKey(name: 'show_notification') final  bool showNotification;
@override@JsonKey(name: 'notification_position') final  DioLensNotificationPosition notificationPosition;
@override@JsonKey(name: 'notification_duration') final  Duration notificationDuration;
@override@JsonKey(name: 'show_bubble') final  bool showBubble;
@override@JsonKey(name: 'bubble_position') final  DioLensBubblePosition bubblePosition;
@override@JsonKey(name: 'redact_headers') final  bool redactHeaders;
 final  List<String> _redactedHeaders;
@override@JsonKey(name: 'redacted_headers') List<String> get redactedHeaders {
  if (_redactedHeaders is EqualUnmodifiableListView) return _redactedHeaders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_redactedHeaders);
}

@override@JsonKey(name: 'redact_query') final  bool redactQuery;
 final  List<String> _redactedQueryParams;
@override@JsonKey(name: 'redacted_query_params') List<String> get redactedQueryParams {
  if (_redactedQueryParams is EqualUnmodifiableListView) return _redactedQueryParams;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_redactedQueryParams);
}

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
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DioLensSettings&&(identical(other.maxRequests, maxRequests) || other.maxRequests == maxRequests)&&(identical(other.maxBodyBytes, maxBodyBytes) || other.maxBodyBytes == maxBodyBytes)&&(identical(other.retention, retention) || other.retention == retention)&&(identical(other.showNotification, showNotification) || other.showNotification == showNotification)&&(identical(other.notificationPosition, notificationPosition) || other.notificationPosition == notificationPosition)&&(identical(other.notificationDuration, notificationDuration) || other.notificationDuration == notificationDuration)&&(identical(other.showBubble, showBubble) || other.showBubble == showBubble)&&(identical(other.bubblePosition, bubblePosition) || other.bubblePosition == bubblePosition)&&(identical(other.redactHeaders, redactHeaders) || other.redactHeaders == redactHeaders)&&const DeepCollectionEquality().equals(other.redactedHeaders, _redactedHeaders)&&(identical(other.redactQuery, redactQuery) || other.redactQuery == redactQuery)&&const DeepCollectionEquality().equals(other.redactedQueryParams, _redactedQueryParams)&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,maxRequests,maxBodyBytes,retention,showNotification,notificationPosition,notificationDuration,showBubble,bubblePosition,redactHeaders,const DeepCollectionEquality().hash(_redactedHeaders),redactQuery,const DeepCollectionEquality().hash(_redactedQueryParams),themeMode);
}

@override
String toString() {
    return 'DioLensSettings(maxRequests: $maxRequests, maxBodyBytes: $maxBodyBytes, retention: $retention, showNotification: $showNotification, notificationPosition: $notificationPosition, notificationDuration: $notificationDuration, showBubble: $showBubble, bubblePosition: $bubblePosition, redactHeaders: $redactHeaders, redactedHeaders: $redactedHeaders, redactQuery: $redactQuery, redactedQueryParams: $redactedQueryParams, themeMode: $themeMode)';
}


}

/// @nodoc
abstract mixin class _$DioLensSettingsCopyWith<$Res> implements $DioLensSettingsCopyWith<$Res> {
  factory _$DioLensSettingsCopyWith(_DioLensSettings value, $Res Function(_DioLensSettings) _then) = __$DioLensSettingsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'max_requests') int maxRequests,@JsonKey(name: 'max_body_bytes', readValue: _readMaxBodyBytes, fromJson: _maxBodyBytesFromJson) int? maxBodyBytes,@JsonKey(name: 'retention') DioLensRetention retention,@JsonKey(name: 'show_notification') bool showNotification,@JsonKey(name: 'notification_position') DioLensNotificationPosition notificationPosition,@JsonKey(name: 'notification_duration') Duration notificationDuration,@JsonKey(name: 'show_bubble') bool showBubble,@JsonKey(name: 'bubble_position') DioLensBubblePosition bubblePosition,@JsonKey(name: 'redact_headers') bool redactHeaders,@JsonKey(name: 'redacted_headers') List<String> redactedHeaders,@JsonKey(name: 'redact_query') bool redactQuery,@JsonKey(name: 'redacted_query_params') List<String> redactedQueryParams,@JsonKey(name: 'theme_mode') ThemeMode themeMode
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
@override @pragma('vm:prefer-inline') $Res call({Object? maxRequests = null,Object? maxBodyBytes = freezed,Object? retention = null,Object? showNotification = null,Object? notificationPosition = null,Object? notificationDuration = null,Object? showBubble = null,Object? bubblePosition = null,Object? redactHeaders = null,Object? redactedHeaders = null,Object? redactQuery = null,Object? redactedQueryParams = null,Object? themeMode = null,}) {
  return _then(_DioLensSettings(
maxRequests: null == maxRequests ? _self.maxRequests : maxRequests // ignore: cast_nullable_to_non_nullable
as int,maxBodyBytes: freezed == maxBodyBytes ? _self.maxBodyBytes : maxBodyBytes // ignore: cast_nullable_to_non_nullable
as int?,retention: null == retention ? _self.retention : retention // ignore: cast_nullable_to_non_nullable
as DioLensRetention,showNotification: null == showNotification ? _self.showNotification : showNotification // ignore: cast_nullable_to_non_nullable
as bool,notificationPosition: null == notificationPosition ? _self.notificationPosition : notificationPosition // ignore: cast_nullable_to_non_nullable
as DioLensNotificationPosition,notificationDuration: null == notificationDuration ? _self.notificationDuration : notificationDuration // ignore: cast_nullable_to_non_nullable
as Duration,showBubble: null == showBubble ? _self.showBubble : showBubble // ignore: cast_nullable_to_non_nullable
as bool,bubblePosition: null == bubblePosition ? _self.bubblePosition : bubblePosition // ignore: cast_nullable_to_non_nullable
as DioLensBubblePosition,redactHeaders: null == redactHeaders ? _self.redactHeaders : redactHeaders // ignore: cast_nullable_to_non_nullable
as bool,redactedHeaders: null == redactedHeaders ? _self._redactedHeaders : redactedHeaders // ignore: cast_nullable_to_non_nullable
as List<String>,redactQuery: null == redactQuery ? _self.redactQuery : redactQuery // ignore: cast_nullable_to_non_nullable
as bool,redactedQueryParams: null == redactedQueryParams ? _self._redactedQueryParams : redactedQueryParams // ignore: cast_nullable_to_non_nullable
as List<String>,themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as ThemeMode,
  ));
}


}

// dart format on
