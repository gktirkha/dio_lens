// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'time_bucket_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TimeBucketEntity {

@JsonKey(name: 'start') DateTime get start;@JsonKey(name: 'count') int get count;
/// Create a copy of TimeBucketEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimeBucketEntityCopyWith<TimeBucketEntity> get copyWith => _$TimeBucketEntityCopyWithImpl<TimeBucketEntity>(this as TimeBucketEntity, _$identity);

  /// Serializes this TimeBucketEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TimeBucketEntity;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimeBucketEntity&&(identical(other.start, _this.start) || other.start == _this.start)&&(identical(other.count, _this.count) || other.count == _this.count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TimeBucketEntity;
  return Object.hash(runtimeType,_this.start,_this.count);
}

@override
String toString() {
  final _this = this as TimeBucketEntity;
  return 'TimeBucketEntity(start: ${_this.start}, count: ${_this.count})';
}


}

/// @nodoc
abstract mixin class $TimeBucketEntityCopyWith<$Res>  {
  factory $TimeBucketEntityCopyWith(TimeBucketEntity value, $Res Function(TimeBucketEntity) _then) = _$TimeBucketEntityCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'start') DateTime start,@JsonKey(name: 'count') int count
});




}
/// @nodoc
class _$TimeBucketEntityCopyWithImpl<$Res>
    implements $TimeBucketEntityCopyWith<$Res> {
  _$TimeBucketEntityCopyWithImpl(this._self, this._then);

  final TimeBucketEntity _self;
  final $Res Function(TimeBucketEntity) _then;

/// Create a copy of TimeBucketEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? start = null,Object? count = null,}) {
  return _then(TimeBucketEntity(
start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TimeBucketEntity].
extension TimeBucketEntityPatterns on TimeBucketEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimeBucketEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimeBucketEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimeBucketEntity value)  $default,){
final _that = this;
switch (_that) {
case _TimeBucketEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimeBucketEntity value)?  $default,){
final _that = this;
switch (_that) {
case _TimeBucketEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'start')  DateTime start, @JsonKey(name: 'count')  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimeBucketEntity() when $default != null:
return $default(_that.start,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'start')  DateTime start, @JsonKey(name: 'count')  int count)  $default,) {final _that = this;
switch (_that) {
case _TimeBucketEntity():
return $default(_that.start,_that.count);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'start')  DateTime start, @JsonKey(name: 'count')  int count)?  $default,) {final _that = this;
switch (_that) {
case _TimeBucketEntity() when $default != null:
return $default(_that.start,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TimeBucketEntity implements TimeBucketEntity {
  const _TimeBucketEntity({@JsonKey(name: 'start') required this.start, @JsonKey(name: 'count') required this.count});
  factory _TimeBucketEntity.fromJson(Map<String, dynamic> json) => _$TimeBucketEntityFromJson(json);

@override@JsonKey(name: 'start') final  DateTime start;
@override@JsonKey(name: 'count') final  int count;

/// Create a copy of TimeBucketEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimeBucketEntityCopyWith<_TimeBucketEntity> get copyWith => __$TimeBucketEntityCopyWithImpl<_TimeBucketEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TimeBucketEntityToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimeBucketEntity&&(identical(other.start, start) || other.start == start)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,start,count);
}

@override
String toString() {
    return 'TimeBucketEntity(start: $start, count: $count)';
}


}

/// @nodoc
abstract mixin class _$TimeBucketEntityCopyWith<$Res> implements $TimeBucketEntityCopyWith<$Res> {
  factory _$TimeBucketEntityCopyWith(_TimeBucketEntity value, $Res Function(_TimeBucketEntity) _then) = __$TimeBucketEntityCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'start') DateTime start,@JsonKey(name: 'count') int count
});




}
/// @nodoc
class __$TimeBucketEntityCopyWithImpl<$Res>
    implements _$TimeBucketEntityCopyWith<$Res> {
  __$TimeBucketEntityCopyWithImpl(this._self, this._then);

  final _TimeBucketEntity _self;
  final $Res Function(_TimeBucketEntity) _then;

/// Create a copy of TimeBucketEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? start = null,Object? count = null,}) {
  return _then(_TimeBucketEntity(
start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
