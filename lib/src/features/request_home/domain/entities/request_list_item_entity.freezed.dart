// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'request_list_item_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RequestListItemEntity {

@JsonKey(name: 'id') String get id;/// Upper-case HTTP method, e.g. `GET`, `POST`.
@JsonKey(name: 'method') String get method;@JsonKey(name: 'uri') Uri get uri;@JsonKey(name: 'started_at') DateTime get startedAt;@JsonKey(name: 'state') RequestState get state;/// HTTP status code; null while pending or when the request failed
/// without a response.
@JsonKey(name: 'status_code') int? get statusCode;/// Time from send to response/error; null while pending.
@JsonKey(name: 'duration') Duration? get duration;/// Response body size in bytes; null when unknown.
@JsonKey(name: 'response_size') int? get responseSize;/// `DioExceptionType` name for failed requests, e.g. `connectionTimeout`.
@JsonKey(name: 'error_type') String? get errorType;/// MIME type of the request body, e.g. `application/json`; null when
/// there is no body.
@JsonKey(name: 'request_content_type') String? get requestContentType;/// MIME type of the response body; null when there is none.
@JsonKey(name: 'response_content_type') String? get responseContentType;
/// Create a copy of RequestListItemEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RequestListItemEntityCopyWith<RequestListItemEntity> get copyWith => _$RequestListItemEntityCopyWithImpl<RequestListItemEntity>(this as RequestListItemEntity, _$identity);

  /// Serializes this RequestListItemEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RequestListItemEntity;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RequestListItemEntity&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.method, _this.method) || other.method == _this.method)&&(identical(other.uri, _this.uri) || other.uri == _this.uri)&&(identical(other.startedAt, _this.startedAt) || other.startedAt == _this.startedAt)&&(identical(other.state, _this.state) || other.state == _this.state)&&(identical(other.statusCode, _this.statusCode) || other.statusCode == _this.statusCode)&&(identical(other.duration, _this.duration) || other.duration == _this.duration)&&(identical(other.responseSize, _this.responseSize) || other.responseSize == _this.responseSize)&&(identical(other.errorType, _this.errorType) || other.errorType == _this.errorType)&&(identical(other.requestContentType, _this.requestContentType) || other.requestContentType == _this.requestContentType)&&(identical(other.responseContentType, _this.responseContentType) || other.responseContentType == _this.responseContentType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RequestListItemEntity;
  return Object.hash(runtimeType,_this.id,_this.method,_this.uri,_this.startedAt,_this.state,_this.statusCode,_this.duration,_this.responseSize,_this.errorType,_this.requestContentType,_this.responseContentType);
}

@override
String toString() {
  final _this = this as RequestListItemEntity;
  return 'RequestListItemEntity(id: ${_this.id}, method: ${_this.method}, uri: ${_this.uri}, startedAt: ${_this.startedAt}, state: ${_this.state}, statusCode: ${_this.statusCode}, duration: ${_this.duration}, responseSize: ${_this.responseSize}, errorType: ${_this.errorType}, requestContentType: ${_this.requestContentType}, responseContentType: ${_this.responseContentType})';
}


}

/// @nodoc
abstract mixin class $RequestListItemEntityCopyWith<$Res>  {
  factory $RequestListItemEntityCopyWith(RequestListItemEntity value, $Res Function(RequestListItemEntity) _then) = _$RequestListItemEntityCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'method') String method,@JsonKey(name: 'uri') Uri uri,@JsonKey(name: 'started_at') DateTime startedAt,@JsonKey(name: 'state') RequestState state,@JsonKey(name: 'status_code') int? statusCode,@JsonKey(name: 'duration') Duration? duration,@JsonKey(name: 'response_size') int? responseSize,@JsonKey(name: 'error_type') String? errorType,@JsonKey(name: 'request_content_type') String? requestContentType,@JsonKey(name: 'response_content_type') String? responseContentType
});




}
/// @nodoc
class _$RequestListItemEntityCopyWithImpl<$Res>
    implements $RequestListItemEntityCopyWith<$Res> {
  _$RequestListItemEntityCopyWithImpl(this._self, this._then);

  final RequestListItemEntity _self;
  final $Res Function(RequestListItemEntity) _then;

/// Create a copy of RequestListItemEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? method = null,Object? uri = null,Object? startedAt = null,Object? state = null,Object? statusCode = freezed,Object? duration = freezed,Object? responseSize = freezed,Object? errorType = freezed,Object? requestContentType = freezed,Object? responseContentType = freezed,}) {
  return _then(RequestListItemEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,uri: null == uri ? _self.uri : uri // ignore: cast_nullable_to_non_nullable
as Uri,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as RequestState,statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration?,responseSize: freezed == responseSize ? _self.responseSize : responseSize // ignore: cast_nullable_to_non_nullable
as int?,errorType: freezed == errorType ? _self.errorType : errorType // ignore: cast_nullable_to_non_nullable
as String?,requestContentType: freezed == requestContentType ? _self.requestContentType : requestContentType // ignore: cast_nullable_to_non_nullable
as String?,responseContentType: freezed == responseContentType ? _self.responseContentType : responseContentType // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RequestListItemEntity].
extension RequestListItemEntityPatterns on RequestListItemEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RequestListItemEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RequestListItemEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RequestListItemEntity value)  $default,){
final _that = this;
switch (_that) {
case _RequestListItemEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RequestListItemEntity value)?  $default,){
final _that = this;
switch (_that) {
case _RequestListItemEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'method')  String method, @JsonKey(name: 'uri')  Uri uri, @JsonKey(name: 'started_at')  DateTime startedAt, @JsonKey(name: 'state')  RequestState state, @JsonKey(name: 'status_code')  int? statusCode, @JsonKey(name: 'duration')  Duration? duration, @JsonKey(name: 'response_size')  int? responseSize, @JsonKey(name: 'error_type')  String? errorType, @JsonKey(name: 'request_content_type')  String? requestContentType, @JsonKey(name: 'response_content_type')  String? responseContentType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RequestListItemEntity() when $default != null:
return $default(_that.id,_that.method,_that.uri,_that.startedAt,_that.state,_that.statusCode,_that.duration,_that.responseSize,_that.errorType,_that.requestContentType,_that.responseContentType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'method')  String method, @JsonKey(name: 'uri')  Uri uri, @JsonKey(name: 'started_at')  DateTime startedAt, @JsonKey(name: 'state')  RequestState state, @JsonKey(name: 'status_code')  int? statusCode, @JsonKey(name: 'duration')  Duration? duration, @JsonKey(name: 'response_size')  int? responseSize, @JsonKey(name: 'error_type')  String? errorType, @JsonKey(name: 'request_content_type')  String? requestContentType, @JsonKey(name: 'response_content_type')  String? responseContentType)  $default,) {final _that = this;
switch (_that) {
case _RequestListItemEntity():
return $default(_that.id,_that.method,_that.uri,_that.startedAt,_that.state,_that.statusCode,_that.duration,_that.responseSize,_that.errorType,_that.requestContentType,_that.responseContentType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'method')  String method, @JsonKey(name: 'uri')  Uri uri, @JsonKey(name: 'started_at')  DateTime startedAt, @JsonKey(name: 'state')  RequestState state, @JsonKey(name: 'status_code')  int? statusCode, @JsonKey(name: 'duration')  Duration? duration, @JsonKey(name: 'response_size')  int? responseSize, @JsonKey(name: 'error_type')  String? errorType, @JsonKey(name: 'request_content_type')  String? requestContentType, @JsonKey(name: 'response_content_type')  String? responseContentType)?  $default,) {final _that = this;
switch (_that) {
case _RequestListItemEntity() when $default != null:
return $default(_that.id,_that.method,_that.uri,_that.startedAt,_that.state,_that.statusCode,_that.duration,_that.responseSize,_that.errorType,_that.requestContentType,_that.responseContentType);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RequestListItemEntity extends RequestListItemEntity {
  const _RequestListItemEntity({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'method') required this.method, @JsonKey(name: 'uri') required this.uri, @JsonKey(name: 'started_at') required this.startedAt, @JsonKey(name: 'state') required this.state, @JsonKey(name: 'status_code') this.statusCode, @JsonKey(name: 'duration') this.duration, @JsonKey(name: 'response_size') this.responseSize, @JsonKey(name: 'error_type') this.errorType, @JsonKey(name: 'request_content_type') this.requestContentType, @JsonKey(name: 'response_content_type') this.responseContentType}): super._();
  factory _RequestListItemEntity.fromJson(Map<String, dynamic> json) => _$RequestListItemEntityFromJson(json);

@override@JsonKey(name: 'id') final  String id;
/// Upper-case HTTP method, e.g. `GET`, `POST`.
@override@JsonKey(name: 'method') final  String method;
@override@JsonKey(name: 'uri') final  Uri uri;
@override@JsonKey(name: 'started_at') final  DateTime startedAt;
@override@JsonKey(name: 'state') final  RequestState state;
/// HTTP status code; null while pending or when the request failed
/// without a response.
@override@JsonKey(name: 'status_code') final  int? statusCode;
/// Time from send to response/error; null while pending.
@override@JsonKey(name: 'duration') final  Duration? duration;
/// Response body size in bytes; null when unknown.
@override@JsonKey(name: 'response_size') final  int? responseSize;
/// `DioExceptionType` name for failed requests, e.g. `connectionTimeout`.
@override@JsonKey(name: 'error_type') final  String? errorType;
/// MIME type of the request body, e.g. `application/json`; null when
/// there is no body.
@override@JsonKey(name: 'request_content_type') final  String? requestContentType;
/// MIME type of the response body; null when there is none.
@override@JsonKey(name: 'response_content_type') final  String? responseContentType;

/// Create a copy of RequestListItemEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RequestListItemEntityCopyWith<_RequestListItemEntity> get copyWith => __$RequestListItemEntityCopyWithImpl<_RequestListItemEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RequestListItemEntityToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RequestListItemEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.method, method) || other.method == method)&&(identical(other.uri, uri) || other.uri == uri)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.state, state) || other.state == state)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.responseSize, responseSize) || other.responseSize == responseSize)&&(identical(other.errorType, errorType) || other.errorType == errorType)&&(identical(other.requestContentType, requestContentType) || other.requestContentType == requestContentType)&&(identical(other.responseContentType, responseContentType) || other.responseContentType == responseContentType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,method,uri,startedAt,state,statusCode,duration,responseSize,errorType,requestContentType,responseContentType);
}

@override
String toString() {
    return 'RequestListItemEntity(id: $id, method: $method, uri: $uri, startedAt: $startedAt, state: $state, statusCode: $statusCode, duration: $duration, responseSize: $responseSize, errorType: $errorType, requestContentType: $requestContentType, responseContentType: $responseContentType)';
}


}

/// @nodoc
abstract mixin class _$RequestListItemEntityCopyWith<$Res> implements $RequestListItemEntityCopyWith<$Res> {
  factory _$RequestListItemEntityCopyWith(_RequestListItemEntity value, $Res Function(_RequestListItemEntity) _then) = __$RequestListItemEntityCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'method') String method,@JsonKey(name: 'uri') Uri uri,@JsonKey(name: 'started_at') DateTime startedAt,@JsonKey(name: 'state') RequestState state,@JsonKey(name: 'status_code') int? statusCode,@JsonKey(name: 'duration') Duration? duration,@JsonKey(name: 'response_size') int? responseSize,@JsonKey(name: 'error_type') String? errorType,@JsonKey(name: 'request_content_type') String? requestContentType,@JsonKey(name: 'response_content_type') String? responseContentType
});




}
/// @nodoc
class __$RequestListItemEntityCopyWithImpl<$Res>
    implements _$RequestListItemEntityCopyWith<$Res> {
  __$RequestListItemEntityCopyWithImpl(this._self, this._then);

  final _RequestListItemEntity _self;
  final $Res Function(_RequestListItemEntity) _then;

/// Create a copy of RequestListItemEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? method = null,Object? uri = null,Object? startedAt = null,Object? state = null,Object? statusCode = freezed,Object? duration = freezed,Object? responseSize = freezed,Object? errorType = freezed,Object? requestContentType = freezed,Object? responseContentType = freezed,}) {
  return _then(_RequestListItemEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,uri: null == uri ? _self.uri : uri // ignore: cast_nullable_to_non_nullable
as Uri,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as RequestState,statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration?,responseSize: freezed == responseSize ? _self.responseSize : responseSize // ignore: cast_nullable_to_non_nullable
as int?,errorType: freezed == errorType ? _self.errorType : errorType // ignore: cast_nullable_to_non_nullable
as String?,requestContentType: freezed == requestContentType ? _self.requestContentType : requestContentType // ignore: cast_nullable_to_non_nullable
as String?,responseContentType: freezed == responseContentType ? _self.responseContentType : responseContentType // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
