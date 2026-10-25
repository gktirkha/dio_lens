// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'endpoint_latency_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EndpointLatencyEntity {

/// Endpoint path.
@JsonKey(name: 'path') String get path;/// Average time to a response.
@JsonKey(name: 'average_latency') Duration get averageLatency;
/// Create a copy of EndpointLatencyEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EndpointLatencyEntityCopyWith<EndpointLatencyEntity> get copyWith => _$EndpointLatencyEntityCopyWithImpl<EndpointLatencyEntity>(this as EndpointLatencyEntity, _$identity);

  /// Serializes this EndpointLatencyEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EndpointLatencyEntity;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EndpointLatencyEntity&&(identical(other.path, _this.path) || other.path == _this.path)&&(identical(other.averageLatency, _this.averageLatency) || other.averageLatency == _this.averageLatency));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EndpointLatencyEntity;
  return Object.hash(runtimeType,_this.path,_this.averageLatency);
}

@override
String toString() {
  final _this = this as EndpointLatencyEntity;
  return 'EndpointLatencyEntity(path: ${_this.path}, averageLatency: ${_this.averageLatency})';
}


}

/// @nodoc
abstract mixin class $EndpointLatencyEntityCopyWith<$Res>  {
  factory $EndpointLatencyEntityCopyWith(EndpointLatencyEntity value, $Res Function(EndpointLatencyEntity) _then) = _$EndpointLatencyEntityCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'path') String path,@JsonKey(name: 'average_latency') Duration averageLatency
});




}
/// @nodoc
class _$EndpointLatencyEntityCopyWithImpl<$Res>
    implements $EndpointLatencyEntityCopyWith<$Res> {
  _$EndpointLatencyEntityCopyWithImpl(this._self, this._then);

  final EndpointLatencyEntity _self;
  final $Res Function(EndpointLatencyEntity) _then;

/// Create a copy of EndpointLatencyEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? path = null,Object? averageLatency = null,}) {
  return _then(EndpointLatencyEntity(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,averageLatency: null == averageLatency ? _self.averageLatency : averageLatency // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}

}


/// Adds pattern-matching-related methods to [EndpointLatencyEntity].
extension EndpointLatencyEntityPatterns on EndpointLatencyEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EndpointLatencyEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EndpointLatencyEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EndpointLatencyEntity value)  $default,){
final _that = this;
switch (_that) {
case _EndpointLatencyEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EndpointLatencyEntity value)?  $default,){
final _that = this;
switch (_that) {
case _EndpointLatencyEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'path')  String path, @JsonKey(name: 'average_latency')  Duration averageLatency)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EndpointLatencyEntity() when $default != null:
return $default(_that.path,_that.averageLatency);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'path')  String path, @JsonKey(name: 'average_latency')  Duration averageLatency)  $default,) {final _that = this;
switch (_that) {
case _EndpointLatencyEntity():
return $default(_that.path,_that.averageLatency);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'path')  String path, @JsonKey(name: 'average_latency')  Duration averageLatency)?  $default,) {final _that = this;
switch (_that) {
case _EndpointLatencyEntity() when $default != null:
return $default(_that.path,_that.averageLatency);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EndpointLatencyEntity implements EndpointLatencyEntity {
  const _EndpointLatencyEntity({@JsonKey(name: 'path') required this.path, @JsonKey(name: 'average_latency') required this.averageLatency});
  factory _EndpointLatencyEntity.fromJson(Map<String, dynamic> json) => _$EndpointLatencyEntityFromJson(json);

/// Endpoint path.
@override@JsonKey(name: 'path') final  String path;
/// Average time to a response.
@override@JsonKey(name: 'average_latency') final  Duration averageLatency;

/// Create a copy of EndpointLatencyEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EndpointLatencyEntityCopyWith<_EndpointLatencyEntity> get copyWith => __$EndpointLatencyEntityCopyWithImpl<_EndpointLatencyEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EndpointLatencyEntityToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EndpointLatencyEntity&&(identical(other.path, path) || other.path == path)&&(identical(other.averageLatency, averageLatency) || other.averageLatency == averageLatency));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,path,averageLatency);
}

@override
String toString() {
    return 'EndpointLatencyEntity(path: $path, averageLatency: $averageLatency)';
}


}

/// @nodoc
abstract mixin class _$EndpointLatencyEntityCopyWith<$Res> implements $EndpointLatencyEntityCopyWith<$Res> {
  factory _$EndpointLatencyEntityCopyWith(_EndpointLatencyEntity value, $Res Function(_EndpointLatencyEntity) _then) = __$EndpointLatencyEntityCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'path') String path,@JsonKey(name: 'average_latency') Duration averageLatency
});




}
/// @nodoc
class __$EndpointLatencyEntityCopyWithImpl<$Res>
    implements _$EndpointLatencyEntityCopyWith<$Res> {
  __$EndpointLatencyEntityCopyWithImpl(this._self, this._then);

  final _EndpointLatencyEntity _self;
  final $Res Function(_EndpointLatencyEntity) _then;

/// Create a copy of EndpointLatencyEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? path = null,Object? averageLatency = null,}) {
  return _then(_EndpointLatencyEntity(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,averageLatency: null == averageLatency ? _self.averageLatency : averageLatency // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}


}

// dart format on
