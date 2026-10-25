import 'package:freezed_annotation/freezed_annotation.dart';

part 'endpoint_size_entity.freezed.dart';
part 'endpoint_size_entity.g.dart';

/// An endpoint path and its largest response body, in bytes.
@freezed
abstract class EndpointSizeEntity with _$EndpointSizeEntity {
  const factory EndpointSizeEntity({
    @JsonKey(name: 'path') required String path,
    @JsonKey(name: 'bytes') required int bytes,
  }) = _EndpointSizeEntity;

  factory EndpointSizeEntity.fromJson(Map<String, dynamic> json) =>
      _$EndpointSizeEntityFromJson(json);
}
