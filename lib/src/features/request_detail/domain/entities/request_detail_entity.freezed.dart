// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'request_detail_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RequestDetailEntity {

@JsonKey(name: 'id') String get id;/// Upper-case HTTP method, e.g. `GET`, `QUERY`.
@JsonKey(name: 'method') String get method;@JsonKey(name: 'uri') Uri get uri;@JsonKey(name: 'started_at') DateTime get startedAt;@JsonKey(name: 'state') RequestState get state;@JsonKey(name: 'status_code') int? get statusCode;@JsonKey(name: 'duration') Duration? get duration;/// e.g. `HTTP/2`; null when unknown.
@JsonKey(name: 'protocol') String? get protocol;/// Body sizes in bytes; null when unknown.
@JsonKey(name: 'request_size') int? get requestSize;@JsonKey(name: 'response_size') int? get responseSize;@JsonKey(name: 'request_content_type') String? get requestContentType;@JsonKey(name: 'response_content_type') String? get responseContentType;@JsonKey(name: 'request_headers') Map<String, String> get requestHeaders;@JsonKey(name: 'response_headers') Map<String, String> get responseHeaders;/// Decoded body: a JSON map/list, a form map, a string, or null.
@JsonKey(name: 'request_body') Object? get requestBody;@JsonKey(name: 'response_body') Object? get responseBody;/// Why the request failed without a response; null otherwise.
@JsonKey(name: 'error_type') DioExceptionType? get errorType;@JsonKey(name: 'error_message') String? get errorMessage;@JsonKey(name: 'stack_trace') String? get stackTrace;
/// Create a copy of RequestDetailEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RequestDetailEntityCopyWith<RequestDetailEntity> get copyWith => _$RequestDetailEntityCopyWithImpl<RequestDetailEntity>(this as RequestDetailEntity, _$identity);

  /// Serializes this RequestDetailEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RequestDetailEntity;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RequestDetailEntity&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.method, _this.method) || other.method == _this.method)&&(identical(other.uri, _this.uri) || other.uri == _this.uri)&&(identical(other.startedAt, _this.startedAt) || other.startedAt == _this.startedAt)&&(identical(other.state, _this.state) || other.state == _this.state)&&(identical(other.statusCode, _this.statusCode) || other.statusCode == _this.statusCode)&&(identical(other.duration, _this.duration) || other.duration == _this.duration)&&(identical(other.protocol, _this.protocol) || other.protocol == _this.protocol)&&(identical(other.requestSize, _this.requestSize) || other.requestSize == _this.requestSize)&&(identical(other.responseSize, _this.responseSize) || other.responseSize == _this.responseSize)&&(identical(other.requestContentType, _this.requestContentType) || other.requestContentType == _this.requestContentType)&&(identical(other.responseContentType, _this.responseContentType) || other.responseContentType == _this.responseContentType)&&const DeepCollectionEquality().equals(other.requestHeaders, _this.requestHeaders)&&const DeepCollectionEquality().equals(other.responseHeaders, _this.responseHeaders)&&const DeepCollectionEquality().equals(other.requestBody, _this.requestBody)&&const DeepCollectionEquality().equals(other.responseBody, _this.responseBody)&&(identical(other.errorType, _this.errorType) || other.errorType == _this.errorType)&&(identical(other.errorMessage, _this.errorMessage) || other.errorMessage == _this.errorMessage)&&(identical(other.stackTrace, _this.stackTrace) || other.stackTrace == _this.stackTrace));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RequestDetailEntity;
  return Object.hashAll([runtimeType,_this.id,_this.method,_this.uri,_this.startedAt,_this.state,_this.statusCode,_this.duration,_this.protocol,_this.requestSize,_this.responseSize,_this.requestContentType,_this.responseContentType,const DeepCollectionEquality().hash(_this.requestHeaders),const DeepCollectionEquality().hash(_this.responseHeaders),const DeepCollectionEquality().hash(_this.requestBody),const DeepCollectionEquality().hash(_this.responseBody),_this.errorType,_this.errorMessage,_this.stackTrace]);
}

@override
String toString() {
  final _this = this as RequestDetailEntity;
  return 'RequestDetailEntity(id: ${_this.id}, method: ${_this.method}, uri: ${_this.uri}, startedAt: ${_this.startedAt}, state: ${_this.state}, statusCode: ${_this.statusCode}, duration: ${_this.duration}, protocol: ${_this.protocol}, requestSize: ${_this.requestSize}, responseSize: ${_this.responseSize}, requestContentType: ${_this.requestContentType}, responseContentType: ${_this.responseContentType}, requestHeaders: ${_this.requestHeaders}, responseHeaders: ${_this.responseHeaders}, requestBody: ${_this.requestBody}, responseBody: ${_this.responseBody}, errorType: ${_this.errorType}, errorMessage: ${_this.errorMessage}, stackTrace: ${_this.stackTrace})';
}


}

/// @nodoc
abstract mixin class $RequestDetailEntityCopyWith<$Res>  {
  factory $RequestDetailEntityCopyWith(RequestDetailEntity value, $Res Function(RequestDetailEntity) _then) = _$RequestDetailEntityCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'method') String method,@JsonKey(name: 'uri') Uri uri,@JsonKey(name: 'started_at') DateTime startedAt,@JsonKey(name: 'state') RequestState state,@JsonKey(name: 'status_code') int? statusCode,@JsonKey(name: 'duration') Duration? duration,@JsonKey(name: 'protocol') String? protocol,@JsonKey(name: 'request_size') int? requestSize,@JsonKey(name: 'response_size') int? responseSize,@JsonKey(name: 'request_content_type') String? requestContentType,@JsonKey(name: 'response_content_type') String? responseContentType,@JsonKey(name: 'request_headers') Map<String, String> requestHeaders,@JsonKey(name: 'response_headers') Map<String, String> responseHeaders,@JsonKey(name: 'request_body') Object? requestBody,@JsonKey(name: 'response_body') Object? responseBody,@JsonKey(name: 'error_type') DioExceptionType? errorType,@JsonKey(name: 'error_message') String? errorMessage,@JsonKey(name: 'stack_trace') String? stackTrace
});




}
/// @nodoc
class _$RequestDetailEntityCopyWithImpl<$Res>
    implements $RequestDetailEntityCopyWith<$Res> {
  _$RequestDetailEntityCopyWithImpl(this._self, this._then);

  final RequestDetailEntity _self;
  final $Res Function(RequestDetailEntity) _then;

/// Create a copy of RequestDetailEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? method = null,Object? uri = null,Object? startedAt = null,Object? state = null,Object? statusCode = freezed,Object? duration = freezed,Object? protocol = freezed,Object? requestSize = freezed,Object? responseSize = freezed,Object? requestContentType = freezed,Object? responseContentType = freezed,Object? requestHeaders = null,Object? responseHeaders = null,Object? requestBody = freezed,Object? responseBody = freezed,Object? errorType = freezed,Object? errorMessage = freezed,Object? stackTrace = freezed,}) {
  return _then(RequestDetailEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,uri: null == uri ? _self.uri : uri // ignore: cast_nullable_to_non_nullable
as Uri,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as RequestState,statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration?,protocol: freezed == protocol ? _self.protocol : protocol // ignore: cast_nullable_to_non_nullable
as String?,requestSize: freezed == requestSize ? _self.requestSize : requestSize // ignore: cast_nullable_to_non_nullable
as int?,responseSize: freezed == responseSize ? _self.responseSize : responseSize // ignore: cast_nullable_to_non_nullable
as int?,requestContentType: freezed == requestContentType ? _self.requestContentType : requestContentType // ignore: cast_nullable_to_non_nullable
as String?,responseContentType: freezed == responseContentType ? _self.responseContentType : responseContentType // ignore: cast_nullable_to_non_nullable
as String?,requestHeaders: null == requestHeaders ? _self.requestHeaders : requestHeaders // ignore: cast_nullable_to_non_nullable
as Map<String, String>,responseHeaders: null == responseHeaders ? _self.responseHeaders : responseHeaders // ignore: cast_nullable_to_non_nullable
as Map<String, String>,requestBody: freezed == requestBody ? _self.requestBody : requestBody ,responseBody: freezed == responseBody ? _self.responseBody : responseBody ,errorType: freezed == errorType ? _self.errorType : errorType // ignore: cast_nullable_to_non_nullable
as DioExceptionType?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RequestDetailEntity].
extension RequestDetailEntityPatterns on RequestDetailEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RequestDetailEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RequestDetailEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RequestDetailEntity value)  $default,){
final _that = this;
switch (_that) {
case _RequestDetailEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RequestDetailEntity value)?  $default,){
final _that = this;
switch (_that) {
case _RequestDetailEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'method')  String method, @JsonKey(name: 'uri')  Uri uri, @JsonKey(name: 'started_at')  DateTime startedAt, @JsonKey(name: 'state')  RequestState state, @JsonKey(name: 'status_code')  int? statusCode, @JsonKey(name: 'duration')  Duration? duration, @JsonKey(name: 'protocol')  String? protocol, @JsonKey(name: 'request_size')  int? requestSize, @JsonKey(name: 'response_size')  int? responseSize, @JsonKey(name: 'request_content_type')  String? requestContentType, @JsonKey(name: 'response_content_type')  String? responseContentType, @JsonKey(name: 'request_headers')  Map<String, String> requestHeaders, @JsonKey(name: 'response_headers')  Map<String, String> responseHeaders, @JsonKey(name: 'request_body')  Object? requestBody, @JsonKey(name: 'response_body')  Object? responseBody, @JsonKey(name: 'error_type')  DioExceptionType? errorType, @JsonKey(name: 'error_message')  String? errorMessage, @JsonKey(name: 'stack_trace')  String? stackTrace)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RequestDetailEntity() when $default != null:
return $default(_that.id,_that.method,_that.uri,_that.startedAt,_that.state,_that.statusCode,_that.duration,_that.protocol,_that.requestSize,_that.responseSize,_that.requestContentType,_that.responseContentType,_that.requestHeaders,_that.responseHeaders,_that.requestBody,_that.responseBody,_that.errorType,_that.errorMessage,_that.stackTrace);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'method')  String method, @JsonKey(name: 'uri')  Uri uri, @JsonKey(name: 'started_at')  DateTime startedAt, @JsonKey(name: 'state')  RequestState state, @JsonKey(name: 'status_code')  int? statusCode, @JsonKey(name: 'duration')  Duration? duration, @JsonKey(name: 'protocol')  String? protocol, @JsonKey(name: 'request_size')  int? requestSize, @JsonKey(name: 'response_size')  int? responseSize, @JsonKey(name: 'request_content_type')  String? requestContentType, @JsonKey(name: 'response_content_type')  String? responseContentType, @JsonKey(name: 'request_headers')  Map<String, String> requestHeaders, @JsonKey(name: 'response_headers')  Map<String, String> responseHeaders, @JsonKey(name: 'request_body')  Object? requestBody, @JsonKey(name: 'response_body')  Object? responseBody, @JsonKey(name: 'error_type')  DioExceptionType? errorType, @JsonKey(name: 'error_message')  String? errorMessage, @JsonKey(name: 'stack_trace')  String? stackTrace)  $default,) {final _that = this;
switch (_that) {
case _RequestDetailEntity():
return $default(_that.id,_that.method,_that.uri,_that.startedAt,_that.state,_that.statusCode,_that.duration,_that.protocol,_that.requestSize,_that.responseSize,_that.requestContentType,_that.responseContentType,_that.requestHeaders,_that.responseHeaders,_that.requestBody,_that.responseBody,_that.errorType,_that.errorMessage,_that.stackTrace);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'method')  String method, @JsonKey(name: 'uri')  Uri uri, @JsonKey(name: 'started_at')  DateTime startedAt, @JsonKey(name: 'state')  RequestState state, @JsonKey(name: 'status_code')  int? statusCode, @JsonKey(name: 'duration')  Duration? duration, @JsonKey(name: 'protocol')  String? protocol, @JsonKey(name: 'request_size')  int? requestSize, @JsonKey(name: 'response_size')  int? responseSize, @JsonKey(name: 'request_content_type')  String? requestContentType, @JsonKey(name: 'response_content_type')  String? responseContentType, @JsonKey(name: 'request_headers')  Map<String, String> requestHeaders, @JsonKey(name: 'response_headers')  Map<String, String> responseHeaders, @JsonKey(name: 'request_body')  Object? requestBody, @JsonKey(name: 'response_body')  Object? responseBody, @JsonKey(name: 'error_type')  DioExceptionType? errorType, @JsonKey(name: 'error_message')  String? errorMessage, @JsonKey(name: 'stack_trace')  String? stackTrace)?  $default,) {final _that = this;
switch (_that) {
case _RequestDetailEntity() when $default != null:
return $default(_that.id,_that.method,_that.uri,_that.startedAt,_that.state,_that.statusCode,_that.duration,_that.protocol,_that.requestSize,_that.responseSize,_that.requestContentType,_that.responseContentType,_that.requestHeaders,_that.responseHeaders,_that.requestBody,_that.responseBody,_that.errorType,_that.errorMessage,_that.stackTrace);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RequestDetailEntity extends RequestDetailEntity {
  const _RequestDetailEntity({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'method') required this.method, @JsonKey(name: 'uri') required this.uri, @JsonKey(name: 'started_at') required this.startedAt, @JsonKey(name: 'state') required this.state, @JsonKey(name: 'status_code') this.statusCode, @JsonKey(name: 'duration') this.duration, @JsonKey(name: 'protocol') this.protocol, @JsonKey(name: 'request_size') this.requestSize, @JsonKey(name: 'response_size') this.responseSize, @JsonKey(name: 'request_content_type') this.requestContentType, @JsonKey(name: 'response_content_type') this.responseContentType, @JsonKey(name: 'request_headers')  Map<String, String> requestHeaders = const <String, String>{}, @JsonKey(name: 'response_headers')  Map<String, String> responseHeaders = const <String, String>{}, @JsonKey(name: 'request_body') this.requestBody, @JsonKey(name: 'response_body') this.responseBody, @JsonKey(name: 'error_type') this.errorType, @JsonKey(name: 'error_message') this.errorMessage, @JsonKey(name: 'stack_trace') this.stackTrace}): _requestHeaders = requestHeaders,_responseHeaders = responseHeaders,super._();
  factory _RequestDetailEntity.fromJson(Map<String, dynamic> json) => _$RequestDetailEntityFromJson(json);

@override@JsonKey(name: 'id') final  String id;
/// Upper-case HTTP method, e.g. `GET`, `QUERY`.
@override@JsonKey(name: 'method') final  String method;
@override@JsonKey(name: 'uri') final  Uri uri;
@override@JsonKey(name: 'started_at') final  DateTime startedAt;
@override@JsonKey(name: 'state') final  RequestState state;
@override@JsonKey(name: 'status_code') final  int? statusCode;
@override@JsonKey(name: 'duration') final  Duration? duration;
/// e.g. `HTTP/2`; null when unknown.
@override@JsonKey(name: 'protocol') final  String? protocol;
/// Body sizes in bytes; null when unknown.
@override@JsonKey(name: 'request_size') final  int? requestSize;
@override@JsonKey(name: 'response_size') final  int? responseSize;
@override@JsonKey(name: 'request_content_type') final  String? requestContentType;
@override@JsonKey(name: 'response_content_type') final  String? responseContentType;
 final  Map<String, String> _requestHeaders;
@override@JsonKey(name: 'request_headers') Map<String, String> get requestHeaders {
  if (_requestHeaders is EqualUnmodifiableMapView) return _requestHeaders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_requestHeaders);
}

 final  Map<String, String> _responseHeaders;
@override@JsonKey(name: 'response_headers') Map<String, String> get responseHeaders {
  if (_responseHeaders is EqualUnmodifiableMapView) return _responseHeaders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_responseHeaders);
}

/// Decoded body: a JSON map/list, a form map, a string, or null.
@override@JsonKey(name: 'request_body') final  Object? requestBody;
@override@JsonKey(name: 'response_body') final  Object? responseBody;
/// Why the request failed without a response; null otherwise.
@override@JsonKey(name: 'error_type') final  DioExceptionType? errorType;
@override@JsonKey(name: 'error_message') final  String? errorMessage;
@override@JsonKey(name: 'stack_trace') final  String? stackTrace;

/// Create a copy of RequestDetailEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RequestDetailEntityCopyWith<_RequestDetailEntity> get copyWith => __$RequestDetailEntityCopyWithImpl<_RequestDetailEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RequestDetailEntityToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RequestDetailEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.method, method) || other.method == method)&&(identical(other.uri, uri) || other.uri == uri)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.state, state) || other.state == state)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.protocol, protocol) || other.protocol == protocol)&&(identical(other.requestSize, requestSize) || other.requestSize == requestSize)&&(identical(other.responseSize, responseSize) || other.responseSize == responseSize)&&(identical(other.requestContentType, requestContentType) || other.requestContentType == requestContentType)&&(identical(other.responseContentType, responseContentType) || other.responseContentType == responseContentType)&&const DeepCollectionEquality().equals(other.requestHeaders, _requestHeaders)&&const DeepCollectionEquality().equals(other.responseHeaders, _responseHeaders)&&const DeepCollectionEquality().equals(other.requestBody, requestBody)&&const DeepCollectionEquality().equals(other.responseBody, responseBody)&&(identical(other.errorType, errorType) || other.errorType == errorType)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,method,uri,startedAt,state,statusCode,duration,protocol,requestSize,responseSize,requestContentType,responseContentType,const DeepCollectionEquality().hash(_requestHeaders),const DeepCollectionEquality().hash(_responseHeaders),const DeepCollectionEquality().hash(requestBody),const DeepCollectionEquality().hash(responseBody),errorType,errorMessage,stackTrace]);
}

@override
String toString() {
    return 'RequestDetailEntity(id: $id, method: $method, uri: $uri, startedAt: $startedAt, state: $state, statusCode: $statusCode, duration: $duration, protocol: $protocol, requestSize: $requestSize, responseSize: $responseSize, requestContentType: $requestContentType, responseContentType: $responseContentType, requestHeaders: $requestHeaders, responseHeaders: $responseHeaders, requestBody: $requestBody, responseBody: $responseBody, errorType: $errorType, errorMessage: $errorMessage, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class _$RequestDetailEntityCopyWith<$Res> implements $RequestDetailEntityCopyWith<$Res> {
  factory _$RequestDetailEntityCopyWith(_RequestDetailEntity value, $Res Function(_RequestDetailEntity) _then) = __$RequestDetailEntityCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'method') String method,@JsonKey(name: 'uri') Uri uri,@JsonKey(name: 'started_at') DateTime startedAt,@JsonKey(name: 'state') RequestState state,@JsonKey(name: 'status_code') int? statusCode,@JsonKey(name: 'duration') Duration? duration,@JsonKey(name: 'protocol') String? protocol,@JsonKey(name: 'request_size') int? requestSize,@JsonKey(name: 'response_size') int? responseSize,@JsonKey(name: 'request_content_type') String? requestContentType,@JsonKey(name: 'response_content_type') String? responseContentType,@JsonKey(name: 'request_headers') Map<String, String> requestHeaders,@JsonKey(name: 'response_headers') Map<String, String> responseHeaders,@JsonKey(name: 'request_body') Object? requestBody,@JsonKey(name: 'response_body') Object? responseBody,@JsonKey(name: 'error_type') DioExceptionType? errorType,@JsonKey(name: 'error_message') String? errorMessage,@JsonKey(name: 'stack_trace') String? stackTrace
});




}
/// @nodoc
class __$RequestDetailEntityCopyWithImpl<$Res>
    implements _$RequestDetailEntityCopyWith<$Res> {
  __$RequestDetailEntityCopyWithImpl(this._self, this._then);

  final _RequestDetailEntity _self;
  final $Res Function(_RequestDetailEntity) _then;

/// Create a copy of RequestDetailEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? method = null,Object? uri = null,Object? startedAt = null,Object? state = null,Object? statusCode = freezed,Object? duration = freezed,Object? protocol = freezed,Object? requestSize = freezed,Object? responseSize = freezed,Object? requestContentType = freezed,Object? responseContentType = freezed,Object? requestHeaders = null,Object? responseHeaders = null,Object? requestBody = freezed,Object? responseBody = freezed,Object? errorType = freezed,Object? errorMessage = freezed,Object? stackTrace = freezed,}) {
  return _then(_RequestDetailEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,uri: null == uri ? _self.uri : uri // ignore: cast_nullable_to_non_nullable
as Uri,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as RequestState,statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration?,protocol: freezed == protocol ? _self.protocol : protocol // ignore: cast_nullable_to_non_nullable
as String?,requestSize: freezed == requestSize ? _self.requestSize : requestSize // ignore: cast_nullable_to_non_nullable
as int?,responseSize: freezed == responseSize ? _self.responseSize : responseSize // ignore: cast_nullable_to_non_nullable
as int?,requestContentType: freezed == requestContentType ? _self.requestContentType : requestContentType // ignore: cast_nullable_to_non_nullable
as String?,responseContentType: freezed == responseContentType ? _self.responseContentType : responseContentType // ignore: cast_nullable_to_non_nullable
as String?,requestHeaders: null == requestHeaders ? _self._requestHeaders : requestHeaders // ignore: cast_nullable_to_non_nullable
as Map<String, String>,responseHeaders: null == responseHeaders ? _self._responseHeaders : responseHeaders // ignore: cast_nullable_to_non_nullable
as Map<String, String>,requestBody: freezed == requestBody ? _self.requestBody : requestBody ,responseBody: freezed == responseBody ? _self.responseBody : responseBody ,errorType: freezed == errorType ? _self.errorType : errorType // ignore: cast_nullable_to_non_nullable
as DioExceptionType?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
