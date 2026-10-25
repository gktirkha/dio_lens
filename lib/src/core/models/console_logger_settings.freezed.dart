// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'console_logger_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConsoleLoggerSettings {

/// Print request [Options].
 bool get request;/// Print request header [Options.headers].
 bool get requestHeader;/// Print request data [Options.data].
 bool get requestBody;/// Print [Response.data].
 bool get responseBody;/// Print [Response.headers].
 bool get responseHeader;/// Print error message.
 bool get error;/// Width size per logPrint.
 int get maxWidth;/// Print compact json response.
 bool get compact;/// Show state/stage in header.
 bool get showStateInHeader;/// Enable logging.
 bool get enabled;
/// Create a copy of ConsoleLoggerSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConsoleLoggerSettingsCopyWith<ConsoleLoggerSettings> get copyWith => _$ConsoleLoggerSettingsCopyWithImpl<ConsoleLoggerSettings>(this as ConsoleLoggerSettings, _$identity);

  /// Serializes this ConsoleLoggerSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ConsoleLoggerSettings;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConsoleLoggerSettings&&(identical(other.request, _this.request) || other.request == _this.request)&&(identical(other.requestHeader, _this.requestHeader) || other.requestHeader == _this.requestHeader)&&(identical(other.requestBody, _this.requestBody) || other.requestBody == _this.requestBody)&&(identical(other.responseBody, _this.responseBody) || other.responseBody == _this.responseBody)&&(identical(other.responseHeader, _this.responseHeader) || other.responseHeader == _this.responseHeader)&&(identical(other.error, _this.error) || other.error == _this.error)&&(identical(other.maxWidth, _this.maxWidth) || other.maxWidth == _this.maxWidth)&&(identical(other.compact, _this.compact) || other.compact == _this.compact)&&(identical(other.showStateInHeader, _this.showStateInHeader) || other.showStateInHeader == _this.showStateInHeader)&&(identical(other.enabled, _this.enabled) || other.enabled == _this.enabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ConsoleLoggerSettings;
  return Object.hash(runtimeType,_this.request,_this.requestHeader,_this.requestBody,_this.responseBody,_this.responseHeader,_this.error,_this.maxWidth,_this.compact,_this.showStateInHeader,_this.enabled);
}

@override
String toString() {
  final _this = this as ConsoleLoggerSettings;
  return 'ConsoleLoggerSettings(request: ${_this.request}, requestHeader: ${_this.requestHeader}, requestBody: ${_this.requestBody}, responseBody: ${_this.responseBody}, responseHeader: ${_this.responseHeader}, error: ${_this.error}, maxWidth: ${_this.maxWidth}, compact: ${_this.compact}, showStateInHeader: ${_this.showStateInHeader}, enabled: ${_this.enabled})';
}


}

/// @nodoc
abstract mixin class $ConsoleLoggerSettingsCopyWith<$Res>  {
  factory $ConsoleLoggerSettingsCopyWith(ConsoleLoggerSettings value, $Res Function(ConsoleLoggerSettings) _then) = _$ConsoleLoggerSettingsCopyWithImpl;
@useResult
$Res call({
 bool request, bool requestHeader, bool requestBody, bool responseBody, bool responseHeader, bool error, int maxWidth, bool compact, bool showStateInHeader, bool enabled
});




}
/// @nodoc
class _$ConsoleLoggerSettingsCopyWithImpl<$Res>
    implements $ConsoleLoggerSettingsCopyWith<$Res> {
  _$ConsoleLoggerSettingsCopyWithImpl(this._self, this._then);

  final ConsoleLoggerSettings _self;
  final $Res Function(ConsoleLoggerSettings) _then;

/// Create a copy of ConsoleLoggerSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? request = null,Object? requestHeader = null,Object? requestBody = null,Object? responseBody = null,Object? responseHeader = null,Object? error = null,Object? maxWidth = null,Object? compact = null,Object? showStateInHeader = null,Object? enabled = null,}) {
  return _then(ConsoleLoggerSettings(
request: null == request ? _self.request : request // ignore: cast_nullable_to_non_nullable
as bool,requestHeader: null == requestHeader ? _self.requestHeader : requestHeader // ignore: cast_nullable_to_non_nullable
as bool,requestBody: null == requestBody ? _self.requestBody : requestBody // ignore: cast_nullable_to_non_nullable
as bool,responseBody: null == responseBody ? _self.responseBody : responseBody // ignore: cast_nullable_to_non_nullable
as bool,responseHeader: null == responseHeader ? _self.responseHeader : responseHeader // ignore: cast_nullable_to_non_nullable
as bool,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as bool,maxWidth: null == maxWidth ? _self.maxWidth : maxWidth // ignore: cast_nullable_to_non_nullable
as int,compact: null == compact ? _self.compact : compact // ignore: cast_nullable_to_non_nullable
as bool,showStateInHeader: null == showStateInHeader ? _self.showStateInHeader : showStateInHeader // ignore: cast_nullable_to_non_nullable
as bool,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ConsoleLoggerSettings].
extension ConsoleLoggerSettingsPatterns on ConsoleLoggerSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConsoleLoggerSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConsoleLoggerSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConsoleLoggerSettings value)  $default,){
final _that = this;
switch (_that) {
case _ConsoleLoggerSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConsoleLoggerSettings value)?  $default,){
final _that = this;
switch (_that) {
case _ConsoleLoggerSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool request,  bool requestHeader,  bool requestBody,  bool responseBody,  bool responseHeader,  bool error,  int maxWidth,  bool compact,  bool showStateInHeader,  bool enabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConsoleLoggerSettings() when $default != null:
return $default(_that.request,_that.requestHeader,_that.requestBody,_that.responseBody,_that.responseHeader,_that.error,_that.maxWidth,_that.compact,_that.showStateInHeader,_that.enabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool request,  bool requestHeader,  bool requestBody,  bool responseBody,  bool responseHeader,  bool error,  int maxWidth,  bool compact,  bool showStateInHeader,  bool enabled)  $default,) {final _that = this;
switch (_that) {
case _ConsoleLoggerSettings():
return $default(_that.request,_that.requestHeader,_that.requestBody,_that.responseBody,_that.responseHeader,_that.error,_that.maxWidth,_that.compact,_that.showStateInHeader,_that.enabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool request,  bool requestHeader,  bool requestBody,  bool responseBody,  bool responseHeader,  bool error,  int maxWidth,  bool compact,  bool showStateInHeader,  bool enabled)?  $default,) {final _that = this;
switch (_that) {
case _ConsoleLoggerSettings() when $default != null:
return $default(_that.request,_that.requestHeader,_that.requestBody,_that.responseBody,_that.responseHeader,_that.error,_that.maxWidth,_that.compact,_that.showStateInHeader,_that.enabled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConsoleLoggerSettings implements ConsoleLoggerSettings {
  const _ConsoleLoggerSettings({this.request = true, this.requestHeader = true, this.requestBody = true, this.responseBody = true, this.responseHeader = true, this.error = true, this.maxWidth = 90, this.compact = true, this.showStateInHeader = true, this.enabled = true});
  factory _ConsoleLoggerSettings.fromJson(Map<String, dynamic> json) => _$ConsoleLoggerSettingsFromJson(json);

/// Print request [Options].
@override@JsonKey() final  bool request;
/// Print request header [Options.headers].
@override@JsonKey() final  bool requestHeader;
/// Print request data [Options.data].
@override@JsonKey() final  bool requestBody;
/// Print [Response.data].
@override@JsonKey() final  bool responseBody;
/// Print [Response.headers].
@override@JsonKey() final  bool responseHeader;
/// Print error message.
@override@JsonKey() final  bool error;
/// Width size per logPrint.
@override@JsonKey() final  int maxWidth;
/// Print compact json response.
@override@JsonKey() final  bool compact;
/// Show state/stage in header.
@override@JsonKey() final  bool showStateInHeader;
/// Enable logging.
@override@JsonKey() final  bool enabled;

/// Create a copy of ConsoleLoggerSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConsoleLoggerSettingsCopyWith<_ConsoleLoggerSettings> get copyWith => __$ConsoleLoggerSettingsCopyWithImpl<_ConsoleLoggerSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConsoleLoggerSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConsoleLoggerSettings&&(identical(other.request, request) || other.request == request)&&(identical(other.requestHeader, requestHeader) || other.requestHeader == requestHeader)&&(identical(other.requestBody, requestBody) || other.requestBody == requestBody)&&(identical(other.responseBody, responseBody) || other.responseBody == responseBody)&&(identical(other.responseHeader, responseHeader) || other.responseHeader == responseHeader)&&(identical(other.error, error) || other.error == error)&&(identical(other.maxWidth, maxWidth) || other.maxWidth == maxWidth)&&(identical(other.compact, compact) || other.compact == compact)&&(identical(other.showStateInHeader, showStateInHeader) || other.showStateInHeader == showStateInHeader)&&(identical(other.enabled, enabled) || other.enabled == enabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,request,requestHeader,requestBody,responseBody,responseHeader,error,maxWidth,compact,showStateInHeader,enabled);
}

@override
String toString() {
    return 'ConsoleLoggerSettings(request: $request, requestHeader: $requestHeader, requestBody: $requestBody, responseBody: $responseBody, responseHeader: $responseHeader, error: $error, maxWidth: $maxWidth, compact: $compact, showStateInHeader: $showStateInHeader, enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class _$ConsoleLoggerSettingsCopyWith<$Res> implements $ConsoleLoggerSettingsCopyWith<$Res> {
  factory _$ConsoleLoggerSettingsCopyWith(_ConsoleLoggerSettings value, $Res Function(_ConsoleLoggerSettings) _then) = __$ConsoleLoggerSettingsCopyWithImpl;
@override @useResult
$Res call({
 bool request, bool requestHeader, bool requestBody, bool responseBody, bool responseHeader, bool error, int maxWidth, bool compact, bool showStateInHeader, bool enabled
});




}
/// @nodoc
class __$ConsoleLoggerSettingsCopyWithImpl<$Res>
    implements _$ConsoleLoggerSettingsCopyWith<$Res> {
  __$ConsoleLoggerSettingsCopyWithImpl(this._self, this._then);

  final _ConsoleLoggerSettings _self;
  final $Res Function(_ConsoleLoggerSettings) _then;

/// Create a copy of ConsoleLoggerSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? request = null,Object? requestHeader = null,Object? requestBody = null,Object? responseBody = null,Object? responseHeader = null,Object? error = null,Object? maxWidth = null,Object? compact = null,Object? showStateInHeader = null,Object? enabled = null,}) {
  return _then(_ConsoleLoggerSettings(
request: null == request ? _self.request : request // ignore: cast_nullable_to_non_nullable
as bool,requestHeader: null == requestHeader ? _self.requestHeader : requestHeader // ignore: cast_nullable_to_non_nullable
as bool,requestBody: null == requestBody ? _self.requestBody : requestBody // ignore: cast_nullable_to_non_nullable
as bool,responseBody: null == responseBody ? _self.responseBody : responseBody // ignore: cast_nullable_to_non_nullable
as bool,responseHeader: null == responseHeader ? _self.responseHeader : responseHeader // ignore: cast_nullable_to_non_nullable
as bool,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as bool,maxWidth: null == maxWidth ? _self.maxWidth : maxWidth // ignore: cast_nullable_to_non_nullable
as int,compact: null == compact ? _self.compact : compact // ignore: cast_nullable_to_non_nullable
as bool,showStateInHeader: null == showStateInHeader ? _self.showStateInHeader : showStateInHeader // ignore: cast_nullable_to_non_nullable
as bool,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
