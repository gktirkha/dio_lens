// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'named_count_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NamedCountEntity _$NamedCountEntityFromJson(Map<String, dynamic> json) =>
    _NamedCountEntity(
      name: json['name'] as String,
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$NamedCountEntityToJson(_NamedCountEntity instance) =>
    <String, dynamic>{'name': instance.name, 'count': instance.count};
