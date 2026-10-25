import 'package:freezed_annotation/freezed_annotation.dart';

part 'endpoint_size_entity.freezed.dart';
part 'endpoint_size_entity.g.dart';

/// An endpoint path and its largest response body, in bytes.
@freezed
abstract class EndpointSizeEntity with _$EndpointSizeEntity {
  /// Creates an entry.
  const factory EndpointSizeEntity({
    /// Endpoint path.
    @JsonKey(name: 'path') required String path,

    /// Largest response body size, in bytes.
    @JsonKey(name: 'bytes') required int bytes,
  }) = _EndpointSizeEntity;

  /// Reads an entry stored by `toJson`.
  factory EndpointSizeEntity.fromJson(Map<String, dynamic> json) =>
      _$EndpointSizeEntityFromJson(json);
}
