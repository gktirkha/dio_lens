// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'status_share_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StatusShareEntity {

/// The status class.
@JsonKey(name: 'status_class') RequestStatusClass get statusClass;/// Requests in it.
@JsonKey(name: 'count') int get count;
/// Create a copy of StatusShareEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StatusShareEntityCopyWith<StatusShareEntity> get copyWith => _$StatusShareEntityCopyWithImpl<StatusShareEntity>(this as StatusShareEntity, _$identity);

  /// Serializes this StatusShareEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StatusShareEntity;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StatusShareEntity&&(identical(other.statusClass, _this.statusClass) || other.statusClass == _this.statusClass)&&(identical(other.count, _this.count) || other.count == _this.count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StatusShareEntity;
  return Object.hash(runtimeType,_this.statusClass,_this.count);
}

@override
String toString() {
  final _this = this as StatusShareEntity;
  return 'StatusShareEntity(statusClass: ${_this.statusClass}, count: ${_this.count})';
}


}

/// @nodoc
abstract mixin class $StatusShareEntityCopyWith<$Res>  {
  factory $StatusShareEntityCopyWith(StatusShareEntity value, $Res Function(StatusShareEntity) _then) = _$StatusShareEntityCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'status_class') RequestStatusClass statusClass,@JsonKey(name: 'count') int count
});




}
/// @nodoc
class _$StatusShareEntityCopyWithImpl<$Res>
    implements $StatusShareEntityCopyWith<$Res> {
  _$StatusShareEntityCopyWithImpl(this._self, this._then);

  final StatusShareEntity _self;
  final $Res Function(StatusShareEntity) _then;

/// Create a copy of StatusShareEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? statusClass = null,Object? count = null,}) {
  return _then(StatusShareEntity(
statusClass: null == statusClass ? _self.statusClass : statusClass // ignore: cast_nullable_to_non_nullable
as RequestStatusClass,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [StatusShareEntity].
extension StatusShareEntityPatterns on StatusShareEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StatusShareEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StatusShareEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StatusShareEntity value)  $default,){
final _that = this;
switch (_that) {
case _StatusShareEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StatusShareEntity value)?  $default,){
final _that = this;
switch (_that) {
case _StatusShareEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'status_class')  RequestStatusClass statusClass, @JsonKey(name: 'count')  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StatusShareEntity() when $default != null:
return $default(_that.statusClass,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'status_class')  RequestStatusClass statusClass, @JsonKey(name: 'count')  int count)  $default,) {final _that = this;
switch (_that) {
case _StatusShareEntity():
return $default(_that.statusClass,_that.count);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'status_class')  RequestStatusClass statusClass, @JsonKey(name: 'count')  int count)?  $default,) {final _that = this;
switch (_that) {
case _StatusShareEntity() when $default != null:
return $default(_that.statusClass,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StatusShareEntity implements StatusShareEntity {
  const _StatusShareEntity({@JsonKey(name: 'status_class') required this.statusClass, @JsonKey(name: 'count') required this.count});
  factory _StatusShareEntity.fromJson(Map<String, dynamic> json) => _$StatusShareEntityFromJson(json);

/// The status class.
@override@JsonKey(name: 'status_class') final  RequestStatusClass statusClass;
/// Requests in it.
@override@JsonKey(name: 'count') final  int count;

/// Create a copy of StatusShareEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StatusShareEntityCopyWith<_StatusShareEntity> get copyWith => __$StatusShareEntityCopyWithImpl<_StatusShareEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StatusShareEntityToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StatusShareEntity&&(identical(other.statusClass, statusClass) || other.statusClass == statusClass)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,statusClass,count);
}

@override
String toString() {
    return 'StatusShareEntity(statusClass: $statusClass, count: $count)';
}


}

/// @nodoc
abstract mixin class _$StatusShareEntityCopyWith<$Res> implements $StatusShareEntityCopyWith<$Res> {
  factory _$StatusShareEntityCopyWith(_StatusShareEntity value, $Res Function(_StatusShareEntity) _then) = __$StatusShareEntityCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'status_class') RequestStatusClass statusClass,@JsonKey(name: 'count') int count
});




}
/// @nodoc
class __$StatusShareEntityCopyWithImpl<$Res>
    implements _$StatusShareEntityCopyWith<$Res> {
  __$StatusShareEntityCopyWithImpl(this._self, this._then);

  final _StatusShareEntity _self;
  final $Res Function(_StatusShareEntity) _then;

/// Create a copy of StatusShareEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? statusClass = null,Object? count = null,}) {
  return _then(_StatusShareEntity(
statusClass: null == statusClass ? _self.statusClass : statusClass // ignore: cast_nullable_to_non_nullable
as RequestStatusClass,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
