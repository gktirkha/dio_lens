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

/// Most requests kept; the oldest are removed past this limit.
@JsonKey(name: 'max_requests') int get maxRequests;@JsonKey(name: 'retention') DioLensRetention get retention;/// Show a banner over the host app when a request finishes.
@JsonKey(name: 'show_notification') bool get showNotification;/// How long the request-finished banner stays on screen.
@JsonKey(name: 'notification_duration') Duration get notificationDuration;/// Show the tap-to-open bubble over the host app.
@JsonKey(name: 'show_bubble') bool get showBubble;@JsonKey(name: 'bubble_position') DioLensBubblePosition get bubblePosition;/// Mask Authorization, Cookie and Set-Cookie values in the UI.
@JsonKey(name: 'redact_headers') bool get redactHeaders;@JsonKey(name: 'theme_mode') ThemeMode get themeMode;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DioLensSettings&&(identical(other.maxRequests, _this.maxRequests) || other.maxRequests == _this.maxRequests)&&(identical(other.retention, _this.retention) || other.retention == _this.retention)&&(identical(other.showNotification, _this.showNotification) || other.showNotification == _this.showNotification)&&(identical(other.notificationDuration, _this.notificationDuration) || other.notificationDuration == _this.notificationDuration)&&(identical(other.showBubble, _this.showBubble) || other.showBubble == _this.showBubble)&&(identical(other.bubblePosition, _this.bubblePosition) || other.bubblePosition == _this.bubblePosition)&&(identical(other.redactHeaders, _this.redactHeaders) || other.redactHeaders == _this.redactHeaders)&&(identical(other.themeMode, _this.themeMode) || other.themeMode == _this.themeMode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DioLensSettings;
  return Object.hash(runtimeType,_this.maxRequests,_this.retention,_this.showNotification,_this.notificationDuration,_this.showBubble,_this.bubblePosition,_this.redactHeaders,_this.themeMode);
}

@override
String toString() {
  final _this = this as DioLensSettings;
  return 'DioLensSettings(maxRequests: ${_this.maxRequests}, retention: ${_this.retention}, showNotification: ${_this.showNotification}, notificationDuration: ${_this.notificationDuration}, showBubble: ${_this.showBubble}, bubblePosition: ${_this.bubblePosition}, redactHeaders: ${_this.redactHeaders}, themeMode: ${_this.themeMode})';
}


}

/// @nodoc
abstract mixin class $DioLensSettingsCopyWith<$Res>  {
  factory $DioLensSettingsCopyWith(DioLensSettings value, $Res Function(DioLensSettings) _then) = _$DioLensSettingsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'max_requests') int maxRequests,@JsonKey(name: 'retention') DioLensRetention retention,@JsonKey(name: 'show_notification') bool showNotification,@JsonKey(name: 'notification_duration') Duration notificationDuration,@JsonKey(name: 'show_bubble') bool showBubble,@JsonKey(name: 'bubble_position') DioLensBubblePosition bubblePosition,@JsonKey(name: 'redact_headers') bool redactHeaders,@JsonKey(name: 'theme_mode') ThemeMode themeMode
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
@pragma('vm:prefer-inline') @override $Res call({Object? maxRequests = null,Object? retention = null,Object? showNotification = null,Object? notificationDuration = null,Object? showBubble = null,Object? bubblePosition = null,Object? redactHeaders = null,Object? themeMode = null,}) {
  return _then(DioLensSettings(
maxRequests: null == maxRequests ? _self.maxRequests : maxRequests // ignore: cast_nullable_to_non_nullable
as int,retention: null == retention ? _self.retention : retention // ignore: cast_nullable_to_non_nullable
as DioLensRetention,showNotification: null == showNotification ? _self.showNotification : showNotification // ignore: cast_nullable_to_non_nullable
as bool,notificationDuration: null == notificationDuration ? _self.notificationDuration : notificationDuration // ignore: cast_nullable_to_non_nullable
as Duration,showBubble: null == showBubble ? _self.showBubble : showBubble // ignore: cast_nullable_to_non_nullable
as bool,bubblePosition: null == bubblePosition ? _self.bubblePosition : bubblePosition // ignore: cast_nullable_to_non_nullable
as DioLensBubblePosition,redactHeaders: null == redactHeaders ? _self.redactHeaders : redactHeaders // ignore: cast_nullable_to_non_nullable
as bool,themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'max_requests')  int maxRequests, @JsonKey(name: 'retention')  DioLensRetention retention, @JsonKey(name: 'show_notification')  bool showNotification, @JsonKey(name: 'notification_duration')  Duration notificationDuration, @JsonKey(name: 'show_bubble')  bool showBubble, @JsonKey(name: 'bubble_position')  DioLensBubblePosition bubblePosition, @JsonKey(name: 'redact_headers')  bool redactHeaders, @JsonKey(name: 'theme_mode')  ThemeMode themeMode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DioLensSettings() when $default != null:
return $default(_that.maxRequests,_that.retention,_that.showNotification,_that.notificationDuration,_that.showBubble,_that.bubblePosition,_that.redactHeaders,_that.themeMode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'max_requests')  int maxRequests, @JsonKey(name: 'retention')  DioLensRetention retention, @JsonKey(name: 'show_notification')  bool showNotification, @JsonKey(name: 'notification_duration')  Duration notificationDuration, @JsonKey(name: 'show_bubble')  bool showBubble, @JsonKey(name: 'bubble_position')  DioLensBubblePosition bubblePosition, @JsonKey(name: 'redact_headers')  bool redactHeaders, @JsonKey(name: 'theme_mode')  ThemeMode themeMode)  $default,) {final _that = this;
switch (_that) {
case _DioLensSettings():
return $default(_that.maxRequests,_that.retention,_that.showNotification,_that.notificationDuration,_that.showBubble,_that.bubblePosition,_that.redactHeaders,_that.themeMode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'max_requests')  int maxRequests, @JsonKey(name: 'retention')  DioLensRetention retention, @JsonKey(name: 'show_notification')  bool showNotification, @JsonKey(name: 'notification_duration')  Duration notificationDuration, @JsonKey(name: 'show_bubble')  bool showBubble, @JsonKey(name: 'bubble_position')  DioLensBubblePosition bubblePosition, @JsonKey(name: 'redact_headers')  bool redactHeaders, @JsonKey(name: 'theme_mode')  ThemeMode themeMode)?  $default,) {final _that = this;
switch (_that) {
case _DioLensSettings() when $default != null:
return $default(_that.maxRequests,_that.retention,_that.showNotification,_that.notificationDuration,_that.showBubble,_that.bubblePosition,_that.redactHeaders,_that.themeMode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DioLensSettings extends DioLensSettings {
  const _DioLensSettings({@JsonKey(name: 'max_requests') this.maxRequests = 500, @JsonKey(name: 'retention') this.retention = DioLensRetention.oneDay, @JsonKey(name: 'show_notification') this.showNotification = true, @JsonKey(name: 'notification_duration') this.notificationDuration = const Duration(seconds: 4), @JsonKey(name: 'show_bubble') this.showBubble = true, @JsonKey(name: 'bubble_position') this.bubblePosition = DioLensBubblePosition.bottomEnd, @JsonKey(name: 'redact_headers') this.redactHeaders = true, @JsonKey(name: 'theme_mode') this.themeMode = ThemeMode.dark}): assert(maxRequests >= DioLensSettings.minRequests && maxRequests <= DioLensSettings.maxRequestsLimit, 'maxRequests must be between 10 and 10000'),super._();
  factory _DioLensSettings.fromJson(Map<String, dynamic> json) => _$DioLensSettingsFromJson(json);

/// Most requests kept; the oldest are removed past this limit.
@override@JsonKey(name: 'max_requests') final  int maxRequests;
@override@JsonKey(name: 'retention') final  DioLensRetention retention;
/// Show a banner over the host app when a request finishes.
@override@JsonKey(name: 'show_notification') final  bool showNotification;
/// How long the request-finished banner stays on screen.
@override@JsonKey(name: 'notification_duration') final  Duration notificationDuration;
/// Show the tap-to-open bubble over the host app.
@override@JsonKey(name: 'show_bubble') final  bool showBubble;
@override@JsonKey(name: 'bubble_position') final  DioLensBubblePosition bubblePosition;
/// Mask Authorization, Cookie and Set-Cookie values in the UI.
@override@JsonKey(name: 'redact_headers') final  bool redactHeaders;
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
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DioLensSettings&&(identical(other.maxRequests, maxRequests) || other.maxRequests == maxRequests)&&(identical(other.retention, retention) || other.retention == retention)&&(identical(other.showNotification, showNotification) || other.showNotification == showNotification)&&(identical(other.notificationDuration, notificationDuration) || other.notificationDuration == notificationDuration)&&(identical(other.showBubble, showBubble) || other.showBubble == showBubble)&&(identical(other.bubblePosition, bubblePosition) || other.bubblePosition == bubblePosition)&&(identical(other.redactHeaders, redactHeaders) || other.redactHeaders == redactHeaders)&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,maxRequests,retention,showNotification,notificationDuration,showBubble,bubblePosition,redactHeaders,themeMode);
}

@override
String toString() {
    return 'DioLensSettings(maxRequests: $maxRequests, retention: $retention, showNotification: $showNotification, notificationDuration: $notificationDuration, showBubble: $showBubble, bubblePosition: $bubblePosition, redactHeaders: $redactHeaders, themeMode: $themeMode)';
}


}

/// @nodoc
abstract mixin class _$DioLensSettingsCopyWith<$Res> implements $DioLensSettingsCopyWith<$Res> {
  factory _$DioLensSettingsCopyWith(_DioLensSettings value, $Res Function(_DioLensSettings) _then) = __$DioLensSettingsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'max_requests') int maxRequests,@JsonKey(name: 'retention') DioLensRetention retention,@JsonKey(name: 'show_notification') bool showNotification,@JsonKey(name: 'notification_duration') Duration notificationDuration,@JsonKey(name: 'show_bubble') bool showBubble,@JsonKey(name: 'bubble_position') DioLensBubblePosition bubblePosition,@JsonKey(name: 'redact_headers') bool redactHeaders,@JsonKey(name: 'theme_mode') ThemeMode themeMode
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
@override @pragma('vm:prefer-inline') $Res call({Object? maxRequests = null,Object? retention = null,Object? showNotification = null,Object? notificationDuration = null,Object? showBubble = null,Object? bubblePosition = null,Object? redactHeaders = null,Object? themeMode = null,}) {
  return _then(_DioLensSettings(
maxRequests: null == maxRequests ? _self.maxRequests : maxRequests // ignore: cast_nullable_to_non_nullable
as int,retention: null == retention ? _self.retention : retention // ignore: cast_nullable_to_non_nullable
as DioLensRetention,showNotification: null == showNotification ? _self.showNotification : showNotification // ignore: cast_nullable_to_non_nullable
as bool,notificationDuration: null == notificationDuration ? _self.notificationDuration : notificationDuration // ignore: cast_nullable_to_non_nullable
as Duration,showBubble: null == showBubble ? _self.showBubble : showBubble // ignore: cast_nullable_to_non_nullable
as bool,bubblePosition: null == bubblePosition ? _self.bubblePosition : bubblePosition // ignore: cast_nullable_to_non_nullable
as DioLensBubblePosition,redactHeaders: null == redactHeaders ? _self.redactHeaders : redactHeaders // ignore: cast_nullable_to_non_nullable
as bool,themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as ThemeMode,
  ));
}


}

// dart format on
