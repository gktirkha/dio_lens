// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'named_count_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NamedCountEntity {

/// The label, e.g. an endpoint path or a host.
@JsonKey(name: 'name') String get name;/// How often it occurred.
@JsonKey(name: 'count') int get count;
/// Create a copy of NamedCountEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NamedCountEntityCopyWith<NamedCountEntity> get copyWith => _$NamedCountEntityCopyWithImpl<NamedCountEntity>(this as NamedCountEntity, _$identity);

  /// Serializes this NamedCountEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NamedCountEntity;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NamedCountEntity&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.count, _this.count) || other.count == _this.count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NamedCountEntity;
  return Object.hash(runtimeType,_this.name,_this.count);
}

@override
String toString() {
  final _this = this as NamedCountEntity;
  return 'NamedCountEntity(name: ${_this.name}, count: ${_this.count})';
}


}

/// @nodoc
abstract mixin class $NamedCountEntityCopyWith<$Res>  {
  factory $NamedCountEntityCopyWith(NamedCountEntity value, $Res Function(NamedCountEntity) _then) = _$NamedCountEntityCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'name') String name,@JsonKey(name: 'count') int count
});




}
/// @nodoc
class _$NamedCountEntityCopyWithImpl<$Res>
    implements $NamedCountEntityCopyWith<$Res> {
  _$NamedCountEntityCopyWithImpl(this._self, this._then);

  final NamedCountEntity _self;
  final $Res Function(NamedCountEntity) _then;

/// Create a copy of NamedCountEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? count = null,}) {
  return _then(NamedCountEntity(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [NamedCountEntity].
extension NamedCountEntityPatterns on NamedCountEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NamedCountEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NamedCountEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NamedCountEntity value)  $default,){
final _that = this;
switch (_that) {
case _NamedCountEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NamedCountEntity value)?  $default,){
final _that = this;
switch (_that) {
case _NamedCountEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'name')  String name, @JsonKey(name: 'count')  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NamedCountEntity() when $default != null:
return $default(_that.name,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'name')  String name, @JsonKey(name: 'count')  int count)  $default,) {final _that = this;
switch (_that) {
case _NamedCountEntity():
return $default(_that.name,_that.count);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'name')  String name, @JsonKey(name: 'count')  int count)?  $default,) {final _that = this;
switch (_that) {
case _NamedCountEntity() when $default != null:
return $default(_that.name,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NamedCountEntity implements NamedCountEntity {
  const _NamedCountEntity({@JsonKey(name: 'name') required this.name, @JsonKey(name: 'count') required this.count});
  factory _NamedCountEntity.fromJson(Map<String, dynamic> json) => _$NamedCountEntityFromJson(json);

/// The label, e.g. an endpoint path or a host.
@override@JsonKey(name: 'name') final  String name;
/// How often it occurred.
@override@JsonKey(name: 'count') final  int count;

/// Create a copy of NamedCountEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NamedCountEntityCopyWith<_NamedCountEntity> get copyWith => __$NamedCountEntityCopyWithImpl<_NamedCountEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NamedCountEntityToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NamedCountEntity&&(identical(other.name, name) || other.name == name)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,count);
}

@override
String toString() {
    return 'NamedCountEntity(name: $name, count: $count)';
}


}

/// @nodoc
abstract mixin class _$NamedCountEntityCopyWith<$Res> implements $NamedCountEntityCopyWith<$Res> {
  factory _$NamedCountEntityCopyWith(_NamedCountEntity value, $Res Function(_NamedCountEntity) _then) = __$NamedCountEntityCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'name') String name,@JsonKey(name: 'count') int count
});




}
/// @nodoc
class __$NamedCountEntityCopyWithImpl<$Res>
    implements _$NamedCountEntityCopyWith<$Res> {
  __$NamedCountEntityCopyWithImpl(this._self, this._then);

  final _NamedCountEntity _self;
  final $Res Function(_NamedCountEntity) _then;

/// Create a copy of NamedCountEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? count = null,}) {
  return _then(_NamedCountEntity(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
