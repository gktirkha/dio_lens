import 'package:freezed_annotation/freezed_annotation.dart';

part 'endpoint_latency_entity.freezed.dart';
part 'endpoint_latency_entity.g.dart';

/// An endpoint path and its average latency.
@freezed
abstract class EndpointLatencyEntity with _$EndpointLatencyEntity {
  /// Creates an entry.
  const factory EndpointLatencyEntity({
    /// Endpoint path.
    @JsonKey(name: 'path') required String path,

    /// Average time to a response.
    @JsonKey(name: 'average_latency') required Duration averageLatency,
  }) = _EndpointLatencyEntity;

  /// Reads an entry stored by `toJson`.
  factory EndpointLatencyEntity.fromJson(Map<String, dynamic> json) =>
      _$EndpointLatencyEntityFromJson(json);
}
