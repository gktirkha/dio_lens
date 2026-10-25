// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'endpoint_size_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EndpointSizeEntity _$EndpointSizeEntityFromJson(Map<String, dynamic> json) =>
    _EndpointSizeEntity(
      path: json['path'] as String,
      bytes: (json['bytes'] as num).toInt(),
    );

Map<String, dynamic> _$EndpointSizeEntityToJson(_EndpointSizeEntity instance) =>
    <String, dynamic>{'path': instance.path, 'bytes': instance.bytes};
