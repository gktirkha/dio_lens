import 'package:freezed_annotation/freezed_annotation.dart';

part 'endpoint_latency_entity.freezed.dart';
part 'endpoint_latency_entity.g.dart';

@freezed
abstract class EndpointLatencyEntity with _$EndpointLatencyEntity {
  const factory EndpointLatencyEntity({
    @JsonKey(name: 'path') required String path,
    @JsonKey(name: 'average_latency') required Duration averageLatency,
  }) = _EndpointLatencyEntity;

  factory EndpointLatencyEntity.fromJson(Map<String, dynamic> json) =>
      _$EndpointLatencyEntityFromJson(json);
}
