// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dio_lens_console_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DioLensConsoleSettings {

/// Print the request method and URL.
 bool get request;/// Print query parameters, request headers, options and extras.
 bool get requestHeader;/// Print the request body.
 bool get requestBody;/// Print the response body.
 bool get responseBody;/// Print response headers.
 bool get responseHeader;/// Print errors.
 bool get error;/// Line width before wrapping.
 int get maxWidth;/// Print short maps and lists on one line.
 bool get compact;/// Prefix section headers with `[REQUEST]`, `[RESPONSE]` or `[ERROR]`.
 bool get showStateInHeader;
/// Create a copy of DioLensConsoleSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DioLensConsoleSettingsCopyWith<DioLensConsoleSettings> get copyWith => _$DioLensConsoleSettingsCopyWithImpl<DioLensConsoleSettings>(this as DioLensConsoleSettings, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DioLensConsoleSettings;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DioLensConsoleSettings&&(identical(other.request, _this.request) || other.request == _this.request)&&(identical(other.requestHeader, _this.requestHeader) || other.requestHeader == _this.requestHeader)&&(identical(other.requestBody, _this.requestBody) || other.requestBody == _this.requestBody)&&(identical(other.responseBody, _this.responseBody) || other.responseBody == _this.responseBody)&&(identical(other.responseHeader, _this.responseHeader) || other.responseHeader == _this.responseHeader)&&(identical(other.error, _this.error) || other.error == _this.error)&&(identical(other.maxWidth, _this.maxWidth) || other.maxWidth == _this.maxWidth)&&(identical(other.compact, _this.compact) || other.compact == _this.compact)&&(identical(other.showStateInHeader, _this.showStateInHeader) || other.showStateInHeader == _this.showStateInHeader));
}


@override
int get hashCode {
  final _this = this as DioLensConsoleSettings;
  return Object.hash(runtimeType,_this.request,_this.requestHeader,_this.requestBody,_this.responseBody,_this.responseHeader,_this.error,_this.maxWidth,_this.compact,_this.showStateInHeader);
}

@override
String toString() {
  final _this = this as DioLensConsoleSettings;
  return 'DioLensConsoleSettings(request: ${_this.request}, requestHeader: ${_this.requestHeader}, requestBody: ${_this.requestBody}, responseBody: ${_this.responseBody}, responseHeader: ${_this.responseHeader}, error: ${_this.error}, maxWidth: ${_this.maxWidth}, compact: ${_this.compact}, showStateInHeader: ${_this.showStateInHeader})';
}


}

/// @nodoc
abstract mixin class $DioLensConsoleSettingsCopyWith<$Res>  {
  factory $DioLensConsoleSettingsCopyWith(DioLensConsoleSettings value, $Res Function(DioLensConsoleSettings) _then) = _$DioLensConsoleSettingsCopyWithImpl;
@useResult
$Res call({
 bool request, bool requestHeader, bool requestBody, bool responseBody, bool responseHeader, bool error, int maxWidth, bool compact, bool showStateInHeader
});




}
/// @nodoc
class _$DioLensConsoleSettingsCopyWithImpl<$Res>
    implements $DioLensConsoleSettingsCopyWith<$Res> {
  _$DioLensConsoleSettingsCopyWithImpl(this._self, this._then);

  final DioLensConsoleSettings _self;
  final $Res Function(DioLensConsoleSettings) _then;

/// Create a copy of DioLensConsoleSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? request = null,Object? requestHeader = null,Object? requestBody = null,Object? responseBody = null,Object? responseHeader = null,Object? error = null,Object? maxWidth = null,Object? compact = null,Object? showStateInHeader = null,}) {
  return _then(DioLensConsoleSettings(
request: null == request ? _self.request : request // ignore: cast_nullable_to_non_nullable
as bool,requestHeader: null == requestHeader ? _self.requestHeader : requestHeader // ignore: cast_nullable_to_non_nullable
as bool,requestBody: null == requestBody ? _self.requestBody : requestBody // ignore: cast_nullable_to_non_nullable
as bool,responseBody: null == responseBody ? _self.responseBody : responseBody // ignore: cast_nullable_to_non_nullable
as bool,responseHeader: null == responseHeader ? _self.responseHeader : responseHeader // ignore: cast_nullable_to_non_nullable
as bool,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as bool,maxWidth: null == maxWidth ? _self.maxWidth : maxWidth // ignore: cast_nullable_to_non_nullable
as int,compact: null == compact ? _self.compact : compact // ignore: cast_nullable_to_non_nullable
as bool,showStateInHeader: null == showStateInHeader ? _self.showStateInHeader : showStateInHeader // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DioLensConsoleSettings].
extension DioLensConsoleSettingsPatterns on DioLensConsoleSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DioLensConsoleSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DioLensConsoleSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DioLensConsoleSettings value)  $default,){
final _that = this;
switch (_that) {
case _DioLensConsoleSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DioLensConsoleSettings value)?  $default,){
final _that = this;
switch (_that) {
case _DioLensConsoleSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool request,  bool requestHeader,  bool requestBody,  bool responseBody,  bool responseHeader,  bool error,  int maxWidth,  bool compact,  bool showStateInHeader)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DioLensConsoleSettings() when $default != null:
return $default(_that.request,_that.requestHeader,_that.requestBody,_that.responseBody,_that.responseHeader,_that.error,_that.maxWidth,_that.compact,_that.showStateInHeader);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool request,  bool requestHeader,  bool requestBody,  bool responseBody,  bool responseHeader,  bool error,  int maxWidth,  bool compact,  bool showStateInHeader)  $default,) {final _that = this;
switch (_that) {
case _DioLensConsoleSettings():
return $default(_that.request,_that.requestHeader,_that.requestBody,_that.responseBody,_that.responseHeader,_that.error,_that.maxWidth,_that.compact,_that.showStateInHeader);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool request,  bool requestHeader,  bool requestBody,  bool responseBody,  bool responseHeader,  bool error,  int maxWidth,  bool compact,  bool showStateInHeader)?  $default,) {final _that = this;
switch (_that) {
case _DioLensConsoleSettings() when $default != null:
return $default(_that.request,_that.requestHeader,_that.requestBody,_that.responseBody,_that.responseHeader,_that.error,_that.maxWidth,_that.compact,_that.showStateInHeader);case _:
  return null;

}
}

}

/// @nodoc


class _DioLensConsoleSettings implements DioLensConsoleSettings {
  const _DioLensConsoleSettings({this.request = true, this.requestHeader = true, this.requestBody = true, this.responseBody = true, this.responseHeader = true, this.error = true, this.maxWidth = 90, this.compact = true, this.showStateInHeader = true});
  

/// Print the request method and URL.
@override@JsonKey() final  bool request;
/// Print query parameters, request headers, options and extras.
@override@JsonKey() final  bool requestHeader;
/// Print the request body.
@override@JsonKey() final  bool requestBody;
/// Print the response body.
@override@JsonKey() final  bool responseBody;
/// Print response headers.
@override@JsonKey() final  bool responseHeader;
/// Print errors.
@override@JsonKey() final  bool error;
/// Line width before wrapping.
@override@JsonKey() final  int maxWidth;
/// Print short maps and lists on one line.
@override@JsonKey() final  bool compact;
/// Prefix section headers with `[REQUEST]`, `[RESPONSE]` or `[ERROR]`.
@override@JsonKey() final  bool showStateInHeader;

/// Create a copy of DioLensConsoleSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DioLensConsoleSettingsCopyWith<_DioLensConsoleSettings> get copyWith => __$DioLensConsoleSettingsCopyWithImpl<_DioLensConsoleSettings>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DioLensConsoleSettings&&(identical(other.request, request) || other.request == request)&&(identical(other.requestHeader, requestHeader) || other.requestHeader == requestHeader)&&(identical(other.requestBody, requestBody) || other.requestBody == requestBody)&&(identical(other.responseBody, responseBody) || other.responseBody == responseBody)&&(identical(other.responseHeader, responseHeader) || other.responseHeader == responseHeader)&&(identical(other.error, error) || other.error == error)&&(identical(other.maxWidth, maxWidth) || other.maxWidth == maxWidth)&&(identical(other.compact, compact) || other.compact == compact)&&(identical(other.showStateInHeader, showStateInHeader) || other.showStateInHeader == showStateInHeader));
}


@override
int get hashCode {
    return Object.hash(runtimeType,request,requestHeader,requestBody,responseBody,responseHeader,error,maxWidth,compact,showStateInHeader);
}

@override
String toString() {
    return 'DioLensConsoleSettings(request: $request, requestHeader: $requestHeader, requestBody: $requestBody, responseBody: $responseBody, responseHeader: $responseHeader, error: $error, maxWidth: $maxWidth, compact: $compact, showStateInHeader: $showStateInHeader)';
}


}

/// @nodoc
abstract mixin class _$DioLensConsoleSettingsCopyWith<$Res> implements $DioLensConsoleSettingsCopyWith<$Res> {
  factory _$DioLensConsoleSettingsCopyWith(_DioLensConsoleSettings value, $Res Function(_DioLensConsoleSettings) _then) = __$DioLensConsoleSettingsCopyWithImpl;
@override @useResult
$Res call({
 bool request, bool requestHeader, bool requestBody, bool responseBody, bool responseHeader, bool error, int maxWidth, bool compact, bool showStateInHeader
});




}
/// @nodoc
class __$DioLensConsoleSettingsCopyWithImpl<$Res>
    implements _$DioLensConsoleSettingsCopyWith<$Res> {
  __$DioLensConsoleSettingsCopyWithImpl(this._self, this._then);

  final _DioLensConsoleSettings _self;
  final $Res Function(_DioLensConsoleSettings) _then;

/// Create a copy of DioLensConsoleSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? request = null,Object? requestHeader = null,Object? requestBody = null,Object? responseBody = null,Object? responseHeader = null,Object? error = null,Object? maxWidth = null,Object? compact = null,Object? showStateInHeader = null,}) {
  return _then(_DioLensConsoleSettings(
request: null == request ? _self.request : request // ignore: cast_nullable_to_non_nullable
as bool,requestHeader: null == requestHeader ? _self.requestHeader : requestHeader // ignore: cast_nullable_to_non_nullable
as bool,requestBody: null == requestBody ? _self.requestBody : requestBody // ignore: cast_nullable_to_non_nullable
as bool,responseBody: null == responseBody ? _self.responseBody : responseBody // ignore: cast_nullable_to_non_nullable
as bool,responseHeader: null == responseHeader ? _self.responseHeader : responseHeader // ignore: cast_nullable_to_non_nullable
as bool,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as bool,maxWidth: null == maxWidth ? _self.maxWidth : maxWidth // ignore: cast_nullable_to_non_nullable
as int,compact: null == compact ? _self.compact : compact // ignore: cast_nullable_to_non_nullable
as bool,showStateInHeader: null == showStateInHeader ? _self.showStateInHeader : showStateInHeader // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
