// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'request_stats_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RequestStatsEntity {

/// Every captured request.
@JsonKey(name: 'total_requests') int get totalRequests;/// Completed or failed requests, i.e. not pending.
@JsonKey(name: 'finished_requests') int get finishedRequests;/// 2xx responses.
@JsonKey(name: 'success_count') int get successCount;/// 4xx and 5xx responses, and requests that failed without a response.
@JsonKey(name: 'error_count') int get errorCount;/// Sum of response body sizes, in bytes.
@JsonKey(name: 'total_bytes') int get totalBytes;/// Average time to a response; null when none completed.
@JsonKey(name: 'average_latency') Duration? get averageLatency;/// 95th percentile time to a response; null when none completed.
@JsonKey(name: 'p95_latency') Duration? get p95Latency;/// Requests per status class, only classes that occur, in display order.
@JsonKey(name: 'status_distribution') List<StatusShareEntity> get statusDistribution;/// Endpoints by average latency, slowest first.
@JsonKey(name: 'slowest_endpoints') List<EndpointLatencyEntity> get slowestEndpoints;/// Endpoints by largest response, largest first.
@JsonKey(name: 'largest_responses') List<EndpointSizeEntity> get largestResponses;/// Endpoints by number of calls, most called first.
@JsonKey(name: 'most_called_endpoints') List<NamedCountEntity> get mostCalledEndpoints;/// Hosts by number of calls, busiest first.
@JsonKey(name: 'top_hosts') List<NamedCountEntity> get topHosts;
/// Create a copy of RequestStatsEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RequestStatsEntityCopyWith<RequestStatsEntity> get copyWith => _$RequestStatsEntityCopyWithImpl<RequestStatsEntity>(this as RequestStatsEntity, _$identity);

  /// Serializes this RequestStatsEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RequestStatsEntity;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RequestStatsEntity&&(identical(other.totalRequests, _this.totalRequests) || other.totalRequests == _this.totalRequests)&&(identical(other.finishedRequests, _this.finishedRequests) || other.finishedRequests == _this.finishedRequests)&&(identical(other.successCount, _this.successCount) || other.successCount == _this.successCount)&&(identical(other.errorCount, _this.errorCount) || other.errorCount == _this.errorCount)&&(identical(other.totalBytes, _this.totalBytes) || other.totalBytes == _this.totalBytes)&&(identical(other.averageLatency, _this.averageLatency) || other.averageLatency == _this.averageLatency)&&(identical(other.p95Latency, _this.p95Latency) || other.p95Latency == _this.p95Latency)&&const DeepCollectionEquality().equals(other.statusDistribution, _this.statusDistribution)&&const DeepCollectionEquality().equals(other.slowestEndpoints, _this.slowestEndpoints)&&const DeepCollectionEquality().equals(other.largestResponses, _this.largestResponses)&&const DeepCollectionEquality().equals(other.mostCalledEndpoints, _this.mostCalledEndpoints)&&const DeepCollectionEquality().equals(other.topHosts, _this.topHosts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RequestStatsEntity;
  return Object.hash(runtimeType,_this.totalRequests,_this.finishedRequests,_this.successCount,_this.errorCount,_this.totalBytes,_this.averageLatency,_this.p95Latency,const DeepCollectionEquality().hash(_this.statusDistribution),const DeepCollectionEquality().hash(_this.slowestEndpoints),const DeepCollectionEquality().hash(_this.largestResponses),const DeepCollectionEquality().hash(_this.mostCalledEndpoints),const DeepCollectionEquality().hash(_this.topHosts));
}

@override
String toString() {
  final _this = this as RequestStatsEntity;
  return 'RequestStatsEntity(totalRequests: ${_this.totalRequests}, finishedRequests: ${_this.finishedRequests}, successCount: ${_this.successCount}, errorCount: ${_this.errorCount}, totalBytes: ${_this.totalBytes}, averageLatency: ${_this.averageLatency}, p95Latency: ${_this.p95Latency}, statusDistribution: ${_this.statusDistribution}, slowestEndpoints: ${_this.slowestEndpoints}, largestResponses: ${_this.largestResponses}, mostCalledEndpoints: ${_this.mostCalledEndpoints}, topHosts: ${_this.topHosts})';
}


}

/// @nodoc
abstract mixin class $RequestStatsEntityCopyWith<$Res>  {
  factory $RequestStatsEntityCopyWith(RequestStatsEntity value, $Res Function(RequestStatsEntity) _then) = _$RequestStatsEntityCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'total_requests') int totalRequests,@JsonKey(name: 'finished_requests') int finishedRequests,@JsonKey(name: 'success_count') int successCount,@JsonKey(name: 'error_count') int errorCount,@JsonKey(name: 'total_bytes') int totalBytes,@JsonKey(name: 'average_latency') Duration? averageLatency,@JsonKey(name: 'p95_latency') Duration? p95Latency,@JsonKey(name: 'status_distribution') List<StatusShareEntity> statusDistribution,@JsonKey(name: 'slowest_endpoints') List<EndpointLatencyEntity> slowestEndpoints,@JsonKey(name: 'largest_responses') List<EndpointSizeEntity> largestResponses,@JsonKey(name: 'most_called_endpoints') List<NamedCountEntity> mostCalledEndpoints,@JsonKey(name: 'top_hosts') List<NamedCountEntity> topHosts
});




}
/// @nodoc
class _$RequestStatsEntityCopyWithImpl<$Res>
    implements $RequestStatsEntityCopyWith<$Res> {
  _$RequestStatsEntityCopyWithImpl(this._self, this._then);

  final RequestStatsEntity _self;
  final $Res Function(RequestStatsEntity) _then;

/// Create a copy of RequestStatsEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalRequests = null,Object? finishedRequests = null,Object? successCount = null,Object? errorCount = null,Object? totalBytes = null,Object? averageLatency = freezed,Object? p95Latency = freezed,Object? statusDistribution = null,Object? slowestEndpoints = null,Object? largestResponses = null,Object? mostCalledEndpoints = null,Object? topHosts = null,}) {
  return _then(RequestStatsEntity(
totalRequests: null == totalRequests ? _self.totalRequests : totalRequests // ignore: cast_nullable_to_non_nullable
as int,finishedRequests: null == finishedRequests ? _self.finishedRequests : finishedRequests // ignore: cast_nullable_to_non_nullable
as int,successCount: null == successCount ? _self.successCount : successCount // ignore: cast_nullable_to_non_nullable
as int,errorCount: null == errorCount ? _self.errorCount : errorCount // ignore: cast_nullable_to_non_nullable
as int,totalBytes: null == totalBytes ? _self.totalBytes : totalBytes // ignore: cast_nullable_to_non_nullable
as int,averageLatency: freezed == averageLatency ? _self.averageLatency : averageLatency // ignore: cast_nullable_to_non_nullable
as Duration?,p95Latency: freezed == p95Latency ? _self.p95Latency : p95Latency // ignore: cast_nullable_to_non_nullable
as Duration?,statusDistribution: null == statusDistribution ? _self.statusDistribution : statusDistribution // ignore: cast_nullable_to_non_nullable
as List<StatusShareEntity>,slowestEndpoints: null == slowestEndpoints ? _self.slowestEndpoints : slowestEndpoints // ignore: cast_nullable_to_non_nullable
as List<EndpointLatencyEntity>,largestResponses: null == largestResponses ? _self.largestResponses : largestResponses // ignore: cast_nullable_to_non_nullable
as List<EndpointSizeEntity>,mostCalledEndpoints: null == mostCalledEndpoints ? _self.mostCalledEndpoints : mostCalledEndpoints // ignore: cast_nullable_to_non_nullable
as List<NamedCountEntity>,topHosts: null == topHosts ? _self.topHosts : topHosts // ignore: cast_nullable_to_non_nullable
as List<NamedCountEntity>,
  ));
}

}


/// Adds pattern-matching-related methods to [RequestStatsEntity].
extension RequestStatsEntityPatterns on RequestStatsEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RequestStatsEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RequestStatsEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RequestStatsEntity value)  $default,){
final _that = this;
switch (_that) {
case _RequestStatsEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RequestStatsEntity value)?  $default,){
final _that = this;
switch (_that) {
case _RequestStatsEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_requests')  int totalRequests, @JsonKey(name: 'finished_requests')  int finishedRequests, @JsonKey(name: 'success_count')  int successCount, @JsonKey(name: 'error_count')  int errorCount, @JsonKey(name: 'total_bytes')  int totalBytes, @JsonKey(name: 'average_latency')  Duration? averageLatency, @JsonKey(name: 'p95_latency')  Duration? p95Latency, @JsonKey(name: 'status_distribution')  List<StatusShareEntity> statusDistribution, @JsonKey(name: 'slowest_endpoints')  List<EndpointLatencyEntity> slowestEndpoints, @JsonKey(name: 'largest_responses')  List<EndpointSizeEntity> largestResponses, @JsonKey(name: 'most_called_endpoints')  List<NamedCountEntity> mostCalledEndpoints, @JsonKey(name: 'top_hosts')  List<NamedCountEntity> topHosts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RequestStatsEntity() when $default != null:
return $default(_that.totalRequests,_that.finishedRequests,_that.successCount,_that.errorCount,_that.totalBytes,_that.averageLatency,_that.p95Latency,_that.statusDistribution,_that.slowestEndpoints,_that.largestResponses,_that.mostCalledEndpoints,_that.topHosts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_requests')  int totalRequests, @JsonKey(name: 'finished_requests')  int finishedRequests, @JsonKey(name: 'success_count')  int successCount, @JsonKey(name: 'error_count')  int errorCount, @JsonKey(name: 'total_bytes')  int totalBytes, @JsonKey(name: 'average_latency')  Duration? averageLatency, @JsonKey(name: 'p95_latency')  Duration? p95Latency, @JsonKey(name: 'status_distribution')  List<StatusShareEntity> statusDistribution, @JsonKey(name: 'slowest_endpoints')  List<EndpointLatencyEntity> slowestEndpoints, @JsonKey(name: 'largest_responses')  List<EndpointSizeEntity> largestResponses, @JsonKey(name: 'most_called_endpoints')  List<NamedCountEntity> mostCalledEndpoints, @JsonKey(name: 'top_hosts')  List<NamedCountEntity> topHosts)  $default,) {final _that = this;
switch (_that) {
case _RequestStatsEntity():
return $default(_that.totalRequests,_that.finishedRequests,_that.successCount,_that.errorCount,_that.totalBytes,_that.averageLatency,_that.p95Latency,_that.statusDistribution,_that.slowestEndpoints,_that.largestResponses,_that.mostCalledEndpoints,_that.topHosts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'total_requests')  int totalRequests, @JsonKey(name: 'finished_requests')  int finishedRequests, @JsonKey(name: 'success_count')  int successCount, @JsonKey(name: 'error_count')  int errorCount, @JsonKey(name: 'total_bytes')  int totalBytes, @JsonKey(name: 'average_latency')  Duration? averageLatency, @JsonKey(name: 'p95_latency')  Duration? p95Latency, @JsonKey(name: 'status_distribution')  List<StatusShareEntity> statusDistribution, @JsonKey(name: 'slowest_endpoints')  List<EndpointLatencyEntity> slowestEndpoints, @JsonKey(name: 'largest_responses')  List<EndpointSizeEntity> largestResponses, @JsonKey(name: 'most_called_endpoints')  List<NamedCountEntity> mostCalledEndpoints, @JsonKey(name: 'top_hosts')  List<NamedCountEntity> topHosts)?  $default,) {final _that = this;
switch (_that) {
case _RequestStatsEntity() when $default != null:
return $default(_that.totalRequests,_that.finishedRequests,_that.successCount,_that.errorCount,_that.totalBytes,_that.averageLatency,_that.p95Latency,_that.statusDistribution,_that.slowestEndpoints,_that.largestResponses,_that.mostCalledEndpoints,_that.topHosts);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RequestStatsEntity extends RequestStatsEntity {
  const _RequestStatsEntity({@JsonKey(name: 'total_requests') required this.totalRequests, @JsonKey(name: 'finished_requests') required this.finishedRequests, @JsonKey(name: 'success_count') required this.successCount, @JsonKey(name: 'error_count') required this.errorCount, @JsonKey(name: 'total_bytes') required this.totalBytes, @JsonKey(name: 'average_latency') this.averageLatency, @JsonKey(name: 'p95_latency') this.p95Latency, @JsonKey(name: 'status_distribution')  List<StatusShareEntity> statusDistribution = const <StatusShareEntity>[], @JsonKey(name: 'slowest_endpoints')  List<EndpointLatencyEntity> slowestEndpoints = const <EndpointLatencyEntity>[], @JsonKey(name: 'largest_responses')  List<EndpointSizeEntity> largestResponses = const <EndpointSizeEntity>[], @JsonKey(name: 'most_called_endpoints')  List<NamedCountEntity> mostCalledEndpoints = const <NamedCountEntity>[], @JsonKey(name: 'top_hosts')  List<NamedCountEntity> topHosts = const <NamedCountEntity>[]}): _statusDistribution = statusDistribution,_slowestEndpoints = slowestEndpoints,_largestResponses = largestResponses,_mostCalledEndpoints = mostCalledEndpoints,_topHosts = topHosts,super._();
  factory _RequestStatsEntity.fromJson(Map<String, dynamic> json) => _$RequestStatsEntityFromJson(json);

/// Every captured request.
@override@JsonKey(name: 'total_requests') final  int totalRequests;
/// Completed or failed requests, i.e. not pending.
@override@JsonKey(name: 'finished_requests') final  int finishedRequests;
/// 2xx responses.
@override@JsonKey(name: 'success_count') final  int successCount;
/// 4xx and 5xx responses, and requests that failed without a response.
@override@JsonKey(name: 'error_count') final  int errorCount;
/// Sum of response body sizes, in bytes.
@override@JsonKey(name: 'total_bytes') final  int totalBytes;
/// Average time to a response; null when none completed.
@override@JsonKey(name: 'average_latency') final  Duration? averageLatency;
/// 95th percentile time to a response; null when none completed.
@override@JsonKey(name: 'p95_latency') final  Duration? p95Latency;
/// Requests per status class, only classes that occur, in display order.
 final  List<StatusShareEntity> _statusDistribution;
/// Requests per status class, only classes that occur, in display order.
@override@JsonKey(name: 'status_distribution') List<StatusShareEntity> get statusDistribution {
  if (_statusDistribution is EqualUnmodifiableListView) return _statusDistribution;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_statusDistribution);
}

/// Endpoints by average latency, slowest first.
 final  List<EndpointLatencyEntity> _slowestEndpoints;
/// Endpoints by average latency, slowest first.
@override@JsonKey(name: 'slowest_endpoints') List<EndpointLatencyEntity> get slowestEndpoints {
  if (_slowestEndpoints is EqualUnmodifiableListView) return _slowestEndpoints;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_slowestEndpoints);
}

/// Endpoints by largest response, largest first.
 final  List<EndpointSizeEntity> _largestResponses;
/// Endpoints by largest response, largest first.
@override@JsonKey(name: 'largest_responses') List<EndpointSizeEntity> get largestResponses {
  if (_largestResponses is EqualUnmodifiableListView) return _largestResponses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_largestResponses);
}

/// Endpoints by number of calls, most called first.
 final  List<NamedCountEntity> _mostCalledEndpoints;
/// Endpoints by number of calls, most called first.
@override@JsonKey(name: 'most_called_endpoints') List<NamedCountEntity> get mostCalledEndpoints {
  if (_mostCalledEndpoints is EqualUnmodifiableListView) return _mostCalledEndpoints;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mostCalledEndpoints);
}

/// Hosts by number of calls, busiest first.
 final  List<NamedCountEntity> _topHosts;
/// Hosts by number of calls, busiest first.
@override@JsonKey(name: 'top_hosts') List<NamedCountEntity> get topHosts {
  if (_topHosts is EqualUnmodifiableListView) return _topHosts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_topHosts);
}


/// Create a copy of RequestStatsEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RequestStatsEntityCopyWith<_RequestStatsEntity> get copyWith => __$RequestStatsEntityCopyWithImpl<_RequestStatsEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RequestStatsEntityToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RequestStatsEntity&&(identical(other.totalRequests, totalRequests) || other.totalRequests == totalRequests)&&(identical(other.finishedRequests, finishedRequests) || other.finishedRequests == finishedRequests)&&(identical(other.successCount, successCount) || other.successCount == successCount)&&(identical(other.errorCount, errorCount) || other.errorCount == errorCount)&&(identical(other.totalBytes, totalBytes) || other.totalBytes == totalBytes)&&(identical(other.averageLatency, averageLatency) || other.averageLatency == averageLatency)&&(identical(other.p95Latency, p95Latency) || other.p95Latency == p95Latency)&&const DeepCollectionEquality().equals(other.statusDistribution, _statusDistribution)&&const DeepCollectionEquality().equals(other.slowestEndpoints, _slowestEndpoints)&&const DeepCollectionEquality().equals(other.largestResponses, _largestResponses)&&const DeepCollectionEquality().equals(other.mostCalledEndpoints, _mostCalledEndpoints)&&const DeepCollectionEquality().equals(other.topHosts, _topHosts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,totalRequests,finishedRequests,successCount,errorCount,totalBytes,averageLatency,p95Latency,const DeepCollectionEquality().hash(_statusDistribution),const DeepCollectionEquality().hash(_slowestEndpoints),const DeepCollectionEquality().hash(_largestResponses),const DeepCollectionEquality().hash(_mostCalledEndpoints),const DeepCollectionEquality().hash(_topHosts));
}

@override
String toString() {
    return 'RequestStatsEntity(totalRequests: $totalRequests, finishedRequests: $finishedRequests, successCount: $successCount, errorCount: $errorCount, totalBytes: $totalBytes, averageLatency: $averageLatency, p95Latency: $p95Latency, statusDistribution: $statusDistribution, slowestEndpoints: $slowestEndpoints, largestResponses: $largestResponses, mostCalledEndpoints: $mostCalledEndpoints, topHosts: $topHosts)';
}


}

/// @nodoc
abstract mixin class _$RequestStatsEntityCopyWith<$Res> implements $RequestStatsEntityCopyWith<$Res> {
  factory _$RequestStatsEntityCopyWith(_RequestStatsEntity value, $Res Function(_RequestStatsEntity) _then) = __$RequestStatsEntityCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'total_requests') int totalRequests,@JsonKey(name: 'finished_requests') int finishedRequests,@JsonKey(name: 'success_count') int successCount,@JsonKey(name: 'error_count') int errorCount,@JsonKey(name: 'total_bytes') int totalBytes,@JsonKey(name: 'average_latency') Duration? averageLatency,@JsonKey(name: 'p95_latency') Duration? p95Latency,@JsonKey(name: 'status_distribution') List<StatusShareEntity> statusDistribution,@JsonKey(name: 'slowest_endpoints') List<EndpointLatencyEntity> slowestEndpoints,@JsonKey(name: 'largest_responses') List<EndpointSizeEntity> largestResponses,@JsonKey(name: 'most_called_endpoints') List<NamedCountEntity> mostCalledEndpoints,@JsonKey(name: 'top_hosts') List<NamedCountEntity> topHosts
});




}
/// @nodoc
class __$RequestStatsEntityCopyWithImpl<$Res>
    implements _$RequestStatsEntityCopyWith<$Res> {
  __$RequestStatsEntityCopyWithImpl(this._self, this._then);

  final _RequestStatsEntity _self;
  final $Res Function(_RequestStatsEntity) _then;

/// Create a copy of RequestStatsEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalRequests = null,Object? finishedRequests = null,Object? successCount = null,Object? errorCount = null,Object? totalBytes = null,Object? averageLatency = freezed,Object? p95Latency = freezed,Object? statusDistribution = null,Object? slowestEndpoints = null,Object? largestResponses = null,Object? mostCalledEndpoints = null,Object? topHosts = null,}) {
  return _then(_RequestStatsEntity(
totalRequests: null == totalRequests ? _self.totalRequests : totalRequests // ignore: cast_nullable_to_non_nullable
as int,finishedRequests: null == finishedRequests ? _self.finishedRequests : finishedRequests // ignore: cast_nullable_to_non_nullable
as int,successCount: null == successCount ? _self.successCount : successCount // ignore: cast_nullable_to_non_nullable
as int,errorCount: null == errorCount ? _self.errorCount : errorCount // ignore: cast_nullable_to_non_nullable
as int,totalBytes: null == totalBytes ? _self.totalBytes : totalBytes // ignore: cast_nullable_to_non_nullable
as int,averageLatency: freezed == averageLatency ? _self.averageLatency : averageLatency // ignore: cast_nullable_to_non_nullable
as Duration?,p95Latency: freezed == p95Latency ? _self.p95Latency : p95Latency // ignore: cast_nullable_to_non_nullable
as Duration?,statusDistribution: null == statusDistribution ? _self._statusDistribution : statusDistribution // ignore: cast_nullable_to_non_nullable
as List<StatusShareEntity>,slowestEndpoints: null == slowestEndpoints ? _self._slowestEndpoints : slowestEndpoints // ignore: cast_nullable_to_non_nullable
as List<EndpointLatencyEntity>,largestResponses: null == largestResponses ? _self._largestResponses : largestResponses // ignore: cast_nullable_to_non_nullable
as List<EndpointSizeEntity>,mostCalledEndpoints: null == mostCalledEndpoints ? _self._mostCalledEndpoints : mostCalledEndpoints // ignore: cast_nullable_to_non_nullable
as List<NamedCountEntity>,topHosts: null == topHosts ? _self._topHosts : topHosts // ignore: cast_nullable_to_non_nullable
as List<NamedCountEntity>,
  ));
}


}

// dart format on
