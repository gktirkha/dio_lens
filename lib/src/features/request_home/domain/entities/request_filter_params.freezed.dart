// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'request_filter_params.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RequestFilterParams {

 RequestStatusFilter get status; Set<String> get methods; String get search;
/// Create a copy of RequestFilterParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RequestFilterParamsCopyWith<RequestFilterParams> get copyWith => _$RequestFilterParamsCopyWithImpl<RequestFilterParams>(this as RequestFilterParams, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RequestFilterParams;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RequestFilterParams&&(identical(other.status, _this.status) || other.status == _this.status)&&const DeepCollectionEquality().equals(other.methods, _this.methods)&&(identical(other.search, _this.search) || other.search == _this.search));
}


@override
int get hashCode {
  final _this = this as RequestFilterParams;
  return Object.hash(runtimeType,_this.status,const DeepCollectionEquality().hash(_this.methods),_this.search);
}

@override
String toString() {
  final _this = this as RequestFilterParams;
  return 'RequestFilterParams(status: ${_this.status}, methods: ${_this.methods}, search: ${_this.search})';
}


}

/// @nodoc
abstract mixin class $RequestFilterParamsCopyWith<$Res>  {
  factory $RequestFilterParamsCopyWith(RequestFilterParams value, $Res Function(RequestFilterParams) _then) = _$RequestFilterParamsCopyWithImpl;
@useResult
$Res call({
 RequestStatusFilter status, Set<String> methods, String search
});




}
/// @nodoc
class _$RequestFilterParamsCopyWithImpl<$Res>
    implements $RequestFilterParamsCopyWith<$Res> {
  _$RequestFilterParamsCopyWithImpl(this._self, this._then);

  final RequestFilterParams _self;
  final $Res Function(RequestFilterParams) _then;

/// Create a copy of RequestFilterParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? methods = null,Object? search = null,}) {
  return _then(RequestFilterParams(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RequestStatusFilter,methods: null == methods ? _self.methods : methods // ignore: cast_nullable_to_non_nullable
as Set<String>,search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RequestFilterParams].
extension RequestFilterParamsPatterns on RequestFilterParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RequestFilterParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RequestFilterParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RequestFilterParams value)  $default,){
final _that = this;
switch (_that) {
case _RequestFilterParams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RequestFilterParams value)?  $default,){
final _that = this;
switch (_that) {
case _RequestFilterParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RequestStatusFilter status,  Set<String> methods,  String search)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RequestFilterParams() when $default != null:
return $default(_that.status,_that.methods,_that.search);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RequestStatusFilter status,  Set<String> methods,  String search)  $default,) {final _that = this;
switch (_that) {
case _RequestFilterParams():
return $default(_that.status,_that.methods,_that.search);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RequestStatusFilter status,  Set<String> methods,  String search)?  $default,) {final _that = this;
switch (_that) {
case _RequestFilterParams() when $default != null:
return $default(_that.status,_that.methods,_that.search);case _:
  return null;

}
}

}

/// @nodoc


class _RequestFilterParams extends RequestFilterParams {
  const _RequestFilterParams({this.status = RequestStatusFilter.all,  Set<String> methods = const <String>{}, this.search = ''}): _methods = methods,super._();
  

@override@JsonKey() final  RequestStatusFilter status;
 final  Set<String> _methods;
@override@JsonKey() Set<String> get methods {
  if (_methods is EqualUnmodifiableSetView) return _methods;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_methods);
}

@override@JsonKey() final  String search;

/// Create a copy of RequestFilterParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RequestFilterParamsCopyWith<_RequestFilterParams> get copyWith => __$RequestFilterParamsCopyWithImpl<_RequestFilterParams>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RequestFilterParams&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.methods, _methods)&&(identical(other.search, search) || other.search == search));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_methods),search);
}

@override
String toString() {
    return 'RequestFilterParams(status: $status, methods: $methods, search: $search)';
}


}

/// @nodoc
abstract mixin class _$RequestFilterParamsCopyWith<$Res> implements $RequestFilterParamsCopyWith<$Res> {
  factory _$RequestFilterParamsCopyWith(_RequestFilterParams value, $Res Function(_RequestFilterParams) _then) = __$RequestFilterParamsCopyWithImpl;
@override @useResult
$Res call({
 RequestStatusFilter status, Set<String> methods, String search
});




}
/// @nodoc
class __$RequestFilterParamsCopyWithImpl<$Res>
    implements _$RequestFilterParamsCopyWith<$Res> {
  __$RequestFilterParamsCopyWithImpl(this._self, this._then);

  final _RequestFilterParams _self;
  final $Res Function(_RequestFilterParams) _then;

/// Create a copy of RequestFilterParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? methods = null,Object? search = null,}) {
  return _then(_RequestFilterParams(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RequestStatusFilter,methods: null == methods ? _self._methods : methods // ignore: cast_nullable_to_non_nullable
as Set<String>,search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
