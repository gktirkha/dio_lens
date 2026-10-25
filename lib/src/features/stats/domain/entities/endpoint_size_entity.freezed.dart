// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'endpoint_size_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EndpointSizeEntity {

@JsonKey(name: 'path') String get path;@JsonKey(name: 'bytes') int get bytes;
/// Create a copy of EndpointSizeEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EndpointSizeEntityCopyWith<EndpointSizeEntity> get copyWith => _$EndpointSizeEntityCopyWithImpl<EndpointSizeEntity>(this as EndpointSizeEntity, _$identity);

  /// Serializes this EndpointSizeEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EndpointSizeEntity;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EndpointSizeEntity&&(identical(other.path, _this.path) || other.path == _this.path)&&(identical(other.bytes, _this.bytes) || other.bytes == _this.bytes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EndpointSizeEntity;
  return Object.hash(runtimeType,_this.path,_this.bytes);
}

@override
String toString() {
  final _this = this as EndpointSizeEntity;
  return 'EndpointSizeEntity(path: ${_this.path}, bytes: ${_this.bytes})';
}


}

/// @nodoc
abstract mixin class $EndpointSizeEntityCopyWith<$Res>  {
  factory $EndpointSizeEntityCopyWith(EndpointSizeEntity value, $Res Function(EndpointSizeEntity) _then) = _$EndpointSizeEntityCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'path') String path,@JsonKey(name: 'bytes') int bytes
});




}
/// @nodoc
class _$EndpointSizeEntityCopyWithImpl<$Res>
    implements $EndpointSizeEntityCopyWith<$Res> {
  _$EndpointSizeEntityCopyWithImpl(this._self, this._then);

  final EndpointSizeEntity _self;
  final $Res Function(EndpointSizeEntity) _then;

/// Create a copy of EndpointSizeEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? path = null,Object? bytes = null,}) {
  return _then(EndpointSizeEntity(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,bytes: null == bytes ? _self.bytes : bytes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [EndpointSizeEntity].
extension EndpointSizeEntityPatterns on EndpointSizeEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EndpointSizeEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EndpointSizeEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EndpointSizeEntity value)  $default,){
final _that = this;
switch (_that) {
case _EndpointSizeEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EndpointSizeEntity value)?  $default,){
final _that = this;
switch (_that) {
case _EndpointSizeEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'path')  String path, @JsonKey(name: 'bytes')  int bytes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EndpointSizeEntity() when $default != null:
return $default(_that.path,_that.bytes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'path')  String path, @JsonKey(name: 'bytes')  int bytes)  $default,) {final _that = this;
switch (_that) {
case _EndpointSizeEntity():
return $default(_that.path,_that.bytes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'path')  String path, @JsonKey(name: 'bytes')  int bytes)?  $default,) {final _that = this;
switch (_that) {
case _EndpointSizeEntity() when $default != null:
return $default(_that.path,_that.bytes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EndpointSizeEntity implements EndpointSizeEntity {
  const _EndpointSizeEntity({@JsonKey(name: 'path') required this.path, @JsonKey(name: 'bytes') required this.bytes});
  factory _EndpointSizeEntity.fromJson(Map<String, dynamic> json) => _$EndpointSizeEntityFromJson(json);

@override@JsonKey(name: 'path') final  String path;
@override@JsonKey(name: 'bytes') final  int bytes;

/// Create a copy of EndpointSizeEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EndpointSizeEntityCopyWith<_EndpointSizeEntity> get copyWith => __$EndpointSizeEntityCopyWithImpl<_EndpointSizeEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EndpointSizeEntityToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EndpointSizeEntity&&(identical(other.path, path) || other.path == path)&&(identical(other.bytes, bytes) || other.bytes == bytes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,path,bytes);
}

@override
String toString() {
    return 'EndpointSizeEntity(path: $path, bytes: $bytes)';
}


}

/// @nodoc
abstract mixin class _$EndpointSizeEntityCopyWith<$Res> implements $EndpointSizeEntityCopyWith<$Res> {
  factory _$EndpointSizeEntityCopyWith(_EndpointSizeEntity value, $Res Function(_EndpointSizeEntity) _then) = __$EndpointSizeEntityCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'path') String path,@JsonKey(name: 'bytes') int bytes
});




}
/// @nodoc
class __$EndpointSizeEntityCopyWithImpl<$Res>
    implements _$EndpointSizeEntityCopyWith<$Res> {
  __$EndpointSizeEntityCopyWithImpl(this._self, this._then);

  final _EndpointSizeEntity _self;
  final $Res Function(_EndpointSizeEntity) _then;

/// Create a copy of EndpointSizeEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? path = null,Object? bytes = null,}) {
  return _then(_EndpointSizeEntity(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,bytes: null == bytes ? _self.bytes : bytes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
